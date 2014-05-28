CREATE proc SSRS_Accounting_SurveyContractYearCompletedOutgoCounts (@ContractParam varchar(7000), @CustomEndDate datetime)
as

--
--	--debug code
--	declare @ContractParam varchar(7000), @CustomEndDate datetime
--	set @CustomEndDate = '2009-03-01 00:00:00'
--	set @ContractParam = 'B150,B167'

	IF OBJECT_ID('tempdb..#Results') IS NOT NULL drop table #Results
	IF OBJECT_ID('tempdb..#workQueue') IS NOT NULL drop table #workQueue
	IF OBJECT_ID('tempdb..#CountOutGo') IS NOT NULL drop table #CountOutGo
	IF OBJECT_ID('tempdb..#CountReturned') IS NOT NULL drop table #CountReturned


	Declare @Contract varchar(7000), @SQL varchar(8000), @Survey_ID int, @datSurvey_Start_dt datetime


	Create table #CountOutGo (ContractNumber varchar(20), Survey_ID int, CountOutGo int)
	Create table #CountReturned (ContractNumber varchar(20), Survey_ID int, ReceiptType_ID int, ReceiptType varchar(100), CountReturned int)

	Create table #Results (	ContractNumber varchar(20), Survey_ID int, survey_nm varchar(100), 
							SurveyStartDate datetime, CustomEndDate datetime, ReceiptType_ID int, 
							ReceiptType varchar(100), CountOutGo int, CountReturned int)

	create table #workQueue (ContractNumber varchar(20), survey_ID int, datSurvey_Start_dt dateTime)

	print 'get Work Queue'

	if @ContractParam is null
		begin
			insert into #workQueue (ContractNumber, survey_ID, datSurvey_Start_dt)
			Select contract, survey_ID, datSurvey_Start_dt
			from survey_Def
			where datSurvey_end_dt > dateadd(d, -60, getdate())
			order by contract, survey_ID
		end
	else
		begin
			
			set @ContractParam = replace(@ContractParam, ',', ''',''')
			
			if right(@ContractParam, len(@ContractParam) -1) = ','
				set @ContractParam = left(@ContractParam, len(@ContractParam) -1)


			set @SQL = '
			insert into #workQueue (ContractNumber, survey_ID, datSurvey_Start_dt)
			Select contract, survey_ID, datSurvey_Start_dt
			from survey_Def
			where datSurvey_end_dt > dateadd(d, -60, getdate()) and Contract in (''' + @ContractParam + ''')
			order by contract, survey_ID'

			print @SQL
			exec (@SQL)
		end	

	--select * from #workQueue

	while (select count(*) from #workQueue) > 0
	begin
		print  'get record to process'
		select top 1 @Contract = ContractNumber, @Survey_ID = survey_ID, @datSurvey_Start_dt = datSurvey_Start_dt from #workQueue

		print 'Processing Contract# ' + @Contract
		print '			  Survey_ID ' + cast(@Survey_ID as varchar(100))

		print  'populate #CountOutGo'
		insert into #CountOutGo (ContractNumber, Survey_ID, CountOutGo)
		select	sd.Contract, sd.Survey_ID, count(distinct sm.sentmail_ID)
		from	sentmailing sm, mailingmethodology mm, survey_def sd
		where	sm.methodology_Id = mm.methodology_Id and 
				mm.survey_Id = sd.survey_ID and
				sd.survey_Id = @Survey_ID and
				sm.datMailed >= @datSurvey_Start_dt and
				sm.datMailed <= @CustomEndDate and
				sd.contract = @Contract
		group by sd.Contract, sd.Survey_ID


		print  'populate #CountReturned'
		insert into #CountReturned (ContractNumber, Survey_ID, ReceiptType_ID, ReceiptType, CountReturned)
		select	sd.Contract, sd.Survey_ID,  isnull(qf.receiptType_ID, 0), 
				isnull(rt.ReceiptType_nm, 'Other'), count(distinct qf.questionform_ID)
		from	questionform qf, survey_def sd, receipttype rt
		where	qf.survey_ID = sd.survey_ID and 
				rt.ReceiptType_ID = qf.ReceiptType_ID and
				qf.datReturned >= @datSurvey_Start_dt and
				qf.datReturned <= @CustomEndDate and
				sd.survey_ID = @Survey_ID and
				sd.contract = @Contract
		group by sd.Contract, sd.Survey_ID, sd.strSurvey_nm + '(' + cast(sd.Survey_ID as varchar(10)) + ')' ,
				sd.datSurvey_start_dt,  isnull(qf.receiptType_ID, 0), 
				isnull(rt.ReceiptType_nm, 'Other')

		print  'populate #Results'		
		insert into #Results (ContractNumber, Survey_ID, survey_nm, SurveyStartDate, CustomEndDate, 
							  ReceiptType_ID, ReceiptType, CountOutGo, CountReturned)
		select	sd.Contract, sd.survey_ID, 
				sd.strSurvey_nm + ' (' + cast(sd.Survey_ID as varchar(10)) + ')' as survey_nm,
				sd.datSurvey_start_dt as SurveyStartDate, @CustomEndDate as CustomEndDate, 
				cr.ReceiptType_ID, cr.ReceiptType, cog.CountOutGo, cr.CountReturned
		from	#CountOutGo cog, #CountReturned cr, survey_def sd
		where	sd.survey_Id = cog.survey_ID and
				sd.contract = cog.ContractNumber and 
				sd.survey_Id = cr.survey_ID and
				sd.contract = cr.ContractNumber and
				cog.survey_Id = cr.survey_ID and
				cog.ContractNumber = cr.ContractNumber 
		
		print  'clear count tables for next process'	


--		select * from #CountReturned
--		select * from #CountOutGo
--		select * from #Results
	 
		truncate table #CountReturned
		truncate table #CountOutGo

		print  'finished with current record so delete it' 
		delete from #workQueue where ContractNumber = @Contract and Survey_ID = @survey_ID

		print  'get next record'
		select top 1 @Contract = ContractNumber, @Survey_ID = survey_ID from #workQueue


	end

	--return the result set now.
	Select * from #Results


