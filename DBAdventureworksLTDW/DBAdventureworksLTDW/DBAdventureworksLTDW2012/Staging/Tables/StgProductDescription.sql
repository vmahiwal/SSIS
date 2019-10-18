CREATE TABLE [Staging].[StgProductDescription] (
    [ProductDescriptionID] INT           NOT NULL,
    [Description]          VARCHAR (400) NOT NULL,
    [ModifiedDate]         DATETIME      NOT NULL,
    [LoadExecutionId]     BIGINT         NOT NULL
);