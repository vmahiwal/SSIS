CREATE TABLE [SystemLog].[ExecutionRejects]
    (
      [ExecutionRejectsId] BIGINT IDENTITY(1,1) NOT NULL
                             CONSTRAINT PK_LoadRejects PRIMARY KEY ,
      [LoadExecutionId] BIGINT NOT NULL ,
      [Code] VARCHAR(100) NOT NULL ,
      [RowValues] VARCHAR(4000)
        NOT NULL
        CONSTRAINT [FK_LoadExecutionRejects_To_LoadExecutions]
        FOREIGN KEY ( [LoadExecutionId] ) REFERENCES [SystemLog].[LoadExecutions] ( [LoadExecutionId] )
    );