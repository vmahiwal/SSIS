CREATE TABLE [Staging].[StgProductModelProductDescription] (
    [ProductModelID]       INT          NOT NULL,
    [ProductDescriptionID] INT          NOT NULL,
    [Culture]              VARCHAR (10) NOT NULL,
    [ModifiedDate]         DATETIME     NOT NULL,
    [LoadExecutionId]      BIGINT       NOT NULL
);