--catclustdb2\catdb2

/****** Object:  LinkedServer [DATAMART]    Script Date: 04/07/2015 16:00:30 ******/
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'DATAMART')EXEC master.dbo.sp_dropserver @server=N'DATAMART', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [DATAMART]    Script Date: 04/07/2015 16:00:30 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'DATAMART', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiQualSQL03'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DATAMART',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DATAMART',@useself=N'False',@locallogin=N'qpsa',@rmtuser=N'qpsa',@rmtpassword='qpsa'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DATAMART',@useself=N'False',@locallogin=N'sa',@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'DATAMART', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


--/****** Object:  LinkedServer [KRATOS]    Script Date: 05/06/2015 15:03:04 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'KRATOS', @srvproduct=N'SQL Server'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'KRATOS',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='########'

--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'rpc', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'rpc out', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'sub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'KRATOS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO


/****** Object:  LinkedServer [DATAMART]    Script Date: 04/07/2015 16:00:30 ******/
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'Medusa')EXEC master.dbo.sp_dropserver @server=N'Medusa', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [DATAMART]    Script Date: 04/07/2015 16:00:30 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'Medusa', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiQualSQL03'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Medusa',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Medusa',@useself=N'False',@locallogin=N'qpsa',@rmtuser=N'qpsa',@rmtpassword='qpsa'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Medusa',@useself=N'False',@locallogin=N'sa',@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'Medusa', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO




/****** Object:  LinkedServer [SECURITY]    Script Date: 04/07/2015 16:02:03 ******/
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'NRCAuth')EXEC master.dbo.sp_dropserver @server=N'NRCAuth', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [SECURITY]    Script Date: 04/07/2015 16:02:03 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'NRCAuth', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiAuthSQL01'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'NRCAuth',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'NRCAuth', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO




--/****** Object:  LinkedServer [OMA0PITSQL01]    Script Date: 05/06/2015 15:03:40 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'OMA0PITSQL01', @srvproduct=N'SQL Server'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'OMA0PITSQL01',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='########'

--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'rpc', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'rpc out', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'sub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'OMA0PITSQL01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO





/****** Object:  LinkedServer [QUALISYS]    Script Date: 04/07/2015 16:01:51 ******/
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'QUALISYS')EXEC master.dbo.sp_dropserver @server=N'QUALISYS', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [QUALISYS]    Script Date: 04/07/2015 16:01:51 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'QUALISYS', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiQualSQL02'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'QUALISYS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO



--/****** Object:  LinkedServer [QUALISYS_CA]    Script Date: 05/06/2015 15:00:43 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'QUALISYS_CA', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'mhm0pqualsql02.nrccanada.com'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS_CA',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS_CA',@useself=N'False',@locallogin=N'NRC\ccaouette',@rmtuser=N'ETLUser',@rmtpassword='########'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS_CA',@useself=N'False',@locallogin=N'NRC\dhansen',@rmtuser=N'qpsa',@rmtpassword='########'

--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'rpc', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'rpc out', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'sub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'QUALISYS_CA', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO



--/****** Object:  LinkedServer [RESEARCHSQL01]    Script Date: 05/06/2015 15:03:58 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'RESEARCHSQL01', @srvproduct=N'SQL Server'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'False',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'True',@locallogin=N'NRC\aweixelman',@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'False',@locallogin=N'NRC\ccaouette',@rmtuser=N'NRC',@rmtpassword='########'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'False',@locallogin=N'NRC\dhansen',@rmtuser=N'NRC',@rmtpassword='########'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'True',@locallogin=N'NRC\jbonander',@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'True',@locallogin=N'NRC\jschwab',@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'True',@locallogin=N'NRC\THeidinger',@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RESEARCHSQL01',@useself=N'True',@locallogin=N'NRC\TRyck',@rmtuser=NULL,@rmtpassword=NULL

--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'rpc', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'rpc out', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'sub', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RESEARCHSQL01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO




--/****** Object:  LinkedServer [Reveal]    Script Date: 05/06/2015 15:04:07 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'Reveal', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'rvl01\dm01'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Reveal',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Reveal',@useself=N'False',@locallogin=N'NRC\#NRCSRV',@rmtuser=N'revealJobs',@rmtpassword='########'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Reveal',@useself=N'False',@locallogin=N'NRC\ccaouette',@rmtuser=N'revealJobs',@rmtpassword='########'

--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'rpc', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'rpc out', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'sub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'Reveal', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO



--/****** Object:  LinkedServer [RVL01\DM01]    Script Date: 05/06/2015 15:04:23 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'RVL01\DM01', @srvproduct=N'SQL Server'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'RVL01\DM01',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL

--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'data access', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'rpc', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'rpc out', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'sub', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'RVL01\DM01', @optname=N'remote proc transaction promotion', @optvalue=N'false'
--GO





--/****** Object:  LinkedServer [SLXSQL]    Script Date: 05/06/2015 15:04:31 ******/
--EXEC master.dbo.sp_addlinkedserver @server = N'SLXSQL', @srvproduct=N'sqloledb', @provider=N'SQLNCLI', @datasrc=N'oma0pslxsql02'
--EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SLXSQL',@useself=N'False',@locallogin=NULL,@rmtuser=N'SSRS_Reporting',@rmtpassword='########'

--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'collation compatible', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'data access', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'dist', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'pub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'rpc', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'rpc out', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'sub', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'connect timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'collation name', @optvalue=null
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'lazy schema validation', @optvalue=N'false'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'query timeout', @optvalue=N'0'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'use remote collation', @optvalue=N'true'
--GO
--EXEC master.dbo.sp_serveroption @server=N'SLXSQL', @optname=N'remote proc transaction promotion', @optvalue=N'true'
--GO

