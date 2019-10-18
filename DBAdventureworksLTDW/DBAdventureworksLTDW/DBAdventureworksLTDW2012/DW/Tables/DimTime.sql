CREATE TABLE [DW].[DimTime] (
    [IDTime]           BIGINT       NOT NULL,
    [DateOfDay]        DATETIME     NOT NULL,
    [DayName]          VARCHAR (20) NOT NULL,
    [DayNbOfTheWeek]   TINYINT      NOT NULL,
    [DayNbOfTheMonth]  TINYINT      NOT NULL,
    [DayNbOfTheYear]   SMALLINT     NOT NULL,
    [MonthName]        VARCHAR (20) NOT NULL,
    [MonthNb]          TINYINT      NOT NULL,
    [WeekNbOfTheMonth] TINYINT      NOT NULL,
    [QuaterNb]         TINYINT      NOT NULL,
    [YearNb]           SMALLINT     NOT NULL,
    [IsWeekDayFlag]    BIT          NOT NULL,
    [IsHolidayFlag]    BIT          NOT NULL,
    CONSTRAINT [DimTime_PK] PRIMARY KEY CLUSTERED ([IDTime] ASC)
);