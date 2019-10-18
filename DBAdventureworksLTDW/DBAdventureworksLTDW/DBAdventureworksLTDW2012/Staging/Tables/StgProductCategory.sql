CREATE TABLE [Staging].[StgProductCategory] (
    [ProductCategoryID]       INT          NOT NULL,
    [ParentProductCategoryID] INT          NULL,
    [Name]                    VARCHAR (50) NOT NULL,
    [ModifiedDate]            DATETIME     NOT NULL,
    [LoadExecutionId]         BIGINT       NOT NULL
);