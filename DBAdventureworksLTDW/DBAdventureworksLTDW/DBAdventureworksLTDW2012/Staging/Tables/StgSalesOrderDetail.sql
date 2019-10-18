CREATE TABLE [Staging].[StgSalesOrderDetail] (
    [SalesOrderID]       INT             NOT NULL,
    [OrderQty]           SMALLINT        NOT NULL,
    [ProductID]          INT             NOT NULL,
    [UnitPrice]          MONEY           NOT NULL,
    [UnitPriceDiscount]  MONEY           NOT NULL,
    [LineTotal]          NUMERIC (38, 6) NOT NULL,
    [ModifiedDate]       DATETIME        NOT NULL,
    [SalesOrderDetailID] INT             NOT NULL,
    [LoadExecutionId]    BIGINT          NOT NULL
);