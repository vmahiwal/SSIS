CREATE VIEW [SystemLog].[v_Audit_Task_ComponentLogDtl]
AS
SELECT     id, source AS TaskName, sourceid AS SSISTaskID, CAST(executionid AS varchar(36)) AS SSIS_EXECUTION_ID, dbo.ParsePipeline(message, 1) 
                      AS SSIS_PATH_ID, dbo.ParsePipeline(message, 2) AS SSIS_PATH_Name, dbo.ParsePipeline(message, 3) AS SSISTransformID, 
                      dbo.ParsePipeline(message, 4) AS SSISTransformName, dbo.ParsePipeline(message, 5) AS SSIS_INPUT_ID, dbo.ParsePipeline(message, 6) 
                      AS SSIS_INPUT_NAME, CONVERT(int, dbo.ParsePipeline(message, 7)) AS ROWS_SENT, starttime AS TranformStartDate, endtime AS TransformEndDate, computer, 
                      operator
FROM         dbo.sysssislog
WHERE     (event LIKE 'onpipelinerowssent%');
