CREATE TABLE [DW].[DimProduct] (
    [IDProduct]          SMALLINT       NOT NULL,
    [ProductNumber]      VARCHAR (25)   NOT NULL,
    [ProductName]        VARCHAR (50)   NOT NULL,
    [EnglishDescription] VARCHAR (400)  NOT NULL,
    [FrenchDescription]  VARCHAR (400)  NOT NULL,
    [Color]              VARCHAR (25)   NOT NULL,
    [Size]               VARCHAR (5)    NOT NULL,
    [Weight]             DECIMAL (8, 2) NOT NULL,
    [StandardCost]       MONEY          NOT NULL,
    [ListPrice]          MONEY          NOT NULL,
    [ModelName]          VARCHAR (50)   NOT NULL,
    [Category]           VARCHAR (50)   NOT NULL,
    [SubCategory]        VARCHAR (50)   NOT NULL,
    [LoadExecutionId]    BIGINT         NOT NULL,
    CONSTRAINT [DimProduct_PK] PRIMARY KEY CLUSTERED ([IDProduct] ASC)
);

