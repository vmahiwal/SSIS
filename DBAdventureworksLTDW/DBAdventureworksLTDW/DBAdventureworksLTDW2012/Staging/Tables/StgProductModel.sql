CREATE TABLE [Staging].[StgProductModel] (
    [ProductModelID]     INT          NOT NULL,
    [Name]               VARCHAR (50) NOT NULL,
    [CatalogDescription] XML          NULL,
    [ModifiedDate]       DATETIME     NOT NULL,
    [LoadExecutionId]    BIGINT       NOT NULL
);