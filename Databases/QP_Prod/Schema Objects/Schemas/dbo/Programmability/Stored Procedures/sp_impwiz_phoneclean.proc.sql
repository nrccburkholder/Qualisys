/* Created By: Daniel Vansteenburg, Cap Gemini America, Inc.
** Created On: 9/8/1999
*/
create procedure sp_impwiz_phoneclean
 @study_id int,
 @numok int output,
 @numerr int output,
 @nummiss int output,
 @numtotal int output
as
 declare @table_nm varchar(32), @strstudy_id varchar(9)
 declare @strsql varchar(8000)
 set @strstudy_id = convert(varchar(9),@study_id)
 set @table_nm = 'POPULATION'
/* Check to make sure that the PHONSTAT field exists on the table, if not
** then we cannot phone number clean
*/
 create table #phnstats (
  numok int, numerr int, nummiss int, numtotal int
 )
/* For each table with the Phone number status field (PhonStat) field, do
** phone number cleaning.  Other required fields for this table are...
** AreaCode, PhoneNumber.  If any fields are missing, we will set the stat
** to a -1.  We will only verify those that haven't been verified. */
/* If the area code field doesn't exist, we will Error ALL the phone numbers */
 if not exists (select strfield_nm
   from dbo.metadata_view
   where study_id = @study_id
   and strtable_nm = @table_nm
   and strfield_nm = 'AreaCode')
 begin
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' + 
         'SET PHONSTAT = -1 ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
 end
 else
 begin
/* Error - Area codes that are missing */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 1 ' +
         'WHERE AREACODE IS NULL ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
/* Error - Area codes for 800#s, 900#, 977#, 000, 999, *** */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 2 ' +
         'WHERE AREACODE IN (''800'',''877'',''880'',''881'',''882'',''888'',''899'',''900'',''977'',''000'',''999'',''***'')' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
/* Error - Not all the numbers are numeric */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 3 ' +
         'WHERE (ISNUMERIC(AREACODE) = 0 OR ' +
    'CHARINDEX('' '',AREACODE) > 0 OR ' +
    'DATALENGTH(AREACODE) < 3) ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
 end
/* Next, check the phone number field */
/* If the Phone field doesn't exist, we will Error ALL the phone numbers */
 if not exists (select strfield_nm
   from dbo.metadata_view
   where study_id = @study_id
   and strtable_nm = @table_nm
   and strfield_nm = 'Phone')
 begin
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' + 
         'SET PHONSTAT = -1 ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
 end
 else
 begin
/* Error - Phones that are missing */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 1 ' +
         'WHERE PHONE IS NULL ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
/* Error - Phones for 0000000, 9999999, ******* */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 2 ' +
         'WHERE PHONE IN (''0000000'',''9999999'',''*******'')' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
/* Error - Not all the numbers are numeric */
  set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
         'SET PHONSTAT = 3 ' +
         'WHERE (ISNUMERIC(PHONE) = 0 OR ' +
    'CHARINDEX('' '',PHONE) > 0 OR ' +
    'DATALENGTH(PHONE) < 7) ' +
         'AND PHONSTAT IS NULL '
  execute (@strsql)
 end
/* Finally, anything leftover is good */
 set @strsql = 'UPDATE S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD ' +
        'SET PHONSTAT = 0 ' +
        'WHERE PHONSTAT IS NULL '
 execute (@strsql)
/* Calculate Stats */
 set @strsql = 'INSERT INTO #phnstats (numok, numerr, nummiss, numtotal) ' +
        'SELECT SUM(CASE WHEN PHONSTAT = 0 THEN 1 ELSE 0 END), ' + 
        '       SUM(CASE WHEN PHONSTAT > 1 THEN 1 ELSE 0 END), ' +
        '       SUM(CASE WHEN ABS(PHONSTAT) = 1 THEN 1 ELSE 0 END), ' +
        '       COUNT(*) ' +
        'FROM S' + ltrim(rtrim(@strstudy_id)) + '.' + ltrim(rtrim(@table_nm)) + '_LOAD '
 execute (@strsql)
/* Output the stats */
 SELECT @numok = SUM(numok),
  @numerr = SUM(numerr),
  @nummiss = SUM(nummiss),
  @numtotal = SUM(numtotal)
 FROM #phnstats
 select @numok = isnull(@numok,0),
  @numerr = isnull(@numerr,0),
  @nummiss = isnull(@nummiss,0),
  @numtotal = isnull(@numtotal,0)
 DROP TABLE #phnstats


