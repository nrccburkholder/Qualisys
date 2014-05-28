CREATE PROCEDURE dbo.sp_HWF_Map @study_id INT,  @survey_id INT
AS

--DECLARE @study_id INT, @survey_id INT                                                                                                
--SELECT @study_id = xxx ,  @survey_id = xxx

/************************************************************/
select * from qp_prod.dbo.clientstudysurvey_view where SURVEY_ID IN (@survey_id)


select * from qp_scan.dbo.handwrittenfield where survey_id IN (@survey_id)
IF @@ROWCOUNT > 0
	BEGIN
	 PRINT 'Hand Entry Already Mapped!'
	 RETURN
	END
select COUNT(*), COUNT(DISTINCT SURVEY_ID) from qp_scan.dbo.handwrittenfield where survey_id IN (@survey_id)

select * from qp_prod.dbo.metadata_view where study_id in (@study_id) 
and strfield_nm like '%LanguageHCAHPS%'
IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'Failure - Not metadata column to Map to!'
	END
ELSE
BEGIN
	select survey_id, sc.mailingstep_id, datgenerate, count(distinct sentmail_id) sentmail, count(*) cnt 
	from qp_prod.dbo.scheduledmailing sc, qp_prod.dbo.mailingstep ms where sc.mailingstep_id = ms.mailingstep_id and ms.survey_id 
	in ( @survey_id)
	and sentmail_id is null
	and datgenerate > DATEADD(dd,-14,GETDATE())
	group by survey_id, sc.mailingstep_id, datgenerate
	
	/************************************************************/
	

		DECLARE @Survey INT, @qstncore INT, @strField_nm VARCHAR(30)
		SET @Survey = @survey_id
		SET @Qstncore = 18952
		SET @strField_nm = 'LanguageHCAHPS'
		
		EXEC QP_SCAN.DBO.SYS_Populate_HandWrittenField @survey, @strfield_nm, @qstncore
	
	
		select * from qp_scan.dbo.handwrittenfield where survey_id IN  (@survey_id)

	IF @@RowCount > 0
		PRINT 'Successfully Mapped HandEntryField.'
	ELSE
		PRINT 'Failure - Check to see if survey has completed generation!'


END


