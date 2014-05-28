CREATE PROCEDURE sp_temp_convertsurvey AS
declare @surv_id int
select top 1 @surv_id=Survey_id from ConvertSurvey where status_flg=0
while @@rowcount>0 
begin
  -- QuestionResult --
  update ConvertSurvey set status_flg=1 where survey_id=@surv_id
  update QR
  set QR.intresponseval=sv.bubbleval
  from questionresult QR, QuestionForm QF, Sel_Qstns SQ, Sel_Scls SS, ScaleValues SV
  where QR.Questionform_id=QF.Questionform_id
    and QF.Survey_id=@surv_id
    and QF.Survey_id=SQ.Survey_id
    and QR.Qstncore=SQ.Qstncore
    and SQ.subtype=1 and SQ.Language=1
    and SQ.survey_id=SS.Survey_id
    and SQ.scaleid=ss.qpc_id
    and ss.qpc_id in (955,828)
--    and QR.intresponseval=ss.val 
    and ss.language=1
    and ss.qpc_id=sv.scaleid
    and ss.item=sv.item
/* changed from and QR.intresponseval<>sv.bubbleval */
    and QR.intresponseval=sv.original_value
--    and qr.qpc_timestamp > 0x000000000EDADB49

  -- Sel_Scls --
  update ConvertSurvey set status_flg=2 where survey_id=@surv_id
  update ss
  set ss.val=sv.bubbleval, ss.missing=sv.missing
  from sel_scls ss, scalevalues sv
  where ss.survey_id=@surv_id
    and ss.qpc_id=sv.scaleid
    and ss.qpc_id in (955,828)
    and ss.item=sv.item
    and (ss.val<>sv.bubbleval or ss.missing <> sv.missing)

  -- BubbleItemPos --
  update ConvertSurvey set status_flg=3 where survey_id=@surv_id
  update BIP
  set bip.val=sv.bubbleval
  from BubbleItemPos BIP, Sel_Qstns SQ, ScaleValues SV
  where BIP.survey_id=@surv_id
    and BIP.Survey_id=SQ.survey_id
    and BIP.Qstncore=SQ.QstnCore
    and SQ.subtype=1 and SQ.Language=1
    and BIP.item=SV.item
    and SQ.ScaleID=SV.ScaleID
    and sv.scaleid in (955,828)
    and BIP.Val <> SV.BubbleVal

  update ConvertSurvey set status_flg=4 where survey_id=@surv_id

  select @surv_id=numParam_value from QualPro_params where strParam_nm='ConvertPause'
  if @surv_id <> 0 
    BREAK

  select top 1 @surv_id=Survey_id from ConvertSurvey where status_flg=0

end


