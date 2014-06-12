

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

exec sp_TestPrints 11392,'DC','DC',1,0,1,'1,2',948,'tbutler@nationalresearch.com'


--exec sp_TestPrints 11392,'DC','DC',1,0,1,'1',907,'jwilley@nationalresearch.com'