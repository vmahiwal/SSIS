CREATE TABLE [SystemLog].[ExecutionStatus]
    (
      [ExecutionStatusId] TINYINT NOT NULL ,
      [ExecutionStatusName] NVARCHAR(25) NOT NULL ,
      [ExecutionStatusDescription] NVARCHAR(100)
        NOT NULL
        CONSTRAINT [PK_ExecutionStatus]
        PRIMARY KEY CLUSTERED ( [ExecutionStatusId] ASC )
    );