CREATE TABLE [SystemLog].[LoadEnvironments]
(
	[LoadEnvironmentId] BIGINT IDENTITY(1,1) NOT NULL  CONSTRAINT [PK_LoadEnvironments] PRIMARY KEY CLUSTERED
   ,[EnvironmentName] NVARCHAR(25) NOT NULL
   ,[EnvironmentDescription] NVARCHAR(1000) NULL
);