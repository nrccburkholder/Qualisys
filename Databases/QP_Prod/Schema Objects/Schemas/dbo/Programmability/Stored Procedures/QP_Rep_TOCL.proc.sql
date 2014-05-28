CREATE PROCEDURE QP_Rep_TOCL @Associate VARCHAR(50), @client VARCHAR(50), @study VARCHAR(50)
AS

DECLARE @study_id INT, @sql VARCHAR(1000)
SELECT @study_id = study_id FROM client c, study s where c.client_id = s.client_id and c.strclient_nm = @client and strstudy_nm = @study

SET @sql = 'SELECT BV.*, T.datTOCL_DAT AS TOCL_Date FROM S' + CONVERT(VARCHAR,@study_id) + '.BIG_VIEW BV, TOCL T WHERE T.STUDY_ID = ' + CONVERT(VARCHAR,@study_id) + ' AND bv.populationpop_id = t.pop_id'
EXEC (@sql)


