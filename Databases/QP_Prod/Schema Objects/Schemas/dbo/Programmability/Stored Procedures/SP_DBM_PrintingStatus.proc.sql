CREATE procedure SP_DBM_PrintingStatus    
as    
declare @value int, @desc varchar(100)    
set @value = (select numparam_value from qualpro_params where param_id = 79)    

declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output

set @desc = 'QualPro shows ' + convert(varchar,@value) + ' PCLGen machines currently running.  It has been reset to 0. '
exec qp_prod.dbo.sp_getemailsubject @desc,@country, @environment, 'Qualisys', @osubject=@desc output
    
if @value > 0    
begin    
  -- exec master.dbo.xp_sendmail @recipients = 'QualisysDBAEmailAlerts@NationalResearch.com',     
  -- @message = @desc    
 EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
 @recipients='itsoftwareengineeringlincoln@nationalresearch.com',  
 @subject=@desc,  
 @body_format='Text',  
 @importance='High'  
  
     update qualpro_params set numparam_value = 0 where param_id = 79    
end


