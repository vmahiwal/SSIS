CREATE TABLE [SystemLog].[LoadExecutions]
    (
      [LoadExecutionId] BIGINT
        NOT NULL
        IDENTITY(1, 1)
        CONSTRAINT [PK_LoadExecutions] PRIMARY KEY CLUSTERED ,
      [SSISServerExecutionId] BIGINT NOT NULL ,
      [LoadId] BIGINT NOT NULL ,
	  [ExecutionStatusId] TINYINT NOT NULL,
	  [LoadEnvironmentId] BIGINT NOT NULL,
      [ExecutionStartDateTime] DATETIME NOT NULL ,
      [ExecutionEndDateTime] DATETIME NULL
    );
	GO

ALTER TABLE SystemLog.LoadExecutions 
WITH NOCHECK ADD
CONSTRAINT [FK_Executions_To_Loads]
FOREIGN KEY ( [LoadId] ) REFERENCES [SystemLog].[Loads] ( [LoadId]);  
GO

ALTER TABLE SystemLog.LoadExecutions  ADD
CONSTRAINT [FK_Executions_To_ExectionStatus]
FOREIGN KEY ( [ExecutionStatusId] ) REFERENCES [SystemLog].[ExecutionStatus] ( [ExecutionStatusId]);  
GO

ALTER TABLE SystemLog.LoadExecutions  ADD
CONSTRAINT [FK_Executions_To_LoadEnvironment]
FOREIGN KEY ( [LoadEnvironmentId] ) REFERENCES [SystemLog].[LoadEnvironments] ( [LoadEnvironmentId]);  