CREATE PROCEDURE [SystemLog].[CloseCycle]
@PackageName VARCHAR (255), @PackageGuid UNIQUEIDENTIFIER, @VersionBuild SMALLINT, @VersionMajor SMALLINT, @VersionMinor SMALLINT, @VersionComment VARCHAR (1000), @CycleID INT
AS
DECLARE @FailedLoadCount int;
DECLARE @FailedMessageCount int;
DECLARE @PackageLogID INT;

BEGIN TRY

  -- Close the load with a status of fail if an error message is attached to the load or a load for the cycle
  -- failed.    
  SELECT @FailedLoadCount = COUNT(*)
  FROM SystemLog.LoadLog l
  WHERE l.CycleID = @CycleID
    AND l.StatusID = [SystemLog].[GetStatusTypeID]('Failure');
    
  SELECT @FailedMessageCount = COUNT(*)
  FROM SystemLog.MessageLog l
       JOIN SystemLog.InformationType t ON l.InformationTypeID = t.InformationTypeID 
  WHERE l.CycleID = @CycleID
    AND l.InformationTypeID = [SystemLog].[GetInformationTypeID]('Error'); 
        
  IF @FailedLoadCount > 0 OR @FailedMessageCount > 0
    BEGIN
      UPDATE SystemLog.CycleLog 
      SET EndDate = GETDATE(), StatusID = [SystemLog].[GetStatusTypeID]('Failure')
      WHERE CycleID = @CycleID;
    END
  ELSE
    BEGIN
      UPDATE SystemLog.CycleLog 
      SET EndDate = GETDATE(), StatusID = [SystemLog].[GetStatusTypeID]('Success')
      WHERE CycleID = @CycleID;
    END
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

  /* Cycle could not be closed insert an error message */
  INSERT INTO SystemLog.MessageLog ([LoadID], [InformationTypeID], [Message], [PackageLogID], [TaskLogID], [Code], [ErrorDate], [CycleID])
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

  RAISERROR('Error closing cycle - %s', 16, 1, @ERRORMESSAGE);	
END CATCH  

Select 0;
