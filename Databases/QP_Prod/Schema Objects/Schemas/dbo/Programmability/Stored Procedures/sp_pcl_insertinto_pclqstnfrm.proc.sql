/* This stored procedure will populate the PCLQuestionForm table with upto 6 results for each
** call for each questionform_id.
** Created: Daniel Vansteenburg, Cap Gemini America, LLC
** Date:  5/20/1999
** Notes: 
** Modifications:
*/
create procedure sp_pcl_insertinto_pclqstnfrm
 @batch_id int,
 @questionform_id1 int=NULL, @survey_id1 int=NULL,
 @paper_type1 int=NULL, @language1 int=NULL
as
 INSERT INTO dbo.PCLQuestionForm (
  Batch_id, QuestionForm_id, Survey_id,
  paper_type, language, bitIsProcessed
 ) VALUES (
  @batch_id, @questionform_id1, @survey_id1,
  @paper_type1, @language1, 0
 )


