CREATE PROCEDURE [dbo].[csp_GetBackgroundTempErrors] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 	

    delete from BackgroundTempError where ExtractFileID = @ExtractFileID

    --find dups
    insert into BackgroundTempError
	select ExtractFileID,samplepop_id,name,space(0),sourcetable,count(*),'dup'
	from BackgroundTemp with (NOLOCK)
	where ExtractFileID = @ExtractFileID
	group by ExtractFileID,samplepop_id,name,sourcetable
    having count(*) > 1

--    	
--	declare @ExtractFileID int
--	set @ExtractFileID= 59 -- test only
--
--    declare @TestString nvarchar(40)
--    set @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) 
--    + NCHAR(9) + NCHAR(10)+ NCHAR(11)+ NCHAR(12) + NCHAR(13)
--   + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) 
--    + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'
   
	
   
--    --remove new line char
--    Update BackgroundTemp
--    Set Value = RTrim(LTrim(REPLACE( [value],NCHAR(13),'' )))
--    From BackgroundTemp
--    Where ExtractFileID = @ExtractFileID
--    And PATINDEX ('%[' + NCHAR(13)+ ']%', [value] COLLATE Latin1_General_BIN) > 0 
--
--    --remove spaces
--    Update BackgroundTemp
--    Set Value = '@@'
--    From BackgroundTemp
--    Where ExtractFileID = @ExtractFileID
--    And Len(RTrim(LTrim([value]))) = 0
   
    
    
--    --find invalid values
--	insert into BackgroundTempError	
--	select  ExtractFileID,samplepop_id,sampleunit_id,name,value,sourcetable,1,'value contains an invalid character'
--	from BackgroundTemp with (NOLOCK)
--	where ExtractFileID = @ExtractFileID 
--    and PATINDEX (@TestString, [value] COLLATE Latin1_General_BIN) > 0   


--exec csp_GetBackgroundTempErrors 38


