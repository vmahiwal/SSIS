Create view Cube.DimTime as 
SELECT        IDTime, DateOfDay, DayName, DayNbOfTheWeek, DayNbOfTheMonth, DayNbOfTheYear, MonthName, MonthNb, WeekNbOfTheMonth, QuaterNb, YearNb, 
                         IsWeekDayFlag, IsHolidayFlag, 'Quarter ' + CAST(QuaterNb AS varchar(1)) AS QuarterName, YearNb * 100 + QuaterNb AS QuaterYear, YearNb * 100 + MonthNb AS MonthYear
FROM            DW.DimTime