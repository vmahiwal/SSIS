CREATE TABLE [Staging].[StgProduct] (
    [ProductID]         INT            NOT NULL,
    [Name]              VARCHAR (50)   NOT NULL,
    [ProductNumber]     VARCHAR (25)   NOT NULL,
    [Color]             VARCHAR (15)   NULL,
    [StandardCost]      MONEY          NOT NULL,
    [ListPrice]         MONEY          NOT NULL,
    [Size]              VARCHAR (5)    NULL,
    [Weight]            DECIMAL (8, 2) NULL,
    [ProductModelID]    INT            NULL,
    [ProductCategoryID] INT            NOT NULL,
    [SellStartDate]     DATETIME       NOT NULL,
    [SellEndDate]       DATETIME       NULL,
    [DiscontinuedDate]  DATETIME       NULL,
    [ModifiedDate]      DATETIME       NOT NULL,
    [LoadExecutionId]   BIGINT            NOT NULL
);