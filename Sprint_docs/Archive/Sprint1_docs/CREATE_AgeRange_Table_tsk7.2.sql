USE [QP_Prod]
GO


CREATE TABLE [dbo].[VendorFileAgeRange](
	[VendorFileAgeRange_id] [int] IDENTITY(1,1) NOT NULL,
	[StartAge] [tinyint] NULL,
	[EndAge] [tinyint] NULL,
	[AgeRange] [varchar](10) NULL
)

GO


insert VendorFileAgeRange values(18,24,'18-24') 
insert VendorFileAgeRange values(25,34,'25-34') 
insert VendorFileAgeRange values(35,44,'35-44') 
insert VendorFileAgeRange values(45,54,'45-54') 
insert VendorFileAgeRange values(55,64,'55-64') 
insert VendorFileAgeRange values(65,74,'65-74') 
insert VendorFileAgeRange values(75,255,'75+') 

select *
from VendorFileAgeRange