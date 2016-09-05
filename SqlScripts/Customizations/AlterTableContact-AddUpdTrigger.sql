USE [CMS_CGS]
GO

/****** Object:  Trigger [dbo].[updContact]    Script Date: 5/30/2016 8:48:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[updContact]
   ON  [dbo].[Contact]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	UPDATE dbo.Contact
	SET LimitToRole = 
		CASE WHEN i.MinistryID in(333,335) THEN 'DirectServices'
			WHEN i.MinistryID = 334 THEN 'EmploymentMinistry'
			WHEN i.MinistryID = 336 THEN 'NeighborhoodMinistry'
			ELSE Null END
	FROM dbo.Contact c
	JOIN inserted i ON i.ContactId = c.ContactId

END

GO


