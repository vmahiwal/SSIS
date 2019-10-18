CREATE PROCEDURE [SystemLog].[LogMessage]
@PackageName VARCHAR (255), @PackageGuid UNIQUEIDENTIFIER, @VersionBuild SMALLINT, @VersionMajor SMALLINT, @VersionMinor SMALLINT, @VersionComment VARCHAR (1000), @ErrorCode INT, @ErrorMessage VARCHAR (4000), @LoadID INT, @CycleID INT, @MessageTypeToLog VARCHAR (60)
AS
DECLARE @PackageLogID SMALLINT;
DECLARE @LKPCycleID INT;

BEGIN TRY 
  /* If CycleID is 0 and loadId is provided, lookup the related cycleID */
  IF @CycleID = 0 AND @LoadID > 0
	  BEGIN
		SELECT @LKPCycleID = CycleID
		FROM SystemLog.LoadLog
		WHERE LoadID = @LoadID
	  END
	 
  ELSE
	  BEGIN
		SET @LKPCycleID = @CycleID
	  END

	  IF @LoadID = 0
	    SET @LoadID = NULL;
	  
 /* Make sure the Meta data table PackageLog contains the information for this package */
  Exec [SystemLog].[PackageLogUps] 
    @PackageName, 
    @PackageGuid, 
    @VersionBuild, 
    @VersionMajor, 
    @VersionMinor, 
    @VersionComment,
    @PackageLogID OUTPUT;    
   
   
   IF NOT EXISTS(SELECT TOP 1 1 FROM [SystemLog].[MessageLog] 
                  WHERE (ISNULL([CycleID], 0) = ISNULL(@CycleID, 0)
                    OR ISNULL([LoadID], 0) = ISNULL(@LoadID, 0))
					AND [Code] = CAST(@ErrorCode AS VARCHAR(50)))
   BEGIN
	  /* Insert the message */
	  INSERT INTO [SystemLog].MessageLog([LoadID], [InformationTypeID], [Message], [PackageLogID], [TaskLogID], [Code], [ErrorDate], [CycleID])
	  VALUES (@LoadID, [SystemLog].[GetInformationTypeID](@MessageTypeToLog), @ErrorMessage, @PackageLogID, 0, CAST(@ErrorCode AS VARCHAR(50)), CAST(GETDATE() AS SmallDateTime), @LKPCycleID) ;
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

  /* Message could not be inserted, insert an error message */
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
	  @LKPCycleID AS CycleID;
	
  DECLARE @OTHERERRORMESSAGE VARCHAR(200);
  
  SELECT @OTHERERRORMESSAGE = ERROR_MESSAGE();

  RAISERROR('Error writting message to SystemLog.MessageLog table - %s', 16, 1, @OTHERERRORMESSAGE);	
END CATCH  


SELECT 0;
