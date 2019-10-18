CREATE TABLE [Staging].[StgCustomer] (
    [CustomerID]		INT           NOT NULL,
    [NameStyle]			BIT           NOT NULL,
    [Title]				VARCHAR (8)   NULL,
    [FirstName]			VARCHAR (50)  NOT NULL,
    [MiddleName]		VARCHAR (50)  NULL,
    [LastName]			VARCHAR (50)  NOT NULL,
    [Suffix]			VARCHAR (10)  NULL,
    [CompanyName]		VARCHAR (128) NULL,
    [SalesPerson]		VARCHAR (256) NULL,
    [EmailAddress]		VARCHAR (50)  NULL,
    [Phone]				VARCHAR (25)  NULL,
    [PasswordHash]		VARCHAR (128) NOT NULL,
    [PasswordSalt]		VARCHAR (10)  NOT NULL,
    [ModifiedDate]		DATETIME      NOT NULL,
    [LoadExecutionId]   BIGINT           NOT NULL
);