/****** Object:  Stored Procedure dbo.sp_RaiseError    Script Date: 4/27/99 9:59:31 AM ******/
/* This is a procedure that forces SQL to give an error.
** Last Modified by:  Daniel Vansteenburg - 5/5/1999
** 8/2/1999 - Daniel Vansteenburg - Added code to actually do something.
** 1. If there is an unrecoverable, system-halting error, the applications will call
** sp_RaiseError with a intSeverity=1.  This will trigger an email to a pager that 
** will alert somebody to do something.
** 2. When finished processing a batch, the application will call some other stored 
** procedure that will count the number of questionnaires in the batch that had an 
** error logged in FormGenError and use sp_RaiserError with intSeverity=5 and a message 
** saying 'There were x questionnaire errors in batch y'"
**
** intSeverity = 1 - Fatal System Errors (e-mail/pager)
** intSeverity = 2 - Error, return Query results (e-mail)
** intSeverity = 5 - Batch Processing Errors. (e-mail)
** All other severities will be assumed general errors and send out the page. (e-mail/pager)
** 9/8/1999 DV - If the Pager is NULL, we will force it to blank.
** 9/23/1999 DS - Added database name to subject line of e-mail.
*/
CREATE PROCEDURE sp_RaiseError
 @intSeverity int,
 @strApplication_nm varchar(200),
 @strErrorMessage varchar(255)
AS
 declare @oper_email varchar(255), @oper_pager varchar(255), @cnt int
 declare @dbname varchar(32), @usernm varchar(32)
 declare @sendto varchar(255), @subject varchar(255), @message varchar(255)
 declare @pager_days tinyint, @nowtime int
 declare @weekday_pager_start_time int, @weekday_pager_end_time int
 declare @saturday_pager_start_time int, @saturday_pager_end_time int
 declare @sunday_pager_start_time int, @sunday_pager_end_time int
 declare operators cursor for
  select distinct so.email_address, so.pager_address, so.pager_days,
   so.weekday_pager_start_time, so.weekday_pager_end_time,
   so.saturday_pager_start_time, so.saturday_pager_end_time,
   so.sunday_pager_start_time, so.sunday_pager_end_time
  from dbo.qualpro_params qp, msdb.dbo.sysoperators so
  where qp.strparam_value = so.name
  and qp.strparam_nm LIKE ltrim(rtrim(@strApplication_nm)) + 'DBA%'
  and qp.strparam_grp = 'DBA'
  and so.enabled = 1
  and so.email_address IS NOT NULL
 INSERT INTO dbo.RaiseError (
  datGenerated, Severity, Application, MessageQuery
 ) VALUES (
  getdate(), @intSeverity, @strApplication_nm, @strErrorMessage
 )
 select @cnt = 0,
  @dbname = db_name(),
  @usernm = user_name(),
  @nowtime = (datepart(hh,getdate()) * 10000) + (datepart(mi,getdate()) * 100) + datepart(ss,getdate())
 open operators
 fetch operators into @oper_email, @oper_pager, @pager_days,
  @weekday_pager_start_time, @weekday_pager_end_time,
  @saturday_pager_start_time, @saturday_pager_end_time,
  @sunday_pager_start_time, @sunday_pager_end_time
 while @@fetch_status = 0
 begin
  select @cnt = @cnt + 1,
   @oper_email = ltrim(rtrim(@oper_email)),
   @oper_pager = ltrim(rtrim(isnull(@oper_pager,'')))
/* Check to see if the pager will be active.  If not, blank out the @oper_pager variable */
  if (@pager_days & 0x3E > 0 AND @nowtime NOT BETWEEN @weekday_pager_start_time AND @weekday_pager_end_time) OR
     (@pager_days & 0x40 > 0 AND @nowtime NOT BETWEEN @saturday_pager_start_time AND @saturday_pager_end_time) OR
     (@pager_days & 0x01 > 0 AND @nowtime NOT BETWEEN @sunday_pager_start_time AND @sunday_pager_end_time) OR
     (@pager_days = 0)
   select @oper_pager = ''
/* Now, do the following actions based on the Severity passed in */
  if @intSeverity = 1
  begin
   select @sendto = @oper_email + ';' + @oper_pager,
    @subject = 'Fatal Error Occured in: ' + rtrim(ltrim(@dbname)) + '-' + rtrim(ltrim(@strApplication_nm)) ,
    @message = @strErrorMessage
   exec master.dbo.xp_sendmail
    @sendto,
    @message=@message,
    @no_output='TRUE',
    @subject=@subject
  end
  else if @intSeverity = 5
  begin
   select @sendto = @oper_email + ';' + @oper_pager,
    @subject = rtrim(ltrim(@dbname)) + '-' + rtrim(ltrim(@strApplication_nm)) + ' Application Errors.',
    @message = @strErrorMessage
   exec master.dbo.xp_sendmail
    @sendto,
    @message=@message,
    @no_output='TRUE',
    @subject=@subject
  end
/* This Severity will assume the Error Message is a Query and return the results of the */
/* Query to the e-mail accounts. */
  else if @intSeverity = 2
  begin
   select @sendto = @oper_email,
    @subject = rtrim(ltrim(@dbname)) + '-' + rtrim(ltrim(@strApplication_nm)) + ' Application Errors.'
   exec master.dbo.xp_sendmail
    @sendto,
    @query=@strErrorMessage,
    @attach_results = 'TRUE',
    @echo_error = 'TRUE',
    @no_output='TRUE',
    @dbuse = @dbname,
    @set_user = @usernm,
    @subject=@subject
   if @oper_pager <> ''
   begin
    select @sendto = @oper_pager,
     @subject = rtrim(ltrim(@dbname)) + '-' + rtrim(ltrim(@strApplication_nm)) + ' Application Errors.',
     @message = 'Please check your NRC e-mail for the results of the query that was generated.'
    exec master.dbo.xp_sendmail
     @sendto,
     @message=@message,
     @no_output='TRUE',
     @subject=@subject
   end
  end
  else
  begin
   select @sendto = @oper_email + ';' + @oper_pager,
    @subject = 'Error in: ' + rtrim(ltrim(@dbname)) + '-' + rtrim(ltrim(@strApplication_nm)),
    @message = @strErrorMessage
   exec master.dbo.xp_sendmail
    @sendto,
    @message=@message,
    @no_output='TRUE',
    @subject=@subject
  end
  fetch operators into @oper_email, @oper_pager, @pager_days,
   @weekday_pager_start_time, @weekday_pager_end_time,
   @saturday_pager_start_time, @saturday_pager_end_time,
   @sunday_pager_start_time, @sunday_pager_end_time
 end
 close operators
 deallocate operators
 if @cnt = 0
 begin
  raiserror ('No operators defined for %s with e-mail or pager addresses, no messages sent.', 16, 1, @strApplication_nm)
 end
 return


