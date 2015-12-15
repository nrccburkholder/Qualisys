-- Creates the Tables used by SmartLink

CREATE TABLE  dbo.SmartLinkWebService (
  ID varchar(25) NOT NULL,
  FileName varchar(255) default NULL,
  FileSizeInBytes INT default NULL,
  StartCheckSum varchar(255) default NULL,
  StartTime datetime default NULL,
  EndCheckSum varchar(255) default NULL,
  EndTime datetime default NULL,
  Success tinyint default (0),
  PRIMARY KEY  (ID)
);

CREATE NONCLUSTERED INDEX IX_SmartLinkWebService_FileName_StartCheckSum_EndCheckSum ON dbo.SmartLinkWebService
(
FileName,
StartCheckSum,
EndCheckSum
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

CREATE TABLE  dbo.VersionInfo (
  VersionID VARCHAR(20) NOT NULL,
  URL varchar(1024) NOT NULL,
  FileName varchar(50) NOT NULL,
  FileCheckSum varchar(100) NOT NULL,
  CreatedDate DATETIME NOT NULL default GETDATE(),
  PRIMARY KEY  (VersionID)
);

CREATE TABLE  dbo.VersionRequest (
  ClientID varchar(50) NOT NULL,
  ClientVersion varchar(20) NOT NULL,
  ProvidedVersion varchar(20) NOT NULL,
  RequestTime DATETIME NOT NULL default GETDATE()
);
