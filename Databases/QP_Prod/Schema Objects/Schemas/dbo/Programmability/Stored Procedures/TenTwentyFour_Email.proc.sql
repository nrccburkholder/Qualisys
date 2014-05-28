CREATE PROC TenTwentyFour_Email @To varchar(1000)    
AS    
DECLARE @message nvarchar(255), @query nvarchar(4000), @Subject nvarchar(1000)    
set @Message = 'This following studies have gone over the 900 column threshold in Study Results.  Please contact your Measurement Services Director for instructions.    
                  '    
set @query = 'Select left(strClientName,35) as ClientName, strStudyName as Study,    
  cast(Study_ID as nvarchar(6)) as [Study#], left(ProjectManagerEmployee_ID,15) as [Project Mgr],     
  cast(ColumnCount as nvarchar(5)) as Columns from QP_Prod.dbo.TenTwentyFour     
  where convert(nvarchar(10),datPollingDate,101) = convert(nvarchar(10),GETDATE(),101)'    
    
set @subject = '1024 Column Limit Report - '+convert(nvarchar(10),GETDATE(),101)
    
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
exec qp_prod.dbo.sp_getemailsubject @subject,@country, @environment, 'Datamart', @osubject=@subject output

EXEC msdb.dbo.sp_send_dbmail @recipients=@To, @body=@Message,@query=@Query,@Subject=@Subject


