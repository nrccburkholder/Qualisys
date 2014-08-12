use qp_prod
go
CREATE TABLE dbo.SubtypeCategory (
	SubtypeCategory_id int identity(1,1)
	,SubtypeCategory_nm varchar(50)
	,bitMultiSelect bit
)
ALTER TABLE SubtypeCategory ADD CONSTRAINT pk_SubtypeCategory PRIMARY KEY (SubtypeCategory_id)
go
INSERT INTO dbo.SubtypeCategory VALUES ('Subtype',1)
INSERT INTO dbo.SubtypeCategory VALUES ('Questionnaire Type',0)
go
CREATE TABLE dbo.Subtype (
	Subtype_id int identity(1,1)
	,Subtype_nm varchar(50)
	,SubtypeCategory_id int
	,bitRuleOverride bit
)
go
ALTER TABLE Subtype ADD CONSTRAINT pk_Subtype PRIMARY KEY (Subtype_id)
go
ALTER TABLE dbo.Subtype 
ADD CONSTRAINT fk_Subtype_SubtypeCategory
FOREIGN KEY (SubtypeCategory_id)
REFERENCES SubtypeCategory(SubtypeCategory_id)
go
CREATE TABLE dbo.SurveyTypeSubtype (
	SurveyTypeSubtype_id int identity(1,1)
	,SurveyType_id int
	,Subtype_id int
)
go
ALTER TABLE SurveyTypeSubtype ADD CONSTRAINT pk_SurveyTypeSubtype PRIMARY KEY (SurveyTypeSubtype_id)
go
ALTER TABLE dbo.SurveyTypeSubtype 
ADD CONSTRAINT fk_SurveyTypeSubtype_SurveyType
FOREIGN KEY (SurveyType_id)
REFERENCES SurveyType(SurveyType_id)
go
ALTER TABLE dbo.SurveyTypeSubtype 
ADD CONSTRAINT fk_SurveyTypeSubtype_Subtype
FOREIGN KEY (Subtype_id)
REFERENCES Subtype(Subtype_id)
go
CREATE TABLE dbo.SurveySubtype (
	SurveySubtype_id int identity(1,1)
	,Survey_id int
	,Subtype_id int
)
go
ALTER TABLE SurveySubtype ADD CONSTRAINT pk_SurveySubtype PRIMARY KEY (SurveySubtype_id)
go
ALTER TABLE dbo.SurveySubtype
ADD CONSTRAINT fk_SurveySubtype_Survey
FOREIGN KEY (Survey_id)
REFERENCES Survey_def(Survey_id)
go
ALTER TABLE dbo.SurveySubtype
ADD CONSTRAINT fk_SurveySubtype_Subtype
FOREIGN KEY (Subtype_id)
REFERENCES Subtype(Subtype_id)
go

begin
	INSERT INTO dbo.subtype VALUES ('MNCM',1,0)
	INSERT INTO dbo.subtype VALUES ('WCHQ',1,0)
	INSERT INTO dbo.subtype VALUES ('MIPEC',1,0)
	INSERT INTO dbo.subtype VALUES ('Visit Adult 2.0',2,0)
	INSERT INTO dbo.subtype VALUES ('12-month Adult 2.0',2,0)
	INSERT INTO dbo.subtype VALUES ('12-month Child 2.0',2,0)
	INSERT INTO dbo.subtype VALUES ('12-month Adult 2.0 w/ PCMH',2,0) 
	INSERT INTO dbo.subtype VALUES ('12-month Child 2.0 w/ PCMH',2,0) 
	INSERT INTO dbo.subtype VALUES ('PCMH',1,0)

	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,1)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,2)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,3)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,4)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,5)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,6)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,7)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,8)
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,9)
end
go
INSERT INTO dbo.surveysubtype (survey_id, subtype_id)
select sd.survey_id, st.subtype_id
from dbo.survey_def sd
inner join dbo.surveysubtypes sst on sd.surveysubtype_id=sst.surveysubtype_id
inner join dbo.subtype st on sst.subtype_nm=st.subtype_nm

INSERT INTO dbo.surveysubtype (survey_id, subtype_id)
select sd.survey_id, st.subtype_id
from dbo.survey_def sd
inner join dbo.questionnairetypes qt on sd.questionnairetype_id=qt.questionnairetype_id
inner join dbo.subtype st on qt.description=st.subtype_nm
go
DROP TABLE dbo.surveysubtypes
DROP TABLE dbo.questionnairetypes 



select * from dbo.SubtypeCategory 
select * from dbo.Subtype
select * from dbo.SurveyTypeSubtype 
select * from dbo.SurveySubtype




exec sp_help SubtypeCategory 
exec sp_help Subtype
exec sp_help SurveyTypeSubtype 
exec sp_help SurveySubtype