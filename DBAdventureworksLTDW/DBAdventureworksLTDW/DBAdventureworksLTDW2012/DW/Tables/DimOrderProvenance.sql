CREATE TABLE [DW].[DimOrderProvenance] (
    [IDOrderProvenance]     SMALLINT     IDENTITY (1, 1) NOT NULL,
    [ProvenanceCode]        SMALLINT     NOT NULL,
    [ProvenanceDescription] VARCHAR (50) NOT NULL,
    [LoadExecutionId]       BIGINT       NOT NULL,
    CONSTRAINT [DimOrderProvenance_PK] PRIMARY KEY CLUSTERED ([IDOrderProvenance] ASC)
);

