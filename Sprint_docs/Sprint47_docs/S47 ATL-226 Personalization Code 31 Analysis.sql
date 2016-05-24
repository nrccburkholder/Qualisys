/*
S47 ATL-226 Personalization Code 31 Analysis.sql

As Atlas team member, we would like analyze work to best configure personalization code 31 
to not require any address field mappings, so that we can use it on handouts.

Chris Burkholder

select * from codes c, codestext ct, codetexttag ctt, tag t
where c.code = ct.code
and ct.codetext_id = ctt.codetext_id
and ctt.tag_id = t.tag_id
and c.code = 31
*/

--DO

USE [QP_Prod]
GO

delete from codetexttag where codetext_id = 48 --and tag_id in (28,29)

--ROLLBACK
/*
if not exists (select * from codetexttag where codetext_id = 48 and tag_id = 23)
insert into CODETEXTTAG (CODETEXT_ID,TAG_ID,INTSTARTPOS,INTLENGTH)
values (48,23,215,11)
if not exists (select * from codetexttag where codetext_id = 48 and tag_id = 28)
insert into CODETEXTTAG (CODETEXT_ID,TAG_ID,INTSTARTPOS,INTLENGTH)
values (48,28,2,9)
if not exists (select * from codetexttag where codetext_id = 48 and tag_id = 29)
insert into CODETEXTTAG (CODETEXT_ID,TAG_ID,INTSTARTPOS,INTLENGTH)
values (48,29,11,10)
*/
