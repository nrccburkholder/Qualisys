/****** Object:  StoredProcedure [dbo].[compute_ChildScoreForRespondents]    Script Date: 08/08/2006 15:58:26 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_ChildScoreForRespondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_ChildScoreForRespondents]
GO
/****** Object:  StoredProcedure [dbo].[compute_ChildScoreForRespondents]    Script Date: 08/08/2006 15:58:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_ChildScoreForRespondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  procedure compute_ChildScoreForRespondents(@RespondentID int)
as
begin

-- Get survey id of the respondent
DECLARE @SurveyID int
SET @SurveyID = [dbo].GetRespondentSurveyID(@RespondentID) 

-- Check that respondent is in correct survey, if not correct survey - flag and exit routine
IF (@SurveyID NOT IN (12, 17))
	BEGIN
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = 1, @RespondentID = @RespondentID, @EventParameters = ''compute_ChildScoreForRespondents: Finalize routine not run for respondent. Does not belong to a listed survey.''
		RETURN	
	END

declare @lwi1	int		-- some of the effective colums to be pulled from the respondents table
declare @lwi1_a	int
declare @lwi1_b	int
declare @lwi1_c_text varchar(1000)
declare @lwi2	int
declare @lwi2_a	int
declare @lwi2_b	int
declare @lwi2_c_text varchar(1000)
declare @lwi3	int
declare @lwi3_a	int
declare @lwi3_b	int
declare @lwi3_c_text varchar(1000)
declare @lwi4	int
declare @lwi4_a	int
declare @lwi4_b	int
declare @lwi4_c_text varchar(1000)
declare @lwi5	int
declare @lwi5_a	int
declare @lwi5_b_text varchar(1000)
declare @lwi6	int
declare @lwi7	int
declare @lwi8	int
declare @lwi9	int



declare @rxmeds int
declare @serve int
declare @func  int
declare @therapy int
declare @mhealth int
declare @lwi_dep int
declare @lwi_serv int
declare @lwi_func int
declare @lwiscren int
declare @metlwi int
declare @lwinum int
declare @defnum int


/* This cursor looks at each respondent and uses the 
 special trigger func getResponseAnswerValue to get the values for the fields lw1,lw1_a, etc.
 There is a bit of finesse in making the values be 0 for no,  and 1 for yes
*/
SET SELECT 
 @lwi1 = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use meds prescribed by doctor''),2),
 /* isnull -- handles if it is not entered.  Alot of the _b, _c  questions are skipped because the first question is skipped,
   so this makes it assume that a null is 2 -- which is a no for most questions.
   2- is the converter that makes the numbers just like in the spss script.  2-1 (yes) = 1  and 2-2(no) = 0
 */
 @lwi1_a = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use medication prescribed by doctor - reason''),2),
 @lwi1_b = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use medication prescribed by doctor - duration''),2),
 @lwi1_c_text = dbo.getResponseText(RespondentID,''Need/use medication prescribed by doctor Cond_name''),
 @lwi2 = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use more medical care - comparison''),2),
 @lwi2_a = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use more medical care - reason''),2),
 @lwi2_b = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/use more medical care - duration''),2),
 @lwi2_c_text = dbo.getResponseText(RespondentID,''Need/use more medical care''),
 @lwi3 = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Limited/prevented doing things - comparison''),2),
 @lwi3_a = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Limited/prevented doing things - reason''),2),
 @lwi3_b = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Limited/prevented doing things - duration''),2),
 @lwi3_c_text = dbo.getResponseText(RespondentID,''Limited/prevented doing things''),
 @lwi4 = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/get special therapy - needs''),2),
 @lwi4_a = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/get special therapy - reason''),2),
 @lwi4_b = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/get special therapy - duration''),2),
 @lwi4_c_text = dbo.getResponseText(RespondentID,''Need/get special therapy''),
 @lwi5 = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/get treatment or counseling - reason''),2),
 @lwi5_a = 2-isnull(dbo.getResponseAnswerValue(RespondentID,''Need/get treatment or counseling - duration''),2),
 @lwi5_b_text = dbo.getResponseText(RespondentID,''Need/get treatment or counseling''),
 @lwi6 = isnull(dbo.getResponseAnswerValue(RespondentID,''Completed immunizations/booster shots''),-1), /*-1 is null, 1 is yes,  2 is no,  3 is maybee */
 @lwi7 = isnull(dbo.getResponseAnswerValue(RespondentID,''Child smoke''),-1), /* -1 is null, 1 is yes,  2 is no,  3 is idontknow */
 @lwi8 = isnull(dbo.getResponseAnswerValue(RespondentID,''Child''''s willingness to quit smoking''),-1), /*-1 is null, 1 is not willing at all,   2 is 2, 3 is 3,  4 is ready to quit now */
 @lwi9 = isnull(dbo.getResponseAnswerValue(RespondentID,''Lead paint in home''),-1) /* -1 is null, 1 is yesm  2 is no,  3 is dont know */
 from respondents
 where RespondentID = @RespondentID

print ''Respondent '' + convert(varchar(20),@respondentid)


/***Identifying children who meet CSHCN criteria on each of the five questions

COMPUTE rxmeds = 0.
IF ((lwi1 = 1) and (lwi1_a = 1) and (lwi1_b = 1)) rxmeds = rxmeds +1.  
EXECUTE.
VARIABLE LABEL  rxmeds ''Qualified on rx''d med use?''.
VALUE LABEL rxmeds 0 ''No''  1 ''Yes''. 
*/
if ((@lwi1 = 1) and (@lwi1_a = 1) and (@lwi1_b = 1)) 
	set @rxmeds = 1
else
	set @rxmeds = 0

exec   spChangeResponseAnswerValueText @RespondentID, ''rxmeds'', @rxmeds,@lwi1_c_text  /*this stores the value in the db */


/*COMPUTE serve = 0.
If ((lwi2 = 1) and (lwi2_a =1) and (lwi2_b = 1)) serve = serve + 1.
EXECUTE.  
VARIABLE LABEL serve ''Qualified on service use?''.  
VALUE LABEL serve 0 ''No''  1 ''Yes''. 
*/
if ((@lwi2 = 1) and (@lwi2_a =1) and (@lwi2_b = 1))
	set @serve =  1
else
	set @serve=0

exec   spChangeResponseAnswerValueText @RespondentID ,''serve'' ,@serve,@lwi2_c_text


/*COMPUTE func = 0.
IF ((lwi3 = 1) and (lwi3_a = 1) and (lwi3_b = 1)) func = func + 1.
EXECUTE.   
VARIABLE LABEL func ''Qualified on functional limits ?''.
VALUE LABEL func  0 ''No''  1 ''Yes''. */
if ((@lwi3 = 1) and (@lwi3_a = 1) and (@lwi3_b = 1)) 
	set @func = 1
else
	set @func=0
exec   spChangeResponseAnswerValueText @RespondentID ,''func'', @func,@lwi3_c_text

/*COMPUTE therapy = 0.
IF ((lwi4 = 1) and (lwi4_a = 1) and (lwi4_b = 1)) therapy = therapy + 1.
EXECUTE.   
VARIABLE LABEL therapy ''Qualified on use of special therapies?''.
VALUE LABEL therapy  0 ''No''  1 ''Yes''. 
*/
if ((@lwi4 = 1) and (@lwi4_a = 1) and (@lwi4_b = 1)) 
	set @therapy = 1
else
	set @therapy=0
exec   spChangeResponseAnswerValueText @RespondentID ,''therapy'', @therapy,@lwi4_c_text

/*COMPUTE mhealth = 0.
IF ((lwi5 = 1) and (lwi5_a = 1)) mhealth = mhealth  + 1.
EXECUTE.   
VARIABLE LABEL mhealth  ''Qualified on use of mental health services?''.
VALUE LABEL mhealth  0 ''No''  1 ''Yes''. */
if ((@lwi5 = 1) and (@lwi5_a = 1))
	set @mhealth = 1
else
	set @mhealth = 0
exec   spChangeResponseAnswerValueText @RespondentID ,''mhealth'' ,@mhealth,@lwi5_b_text




/*** Identifying how many children meet each of the 3 CSHCN definitional domains

COMPUTE lwi_dep = 0.
IF (rxmeds = 1) lwi_dep = 1.
EXECUTE.
VALUE LABEL lwi_dep 1  ''Yes''  0 '' No''.
VARIABLE LABEL  lwi_dep ''Met CSHCN screener dependency definition''.*/

if (@rxmeds = 1)
	set @lwi_dep = 1
else
	set @lwi_dep = 0
exec   spChangeResponseAnswerValue @RespondentID ,''lwi_dep'', @lwi_dep


/*COMPUTE lwi_serv = 0.
IF ((serve = 1) or (therapy = 1) or (mhealth = 1)) lwi_serv = 1.
EXECUTE.
VALUE LABEL lwi_serv  1 ''Yes''  0 ''No''.
VARIABLE LABEL  lwi_serv ''Met CSHCN screener service use definition''.*/
if ((@serve = 1) or (@therapy = 1) or (@mhealth = 1))
	set @lwi_serv = 1
else
	set @lwi_serv = 0
exec   spChangeResponseAnswerValue @RespondentID, ''lwi_serv'', @lwi_serv


/*COMPUTE lwi_func = 0.
IF (func = 1) lwi_func = 1.
EXECUTE.
VALUE LABEL lwi_func  1 ''Yes''  0 ''No''.
VARIABLE LABEL  lwi_func ''Met CSHCN functional limits definition''.*/
if (@func = 1) 
	set @lwi_func = 1
else
	set @lwi_func = 0
exec   spChangeResponseAnswerValue @RespondentID ,''lwi_func'', @lwi_func

/***Scoring the CSHCN screener

COMPUTE lwiscren = (lwi_func + lwi_dep + lwi_serv).
EXECUTE.
VARIABLE LABELS lwiscren "Number of qualifying CSHCN screener answers".
VALUE LABELS lwiscren
0 "No qualifying answers"
1 "One qualifying answer"
2 "Two qualifying answers"
3 "Three qualifying answers"
4 "Four qualifying answers"
5 "Five qualifying answers".*/
set @lwiscren = (@lwi_func + @lwi_dep + @lwi_serv)
exec   spChangeResponseAnswerValue @RespondentID ,''lwiscren'', @lwiscren


/*COMPUTE metlwi = (lwiscren > 0).  
EXECUTE.
VARIABLE LABEL metlwi ''Results for CSHCN screener''.
VALUE LABEL metlwi  1 ''Yes''  0 ''No''.*/
if (@lwiscren >0)
	set @metlwi = 1
else
	set @metlwi = 0
exec   spChangeResponseAnswerValue @RespondentID ,''metlwi'' ,@metlwi

/*COMPUTE lwinum = 0.
IF (lwi_func > 0 )  lwinum  =  lwinum  + 1.
IF (lwi_dep > 0 ) lwinum  =  lwinum  + 1.
IF (lwi_serv > 0 )  lwinum  =  lwinum  + 1.
EXECUTE.
VARIABLE LABLE lwinum  ''Number of qualifying CSHCN definitions''.
VALUE LABEL lwinum  0 '' Met no defs''  1 '' One out of 3 defs''  2 '' Two out of 3 defs''  3 '' All 3 defs''.*/

set @lwinum = 0
	if (@lwi_func > 0)
set @lwinum = @lwinum + 1
	if (@lwi_dep > 0)
set @lwinum = @lwinum + 1
if (@lwi_serv > 0)
	set @lwinum = @lwinum + 1
exec   spChangeResponseAnswerValue @RespondentID ,''lwinum'', @lwinum
 
/*COMPUTE defnum = 0.
IF ((lwi_dep> 0 )and (lwi_serv  = 0) and (lwi_func  = 0)) defnum = 1.
IF ((lwi_dep = 0) and (lwi_serv  > 0) and (lwi_func  = 0)) defnum = 2.
IF ((lwi_dep = 0) and (lwi_serv  = 0) and (lwi_func  > 0)) defnum = 3.
IF ((lwi_func   > 0) and (lwi_dep  > 0)) defnum = 4.
IF ((lwi_func   > 0) and (lwi_serv  > 0)) defnum = 5.
IF ((lwi_dep > 0) and (lwi_serv   > 0)) defnum = 6.
IF ((lwi_dep > 0) and (lwi_serv   > 0) and (lwi_func > 0)) defnum = 7.
Execute.

MISSING VALUE defnum ("0.").
Execute.
VARIABLE LABEL
defnum ''Number meeting all possible combinations of CSHCN screener definitions'' .
VALUE LABEL
defnum  1 ''Dep def only''  2 ''Service def only''  3 ''Funcdef only''  4 ''Func/dep''
5 ''Func/service''  6 ''Dep/service''   7 ''Func/dep/service''.
 */    
set @defnum=0
if ((@lwi_dep> 0 )and (@lwi_serv  = 0) and (@lwi_func  = 0)) 
	set @defnum = 1
if ((@lwi_dep = 0) and (@lwi_serv  > 0) and (@lwi_func  = 0))
	set @defnum = 2
if ((@lwi_dep = 0) and (@lwi_serv  = 0) and (@lwi_func  > 0))
	set @defnum = 3
if ((@lwi_func   > 0) and (@lwi_dep  > 0))
	set @defnum = 4
if ((@lwi_func   > 0) and (@lwi_serv  > 0))
	set @defnum = 5
if ((@lwi_dep > 0) and (@lwi_serv   > 0)) 
	set @defnum = 6
if ((@lwi_dep > 0) and (@lwi_serv   > 0) and (@lwi_func > 0))
	set @defnum = 7
exec   spChangeResponseAnswerValue @RespondentID ,''defnum'', @defnum

end
' 
END
GO
