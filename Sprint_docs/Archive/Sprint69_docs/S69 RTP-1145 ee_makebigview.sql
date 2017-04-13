/*
S69 RTP-1145 ee_makebigview.sql

Chris Burkholder

2/10/2017

-	adding a parameter to hide table name as a prefix on each field for BIG_VIEW_WEB
-	removing check that this is not running from QP_Prod

*/
USE QP_Prod
GO

alter procedure ee_makebigview 
@study_id varchar(10), @suffix varchar(20)='', @DoIt bit=0, @HideTableInField bit=0
as

/* OK TO COMMENT THIS OUT SINCE NO DELETES ARE INVOLVED per Dave G CJB 2/10/2017
if DB_NAME()='QP_Prod'
begin
	print 'Run this proc from the database you''re copying to - not QP_Prod.'
	return
end
*/

declare @select varchar(max), @from varchar(max), @where varchar(max)
select @select='
SELECT ', @from='
FROM ', @where='
WHERE '

Declare @ViewSuffix varchar(20) = @Suffix
if (@HideTableInField = 1)
	SET @Suffix = ''

select @select=@select+
CASE WHEN @HideTableInField = 0 THEN STRTABLE_NM ELSE '' END
+STRfIELD_NM+'=S'+@study_id+'.'+STRTABLE_NM+@suffix+'.'+STRFIELD_NM+', ' from metadata_view where study_id=@study_id
SET @select=LEFT(@select,LEN(@select)-1)

SELECT @from=@from+'S'+@study_id+'.'+STRTABLE_NM+@suffix+', ' FROM METATABLE WHERE STUDY_ID=@study_id
SET @from=LEFT(@from,LEN(@from)-1)

select @where = @where + 's'+@study_id+'.'+mt.strtable_nm+@suffix+'.'+mf.strfield_nm+'=s'+@study_id+'.'+lt.strTable_nm+@suffix+'.'+lf.strField_nm+' AND '
from metalookup ml
inner join metatable mt on ml.NUMMASTERTABLE_ID=mt.table_id
inner join metatable lt on ml.NUMLKUPTABLE_ID=lt.table_id
inner join metafield mf on ml.NUMMASTERFIELD_ID=mf.field_id
inner join metafield lf on ml.NUMLKUPFIELD_ID=lf.field_id
where mt.study_id=@study_id

SET @where=LEFT(@where,LEN(@where)-4)

PRINT 'CREATE VIEW S'+@study_id+'.BIG_VIEW'+@viewSuffix+' AS ' + @SELECT + @FROM + @WHERE

if @DoIt=1
	exec ('CREATE VIEW S'+@study_id+'.BIG_VIEW'+@viewSuffix+' AS ' + @SELECT + @FROM + @WHERE)

GO