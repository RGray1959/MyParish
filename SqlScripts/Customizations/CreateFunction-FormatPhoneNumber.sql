CREATE FUNCTION [cgs].[FormatPhoneNumber](@phoneNumber VARCHAR(20))
RETURNS VARCHAR(20)
BEGIN
	DECLARE @Return varchar(20)

	SET @Return = 
			CASE WHEN Len(@PhoneNumber) = 10 
					THEN Substring(@PhoneNumber, 1, 3) + '-' + Substring(@PhoneNumber, 4, 3) + '-' + Substring(@PhoneNumber, 7, 4)
			     WHEN Len(@PhoneNumber) = 7 
					THEN Substring(@PhoneNumber, 1, 3) + '-' + Substring(@PhoneNumber, 4, 4)
				 ELSE @PhoneNumber END

    RETURN @Return
END 

GO


