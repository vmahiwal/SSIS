CREATE VIEW [SystemLog].[v_Task_Component_Statistics]
AS
SELECT     l.TaskName AS TaskName,l.TaskID, l.SSIS_PATH_ID as TransformID,ts.[TransformStatisticMapName], COUNT(l.SSIS_PATH_ID) AS BuffersToInputCount, l.ExecutionID AS ExecutionID, 
                      l.SSIS_PATH_Name AS TransformName, SUM(l.RowSent) AS RowsSent, MIN(l.TransformStartDate ) AS TransformStartDate, MAX(l.TransformEndDate) AS TransformEndDate, 
                      DATEDIFF(s, MIN(l.TransformStartDate), MAX(l.TransformEndDate)) AS SecondsElapsed
FROM         SystemLog.v_Task_ComponentLogDtl_Statistics AS l INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON UPPER(l.SSIS_PATH_Name) LIKE '%' + UPPER(ts.[TransformStatisticMapObjectLinkCode]) + '%'
GROUP BY l.TaskName, l.SSIS_PATH_Name, l.ExecutionID, ts.[TransformStatisticMapName],l.TaskID,l.SSIS_PATH_ID
UNION ALL
SELECT     l.TaskName, l.TaskID,l.TransformID,ts.[TransformStatisticMapName],COUNT(l.SSIS_PATH_ID) AS BuffersToInputCount, l.ExecutionID, l.TransformName, 
                      SUM(l.RowSent) AS RowsSent, MIN(l.TransformStartDate) AS TransformStartDate, MAX(l.TransformEndDate) AS TransformEndDate, DATEDIFF(s, MIN(l.TransformStartDate), 
                      MAX(l.TransformEndDate)) AS Seconds_Elapsed
FROM         SystemLog.v_Task_ComponentLogDtl_Statistics AS l INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON UPPER(l.TransformName) LIKE '%' + UPPER(ts.[TransformStatisticMapObjectLinkCode]) + '%'
GROUP BY l.TaskName, l.TransformName, l.ExecutionID, ts.[TransformStatisticMapName],l.TaskID, l.TransformID;
