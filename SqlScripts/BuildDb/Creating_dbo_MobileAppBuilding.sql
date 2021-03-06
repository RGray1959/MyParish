CREATE TABLE [dbo].[MobileAppBuilding]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[name] [nvarchar] (100) NOT NULL CONSTRAINT [DF_MobileAppCampuses_name] DEFAULT (''),
[order] [int] NOT NULL CONSTRAINT [DF_MobileAppCampuses_order] DEFAULT ((0)),
[enabled] [bit] NOT NULL CONSTRAINT [DF_MobileAppCampuses_enabled] DEFAULT ((1))
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
