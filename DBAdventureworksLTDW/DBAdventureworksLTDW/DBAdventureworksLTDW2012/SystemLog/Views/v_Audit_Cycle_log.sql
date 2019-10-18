CREATE VIEW [SystemLog].[v_Audit_Cycle_log]
AS
SELECT                appl.ApplicationName, cyc.CycleID, cyc.StartDate AS CycleStartDate,cyc.EndDate AS CycleEndDate,
                      l.LoadID, l.StartDate as LoadStartDate, l.EndDate AS LoadEndDate,
                      pack.PackageName, task.TaskName, tr.TransformName, ts.[TransformStatisticMapName], ptt.StatisticValue, s.StatusName, l.StartDate AS LoadLogStartDate, 
                      l.EndDate AS LoadLogEndDate, ptt.PackageStartDate, ptt.PackageEndDate, ptt.TaskStartDate, ptt.TaskEndDate, ptt.TransformStartDate, ptt.TransformEndDate
FROM                  SystemLog.Application AS Appl inner join 
                      SystemLog.CycleLog AS cyc on Appl.ApplicationID = cyc.ApplicationID inner join 
                      SystemLog.LoadLog AS l  on cyc.CycleID = l.CycleID INNER JOIN
                      SystemLog.ProcessTaskTransformLog AS ptt ON l.LoadID = ptt.LoadID INNER JOIN
                      SystemLog.[TransformStatisticMap] AS ts ON ptt.TransformStatisticID = ts.[TransformStatisticMapID] INNER JOIN
                      SystemLog.Status AS s ON ptt.StatusID = s.StatusID INNER JOIN
                      SystemLog.TransformLog AS tr ON ptt.TransformLogID = tr.TransformLogID INNER JOIN
                      SystemLog.PackageLog AS pack ON ptt.PackageLogID = pack.PackageLogID INNER JOIN
                      SystemLog.TaskLog AS task ON ptt.TaskLogID = task.TaskLogID AND tr.TaskLogID = task.TaskLogID AND pack.PackageLogID = task.PackageLogID;
