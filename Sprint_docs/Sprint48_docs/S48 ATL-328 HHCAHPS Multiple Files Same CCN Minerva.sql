USE QP_DataLoad
GO

DECLARE @LookBackDays INT = 1

Select
	 df.Client_ID ClientNumber
	,c.STRCLIENT_NM ClientName
	,su.MedicareNumber CCN
	,df.Study_ID
	,s.STRSTUDY_NM
	,df.Survey_ID
	,srv.strSurvey_NM
	,COUNT(*) FileCount
	,MAX(df.datreceived) AS 'LastFileDate'
	,MIN(df.datreceived) AS 'FirstFileDate'
From DataFile df
join DataFileState dfs on df.datafile_ID = dfs.datafile_ID
join DataFileStates dfss on dfs.State_ID = dfss.State_ID
Join Qualisys.QP_PROD.dbo.Client c on df.Client_ID = c.Client_ID
Join Qualisys.QP_PROD.dbo.Study s on df.Study_ID = s.Study_ID
Join Qualisys.QP_PROD.dbo.Survey_Def srv on df.Survey_ID = srv.Survey_ID
join Qualisys.QP_PROD.dbo.ClientSUFacilityLookup csfl on df.Client_ID = csfl.client_ID
join Qualisys.QP_Prod.dbo.SUFacility su on csfl.SUFacility_id = su.SUFacility_ID
Where df.datreceived >= GETDATE()-@LookBackDays AND dfss.State_desc = 'Applied'
GROUP BY df.Client_ID, c.STRCLIENT_NM, su.MedicareNumber, df.Study_ID, s.STRSTUDY_NM, df.Survey_ID, srv.strSurvey_NM
HAVING COUNT(*) > 1
ORDER by df.Client_ID, su.MedicareNumber