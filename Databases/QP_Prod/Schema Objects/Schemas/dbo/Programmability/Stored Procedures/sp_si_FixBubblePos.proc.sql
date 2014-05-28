/***********************************************************************************************************************************
SP Name: sp_si_FixBubblePos
Part of:  Scanner Interface - Export (1st pass)
Purpose:  Ensures that enough columns are allocated in the .STR file for each question.  Called
before creating each .txt file.
Input: a QuestionForm_id
 
Output:  
Creation Date: 3/23/2000
Author(s): Dave Gilsdorf
Revision: 
v2.0.1 - 3/23/2000 - Dave Gilsdorf
  initial version
v2.0.2 - 3/23/2000 - Dave Gilsdorf
  Don pointed out the case statement was short sighted.  Changed it to look at the max length 
  of the min and max bubbleitempos values.
v2.0.3 - text3.exe expects the parameter to be @QuestionForm_id
v2.0.4 - 4/12/2000 - Jeffrey J. Fleming
  Modified inner select to account for multiple response questions.
***********************************************************************************************************************************/
create procedure sp_si_FixBubblePos
  @QuestionForm_id int
as
update bubblepos 
set intRespCol=xx.width
from 
  (select bp.sampleunit_id, bp.qstncore, width = 
     case
       when bp.readmethod_id = 1 then count(*) 
       when len(convert(varchar,min(bip.val))) < len(convert(varchar,max(bip.val))) then 
          len(convert(varchar,max(bip.val)))
       else 
          len(convert(varchar,min(val)))
     end
   from bubbleitempos bip, bubblepos bp
   where bp.questionform_id = @QuestionForm_id 
   and bip.questionform_id = bp.questionform_id
   and bip.sampleunit_id = bp.sampleunit_id
   and bip.qstncore = bp.qstncore
   group by bp.sampleunit_id, bp.qstncore, bp.readmethod_id) xx
where bubblepos.questionform_id = @QuestionForm_id
  and bubblepos.sampleunit_id = xx.sampleunit_id
  and bubblepos.qstncore = xx.qstncore
  and bubblepos.intRespCol <> xx.width

if @@rowcount>0 
begin
  declare @su_id int, @qc int, @rc int, @bc int
  declare curQstn cursor for
     select sampleunit_id, qstncore, intRespCol 
     from bubblepos 
     where questionform_id=@QuestionForm_id
     order by intBegColumn
  set @bc=34  
  open curQstn
  fetch curQstn into @su_id, @qc, @RC
  while (@@fetch_status <> -1)
  begin
    update bubblepos 
    set intBegColumn=@bc 
    where questionform_id=@QuestionForm_id
      and sampleunit_id=@su_id
      and qstncore=@qc
    set @bc=@bc+@rc
    fetch curQstn into @su_id, @qc, @RC
  end
  close curQstn
  deallocate curQstn
end


