CREATE PROCEDURE [SystemLog].[OpenCycle]
@PackageName VARCHAR (255), @PackageGuid UNIQUEIDENTIFIER, @VersionBuild SMALLINT, @VersionMajor SMALLINT, @VersionMinor SMALLINT, @VersionComment VARCHAR (1000), @ApplicationName VARCHAR (255), @ReuseCycleID SMALLINT, @UserName VARCHAR (100)
AS
DECLARE @ApplicationID TINYINT;
DECLARE @PackageLogID int;
DECLARE @ExecutingCycleCount int;
DECLARE @CycleTbl TABLE ( CycleID int )

BEGIN TRY

  -- Get the ID for the Application Name
  SELECT @ApplicationID = l.ApplicationID 
  FROM SystemLog.[Application] l
  WHERE UPPER(LTRIM(RTRIM(l.ApplicationName))) = UPPER(LTRIM(RTRIM(@ApplicationName)))
    
  -- Verify that The status IDs have been properly SET
  IF @ApplicationID IS NULL 
    RAISERROR('No entry found in table SystemLog.LoadApplication for application name ''%s''',16, 1, @ApplicationName);
  
  -- Lookup all Cycles for a given ApplicationID which are executing
  SELECT @ExecutingCycleCount = COUNT(*)
  FROM SystemLog.CycleLog l
  WHERE l.ApplicationID = @ApplicationID 
    AND l.StatusID = [SystemLog].[GetStatusTypeID]('Executing');
    
  -- Depending if an executing cycle already exists and or the @ReuseCycleID flag...
  IF @ExecutingCycleCount = 1 AND @ReuseCycleID = 1
    BEGIN
      UPDATE SystemLog.CycleLog
      SET StartDate = GetDate()
      OUTPUT inserted.CycleID
      INTO @CycleTbl
      WHERE ApplicationID = @ApplicationID 
        AND StatusID = [SystemLog].[GetStatusTypeID]('Executing');
    END
    
  IF @ExecutingCycleCount = 1 AND @ReuseCycleID = 0
    BEGIN
      UPDATE SystemLog.CycleLog
      SET StatusID = [SystemLog].[GetStatusTypeID]('Failure'), EndDate = GETDATE()
      WHERE ApplicationID = @ApplicationID 
        AND StatusID = [SystemLog].[GetStatusTypeID]('Executing');
        
      INSERT INTO [SystemLog].[CycleLog] ([ApplicationID], [StartDate] ,[StatusID], [UserName])
      OUTPUT inserted.CycleID
      INTO @CycleTbl
      VALUES( @ApplicationID, GETDATE(), [SystemLog].[GetStatusTypeID]('Executing'), @UserName );      
    END    

  IF @ExecutingCycleCount = 0
    BEGIN
      INSERT INTO [SystemLog].[CycleLog] ([ApplicationID], [StartDate] ,[StatusID], [UserName])
      OUTPUT inserted.CycleID
      INTO @CycleTbl
      VALUES( @ApplicationID, GETDATE(), [SystemLog].[GetStatusTypeID]('Executing'), @UserName );      
    END  

    IF @ExecutingCycleCount > 1
      RAISERROR('More than one cycle currently executing for application ''%s''',16, 1, @ApplicationName);
END TRY
BEGIN CATCH
  /* Make sure the Meta data table PackageLog contains the information for this package */
  Exec [SystemLog].[PackageLogUps] 
    @PackageName, 
    @PackageGuid, 
    @VersionBuild, 
    @VersionMajor, 
    @VersionMinor, 
    @VersionComment,
    @PackageLogID OUTPUT

  /* Cycle could not be opened, insert an error message */
  INSERT INTO SystemLog.MessageLog([LoadID], [InformationTypeID], [Message], [PackageLogID], [TaskLogID], [Code], [ErrorDate], [CycleID])
  SELECT 
    0 AS LoadID,
    [SystemLog].[GetInformationTypeID]('Error'), 
    (
      SELECT 
	      ERROR_NUMBER() AS "@Number",
	      ERROR_STATE() AS "@State",
	      ERROR_SEVERITY() AS "@Severity",
	      ERROR_MESSAGE() AS "Message",
	      ERROR_LINE() AS "Procedure/@Line",
	      ERROR_PROCEDURE() AS "Procedure"
	    FOR XML PATH('Error')
	  ) AS [Message],
	  @PackageLogID AS PackageLogID,
	  0 AS TaskLogID,
	  ERROR_NUMBER() AS Code,
	  GETDATE() AS ErrorDate,
	  0 AS CycleID;

  DECLARE @ERRORMESSAGE VARCHAR(200);
  
  SELECT @ERRORMESSAGE = ERROR_MESSAGE();
  
  INSERT INTO @CycleTbl (CycleID) Values(0);
  
  RAISERROR('Error opening cycle - %s', 16, 1, @ERRORMESSAGE);	
END CATCH  

SELECT ISNULL(s.CycleID, 0) AS CycleID FROM @CycleTbl s;
