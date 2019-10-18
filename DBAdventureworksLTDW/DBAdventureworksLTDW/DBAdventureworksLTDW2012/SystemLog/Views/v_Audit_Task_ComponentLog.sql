CREATE VIEW [SystemLog].[v_Audit_Task_ComponentLog]
AS
SELECT     l.TaskName AS TaskName, ts.[TransformStatisticMapName], COUNT(l.SSIS_PATH_ID) AS BuffersToInputCount, l.SSIS_EXECUTION_ID AS ExecutionID, 
                      l.SSIS_PATH_Name AS ComponentName, SUM(l.ROWS_SENT) AS RowsSent, MIN(l.TranformStartDate) AS BeginDate, MAX(l.TransformEndDate) AS EndDate, 
                      DATEDIFF(s, MIN(l.TranformStartDate), MAX(l.TransformEndDate)) AS SecondsElapsed
FROM         SystemLog.v_Audit_Task_ComponentLogDtl AS l INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON UPPER(l.SSIS_PATH_Name) LIKE '%' + UPPER(ts.[TransformStatisticMapObjectLinkCode]) + '%'
GROUP BY l.TaskName, l.SSIS_PATH_Name, l.SSIS_EXECUTION_ID, ts.[TransformStatisticMapName]
UNION ALL
SELECT     l.TaskName, ts.[TransformStatisticMapName], COUNT(l.SSIS_PATH_ID) AS BuffersToInputCount, l.SSIS_EXECUTION_ID, l.SSISTransformName, 
                      SUM(l.ROWS_SENT) AS RowsSent, MIN(l.TranformStartDate) AS begin_date, MAX(l.TransformEndDate) AS end_date, DATEDIFF(s, MIN(l.TranformStartDate), 
                      MAX(l.TransformEndDate)) AS Seconds_Elapsed
FROM         SystemLog.v_Audit_Task_ComponentLogDtl AS l INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON UPPER(l.SSISTransformName) LIKE '%' + UPPER(ts.[TransformStatisticMapObjectLinkCode]) + '%'
GROUP BY l.TaskName, l.SSISTransformName, l.SSIS_EXECUTION_ID, ts.[TransformStatisticMapName];
