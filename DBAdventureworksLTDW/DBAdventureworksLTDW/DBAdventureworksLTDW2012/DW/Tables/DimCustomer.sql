CREATE TABLE [DW].[DimCustomer] (
    [IDCustomer]      INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]      INT           NOT NULL,
    [Title]           VARCHAR (8)   NOT NULL,
    [FirstName]       VARCHAR (50)  NOT NULL,
    [MiddleName]      VARCHAR (50)  NOT NULL,
    [LastName]        VARCHAR (50)  NOT NULL,
    [Suffix]          VARCHAR (10)  NOT NULL,
    [CompanyName]     VARCHAR (128) NOT NULL,
    [ADWSalesPerson]  VARCHAR (256) NOT NULL,
    [EmailAddress]    VARCHAR (50)  NOT NULL,
    [Phone]           VARCHAR (25)  NOT NULL,
    [CustomerEffDate] DATETIME      NOT NULL,
    [CustomerEndDate] DATETIME      NULL,
    [CustomerCurrent] BIT           NOT NULL,
    [LoadExecutionId] BIGINT        NOT NULL,
    CONSTRAINT [DimCustomer_PK] PRIMARY KEY CLUSTERED ([IDCustomer] ASC)
);