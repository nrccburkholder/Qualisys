

/*
@Survey_id INT, 
@Sexes CHAR(2)='DC', 
@Ages CHAR(2)='DC',  -- DC=Don't Care    
@bitSchedule BIT=0, 
@bitMockup BIT=1, 
@Languages VARCHAR(20)='1', 
@Covers VARCHAR(20)='',   -- comma delimited list of SELCOVER_ID from MAILINGSTEP
@Employee_id INT=0, 
@eMail VARCHAR(50)='' 


exec sp_TestPrints @Survey_id,@Sexes,@Ages,@bitSchedule,@bitMockup,@Languages,@Covers,@Employee_id,@eMail


*/

--exec sp_TestPrints 11392,'DC','DC',1,0,1,'1,2',948,'tbutler@nationalresearch.com'


--exec sp_TestPrints 11392,'DC','DC',1,0,1,'1',907,'jwilley@nationalresearch.com'

DECLARE @survey_id as int

DECLARE test_print_cursor CURSOR FOR
SELECT distinct sq.SURVEY_ID
  FROM [dbo].[SEL_QSTNS] sq
INNER JOIN [dbo].[MAILINGMETHODOLOGY] mm on (mm.SURVEY_ID = sq.SURVEY_ID)
INNER JOIN [dbo].[StandardMethodology] sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
where sq.QSTNCORE = 50860
AND sm.MethodologyType <> 'Telephone Only'
order by SURVEY_ID

OPEN test_print_cursor
FETCH NEXT FROM test_print_cursor INTO @survey_id

WHILE @@FETCH_STATUS = 0
BEGIN
	exec sp_TESTPrints @survey_id, 'DC', 'DC',1,0,1,'1,2',930,'CBurkholder@NationalResearch.com'

	FETCH NEXT FROM test_print_cursor INTO @survey_id
END

CLOSE test_print_cursor
DEALLOCATE test_print_cursor
