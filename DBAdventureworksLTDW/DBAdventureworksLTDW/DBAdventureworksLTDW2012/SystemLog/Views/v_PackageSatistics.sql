CREATE VIEW [SystemLog].[v_PackageSatistics]
AS
SELECT     StartLog.source AS PackageName, StartLog.sourceid AS PackageID, StartLog.executionid AS ExecutionID, 
                      StartLog.starttime AS PackageStartDate, EndLog.endtime AS PackageEndDate, StartLog.computer, StartLog.operator
FROM         dbo.sysssislog AS StartLog LEFT OUTER JOIN
                      dbo.sysssislog AS EndLog ON StartLog.executionid = EndLog.executionid AND StartLog.source = EndLog.source AND 
                      EndLog.event = 'PackageEnd'
WHERE     (StartLog.event = 'PackageStart');
