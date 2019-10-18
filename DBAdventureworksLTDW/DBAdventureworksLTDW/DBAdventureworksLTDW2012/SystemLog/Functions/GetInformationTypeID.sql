CREATE FUNCTION [SystemLog].[GetInformationTypeID]
(@INFORMATIONTYPENAME VARCHAR (25))
RETURNS TINYINT
AS
BEGIN
	declare @Return TINYINT

	SELECT @Return = InformationTypeID
	FROM SystemLog.InformationType
	WHERE InformationTypeName = @INFORMATIONTYPENAME;
	
    RETURN ISNULL(@return, 0)
END
