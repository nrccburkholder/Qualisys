/*
	RTP-4405 Script to Add LangID 2 for HH & OAS.sql

	Dana Petersen 

	8/21/2017

	ALTER PROCEDURE SP_FG_FormGen

*/

/****** 
Script to add LangID 2 to questionnaires for HH CAHPS & OAS CAHPS

For each table, copy records for langid 19 to a temp table, and insert back into the table with langid 2

******/

use QP_Prod

/********** Create Temp Tables **********/

--Sel_Qstns
create table #SelQstns (SelQstns_id int, survey_id int, scaleid int, section_id int,
label char(60),plusminus char(3),subsection int, item int, subtype int, width int, height int,
richtext text, scalepos int, scaleflipped int, nummarkcount int, bitmeanable bit, numbubblecount int,
qstncore int, bitlangreview bit, strfullquestion varchar(6000))

--Sel_Scls
create table #SelScls (survey_id int, qpc_id int, item int, val int, label char(60), richtext text,
	missing bit, charset int, scaleorder int, intresptype int)

--Sel_TextBox
create table #SelTextbox (qpc_id int, survey_id int, coverid int, X int, Y int, width int, height int,
	richtext text, border int, shading int, bitlangreview bit, label char(60))

--CodeQstns
create table #CodeQstns (selqstns_id int, survey_id int, code int, intstartpos int, intlength int)

--CodeTxtBox
create table #CodeTxtBox (qpc_id int, survey_id int, code int, intstartpos int, intlength int)

--SurveyLanguage
create table #surveys (survey_id int)

/********* Populate Temp Tables **************/

--Sel_Qstns
INSERT INTO #SelQstns
	(SelQstns_id, survey_id, scaleid, section_id, label, plusminus, subsection, item, subtype, 
	width, height, richtext, scalepos, scaleflipped, nummarkcount, bitmeanable, numbubblecount, qstncore, 
	bitlangreview, strfullquestion)
SELECT sq.SELQSTNS_ID, sq.SURVEY_ID, sq.SCALEID, sq.SECTION_ID, sq.LABEL, sq.PLUSMINUS, sq.SUBSECTION, sq.ITEM, 
	sq.SUBTYPE, sq.WIDTH, sq.HEIGHT, sq.RICHTEXT, sq.SCALEPOS, sq.SCALEFLIPPED, sq.NUMMARKCOUNT, sq.BITMEANABLE, 
	sq.NUMBUBBLECOUNT, sq.QSTNCORE, sq.BITLANGREVIEW, sq.strFullQuestion
FROM SEL_QSTNS sq 
inner join SURVEY_DEF sd 
on sq.Survey_id = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and sq.[LANGUAGE] = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete tsq 
from #SelQstns tsq
join SEL_QSTNS sq
on tsq.survey_id = sq.SURVEY_ID and tsq.SelQstns_id=sq.SELQSTNS_ID 
where sq.LANGUAGE = 2

--select * from #SelQstns


--Sel_Scls
insert into #SelScls (survey_id, qpc_id, item, val, label, richtext,
	missing, charset, scaleorder, intresptype)
select ss.SURVEY_ID, ss.QPC_ID, ss.ITEM, ss.VAL, ss.LABEL, ss.RICHTEXT,
	ss.MISSING, ss.CHARSET, ss.SCALEORDER, ss.INTRESPTYPE
from SEL_SCLS ss
join SURVEY_DEF sd
on ss.SURVEY_ID = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and ss.[LANGUAGE] = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete tss
from #SelScls tss
join SEL_SCLS ss
on tss.survey_id = ss.SURVEY_ID and tss.qpc_id=ss.qpc_id and tss.item=ss.item
where ss.LANGUAGE = 2


--Sel_TextBox
insert into #SelTextbox (qpc_id, survey_id, coverid, X, Y, width, height,
	richtext, border, shading, bitlangreview, label)
select st.QPC_ID, st.SURVEY_ID, st.COVERID, st.X, st.Y, st.WIDTH, st.HEIGHT,
	st.RICHTEXT, st.BORDER, st.SHADING, st.BITLANGREVIEW, st.LABEL
from SEL_TEXTBOX st
join SURVEY_DEF sd
on st.SURVEY_ID = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and st.[LANGUAGE] = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete tst 
from #SelTextbox tst
join SEL_TEXTBOX st
on tst.survey_id = st.SURVEY_ID and tst.qpc_id=st.qpc_id
where st.LANGUAGE = 2

