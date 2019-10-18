CREATE TABLE [SystemLog].[Loads]
    (
      [LoadId] BIGINT NOT NULL
                      IDENTITY(1, 1)
                      CONSTRAINT [PK_LoadId] PRIMARY KEY CLUSTERED ,
      [LoadApplicationId] TINYINT NOT NULL ,
      [LoadStartDateTime] DATETIME NOT NULL ,
      [LoadEndDateTime] DATETIME NULL ,
      [LoadStatusId] TINYINT NOT NULL
    );
	GO

ALTER TABLE [SystemLog].[Loads]  ADD
CONSTRAINT [FK_Loads_To_LoadApplications]
FOREIGN KEY ( [LoadApplicationId] ) REFERENCES [SystemLog].[LoadApplications] ( [LoadApplicationId]);  

GO
ALTER TABLE [SystemLog].[Loads]  ADD
CONSTRAINT [FK_Loads_To_ExectionStatus]
FOREIGN KEY ( [LoadStatusId] ) REFERENCES [SystemLog].[ExecutionStatus] ( [ExecutionStatusId]);  