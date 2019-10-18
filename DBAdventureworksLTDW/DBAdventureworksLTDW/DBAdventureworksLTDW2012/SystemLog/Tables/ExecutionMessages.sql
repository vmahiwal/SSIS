CREATE TABLE [SystemLog].[ExecutionMessages]
    (
      [ExecutionMessageId] BIGINT
        IDENTITY(1, 1)
        NOT NULL
        CONSTRAINT [PK_ExecutionMessages] PRIMARY KEY CLUSTERED ,
      [LoadExecutionId] BIGINT NOT NULL ,
	  [SSISPackageName] NVARCHAR(260) NOT NULL , 
	  [SSISEventName] NVARCHAR(1024) NOT NULL ,
	  [SourceComponentName] NVARCHAR(500)  NULL ,
	  [PackagePathIdString] NVARCHAR(4000) NOT NULL ,
	  [ExecutionPathIdString] NVARCHAR(4000) NOT NULL ,
      [ExecutionMessageTypeId] TINYINT NOT NULL ,  
      [ExecutionMessage] NVARCHAR(4000)
        NOT NULL,
	  [ExecutionMessageDateTime] DateTime NOT NULL
        CONSTRAINT [FK_ExecutionMessages_To_LoadExecutions]
        FOREIGN KEY ( [LoadExecutionId] ) REFERENCES [SystemLog].[LoadExecutions] ( [LoadExecutionId] )
        CONSTRAINT [FK_ExecutionMessages_to_ExecutionMessageTypes]
        FOREIGN KEY ( ExecutionMessageTypeId ) REFERENCES [SystemLog].ExecutionMessageTypes ( [ExecutionMessageTypeId] )
    );