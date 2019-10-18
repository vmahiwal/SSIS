CREATE PROCEDURE [SystemLog].[OpenLoadExecution]
    @ServerExecutionId BIGINT = 0 ,
    @LoadId BIGINT = -1 ,
	@LoadEnvironmentName NVARCHAR(25) ,
    @LoadExectionId BIGINT OUTPUT
AS
    --These variables will store id's needed for LoadExecutions 
    DECLARE @FailureStatusId TINYINT = 0 ,
        @RunningStatusId TINYINT = 0 ,
        @LoadDateTime DATETIME = GETDATE() ,
		@LoadEnvironmentId BIGINT = 0;
    
	--This table varaible will store the newly created LoadExecutionId
    DECLARE @LoadIdTbl TABLE
        (
          LoadExecutionId BIGINT
        );

    --This table variable will contains the newly created LoadEnvironmentId
	DECLARE @LoadEnvironmentIdTbl TABLE (LoadEnvironmentId BIGINT)

     --Get StatusId for Failed loads
    SELECT  @FailureStatusId = s.ExecutionStatusId
    FROM    SystemLog.ExecutionStatus s
    WHERE   s.ExecutionStatusName = N'Failed';

	--Get StatusId for Running loads
    SELECT  @RunningStatusId = s.ExecutionStatusId
    FROM    SystemLog.ExecutionStatus AS s
    WHERE   s.ExecutionStatusName = N'Running';

	--If the SystemLog.Loads table is used, get its LoadDtartDateTime to have a consistent Start date and time in our loads
    IF ( @LoadId <> -1 )
        BEGIN
            SELECT  @LoadDateTime = l.LoadStartDateTime
            FROM    SystemLog.Loads AS l
            WHERE   LoadId = @LoadId;
        END;
	--Check if there are any pending loads for this Application. Terminate them if that's the case.
    IF EXISTS ( SELECT TOP 1
                        1
                FROM    SystemLog.LoadExecutions le
                WHERE   le.LoadId = @LoadId)
        BEGIN
            UPDATE  SystemLog.LoadExecutions
            SET       ExecutionStatusId = @FailureStatusId
			        , ExecutionEndDateTime = @LoadDateTime
            WHERE   LoadId = @LoadId;
        END;

   --Lookup the LoadEnvironmentId for the @LoadEnvironmentName
   SELECT @LoadEnvironmentId = [le].[LoadEnvironmentId]
	FROM [SystemLog].[LoadEnvironments] AS [le]
	WHERE [le].[EnvironmentName] = @LoadEnvironmentName;

	--If it does not exist, insert a new value for @LoadEnvironmentName
	IF(ISNULL(@LoadEnvironmentId, 0) = 0)
	BEGIN
	   INSERT INTO [SystemLog].[LoadEnvironments] ([EnvironmentName]) 
		OUTPUT [Inserted].[LoadEnvironmentId] INTO @LoadEnvironmentIdTbl([LoadEnvironmentId])
	   VALUES (@LoadEnvironmentName);

	   SELECT @LoadEnvironmentId = [LoadEnvironmentId]
	   FROM @LoadEnvironmentIdTbl;
	 END
    
	--Once we have all foreign keys values, insert a row into [SystemLog].[LoadExecutions] table
    INSERT  INTO SystemLog.LoadExecutions
            ( SSISServerExecutionId ,
              LoadId ,
              ExecutionStatusId ,
			  LoadEnvironmentId ,
              ExecutionStartDateTime ,
              ExecutionEndDateTime
	        )
    OUTPUT  Inserted.LoadExecutionId  --Retreive the Identity LoadExecutionId value
            INTO @LoadIdTbl ( LoadExecutionId )
    VALUES  ( @ServerExecutionId , -- SSISServerExecutionId - bigint
              @LoadId , -- LoadId - bigint
              @RunningStatusId , -- ExecutionStatusId - tinyint
			  @LoadEnvironmentId, -- LoadexecutionId - bigint
              @LoadDateTime , -- ExecutionStartDateTime - datetime
              NULL  -- ExecutionEndDateTime - datetime
	        );

    --Return LoadExecutionId from insert statement above
    SELECT  @LoadExectionId = t.LoadExecutionId
    FROM    @LoadIdTbl AS t; 