--CodeQstns
insert into #CodeQstns (selqstns_id, survey_id, code, intstartpos, intlength)
select cq.SELQSTNS_ID, cq.SURVEY_ID, cq.CODE, cq.INTSTARTPOS, cq.INTLENGTH
from CODEQSTNS cq
join survey_def sd
on cq.SURVEY_ID = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and cq.[LANGUAGE] = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete tcq 
from #CodeQstns tcq
join CODEQSTNS cq
on tcq.survey_id = cq.SURVEY_ID and tcq.selqstns_id=cq.SELQSTNS_ID and tcq.code=cq.code
where cq.LANGUAGE = 2

--CodeTxtBox
insert into #CodeTxtBox (qpc_id, survey_id, code, intstartpos, intlength)
select ctb.QPC_ID, ctb.SURVEY_ID, ctb.CODE, ctb.INTSTARTPOS, ctb.INTLENGTH
from CODETXTBOX ctb
join survey_def sd
on ctb.survey_id = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and ctb.[LANGUAGE] = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete tctb 
from #CodeTxtBox tctb
join CODETXTBOX ctb
on tctb.survey_id = ctb.SURVEY_ID and tctb.qpc_id=ctb.qpc_id and tctb.code=ctb.code
where ctb.LANGUAGE = 2

--SurveyLanguage
insert into #surveys (survey_id)
select sl.survey_id
from SurveyLanguage sl
join survey_def sd
on sl.Survey_id = sd.SURVEY_ID
where sd.SurveyType_id in (3, 16)   --3 = HH, 16 = OAS
and sl.LangID = 19   --HCAHPS Spanish
--and sd.SURVEY_ID = 19132

--Delete records for any surveys that already have langid = 2, so we don't get duplicates
delete ts 
from #surveys ts
join SurveyLanguage sl
on ts.survey_id = sl.Survey_id
where sl.LangID = 2


/************** Insert Data into Real Tables ************/
begin tran
begin try

--Sel_Qstns
insert into SEL_QSTNS 	(SelQstns_id, survey_id, [LANGUAGE], scaleid, section_id, label, plusminus, subsection, item, subtype, 
	width, height, richtext, scalepos, scaleflipped, nummarkcount, bitmeanable, numbubblecount, qstncore, 
	bitlangreview, strfullquestion)
select SelQstns_id, survey_id, 2, scaleid, section_id, label, plusminus, subsection, item, subtype, 
	width, height, richtext, scalepos, scaleflipped, nummarkcount, bitmeanable, numbubblecount, qstncore, 
	bitlangreview, strfullquestion
from #SelQstns

--Sel_Scls
insert into SEL_SCLS (survey_id, qpc_id, item, [LANGUAGE], val, label, richtext,
	missing, charset, scaleorder, intresptype)
select survey_id, qpc_id, item, 2, val, label, richtext,
	missing, charset, scaleorder, intresptype
from #SelScls

--Sel_TextBox
insert into SEL_TEXTBOX (qpc_id, survey_id, [LANGUAGE], coverid, X, Y, width, height,
	richtext, border, shading, bitlangreview, label)
select qpc_id, survey_id, 2, coverid, X, Y, width, height,
	richtext, border, shading, bitlangreview, label
from #SelTextbox

--CodeQstns
insert into CODEQSTNS (selqstns_id, survey_id, [LANGUAGE], code, intstartpos, intlength)
select selqstns_id, survey_id, 2, code, intstartpos, intlength
from #CodeQstns

--CodeTxtBox
insert into CODETXTBOX (qpc_id, survey_id, [language], code, intstartpos, intlength)
select qpc_id, survey_id, 2, code, intstartpos, intlength
from #CodeTxtBox

--SurveyLanguage
insert into SurveyLanguage (Survey_id, LangID)
select survey_id, 2
from #surveys

end try

begin catch
select error_number() as ErrorNum, 
	error_line() as ErrorLine,
	error_message() as ErrorMessage

if @@trancount > 0
	rollback tran
end catch

if @@trancount > 0
	commit tran

/*****************************/
--Looks good??

--commit tran

--Uh-Oh??
--rollback tran

/******Tidy Up***************/

drop table #SelQstns
drop table #SelScls
drop table #SelTextbox
drop table #CodeQstns
drop table #CodeTxtBox
drop table #surveys

/******* Testing ************/

--select * from SEL_QSTNS
--where survey_id = 19132
--order by qstncore, [language]

--select * from SEL_SCLS
--where survey_id = 19132

--select * from SEL_TEXTBOX
--where survey_id = 19132

--select * from CODEQSTNS
--where survey_id = 19132

--select * from CODETXTBOX
--where survey_id = 19132

--select * from SurveyLanguage
--where Survey_id = 19132
