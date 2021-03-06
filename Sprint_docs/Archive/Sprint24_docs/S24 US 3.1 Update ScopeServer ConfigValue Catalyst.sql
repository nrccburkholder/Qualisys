/****** 

S24 US 3.1 Update ScopeServer ConfigValue Catalyst

Replace new machine names in ScopeServer table
Remove old domains TestNRCUS and StageNRCUS from ConfigValue params

select ScopeID, servername from [NRC_Configuration].[dbo].[ScopeServer] order by 1,2

select * from [NRC_Configuration].[dbo].[ConfigValue] 
where name in ('ExperienceDashboardServiceUrl','IPChartServiceUrl',
'NRC_Auth',
'NRC_Benchmarks',
'NRC_VBP',
'NRCAuthIV',
'NRCAuthKey',
'SSRSCredentials',
'NRC_Auth',
'SiteSetupUNC',
'TrendlineServiceUrl',
'UpdateUrl',
'ApplyMassChangesServiceUrl',
'MyAccountUrl')
order by 2,4
******/

--TEST

update [NRC_Configuration].[dbo].[ScopeServer] set servername = replace(servername, 'lnk0t', 'ti') 
--select servername, replace(servername, 'lnk0t', 'ti') from [NRC_Configuration].[dbo].[ScopeServer]
where ScopeID = 1

update   [NRC_Configuration].[dbo].[ConfigValue] set value = replace(value, '.testnrcus.nationalresearch.com', '')  
--select * from [NRC_Configuration].[dbo].[ConfigValue] 
where name in ('SiteSetupUNC', 'RevealURL') and  ScopeID = 1 and value like '%testnrcus%'

update [NRC_Configuration].[dbo].[ConfigValue] set value = 'nrc,#nrcsrv,88hawk' --TODO plug in correct new TEST (DEVNRCUS?) credentials here
--select *, 'nrc,#nrcsrv,88hawk' from [NRC_Configuration].[dbo].[ConfigValue] 
where name = 'SSRSCredentials' and ScopeID = 1

--STAGE

update [NRC_Configuration].[dbo].[ScopeServer] set servername = replace(servername, 'lnk0s', 'si') 
--select servername, replace(servername, 'lnk0s', 'si') from [NRC_Configuration].[dbo].[ScopeServer]
where ScopeID = 2

update   [NRC_Configuration].[dbo].[ConfigValue] set value = replace(value, '.stagenrcus.nationalresearch.com', '')  
--select * from [NRC_Configuration].[dbo].[ConfigValue] 
where name in ('SiteSetupUNC', 'RevealURL') and ScopeID = 2 and value like '%stagenrcus%'

update [NRC_Configuration].[dbo].[ConfigValue] set value = 'nrc,#nrcsrv,88hawk' --TODO plug in correct new STAGE (DEVNRCUS?) credentials here
--select *, 'nrc,#nrcsrv,88hawk' from [NRC_Configuration].[dbo].[ConfigValue] 
where name = 'SSRSCredentials' and ScopeID = 2

/*
SELECT TOP 1000 [ScopeServerID]
      ,[ScopeID]
      ,[ServerName]
  FROM [NRC_Configuration].[dbo].[ScopeServer]
  ORDER BY 1, 2

  SELECT TOP 1000 [ConfigValueID]
      ,[ScopeID]
      ,[ConfigValueTypeID]
      ,[Name]
      ,[Value]
  FROM [NRC_Configuration].[dbo].[ConfigValue]
  ORDER BY 2,4
*/

--on CatClustDB1\catdb1 PRODUCTION

--ScopeID	servername
--1	LNK0TCATSP01
--1	LNK0TCATSQL01
--2	lnk0scatsp03
--2	lnk0scatsp04
--2	lnk0scatsql01a
--2	lnk0scatsql02
--2	lnk0scatsql03
--2	NBAALIABADI
--2	nrcdev7
--2	nrcdev8
--2	STGCATALYSTAGGS
--2	stgcatalystaggsrv
--2	stgcatclustdb1
--2	stgcatclustdb2
--2	wsccaouette
--3	alexg-laptop
--3	catalystaggsrv
--3	catclustdb1
--3	catclustdb2
--3	oma0pcatsp01
--3	oma0pcatsp02
--3	oma0pcatsp04
--3	oma0pcatsql01
--3	oma0pcatsql02
--3	oma0pcatsql03
--4	nrcdev1
--6	nrcdev2

