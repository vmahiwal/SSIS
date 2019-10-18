
CREATE VIEW [SystemLog].[v_Audit_Load_log]
AS
SELECT     l.LoadID, pack.PackageName, task.TaskName, tr.TransformName, ts.[TransformStatisticMapName], ptt.StatisticValue, s.StatusName, l.StartDate AS LoadLogStartDate, 
                      l.EndDate AS LoadLogEndDate, ptt.PackageStartDate, ptt.PackageEndDate, ptt.TaskStartDate, ptt.TaskEndDate, ptt.TransformStartDate, ptt.TransformEndDate
FROM         SystemLog.LoadLog AS l INNER JOIN
                      SystemLog.ProcessTaskTransformLog AS ptt ON l.LoadID = ptt.LoadID INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON ptt.TransformStatisticID = ts.[TransformStatisticMapID] INNER JOIN
                      SystemLog.Status AS s ON l.StatusID = s.StatusID INNER JOIN
                      SystemLog.TransformLog AS tr ON ptt.TransformLogID = tr.TransformLogID INNER JOIN
                      SystemLog.PackageLog AS pack ON ptt.PackageLogID = pack.PackageLogID INNER JOIN
                      SystemLog.TaskLog AS task ON ptt.TaskLogID = task.TaskLogID AND tr.TaskLogID = task.TaskLogID AND pack.PackageLogID = task.PackageLogID;

