CREATE TABLE [DW].[DimAddress] (
    [IDAddress]			INT           NOT NULL,
    [Address]			VARCHAR (500) NOT NULL,
    [City]				VARCHAR (100) NOT NULL,
    [ProvState]			VARCHAR (100) NOT NULL,
    [Country]			VARCHAR (100) NOT NULL,
    [PostalCode]		VARCHAR (25)  NOT NULL,
    [LoadExecutionId]   BIGINT        NOT NULL,
    CONSTRAINT [DimAddress_PK] PRIMARY KEY CLUSTERED ([IDAddress] ASC)
);