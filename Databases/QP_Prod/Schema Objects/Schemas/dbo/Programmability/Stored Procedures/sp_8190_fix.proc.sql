create proc sp_8190_fix as
begin tran

update bip  --13828
set val = val + 90
from del_8190 d, qp_scan.dbo.bubbleitempos bip
where d.questionform_id = bip.questionform_id
and bip.qstncore = 8190

if @@rowcount <> 13828
begin
  rollback tran
  return
end

update bp  --3457
set intbegcolumn = 240, intrespcol = 2
from del_8190 d, qp_scan.dbo.bubblepos bp
where d.questionform_id = bp.questionform_id
and bp.qstncore = 8190

if @@rowcount <> 3457
begin
  rollback tran
  return
end

commit tran


