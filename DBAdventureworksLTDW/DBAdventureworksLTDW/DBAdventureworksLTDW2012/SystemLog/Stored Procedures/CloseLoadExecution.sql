CREATE PROCEDURE [SystemLog].[CloseLoadExecution]
    @LoadExecutionId BIGINT
AS
    DECLARE @SSISExecutionId BIGINT = 0, @EndExecutionDateTime DATETIME = GETDATE()
	, @ErrorCount BIGINT = 0, @ErrorExecutionStatusId TINYINT = 4
	, @SuccessExecutionStatusId TINYINT = 7, @LoadExecutionStatusId TINYINT = 0;
	DECLARE @SSISExecutionIdTbl TABLE (SSISExecutionId BIGINT NOT NULL);
	
    UPDATE  [le]
    SET     [le].[ExecutionEndDateTime] = @EndExecutionDateTime
    OUTPUT  [Inserted].[SSISServerExecutionId]
            INTO @SSISExecutionIdTbl
    FROM    [SystemLog].[LoadExecutions] AS [le]
    WHERE   [le].[LoadExecutionId] = @LoadExecutionId;


	SELECT @SSISExecutionId = [s].[SSISExecutionId]
	FROM @SSISExecutionIdTbl AS [s];

	-- Retreive Catalog Execution statstics and insert them into [SystemLog].[ExecutionStatistics] table
    INSERT  INTO [SystemLog].[ExecutionStatictics]
            (
              [LoadExecutionId]
            , [SSISProjectName]
            , [SSISPackageName]
            , [SSISPackageStartDateTime]
            , [SSISPackageEndDateTime]
            , [DataFlowPathIdString]
            , [SourceComponentName]
            , [DestinationComponentName]
            , [RowsSent]
	        )
            SELECT  @LoadExecutionId
				  , [e].[project_name]
                  , [eds].[package_name]
                  , [e].[start_time] AS [package_start_time]
                  , [e].[end_time] AS [package_end_time]
                  , [dataflow_path_id_string]
                  , [source_component_name]
                  , [destination_component_name]
                  , SUM([rows_sent]) AS [rows_sent]
            FROM    [$(SSISDB)].[catalog].[execution_data_statistics] AS [eds]
                    INNER JOIN [$(SSISDB)].[catalog].[executions] AS [e] ON [e].[execution_id] = [eds].[execution_id]
            WHERE   [e].[execution_id] = @SSISExecutionId
            GROUP BY [eds].[package_name]
			      , [e].project_name
                  , [e].[start_time]
                  , [e].[end_time]
                  , [dataflow_path_id_string]
                  , [source_component_name]
                  , [destination_component_name];

				  --Retrieve execution messages and insert them innsert them into [SystemLog].[ExecutionMessages] table
    WITH    [ExecutionMessage] ( [RoundedMessageTime], [message], [package_name], [event_name], [message_source_name], [subcomponent_name], [package_path], [execution_path], [ExecutionMessageTypeId] )
              AS ( SELECT TOP 100 PERCENT
                            CAST(YEAR([message_time]) AS NVARCHAR) + '-'
                            + LEFT('0'
                                   + CAST(MONTH([message_time]) AS NVARCHAR) ,
                                   2) + '-' + LEFT('0'
                                                   + CAST(DAY([message_time]) AS NVARCHAR) ,
                                                   2) + ' ' + LEFT('0'
                                                              + CAST(DATEPART(HOUR ,
                                                              [message_time]) AS NVARCHAR) ,
                                                              2) + ':'
                            + LEFT('0'
                                   + CAST(DATEPART(MINUTE , [message_time]) AS NVARCHAR) ,
                                   2) + ':' + LEFT('0'
                                                   + CAST(DATEPART(SECOND ,
                                                              [message_time]) AS NVARCHAR) ,
                                                   2) AS [RoundedMessageTime]
                          , [message]
                          , [package_name]
                          , [event_name]
                          , [message_source_name]
                          , [subcomponent_name]
                          , [package_path]
                          , [execution_path]
						  , [emt].[ExecutionMessageTypeId]
                   FROM     [$(SSISDB)].[catalog].[event_messages] AS [em] 
                            INNER JOIN [SystemLog].[ExecutionMessageTypes] AS [emt] ON [em].[message_type] = [emt].[SSISDBMessageType]
                   WHERE    [operation_id] = @SSISExecutionId
                   ORDER BY [message_time]
                 )
        INSERT  INTO [SystemLog].[ExecutionMessages]
                (
                  [LoadExecutionId]
                , [ExecutionMessageDateTime]
                , [ExecutionMessage]
                , [SSISPackageName]
                , [SSISEventName]
                , [SourceComponentName]
                , [PackagePathIdString]
                , [ExecutionPathIdString]
				, [ExecutionMessageTypeId]

	            )
                SELECT DISTINCT
                        @LoadExecutionId
                      , [RoundedMessageTime]
                      , [message]
                      , [package_name]
                      , [event_name]
                      , [message_source_name]
                      --, [subcomponent_name]
                      , [package_path]
                      , [execution_path]
					  , [ExecutionMessageTypeId]
                FROM    [ExecutionMessage];

				SELECT @ErrorCount = COUNT(*)
				FROM [SystemLog].[ExecutionMessages] AS [emt]
				WHERE [emt].[ExecutionMessageTypeId] = 1
				AND [emt].LoadExecutionId = @LoadExecutionId;

				SET @LoadExecutionStatusId = IIF((@ErrorCount = 0), @SuccessExecutionStatusId, @ErrorExecutionStatusId);

				
				UPDATE [SystemLog].[LoadExecutions]
				SET [ExecutionStatusId] = @LoadExecutionStatusId
				WHERE [LoadExecutionId] = @LoadExecutionId;
				