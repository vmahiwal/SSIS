CREATE PROCEDURE [SystemLog].[OpenLoad]
AS --BEGIN TRY

	DECLARE @LoadIdTbl TABLE
			(
			  LoadId BIGINT
			);
 
    INSERT  INTO [SystemLog].[Loads]
            ( LoadStartDateTime )
			OUTPUT  Inserted.LoadId  --Retreive the Identity LoadExecutionId value
            INTO @LoadIdTbl ( LoadId )
    VALUES  ( GETDATE() );


--  RAISERROR('Error opening load - %s', 16, 1, @ERRORMESSAGE);
--END CATCH  

    SELECT  ISNULL(l.LoadId, 0) AS LoadId ,
            ISNULL(( SELECT MAX(t.LoadId) AS PreviousLoadId
                     FROM   SystemLog.Loads t
                   ), 0) AS PreviousLoadId
    FROM    @LoadIdTbl l;