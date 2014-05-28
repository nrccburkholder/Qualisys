Create PROCEDURE [dbo].[SP_dbm_ResetHungPCLPieces]       
 @indebug tinyint = 0      
AS  

declare @MaxDatLogged datetime, @Batch_ID int, @Msgbody varchar(5000), @SQLQry varchar(5000)

select computer_nm, batch_ID, MAX(l.DATLOGGED) MaxDatLogged
into #maxTimes
from pclgenrun r (nolock), pclgenlog l (nolock), pclneeded p (nolock)  
where	r.pclgenrun_id = l.pclgenrun_id and 
		substring(l.logentry,12,charindex(' - ',logentry)-12) = p.batch_id and
		logentry like 'load batch%' and 
		p.bitdone = 1 and 
		convert(varchar(10),start_dt, 120) = convert(varchar(10),getdate(), 120)
group by computer_nm, batch_ID

if @indebug = 1 select '#maxTimes' [#maxTimes], * from #maxTimes

Select distinct Batch_ID, MaxDatLogged
into #Times
from #maxTimes

if @indebug = 1 select '#Times' [#Times], * from #Times


while (select COUNT(*) from #times) > 0
begin
	select top 1 @batch_ID = batch_ID, @MaxDatLogged = MaxDatLogged from #times

	if @indebug = 1 
	begin
		print '@batch_ID = ' + cast(@batch_ID as varchar(25))
		print '@MaxDatLogged = ' + cast(@MaxDatLogged as varchar(25))
	end

	if exists (select 'x' from #times where batch_ID = @Batch_ID and MaxDatLogged = @MaxDatLogged and DATEDIFF(n,MaxDatLogged, getdate()) > 30) 
	BEGIN
		
		select @Msgbody = 'PCL Pieces for Batch_ID ' + CAST(@batch_ID as varchar(100)) + ' have been reset because nothing has processed in the batch since ' +   CAST(@MaxDatLogged as varchar(100))
		select @SQLQry =   'print ''''
							print ''Show all rows in Batch''
							Select * from pclneeded where batch_ID = ' + CAST(@batch_ID as varchar(100)) + '
		
							print ''''
							print ''Show only rows that will be updated in Batch''
							Select	p.*
							from	scheduledmailing s(nolock), pclneeded p 
							where	s.sentmail_id = p.sentmail_id and
									s.scheduledmailing_id not in (SELECT f.scheduledmailing_id from FormGenError f) and
									bitdone = 1 and Batch_id = ' + CAST(@batch_ID as varchar(100)) + '
									
							print ''''
							print ''Show only rows that will be not updated in Batch because they are in formgenerror table''
							Select	p.*, f.*
							from	formgenerror f, scheduledmailing s(nolock), pclneeded p 
							where	s.sentmail_id = p.sentmail_id and
									s.scheduledmailing_id  = f.scheduledmailing_id and
									bitdone = 1 and Batch_id = ' + CAST(@batch_ID as varchar(100))
									
									
		
		EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',  
		@recipients='dba@nationalresearch.com;msphone@nrcpicker.com',  
		@subject='PCLGen Pieces Reset',  
		@body=@Msgbody,  
		@body_format='Text',  
		@importance='High',  
		@execute_query_database = 'qp_prod',
		@attach_query_result_as_file = 1,
		@Query=@SQLQry

		
		update PCLNeeded set bitDone = 0 where Batch_id = @batch_ID
		
		update	p 
		set		bitdone = 0 
		from	scheduledmailing s(nolock), pclneeded p 
		where	s.sentmail_id = p.sentmail_id and
				s.scheduledmailing_id not in (SELECT f.scheduledmailing_id from FormGenError f) and
				bitdone = 1 and Batch_id = @batch_ID


	END
	
	delete from #times where batch_ID = @Batch_ID and MaxDatLogged = @MaxDatLogged

end


