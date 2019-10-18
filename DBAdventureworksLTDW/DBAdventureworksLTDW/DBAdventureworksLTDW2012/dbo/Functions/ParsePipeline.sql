CREATE FUNCTION [dbo].[ParsePipeline]
(@message VARCHAR (8000), @which INT)
RETURNS VARCHAR (200)
AS
begin
	--@which defines which value is desired
	-- 1= PathID
	-- 2= declare PathIDName
	-- 3= declare ComponentID
	-- 4= declare ComponentIDName
	-- 5= declare InputID
	-- 6= declare InputIDName
	-- 7= declare rowssent

	declare @sourcemessage varchar(600)	
	declare @where as integer
	declare @mycounter integer

	If @which < 1 or @which > 7 return null
	set @mycounter=0
	--catch older versions of the messages that lacked the extra parameters
	if patindex('%:  :%', @message) = 0 return null
	
	--chop the initial wordy stuff out
	set @sourcemessage = right(@message, len(@message) - patindex('%:  :%', @message) - 3)

	--loop through occurances of : until we get to the desired one
	set @where = 99
	while @where <> 0 begin
		set @mycounter = @mycounter+1
		set @where = patindex('%:%',@sourcemessage)
		If @mycounter = 7 return @sourcemessage
		if @mycounter = @which return(left(@sourcemessage, @where - 1))
		set	@sourcemessage = right(@sourcemessage, (len(@sourcemessage) - @where))	
	end --while
	
	--should not execute this but a return is required as the last statement
	return @sourcemessage
end
