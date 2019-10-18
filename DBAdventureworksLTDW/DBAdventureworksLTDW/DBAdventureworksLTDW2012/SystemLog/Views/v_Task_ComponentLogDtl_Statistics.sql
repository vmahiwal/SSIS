CREATE VIEW [SystemLog].[v_Task_ComponentLogDtl_Statistics]
AS
SELECT     id, cast(source as varchar(255)) AS TaskName, sourceid AS TaskID, executionid  AS ExecutionID, dbo.ParsePipeline(message, 1) 
                      AS SSIS_PATH_ID, dbo.ParsePipeline(message, 2) AS SSIS_PATH_Name, dbo.ParsePipeline(message, 3) AS TransformID, 
                      dbo.ParsePipeline(message, 4) AS TransformName, dbo.ParsePipeline(message, 5) AS SSIS_INPUT_ID, dbo.ParsePipeline(message, 6) 
                      AS SSIS_INPUT_NAME, CONVERT(int, dbo.ParsePipeline(message, 7)) AS RowSent, starttime AS TransformStartDate, endtime AS TransformEndDate, computer, 
                      operator
FROM         dbo.sysssislog
WHERE     (event LIKE 'onpipelinerowssent%');
