
--DROP TABLE ModeSectionMapping

CREATE TABLE ModeSectionMapping 
(ID int IDENTITY(1,1) NOT NULL
,Survey_Id int
,MailingStepMethod_Id int
,MailingStepMethod_nm varchar(42)
,Section_Id int
,SectionLabel varchar(60)
)

