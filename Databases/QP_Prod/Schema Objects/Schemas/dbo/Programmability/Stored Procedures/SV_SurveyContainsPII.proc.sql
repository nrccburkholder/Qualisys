CREATE PROCEDURE dbo.SV_SurveyContainsPII
@Survey_id INT
AS

CREATE TABLE #m (bitError BIT, strMessage VARCHAR(100))

DECLARE @allowPII BIT
SELECT @allowPII=NUMPARAM_VALUE
FROM QualPro_Params
WHERE strParam_nm='PersonalizeSurvey'

IF @allowPII=1
BEGIN
 GOTO Report
END

 -- Fields used on the survey	
INSERT INTO #M (bitError, strMessage)
SELECT DISTINCT 1 bitError, 'PII Field '+mf.strField_nm+' is used on the survey'
FROM Survey_def sd, CodeQstns cq, Sel_Qstns sq, CodesText ct, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf, Metastructure ms
WHERE sd.Survey_id=@Survey_id
AND sd.Survey_id=cq.Survey_id
AND cq.Survey_id=sq.Survey_id
AND cq.Language=sq.Language
AND cq.SelQstns_id=sq.SelQstns_id
AND sq.Section_id>1
AND cq.Code=ct.Code
AND ct.CodeText_id=ctt.CodeText_id
AND ctt.Tag_id=tf.Tag_id
AND sd.study_id=tf.study_id
AND tf.replaceField_flg=0
AND tf.Table_id=mt.Table_id
AND tf.Field_id=mf.Field_id
AND tf.Table_id=ms.Table_id
AND tf.Field_id=ms.Field_id
AND (ms.bitPII=1 OR mf.bitPII=1)

SELECT Survey_id,Coverid,Language,y INTO #PageBreak FROM Sel_PCL WHERE Description='*PageBreak*' AND Survey_id=@Survey_id
IF @@ROWCOUNT>0
BEGIN
	 -- Fields on the cover letters used below the page break
	INSERT INTO #M (bitError, strMessage)
	SELECT DISTINCT 1 bitError, 'PII Field '+mf.strField_nm+' is used on a cover letter, below the page break'
	FROM Survey_def sd, Codetxtbox ctb, #PageBreak pb, Sel_Textbox st, CodesText ct, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf, Metastructure ms
	WHERE pb.Survey_id=st.Survey_id 
	AND pb.coverid=st.coverid 
	AND pb.Language=st.Language
	AND pb.y<=st.y
	AND sd.Survey_id=st.Survey_id
	AND sd.Survey_id=ctb.Survey_id
	AND ctb.Language=st.Language
	AND ctb.qpc_id=st.qpc_id
	AND ctb.Code=ct.Code
	AND ct.CodeText_id=ctt.CodeText_id
	AND ctt.Tag_id=tf.Tag_id
	AND sd.study_id=tf.study_id
	AND tf.replaceField_flg=0
	AND tf.Table_id=mt.Table_id
	AND tf.Field_id=mf.Field_id
	AND tf.Table_id=ms.Table_id
	AND tf.Field_id=ms.Field_id
	AND (ms.bitPII=1 OR mf.bitPII=1)
END
DROP TABLE #PageBreak

DECLARE @integrated BIT
SET @integrated=0

SELECT @integrated = sc.Integrated
FROM Sel_cover sc
WHERE integrated=1
AND pagetype <> 2
AND Survey_id=@Survey_id

IF @integrated=1 
BEGIN
	 -- Fields used on the address label
	INSERT INTO #M (bitError, strMessage)
	SELECT DISTINCT 1 bitError, 'PII Field '+mf.strField_nm+' is used on the address label on an integrated cover letter'
	FROM Survey_def sd, CodeQstns cq, Sel_Qstns sq, CodesText ct, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf, Metastructure ms
	WHERE sd.Survey_id=@Survey_id
	AND sd.Survey_id=cq.Survey_id
	AND cq.Survey_id=sq.Survey_id
	AND cq.Language=sq.Language
	AND cq.SelQstns_id=sq.SelQstns_id
	AND sq.Section_id=-1
	AND cq.Code=ct.Code
	AND ct.CodeText_id=ctt.CodeText_id
	AND ctt.Tag_id=tf.Tag_id
	AND sd.study_id=tf.study_id
	AND tf.replaceField_flg=0
	AND tf.Table_id=mt.Table_id
	AND tf.Field_id=mf.Field_id
	AND tf.Table_id=ms.Table_id
	AND tf.Field_id=ms.Field_id
	AND (ms.bitPII=1 OR mf.bitPII=1)

	 -- Fields used on the cover letter
	INSERT INTO #M (bitError, strMessage)
	SELECT DISTINCT 1 bitError, 'PII Field '+mf.strField_nm+' is used on an integrated cover letter'
	FROM Survey_def sd, Codetxtbox ctb, Sel_Textbox st, Sel_cover sc, CodesText ct, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf, Metastructure ms
	WHERE sd.Survey_id=@Survey_id
	AND sd.Survey_id=ctb.Survey_id
	AND ctb.Survey_id=st.Survey_id
	AND ctb.Language=st.Language
	AND ctb.qpc_id=st.qpc_id
	AND st.coverid=sc.Selcover_id
	AND ctb.Survey_id=sc.Survey_id
	AND sc.integrated=1
	AND sc.pagetype=1
	AND ctb.Code=ct.Code
	AND ct.CodeText_id=ctt.CodeText_id
	AND ctt.Tag_id=tf.Tag_id
	AND sd.study_id=tf.study_id
	AND tf.replaceField_flg=0
	AND tf.Table_id=mt.Table_id
	AND tf.Field_id=mf.Field_id
	AND tf.Table_id=ms.Table_id
	AND tf.Field_id=ms.Field_id
	AND (ms.bitPII=1 OR mf.bitPII=1)
END

Report:

IF (SELECT COUNT(*) FROM #m)=0
SELECT 0 bitError, 'Survey uses PII appropriately' strMessage 
ELSE
SELECT bitError, strMessage
FROM #m


