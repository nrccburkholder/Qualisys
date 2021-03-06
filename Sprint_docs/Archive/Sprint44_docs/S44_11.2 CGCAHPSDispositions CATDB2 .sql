/*

	S44 US11 CG-CAHPS Dispositions 
	As a CG-CAHPS vendor, we need to update the disposition hierarchy to match the new specs, so that we can submit accurate data.

	Task 2 - Update CAHPSTypeDispositions & CAHPSTypeDispositionMapping on Catalyst

	Tim Butler
*/




USE [NRC_Datamart]
GO

DECLARE @CahpsTypeID int  = 10

INSERT INTO [dbo].[CahpsType]
           ([CahpsTypeID]
           ,[Label]
           ,[NumberCutoffDays]
           ,[MinimumNSizeThreshold])
     VALUES
           (@CahpsTypeID
           ,'CGCAHPS'
           ,9999
           ,NULL)

GO

DECLARE @newDispositionID int

SELECT @newDispositionID = Disposition_id
from Qualisys.qp_prod.dbo.Disposition
where strDispositionLabel = 'Incomplete Survey (no measure question answered)'


if not exists (select 1 from dbo.Disposition where Label = 'Incomplete Survey (no measure question answered)')
begin

	INSERT INTO [dbo].[Disposition]([DispositionID],[Label])VALUES(@newDispositionID,'Incomplete Survey (no measure question answered)')

end



INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(101,10,'Complete',1,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(102,10,'Partial Complete',0,1)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(103,10,'Incomplete',0,1)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(104,10,'Survey returned - No to Question 1',0,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(105,10,'Refused to complete survey',0,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(106,10,'Deceased',0,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(107,10,'Ineligible; mentally or physically incapacitated',0,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(108,10,'Unable to contact (bad addr/phone, language barrier)',0,0)
INSERT INTO [dbo].[CahpsDisposition]([CahpsDispositionID],[CahpsTypeID],[Label],[IsCahpsDispositionComplete],[IsCahpsDispositionInComplete]) VALUES(109,10,'Did not respond after maximum attempts',0,0)



INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,13,-1,'Complete',101,4,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,11,-1,'Partial Complete',102,5,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,@newDispositionID,-1,'Incomplete',103,6,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,23,-1,'Survey returned - No to Question 1',104,3,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,2,-1,'Refused to complete survey',105,7,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,3,-1,'Deceased',106,1,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,4,-1,'Ineligible; mentally or physically incapacitated',107,2,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,10,-1,'Unable to contact (bad addr/phone, language barrier)',108,8,0)
INSERT INTO [dbo].[CahpsDispositionMapping]([CahpsTypeID],[DispositionID],[ReceiptTypeID],[Label],[CahpsDispositionID],[CahpsHierarchy],[IsDefaultDisposition]) VALUES(10,12,-1,'Did not respond after maximum attempts',109,12,1)


GO

select *
from dbo.Disposition
where [Label] = 'Incomplete Survey (no measure question answered)'


select *
from dbo.CahpsType
where CahpsTypeID = 10

select *
from [dbo].[CahpsDisposition]
where CahpsTypeID = 10

SELECT *
FROM [NRC_Datamart].[dbo].[CahpsDispositionMapping]
where CahpsTypeID = 10

