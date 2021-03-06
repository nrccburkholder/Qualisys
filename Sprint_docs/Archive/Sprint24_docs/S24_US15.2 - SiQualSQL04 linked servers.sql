--irish	SiQualSQL04

/****** Object:  LinkedServer [QLOADER]    Script Date: 04/07/2015 16:03:06 ******/
IF  EXISTS (SELECT srv.srvname FROM master.dbo.sysservers srv WHERE srv.srvid != 0 AND srv.srvname = N'QLOADER')EXEC master.dbo.sp_dropserver @server=N'QLOADER', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [QLOADER]    Script Date: 04/07/2015 16:03:06 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'QLOADER', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiQualSQL01'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QLOADER',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'

GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'QLOADER', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


/****** Object:  LinkedServer [QUALISYS]    Script Date: 04/07/2015 16:03:46 ******/
IF  EXISTS (SELECT srv.srvname FROM master.dbo.sysservers srv WHERE srv.srvid != 0 AND srv.srvname = N'QUALISYS')EXEC master.dbo.sp_dropserver @server=N'QUALISYS', @droplogins='droplogins'
GO

/****** Object:  LinkedServer [QUALISYS]    Script Date: 04/07/2015 16:03:46 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'QUALISYS', @srvproduct=N'SQLOLEDB', @provider=N'SQLNCLI', @datasrc=N'SiQualSQL02'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS',@useself=N'False',@locallogin=NULL,@rmtuser=N'qpsa',@rmtpassword='qpsa'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'QUALISYS',@useself=N'True',@locallogin=N'devnrcus\#STAGESRV',@rmtuser=NULL,@rmtpassword=NULL

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

