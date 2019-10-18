CREATE TABLE [Staging].[StgCustomerAddress] (
    [CustomerID]		INT          NOT NULL,
    [AddressID]			INT          NOT NULL,
    [AddressType]		VARCHAR (50) NOT NULL,
    [ModifiedDate]		DATETIME     NOT NULL,
    [LoadExecutionId]   BIGINT       NOT NULL
);