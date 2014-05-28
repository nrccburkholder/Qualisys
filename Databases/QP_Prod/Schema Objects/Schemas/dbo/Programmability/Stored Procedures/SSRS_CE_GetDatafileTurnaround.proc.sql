/***********************************************************************************
--Created by dknaus on 4/28/2008--



This procedure is used primarily for a Client Experience Reporting Services report
***********************************************************************************/
--exec SSRS_CE_GetDatafileTurnaround '4/1/2008','4/6/2008'
CREATE procedure [dbo].[SSRS_CE_GetDatafileTurnaround]
	@mindate datetime,@maxdate datetime
as

/***/--declare @mindate datetime,@maxdate datetime
/***/--set @mindate='3/1/2008'
/***/--set @maxdate='3/31/2008'
/*
select df.datafile_id,df.datreceived,df.dataset_id
from qloader.qp_load.dbo.datafile df
	inner join sampledataset sds
		on (df.dataset_id=sds.dataset_id)
	inner join sampleset ss
		on (sds.sampleset_id=ss.sampleset_id)
where ss.datsamplecreate_dt between @mindate and @maxdate
*/


set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))
--return
select	cssad.ad,cssad.strClient_nm,cssad.client_id,left(cssad.strsurvey_nm,4) PJ,ss.survey_id,ss.sampleset_id,sds.dataset_id,df.datafile_id,
		df.datreceived,df.datbegin,ss.datsamplecreate_dt,ss.datscheduled,ms.datmailed,
		case
		when convert(decimal,datediff(dd,df.datreceived,ss.datsamplecreate_dt))<0 then 0
		else convert(decimal,datediff(dd,df.datreceived,ss.datsamplecreate_dt))
		end [Days Load to Samp],	
		case
		when convert(decimal,datediff(dd,ss.datsamplecreate_dt,ss.datscheduled))<0 then 0
		else convert(decimal,datediff(dd,ss.datsamplecreate_dt,ss.datscheduled))
		end [Days Samp to Sched],
		case 
		when convert(decimal,datediff(dd,ss.datscheduled,ms.datmailed))<0 then 0
		else convert(decimal,datediff(dd,ss.datscheduled,ms.datmailed))
		end [Days Sched to Mail],
		case 
		when convert(decimal,datediff(dd,ss.datsamplecreate_dt,ms.datmailed))<0 then 0
		else convert(decimal,datediff(dd,ss.datsamplecreate_dt,ms.datmailed))
		end [Days Samp to Mail]
from SampleDataSet sds 
	inner join sampleset ss 
		on (ss.sampleset_id=sds.sampleset_id)
	inner join qloader.qp_load.dbo.datafile df 
		on (sds.dataset_id=df.dataset_id)
	inner join mailingsummary ms 
		on (ms.sampleset_id=ss.sampleset_id)
	inner join mailingstep mst 
		on (ms.mailingstep_id=mst.mailingstep_id)
	inner join css_ad_view cssad
		on (ss.survey_id=cssad.survey_id)
where ss.datSampleCreate_dt between @mindate and @maxdate	
	and df.isdrgupdate<>1
	and mst.intsequence=1
	and ss.tioversample_flag=0
	and cssad.employee_id not in (select employee_id from lu_SSRS_ExcludedEmployees)
	--and left(cssad.strsurvey_nm,4)='A202'
order by cssad.strclient_nm,left(cssad.strsurvey_nm,4)


