CREATE TABLE [dbo].[ClientFormat]
(
	CCN varchar(6) NOT NULL,
	Format varchar(20) NOT NULL,
	CreateDate DATETIME NOT NULL CONSTRAINT [DF_ClientFormat_CreateDate] DEFAULT GETDATE(),

	constraint PK_ClientFormat primary key clustered (CCN)
)
GO