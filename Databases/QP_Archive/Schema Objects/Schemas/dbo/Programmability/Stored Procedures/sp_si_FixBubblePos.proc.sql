create procedure sp_si_FixBubblePos
  @QuestionForm_id int
as
update bp
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
   from bip bip, bp bp
   where bp.questionform_id = @QuestionForm_id 
   and bip.questionform_id = bp.questionform_id
   and bip.sampleunit_id = bp.sampleunit_id
   and bip.qstncore = bp.qstncore
   group by bp.sampleunit_id, bp.qstncore, bp.readmethod_id) xx
where bp.questionform_id = @QuestionForm_id
  and bp.sampleunit_id = xx.sampleunit_id
  and bp.qstncore = xx.qstncore
  and bp.intRespCol <> xx.width

if @@rowcount>0 
begin
  declare @su_id int, @qc int, @rc int, @bc int
  declare curQstn cursor for
     select sampleunit_id, qstncore, intRespCol 
     from bp
     where questionform_id=@QuestionForm_id
     order by intBegColumn
  set @bc=34  
  open curQstn
  fetch curQstn into @su_id, @qc, @RC
  while (@@fetch_status <> -1)
  begin
    update bp
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


