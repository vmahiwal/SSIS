CREATE FUNCTION [SystemLog].[GetStatusTypeID]
(@STATUSNAME VARCHAR (25))
RETURNS TINYINT
AS
BEGIN
	declare @Return TINYINT

	SELECT @Return = StatusID
	FROM SystemLog.Status
	WHERE StatusName = @STATUSNAME;
	
    RETURN ISNULL(@return, 0)
END