--ConfigValueID	ScopeID	ConfigValueTypeID	Name	Value
--1540	1	1	AMCMaxSiteNodes	1000
--1541	1	1	ApplyMassChangesServiceUrl	http://lnk0tcatsp01/_layouts/ClientReporting/ApplyMassChangesService.asmx
--1758	1	1	AuditEvents	false
--1759	1	1	AuditRequests	false
--1544	1	1	AuditSigTests	false
--1587	1	2	BackgroundFieldsModel	metadata=res://*/SurveyData.BackgroundFieldsModel.csdl|res://*/SurveyData.BackgroundFieldsModel.ssdl|res://*/SurveyData.BackgroundFieldsModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1575	1	2	BenchmarksModel	metadata=res://*/BenchmarksModel.csdl|res://*/BenchmarksModel.ssdl|res://*/BenchmarksModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_Benchmarks;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1576	1	2	CachedRequestModel	metadata=res://*/Request.CachedRequestModel.csdl|res://*/Request.CachedRequestModel.ssdl|res://*/Request.CachedRequestModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_Requests;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1545	1	1	CatalystSupportEmailAddr	catalystsupport@nationalresearch.com
--1577	1	2	ClientPlatformModel	metadata=res://*/ClientPlatformModel.csdl|res://*/ClientPlatformModel.ssdl|res://*/ClientPlatformModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1765	1	3	CPProvider	NRC.ClientPlatform.ClientPlatformSecurityProvider, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1766	1	3	CRProvider	NRC.ClientReporting.ClientReportingSecurityProvider, NRC.ClientReporting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1578	1	2	DataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_DataMart_Metadata;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1546	1	1	DebugXpDB	False
--1568	1	1	EnableAdminThread	True
--1572	1	1	EnableBenchmarkThread	False
--1567	1	1	EnableDebugging	True
--1760	1	1	EnableIPGeneration	false
--1764	1	1	EnableIPThread	True
--1574	1	1	EnableSnapshotThread	True
--1573	1	1	EnableWorkerThreads	True
--1580	1	2	EventDataModel	metadata=res://*/SurveyData.EventData.EventDataModel.csdl|res://*/SurveyData.EventData.EventDataModel.ssdl|res://*/SurveyData.EventData.EventDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1548	1	1	ExperienceDashboardServiceUrl	http://lnk0tcatsp01/_layouts/ClientReporting/ExperienceDashboardService.asmx
--1581	1	2	ImpPlanningModel	metadata=res://*/ImpPlanningModel.csdl|res://*/ImpPlanningModel.ssdl|res://*/ImpPlanningModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ImprovementPlanning;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1549	1	1	IPChartServiceUrl	http://lnk0tcatsp01/_layouts/ImpPlanning/IPChartService.asmx
--1767	1	3	IPProvider	NRC.Catalyst.ImpPlanning.ImpPlanningSecurityProvider, NRC.Catalyst.ImpPlanning.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1550	1	1	LongWebServiceTimeoutMS	600000
--1579	1	2	MasterDataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1566	1	1	MaxWorkerThreads	1
--1551	1	1	MyAccountUrl	https://nrcpicker.com/MyAccount
--1582	1	2	NRC_Auth	Data Source=Mercury.nationalresearch.com;Initial Catalog=NRCAuth;Persist Security Info=True;User ID=qpsa;Password=qpsa
--1780	1	2	NRC_Benchmarks	Server=lnk0tcatsql01\catdb2; Database=NRC_Benchmarks; User Id=nrc; Password=nrc;
--1778	1	2	NRC_VBP	Server=lnk0tcatsql01\catdb2; Database=NRC_VBP; User Id=nrc; Password=nrc;
--1552	1	1	NRCAuthIV	TcbCBV99cqa4qjNvvi8GKQ==
--1553	1	1	NRCAuthKey	BFbzIA142OgKO5uyUfVJXDyaZ2zULQWkvEHovO/vHNU=
--1586	1	2	OUEditorModel	metadata=res://*/SurveyData.OUEditorModel.csdl|res://*/SurveyData.OUEditorModel.ssdl|res://*/SurveyData.OUEditorModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1554	1	1	PDResourceUrl	http://lnk0tcatsp01/CatalystHome/Lists/Resources/AllItems.aspx
--1555	1	1	PDServiceUrl	http://lnk0tcatsp01/_layouts/CatalystResources/PrescriptiveDocumentService.asmx
--1556	1	1	PercentResponseChartServiceUrl	http://lnk0tcatsp01/_layouts/ClientReporting/PercentResponseChartService.asmx
--1761	1	1	ReportEmail	swright@msdev.local
--1558	1	1	ReportingServiceUrl	http://lnk0tcatsql01/ReportServer/ReportService2005.asmx
--1762	1	1	ReportViewerServerConnection	NRC.ClientPlatform.Reporting.ReportServerConnection, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1768	1	3	ResourcesProvider	NRC.Catalyst.Resources.ResourcesSecurityProvider, NRC.Catalyst.Resources, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1774	1	1	RevealURL	https://trvlrpt01.testnrcus.nationalresearch.com/Account/NRCAuthEntry?returnUrl=%2FReports%2FHome
--1560	1	1	SiteSetupUNC	\\lnk0tcatsql01.testnrcus.nationalresearch.com\CatalystSiteSetup
--1569	1	1	SleepIntervalSecs	4
--1755	1	1	SMTPServer	BOGUSSERVER
--1763	1	1	SOTTestMode	0
--1562	1	1	SSRSCredentials	nrc,#nrcsrv,88hawk
--1757	1	1	SuccessEmailRecepient	CatalystAlerts@NationalResearch.com
--1563	1	1	TrendlineServiceUrl	http://lnk0tcatsp01/_layouts/ClientReporting/TrendlineService.asmx
--1564	1	1	UpdateUrl	http://lnk0tcatsp01
--1570	1	1	UrlPattern	%
--1565	1	1	UsageLogging	LogAll
--1583	1	2	UserNavigationSettings	metadata=res://*/Source.SiteNavigation.UserNavigationSettings.csdl|res://*/Source.SiteNavigation.UserNavigationSettings.ssdl|res://*/Source.SiteNavigation.UserNavigationSettings.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1584	1	2	VBPDataModel	metadata=res://*/VBPDataModel.csdl|res://*/VBPDataModel.ssdl|res://*/VBPDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_VBP;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1769	1	3	VBPProvider	NRC.Catalyst.VBP.UI.VBPSecurityProvider, NRC.Catalyst.VBP.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1585	1	2	VBPScenarioModel	metadata=res://*/ScenarioModel.VBPScenarioModel.csdl|res://*/ScenarioModel.VBPScenarioModel.ssdl|res://*/ScenarioModel.VBPScenarioModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_VBP_Scenario;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1593	2	1	AMCMaxSiteNodes	1000
--1594	2	1	ApplyMassChangesServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/ClientReporting/ApplyMassChangesService.asmx
--1595	2	1	AuditEvents	false
--1596	2	1	AuditRequests	false
--1597	2	1	AuditSigTests	false
--1640	2	2	BackgroundFieldsModel	metadata=res://*/SurveyData.BackgroundFieldsModel.csdl|res://*/SurveyData.BackgroundFieldsModel.ssdl|res://*/SurveyData.BackgroundFieldsModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1628	2	2	BenchmarksModel	metadata=res://*/BenchmarksModel.csdl|res://*/BenchmarksModel.ssdl|res://*/BenchmarksModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_Benchmarks;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1629	2	2	CachedRequestModel	metadata=res://*/Request.CachedRequestModel.csdl|res://*/Request.CachedRequestModel.ssdl|res://*/Request.CachedRequestModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1\catdb1;Initial Catalog=NRC_Requests;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1598	2	1	CatalystSupportEmailAddr	catalystsupport@nationalresearch.com
--1630	2	2	ClientPlatformModel	metadata=res://*/ClientPlatformModel.csdl|res://*/ClientPlatformModel.ssdl|res://*/ClientPlatformModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1641	2	3	CPProvider	NRC.ClientPlatform.ClientPlatformSecurityProvider, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1642	2	3	CRProvider	NRC.ClientReporting.ClientReportingSecurityProvider, NRC.ClientReporting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1631	2	2	DataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1.stagenrcus.nationalresearch.com\catdb1;Initial Catalog=NRC_DataMart_Metadata;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1599	2	1	DebugXpDB	False
--1621	2	1	EnableAdminThread	True
--1625	2	1	EnableBenchmarkThread	False
--1620	2	1	EnableDebugging	False
--1600	2	1	EnableIPGeneration	false
--1624	2	1	EnableIPThread	True
--1627	2	1	EnableSnapshotThread	True
--1626	2	1	EnableWorkerThreads	True
--1633	2	2	EventDataModel	metadata=res://*/SurveyData.EventData.EventDataModel.csdl|res://*/SurveyData.EventData.EventDataModel.ssdl|res://*/SurveyData.EventData.EventDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1601	2	1	ExperienceDashboardServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/ClientReporting/ExperienceDashboardService.asmx
--1634	2	2	ImpPlanningModel	metadata=res://*/ImpPlanningModel.csdl|res://*/ImpPlanningModel.ssdl|res://*/ImpPlanningModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1\catdb1;Initial Catalog=NRC_ImprovementPlanning;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1602	2	1	IPChartServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/ImpPlanning/IPChartService.asmx
--1643	2	3	IPProvider	NRC.Catalyst.ImpPlanning.ImpPlanningSecurityProvider, NRC.Catalyst.ImpPlanning.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1603	2	1	LongWebServiceTimeoutMS	600000
--1632	2	2	MasterDataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1619	2	1	MaxWorkerThreads	4
--1604	2	1	MyAccountUrl	https://nrcpicker.com/MyAccount
--1635	2	2	NRC_Auth	Data Source=Mercury.nationalresearch.com;Initial Catalog=NRCAuth;Persist Security Info=True;User ID=qpsa;Password=qpsa
--1605	2	1	NRCAuthIV	TcbCBV99cqa4qjNvvi8GKQ==
--1606	2	1	NRCAuthKey	BFbzIA142OgKO5uyUfVJXDyaZ2zULQWkvEHovO/vHNU=
--1639	2	2	OUEditorModel	metadata=res://*/SurveyData.OUEditorModel.csdl|res://*/SurveyData.OUEditorModel.ssdl|res://*/SurveyData.OUEditorModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1607	2	1	PDResourceUrl	https://betacatalyst.nrcpicker.com/CatalystHome/Lists/Resources/AllItems.aspx
--1608	2	1	PDServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/CatalystResources/PrescriptiveDocumentService.asmx
--1609	2	1	PercentResponseChartServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/ClientReporting/PercentResponseChartService.asmx
--1783	2	2	QPCA_ETL	Data Source=mhm0squalsql02.stage.nrccanada.com;User ID=qpsa;Password=qpsa;Initial Catalog=NRC_DataMart_ETL;Provider=SQLNCLI10.1;Persist Security Info=True;Auto Translate=False;
--1610	2	1	ReportEmail	swright@msdev.local
--1611	2	1	ReportingServiceUrl	http://stgcatalystaggsrv/ReportServer/ReportService2005.asmx
--1612	2	1	ReportViewerServerConnection	NRC.ClientPlatform.Reporting.ReportServerConnection, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1644	2	3	ResourcesProvider	NRC.Catalyst.Resources.ResourcesSecurityProvider, NRC.Catalyst.Resources, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1775	2	1	RevealURL	https://srvlweb01.stagenrcus.nationalresearch.com/Account/NRCAuthEntry?returnUrl=%2FReports%2FHome
--1613	2	1	SiteSetupUNC	\\lnk0scatsql01a.stagenrcus.nationalresearch.com\CatalystSiteSetup
--1622	2	1	SleepIntervalSecs	4
--1614	2	1	SOTTestMode	0
--1615	2	1	SSRSCredentials	nrc,#nrcsrv,88hawk
--1616	2	1	TrendlineServiceUrl	https://betacatalyst.nrcpicker.com/_layouts/ClientReporting/TrendlineService.asmx
--1617	2	1	UpdateUrl	https://betacatalyst.nrcpicker.com
--1623	2	1	UrlPattern	%
--1618	2	1	UsageLogging	LogAll
--1636	2	2	UserNavigationSettings	metadata=res://*/Source.SiteNavigation.UserNavigationSettings.csdl|res://*/Source.SiteNavigation.UserNavigationSettings.ssdl|res://*/Source.SiteNavigation.UserNavigationSettings.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1637	2	2	VBPDataModel	metadata=res://*/VBPDataModel.csdl|res://*/VBPDataModel.ssdl|res://*/VBPDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb2\catdb2;Initial Catalog=NRC_VBP;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1645	2	3	VBPProvider	NRC.Catalyst.VBP.UI.VBPSecurityProvider, NRC.Catalyst.VBP.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1638	2	2	VBPScenarioModel	metadata=res://*/ScenarioModel.VBPScenarioModel.csdl|res://*/ScenarioModel.VBPScenarioModel.ssdl|res://*/ScenarioModel.VBPScenarioModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=stgcatclustdb1\catdb1;Initial Catalog=NRC_VBP_Scenario;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1434	3	1	AMCMaxSiteNodes	1000
--1435	3	1	ApplyMassChangesServiceUrl	https://catalyst.nrcpicker.com/_layouts/ClientReporting/ApplyMassChangesService.asmx
--1436	3	1	AuditEvents	false
--1437	3	1	AuditRequests	false
--1438	3	1	AuditSigTests	false
--1481	3	2	BackgroundFieldsModel	metadata=res://*/SurveyData.BackgroundFieldsModel.csdl|res://*/SurveyData.BackgroundFieldsModel.ssdl|res://*/SurveyData.BackgroundFieldsModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1469	3	2	BenchmarksModel	metadata=res://*/BenchmarksModel.csdl|res://*/BenchmarksModel.ssdl|res://*/BenchmarksModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_Benchmarks;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1470	3	2	CachedRequestModel	metadata=res://*/Request.CachedRequestModel.csdl|res://*/Request.CachedRequestModel.ssdl|res://*/Request.CachedRequestModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_Requests;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1439	3	1	CatalystSupportEmailAddr	catalystsupport@nationalresearch.com
--1471	3	2	ClientPlatformModel	metadata=res://*/ClientPlatformModel.csdl|res://*/ClientPlatformModel.ssdl|res://*/ClientPlatformModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1482	3	3	CPProvider	NRC.ClientPlatform.ClientPlatformSecurityProvider, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1483	3	3	CRProvider	NRC.ClientReporting.ClientReportingSecurityProvider, NRC.ClientReporting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1472	3	2	DataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_DataMart_Metadata;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1440	3	1	DebugXpDB	False
--1462	3	1	EnableAdminThread	True
--1466	3	1	EnableBenchmarkThread	False
--1461	3	1	EnableDebugging	False
--1441	3	1	EnableIPGeneration	false
--1465	3	1	EnableIPThread	True
--1468	3	1	EnableSnapshotThread	True
--1467	3	1	EnableWorkerThreads	True
--1474	3	2	EventDataModel	metadata=res://*/SurveyData.EventData.EventDataModel.csdl|res://*/SurveyData.EventData.EventDataModel.ssdl|res://*/SurveyData.EventData.EventDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1442	3	1	ExperienceDashboardServiceUrl	https://catalyst.nrcpicker.com/_layouts/ClientReporting/ExperienceDashboardService.asmx
--1475	3	2	ImpPlanningModel	metadata=res://*/ImpPlanningModel.csdl|res://*/ImpPlanningModel.ssdl|res://*/ImpPlanningModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_ImprovementPlanning;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1443	3	1	IPChartServiceUrl	https://catalyst.nrcpicker.com/_layouts/ImpPlanning/IPChartService.asmx
--1484	3	3	IPProvider	NRC.Catalyst.ImpPlanning.ImpPlanningSecurityProvider, NRC.Catalyst.ImpPlanning.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1444	3	1	LongWebServiceTimeoutMS	600000
--1473	3	2	MasterDataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1460	3	1	MaxWorkerThreads	24
--1445	3	1	MyAccountUrl	https://nrcpicker.com/MyAccount
--1476	3	2	NRC_Auth	Data Source=Mercury.nationalresearch.com;Initial Catalog=NRCAuth;Persist Security Info=True;User ID=qpsa;Password=qpsa
--1446	3	1	NRCAuthIV	TcbCBV99cqa4qjNvvi8GKQ==
--1447	3	1	NRCAuthKey	BFbzIA142OgKO5uyUfVJXDyaZ2zULQWkvEHovO/vHNU=
--1480	3	2	OUEditorModel	metadata=res://*/SurveyData.OUEditorModel.csdl|res://*/SurveyData.OUEditorModel.ssdl|res://*/SurveyData.OUEditorModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1448	3	1	PDResourceUrl	https://catalyst.nrcpicker.com/CatalystHome/Lists/Resources/AllItems.aspx
--1449	3	1	PDServiceUrl	https://catalyst.nrcpicker.com/_layouts/CatalystResources/PrescriptiveDocumentService.asmx
--1450	3	1	PercentResponseChartServiceUrl	https://catalyst.nrcpicker.com/_layouts/ClientReporting/PercentResponseChartService.asmx
--1784	3	2	QPCA_ETL	Data Source=mhm0pqualsql02.nrccanada.com;User ID=ETLUser;Password=ETLUser;Initial Catalog=NRC_DataMart_ETL;Provider=SQLNCLI10.1;Persist Security Info=True;Auto Translate=False;
--1451	3	1	ReportEmail	swright@msdev.local
--1452	3	1	ReportingServiceUrl	http://catalystaggsrv/ReportServer/ReportService2005.asmx
--1453	3	1	ReportViewerServerConnection	NRC.ClientPlatform.Reporting.ReportServerConnection, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1485	3	3	ResourcesProvider	NRC.Catalyst.Resources.ResourcesSecurityProvider, NRC.Catalyst.Resources, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1776	3	1	RevealURL	https://catalyst.nationalresearch.com/Account/NRCAuthEntry?returnUrl=%2FReports%2FHome
--1454	3	1	SiteSetupUNC	\\oma0pcatsql01.nationalresearch.com\CatalystSiteSetup
--1463	3	1	SleepIntervalSecs	4
--1752	3	1	SMTPServer	SMTP2.nationalresearch.com
--1455	3	1	SOTTestMode	0
--1456	3	1	SSRSCredentials	nrc,#nrcsrv,88hawk
--1753	3	1	SuccessEmailRecepient	CatalystAlerts@NationalResearch.com
--1457	3	1	TrendlineServiceUrl	https://catalyst.nrcpicker.com/_layouts/ClientReporting/TrendlineService.asmx
--1458	3	1	UpdateUrl	https://catalyst.nrcpicker.com
--1464	3	1	UrlPattern	%
--1459	3	1	UsageLogging	LogAll
--1477	3	2	UserNavigationSettings	metadata=res://*/Source.SiteNavigation.UserNavigationSettings.csdl|res://*/Source.SiteNavigation.UserNavigationSettings.ssdl|res://*/Source.SiteNavigation.UserNavigationSettings.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_ClientPlatform;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1478	3	2	VBPDataModel	metadata=res://*/VBPDataModel.csdl|res://*/VBPDataModel.ssdl|res://*/VBPDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb2\catdb2;Initial Catalog=NRC_VBP;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1486	3	3	VBPProvider	NRC.Catalyst.VBP.UI.VBPSecurityProvider, NRC.Catalyst.VBP.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1479	3	2	VBPScenarioModel	metadata=res://*/ScenarioModel.VBPScenarioModel.csdl|res://*/ScenarioModel.VBPScenarioModel.ssdl|res://*/ScenarioModel.VBPScenarioModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=catclustdb1\catdb1;Initial Catalog=NRC_VBP_Scenario;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1699	4	1	AMCMaxSiteNodes	1000
--1700	4	1	ApplyMassChangesServiceUrl	http://nrcdev1/_layouts/ClientReporting/ApplyMassChangesService.asmx
--1701	4	1	AuditEvents	false
--1702	4	1	AuditRequests	false
--1703	4	1	AuditSigTests	false
--1746	4	2	BackgroundFieldsModel	metadata=res://*/SurveyData.BackgroundFieldsModel.csdl|res://*/SurveyData.BackgroundFieldsModel.ssdl|res://*/SurveyData.BackgroundFieldsModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1734	4	2	BenchmarksModel	metadata=res://*/BenchmarksModel.csdl|res://*/BenchmarksModel.ssdl|res://*/BenchmarksModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_Benchmarks;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1735	4	2	CachedRequestModel	metadata=res://*/Request.CachedRequestModel.csdl|res://*/Request.CachedRequestModel.ssdl|res://*/Request.CachedRequestModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_Requests_Steve;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1704	4	1	CatalystSupportEmailAddr	catalystsupport@nationalresearch.com
--1736	4	2	ClientPlatformModel	metadata=res://*/ClientPlatformModel.csdl|res://*/ClientPlatformModel.ssdl|res://*/ClientPlatformModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ClientPlatform_Steve;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1747	4	3	CPProvider	NRC.ClientPlatform.ClientPlatformSecurityProvider, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1748	4	3	CRProvider	NRC.ClientReporting.ClientReportingSecurityProvider, NRC.ClientReporting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1737	4	2	DataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_DataMart_Metadata;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1705	4	1	DebugXpDB	False
--1727	4	1	EnableAdminThread	True
--1731	4	1	EnableBenchmarkThread	False
--1726	4	1	EnableDebugging	False
--1706	4	1	EnableIPGeneration	false
--1730	4	1	EnableIPThread	True
--1733	4	1	EnableSnapshotThread	True
--1732	4	1	EnableWorkerThreads	True
--1739	4	2	EventDataModel	metadata=res://*/SurveyData.EventData.EventDataModel.csdl|res://*/SurveyData.EventData.EventDataModel.ssdl|res://*/SurveyData.EventData.EventDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1707	4	1	ExperienceDashboardServiceUrl	http://nrcdev1/_layouts/ClientReporting/ExperienceDashboardService.asmx
--1740	4	2	ImpPlanningModel	metadata=res://*/ImpPlanningModel.csdl|res://*/ImpPlanningModel.ssdl|res://*/ImpPlanningModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ImprovementPlanning;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1708	4	1	IPChartServiceUrl	http://nrcdev1/_layouts/ImpPlanning/IPChartService.asmx
--1749	4	3	IPProvider	NRC.Catalyst.ImpPlanning.ImpPlanningSecurityProvider, NRC.Catalyst.ImpPlanning.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1709	4	1	LongWebServiceTimeoutMS	600000
--1738	4	2	MasterDataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1725	4	1	MaxWorkerThreads	3
--1710	4	1	MyAccountUrl	https://nrcpicker.com/MyAccount
--1741	4	2	NRC_Auth	Data Source=Mercury.nationalresearch.com;Initial Catalog=NRCAuth;Persist Security Info=True;User ID=qpsa;Password=qpsa
--1711	4	1	NRCAuthIV	TcbCBV99cqa4qjNvvi8GKQ==
--1712	4	1	NRCAuthKey	BFbzIA142OgKO5uyUfVJXDyaZ2zULQWkvEHovO/vHNU=
--1745	4	2	OUEditorModel	metadata=res://*/SurveyData.OUEditorModel.csdl|res://*/SurveyData.OUEditorModel.ssdl|res://*/SurveyData.OUEditorModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1713	4	1	PDResourceUrl	http://nrcdev1/Lists/Resources/AllItems.aspx
--1714	4	1	PDServiceUrl	http://nrcdev1/_layouts/CatalystResources/PrescriptiveDocumentService.asmx
--1715	4	1	PercentResponseChartServiceUrl	http://nrcdev1/_layouts/ClientReporting/PercentResponseChartService.asmx
--1716	4	1	ReportEmail	swright@msdev.local
--1717	4	1	ReportingServiceUrl	http://nrcdev1/ReportServer/ReportService2005.asmx
--1718	4	1	ReportViewerServerConnection	NRC.ClientPlatform.Reporting.ReportServerConnection, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1750	4	3	ResourcesProvider	NRC.Catalyst.Resources.ResourcesSecurityProvider, NRC.Catalyst.Resources, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1719	4	1	SiteSetupUNC	\\nrcdev1\CatalystSiteSetup
--1728	4	1	SleepIntervalSecs	4
--1720	4	1	SOTTestMode	0
--1721	4	1	SSRSCredentials	nrc,#nrcsrv,88hawk
--1722	4	1	TrendlineServiceUrl	http://nrcdev1/_layouts/ClientReporting/TrendlineService.asmx
--1723	4	1	UpdateUrl	http://nrcdev1
--1729	4	1	UrlPattern	%
--1724	4	1	UsageLogging	LogAll
--1742	4	2	UserNavigationSettings	metadata=res://*/Source.SiteNavigation.UserNavigationSettings.csdl|res://*/Source.SiteNavigation.UserNavigationSettings.ssdl|res://*/Source.SiteNavigation.UserNavigationSettings.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_ClientPlatform_Steve;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1743	4	2	VBPDataModel	metadata=res://*/VBPDataModel.csdl|res://*/VBPDataModel.ssdl|res://*/VBPDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_VBP;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1751	4	3	VBPProvider	NRC.Catalyst.VBP.UI.VBPSecurityProvider, NRC.Catalyst.VBP.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1744	4	2	VBPScenarioModel	metadata=res://*/ScenarioModel.VBPScenarioModel.csdl|res://*/ScenarioModel.VBPScenarioModel.ssdl|res://*/ScenarioModel.VBPScenarioModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb1;Initial Catalog=NRC_VBP_Scenario;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1222	6	1	AMCMaxSiteNodes	1000
--1223	6	1	ApplyMassChangesServiceUrl	http://nrcdev2/_layouts/ClientReporting/ApplyMassChangesService.asmx
--1224	6	1	AuditEvents	false
--1225	6	1	AuditRequests	false
--1226	6	1	AuditSigTests	false
--1269	6	2	BackgroundFieldsModel	metadata=res://*/SurveyData.BackgroundFieldsModel.csdl|res://*/SurveyData.BackgroundFieldsModel.ssdl|res://*/SurveyData.BackgroundFieldsModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=lnk0tcatsql01\catdb2;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1257	6	2	BenchmarksModel	metadata=res://*/BenchmarksModel.csdl|res://*/BenchmarksModel.ssdl|res://*/BenchmarksModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql\catalyst;Initial Catalog=NRC_Benchmarks;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1258	6	2	CachedRequestModel	metadata=res://*/Request.CachedRequestModel.csdl|res://*/Request.CachedRequestModel.ssdl|res://*/Request.CachedRequestModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_Requests_Jun;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1227	6	1	CatalystSupportEmailAddr	catalystsupport@nationalresearch.com
--1259	6	2	ClientPlatformModel	metadata=res://*/ClientPlatformModel.csdl|res://*/ClientPlatformModel.ssdl|res://*/ClientPlatformModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_ClientPlatform_Jun;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1270	6	3	CPProvider	NRC.ClientPlatform.ClientPlatformSecurityProvider, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1271	6	3	CRProvider	NRC.ClientReporting.ClientReportingSecurityProvider, NRC.ClientReporting, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1260	6	2	DataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_DataMart_Metadata;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1228	6	1	DebugXpDB	False
--1250	6	1	EnableAdminThread	True
--1254	6	1	EnableBenchmarkThread	False
--1249	6	1	EnableDebugging	False
--1229	6	1	EnableIPGeneration	false
--1253	6	1	EnableIPThread	True
--1256	6	1	EnableSnapshotThread	True
--1255	6	1	EnableWorkerThreads	True
--1262	6	2	EventDataModel	metadata=res://*/SurveyData.EventData.EventDataModel.csdl|res://*/SurveyData.EventData.EventDataModel.ssdl|res://*/SurveyData.EventData.EventDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql\catalyst;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1230	6	1	ExperienceDashboardServiceUrl	http://nrcdev2/_layouts/ClientReporting/ExperienceDashboardService.asmx
--1263	6	2	ImpPlanningModel	metadata=res://*/ImpPlanningModel.csdl|res://*/ImpPlanningModel.ssdl|res://*/ImpPlanningModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_ImprovementPlanning;Persist Security Info=True;User ID=nrc;Password=nrc;Pooling=False;MultipleActiveResultSets=True'
--1231	6	1	IPChartServiceUrl	http://nrcdev2/_layouts/ImpPlanning/IPChartService.asmx
--1272	6	3	IPProvider	NRC.Catalyst.ImpPlanning.ImpPlanningSecurityProvider, NRC.Catalyst.ImpPlanning.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1232	6	1	LongWebServiceTimeoutMS	600000
--1261	6	2	MasterDataMartModel	metadata=res://*/SurveyData.DataMartModel.csdl|res://*/SurveyData.DataMartModel.ssdl|res://*/SurveyData.DataMartModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql\catalyst;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1248	6	1	MaxWorkerThreads	3
--1233	6	1	MyAccountUrl	https://nrcpicker.com/MyAccount
--1264	6	2	NRC_Auth	Data Source=Mercury;Initial Catalog=NRCAuth;Persist Security Info=True;User ID=qpsa;Password=qpsa
--1234	6	1	NRCAuthIV	TcbCBV99cqa4qjNvvi8GKQ==
--1235	6	1	NRCAuthKey	BFbzIA142OgKO5uyUfVJXDyaZ2zULQWkvEHovO/vHNU=
--1268	6	2	OUEditorModel	metadata=res://*/SurveyData.OUEditorModel.csdl|res://*/SurveyData.OUEditorModel.ssdl|res://*/SurveyData.OUEditorModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql\catalyst;Initial Catalog=NRC_DataMart;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1236	6	1	PDResourceUrl	http://nrcdev2/Lists/Resources/AllItems.aspx
--1237	6	1	PDServiceUrl	http://nrcdev2/_layouts/CatalystResources/PrescriptiveDocumentService.asmx
--1238	6	1	PercentResponseChartServiceUrl	http://nrcdev2/_layouts/ClientReporting/PercentResponseChartService.asmx
--1239	6	1	ReportEmail	swright@msdev.local
--1240	6	1	ReportingServiceUrl	http://nrcdev2/ReportServer/ReportService2005.asmx
--1241	6	1	ReportViewerServerConnection	NRC.ClientPlatform.Reporting.ReportServerConnection, NRC.ClientPlatform, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1273	6	3	ResourcesProvider	NRC.Catalyst.Resources.ResourcesSecurityProvider, NRC.Catalyst.Resources, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1242	6	1	SiteSetupUNC	\\nrcdev2\CatalystSiteSetup
--1251	6	1	SleepIntervalSecs	4
--1243	6	1	SOTTestMode	0
--1244	6	1	SSRSCredentials	nrc,#nrcsrv,88hawk
--1245	6	1	TrendlineServiceUrl	http://nrcdev2/_layouts/ClientReporting/TrendlineService.asmx
--1246	6	1	UpdateUrl	http://nrcdev2
--1252	6	1	UrlPattern	%
--1247	6	1	UsageLogging	LogAll
--1265	6	2	UserNavigationSettings	metadata=res://*/Source.SiteNavigation.UserNavigationSettings.csdl|res://*/Source.SiteNavigation.UserNavigationSettings.ssdl|res://*/Source.SiteNavigation.UserNavigationSettings.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_ClientPlatform_Jun;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1266	6	2	VBPDataModel	metadata=res://*/VBPDataModel.csdl|res://*/VBPDataModel.ssdl|res://*/VBPDataModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql\catalyst;Initial Catalog=NRC_VBP;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'
--1274	6	3	VBPProvider	NRC.Catalyst.VBP.UI.VBPSecurityProvider, NRC.Catalyst.VBP.UI, Version=1.0.0.0, Culture=neutral, PublicKeyToken=cc146295093fd92b
--1267	6	2	VBPScenarioModel	metadata=res://*/ScenarioModel.VBPScenarioModel.csdl|res://*/ScenarioModel.VBPScenarioModel.ssdl|res://*/ScenarioModel.VBPScenarioModel.msl;provider=System.Data.SqlClient;provider connection string='Data Source=testnrcsql;Initial Catalog=NRC_VBP_Scenario;Persist Security Info=True;User ID=nrc;Password=nrc;MultipleActiveResultSets=True'

