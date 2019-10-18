CREATE PROCEDURE [SystemLog].[PackageLogUps]
@PackageName VARCHAR (255), @PackageGuid UNIQUEIDENTIFIER, @VersionBuild SMALLINT, @VersionMajor SMALLINT, @VersionMinor SMALLINT, @VersionComment VARCHAR (1000), @PackageLogID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @tbl table (ID int);
	SET @PackageLogID = -1;
	begin try
		update [SystemLog].PackageLog
		set PackageName = @PackageName,
		    VersionComment = @VersionComment
		output inserted.PackageLogID into @tbl
		WHERE PackageGUID = @PackageGuid
		  and  VersionBuild = @VersionBuild
		  and VersionMajor = @VersionMajor
		  and VersionMinor = @VersionMinor;
	      
		IF (Select COUNT(1) from @tbl) > 1 
		  raiserror('More than one packagelog row updated',10,127)
		  
		if not exists( select 1 from @tbl) 
		  INSERT INTO [SystemLog].[PackageLog]
			   ([PackageName]
			   ,[PackageGUID]
			   ,[VersionBuild]
			   ,[VersionMajor]
			   ,[VersionMinor]
			   ,[VersionComment])
			   output inserted.PackageLogID into @tbl 
		 VALUES
			   (@PackageName, 
				@PackageGUID, 
				@VersionBuild, 
				@VersionMajor, 
				@VersionMinor, 
				@VersionComment);
	   select @PackageLogID =  ID
	   from @tbl;
	end try
	begin catch
	  SELECT
		ERROR_NUMBER() AS "@Number",
		ERROR_STATE() AS "@State",
		ERROR_SEVERITY() AS "@Severity",
		ERROR_MESSAGE() AS "Message",
		ERROR_LINE() AS "Procedure/@Line",
		ERROR_PROCEDURE() AS "Procedure"
		FOR XML PATH('Error');
	end catch            


  
END
