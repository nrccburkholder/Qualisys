CREATE proc MapHandwrittenField @study_id INT, @survey_id INT, @qstncore INT, @strField_nm VARCHAR(30)                                                                                                
as
print '@study_id: ' + cast(@study_id as varchar)
print '@survey_id: ' + cast(@survey_id as varchar)
print '@qstncore: ' + cast(@qstncore as varchar)
print '@strField_nm: ' + @strField_nm

IF exists (select * from qp_scan.dbo.handwrittenfield where survey_id IN (@survey_id) and qstncore = @qstncore )
	BEGIN
	 PRINT 'Hand Entry Already Mapped!'
	 RETURN
	END

IF not exists (select * from qp_prod.dbo.metadata_view where study_id in (@study_id) and strfield_nm = @strField_nm)
	BEGIN
		PRINT 'Failure - No metadata column to Map to!'
	END
ELSE
BEGIN
		EXEC QP_SCAN.DBO.SYS_Populate_HandWrittenField @survey_id, @strfield_nm, @qstncore

	IF exists (select 1 from qp_scan.dbo.handwrittenfield where survey_id IN  (@survey_id) and qstncore = @qstncore)
		PRINT 'Successfully Mapped HandEntryField.'
	ELSE
		PRINT 'Failure - Check to see if survey has completed generation!'
END

print ''


