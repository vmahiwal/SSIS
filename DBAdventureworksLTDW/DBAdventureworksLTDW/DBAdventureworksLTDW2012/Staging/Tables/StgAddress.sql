CREATE TABLE [Staging].[StgAddress] (
    [AddressID]			INT          NOT NULL,
    [AddressLine1]		VARCHAR (60) NOT NULL,
    [AddressLine2]		VARCHAR (60) NULL,
    [City]				VARCHAR (30) NOT NULL,
    [StateProvince]		VARCHAR (50) NULL,
    [PostalCode]		VARCHAR (15) NOT NULL,
    [CountryRegion]		VARCHAR (50) NOT NULL,
    [ModifiedDate]		DATETIME     NOT NULL,
    [LoadExecutionId]   BIGINT          NOT NULL
);

