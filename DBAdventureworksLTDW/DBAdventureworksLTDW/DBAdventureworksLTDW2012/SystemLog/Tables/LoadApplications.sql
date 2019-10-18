CREATE TABLE [SystemLog].[LoadApplications]
    (
      [LoadApplicationId] TINYINT IDENTITY(1,1) NOT NULL
                              CONSTRAINT [PK_LoadApplications] PRIMARY KEY ,
      [ApplicationName] NVARCHAR(100) NOT NULL ,
      [ApplicationDescription] NVARCHAR(200) NOT NULL
    );