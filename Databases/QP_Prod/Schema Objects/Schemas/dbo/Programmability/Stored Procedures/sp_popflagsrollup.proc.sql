/****** Object:  Stored Procedure dbo.sp_popflagsrollup    Script Date: 8/27/99 1:07:13 PM ******/
/****** Object:  Stored Procedure dbo.sp_popflagsrollup    Script Date: 6/9/99 4:36:36 PM ******/
/****** Object:  Stored Procedure dbo.sp_popflagsrollup    Script Date: 3/12/99 4:16:10 PM ******/
/****** Object:  Stored Procedure dbo.sp_popflagsrollup    Script Date: 12/7/98 2:34:55 PM ******/
/* 9/2/1999 DV - Added update statistics */
CREATE PROCEDURE sp_popflagsrollup AS
declare @sid int
declare unik cursor for 
   select distinct study_id from mailingwork
declare @sq varchar(255)
execute sp_qp_didx_popflags
open unik
fetch unik into @sid
while (@@fetch_status <> -1)
  begin
  SELECT @sq = 'INSERT INTO dbo.PopFlags 
  SELECT ' + CONVERT(varchar, @sid) + ', SPF.Pop_id, SPF.Adult, SPF.Sex, SPF.Doc 
  FROM S' + CONVERT(varchar, @sid) + '.Popflags SPF, dbo.MailingWork MW
  WHERE SPF.Pop_id = MW.Pop_id AND MW.Study_id ='+ CONVERT(varchar, @sid)
  execute (@sq)
  fetch unik into @sid
end
close unik
deallocate unik
execute sp_qp_cidx_popflags
update statistics dbo.PopFlags


