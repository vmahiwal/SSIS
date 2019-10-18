CREATE TABLE [SystemLog].[ExecutionStatictics]
    (
      [ExecutionStatisticId] BIGINT
        NOT NULL
        IDENTITY(1, 1)
        CONSTRAINT [PK_ExecutionStatistics] PRIMARY KEY CLUSTERED ,
      [LoadExecutionId] BIGINT NOT NULL ,
      [SSISProjectName] NVARCHAR(260) NOT NULL ,
      [SSISPackageName] NVARCHAR(260) NOT NULL ,
      [SSISPackageStartDateTime] DATETIMEOFFSET NOT NULL ,
      [SSISPackageEndDateTime] DATETIMEOFFSET NOT NULL ,
      [DataFlowPathIdString] NVARCHAR(4000) NOT NULL ,
      [SourceComponentName] NVARCHAR(500) NOT NULL ,
      [DestinationComponentName] NVARCHAR(500) NOT NULL ,
      [RowsSent] INT
        NOT NULL
        CONSTRAINT [FK_ExecutionStatictics_To_LoadExecutions]
        FOREIGN KEY ( [LoadExecutionId] ) REFERENCES [SystemLog].[LoadExecutions] ( [LoadExecutionId] )
    );
