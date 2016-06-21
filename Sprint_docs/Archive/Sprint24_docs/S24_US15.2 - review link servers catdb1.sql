-- catclustdb1\catdb1


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





/****** Object:  LinkedServer [SECURITY]    Script Date: 04/07/2015 16:02:03 ******/
IF  EXISTS (SELECT srv.name FROM sys.servers srv WHERE srv.server_id != 0 AND srv.name = N'SECURITY')EXEC master.dbo.sp_dropserver @server=N'SECURITY', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [SECURITY]    Script Date: 04/07/2015 16:02:03 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'SECURITY', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiAuthSQL01'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SECURITY',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SECURITY', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO




--/****** Object:  LinkedServer [SLXSQL]    Script Date: 05/06/2015 15:15:11 ******/
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

