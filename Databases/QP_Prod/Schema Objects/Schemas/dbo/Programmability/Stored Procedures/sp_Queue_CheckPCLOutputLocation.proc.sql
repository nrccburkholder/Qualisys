CREATE procedure dbo.sp_Queue_CheckPCLOutputLocation    
@ProcName varchar(100), @PCLOutput varchar(200) = ''    
as    
    
if @PCLOutput=''    
begin    
 select @PCLOutput = strParam_Value from QualPro_Params where strParam_nm ='QueueServer'    
 if @PCLOutput=ServerProperty('ServerName') --@@servername    
  set @PCLOutput=''    
 else set @PCLOutput=@PCLOutput+'.'    
     
 select @PCLOutput=@PCLOutput + strParam_Value + '.dbo.PCLOutput' from QualPro_Params where strParam_nm ='QueueDatabase'    
end    
    
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec qp_prod.dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output

if @PCLOutput <> 'qp_queue.dbo.PCLOutput'    
begin    
 select @PCLOutput=@ProcName+' cant find PCLOutput ('+@country+' '+strParam_value+' Qualisys)' from qualpro_params where strParam_nm = 'EnvName'    
 --exec master.dbo.xp_sendmail @recipients = 'dba@nationalresearch.com;msphone@nrcpicker.com', @subject = @PCLOutput    
 EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='QualisysEmail',
	@recipients='dba@nationalresearch.com',
	@subject=@PCLOutput,
	@body_format='text',
	@importance='High'
 return -1    
end


