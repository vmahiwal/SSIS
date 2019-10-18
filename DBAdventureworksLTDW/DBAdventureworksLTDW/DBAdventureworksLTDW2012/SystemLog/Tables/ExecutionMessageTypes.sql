CREATE TABLE [SystemLog].[ExecutionMessageTypes]
    (
      [ExecutionMessageTypeId] TINYINT NOT NULL ,
      [ExecutionMessageTypeName] NVARCHAR(20) NOT NULL ,
      [ExecutionMessageTypeDescription] VARCHAR(255) NOT NULL ,
	  [SSISDBMessageType] SMALLINT  NULL
      CONSTRAINT [PK_ExecutionMessageTypes] PRIMARY KEY CLUSTERED
        ( [ExecutionMessageTypeId] ASC )
    );