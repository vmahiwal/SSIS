CREATE PROCEDURE [SystemLog].[CloseLoad]
@PackageName VARCHAR (255), @PackageGuid UNIQUEIDENTIFIER, @VersionBuild SMALLINT, @VersionMajor SMALLINT, @VersionMinor SMALLINT, @VersionComment VARCHAR (1000), @LoadID INT
AS
DECLARE @FailedMessageCount int;
DECLARE @PackageLogID INT;

BEGIN TRY
  -- Close the load with a status of fail if an error message is attached to the load
  SELECT @FailedMessageCount = COUNT(*)
  FROM SystemLog.MessageLog l
  WHERE l.LoadID = @LoadID
    AND l.InformationTypeID = [SystemLog].[GetInformationTypeID]('Error'); 
        
  IF @FailedMessageCount > 0
    BEGIN
      UPDATE SystemLog.LoadLog 
      SET EndDate = CAST(GETDATE() AS smalldatetime), StatusID =  [SystemLog].[GetStatusTypeID]('Failure')
      WHERE LoadID = @LoadID;
    END
  ELSE
    BEGIN
      UPDATE SystemLog.LoadLog 
      SET EndDate = CAST(GETDATE() AS smalldatetime), StatusID =  [SystemLog].[GetStatusTypeID]('Success')
      WHERE LoadID = @LoadID;
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

  /* Load could not be opened, insert an error message */
  INSERT INTO SystemLog.MessageLog([LoadID], [InformationTypeID], [Message], [PackageLogID], [TaskLogID], [Code], [ErrorDate], [CycleID])
  SELECT 
    @LoadID AS LoadID,
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
	  l.CycleID AS CycleID
	FROM SystemLog.LoadLog l
	WHERE l.LoadID = @LoadID;
	
  DECLARE @ERRORMESSAGE VARCHAR(200);
  
  SELECT @ERRORMESSAGE = ERROR_MESSAGE();

  RAISERROR('Error closing load - %s', 16, 1, @ERRORMESSAGE);	
END CATCH  

SELECT 0;
