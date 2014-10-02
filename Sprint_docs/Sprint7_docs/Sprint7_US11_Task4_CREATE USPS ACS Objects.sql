USE [QP_Prod]
GO

/****** Object:  Table [dbo].[USPS_ACS_Schemas]    Script Date: 8/21/2014 11:01:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_Schemas](
	[USPS_ACS_Schema_ID] [int] IDENTITY(1,1) NOT NULL,
	[SchemaName] [varchar](255) NOT NULL,
	[FileVersion] [varchar](2) NULL,
	[DetailRecordIndicator] [varchar](1) NOT NULL,
	[RecordLength] [int] NOT NULL,
	[ExpiryDate] DateTime NULL
 CONSTRAINT [PK_USPS_ACS_Schemas] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_Schema_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[USPS_ACS_SchemaMapping]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_SchemaMapping](
	[USPS_ACS_SchemaMapping_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_Schema_ID] [int] NOT NULL,
	[RecordType] [varchar](1) NOT NULL,
	[DataType] [varchar](10) NOT NULL,
	[ColumnName] [varchar](255) NOT NULL,
	[ColumnStart] [int] NOT NULL,
	[ColumnWidth] [int] NOT NULL
 CONSTRAINT [PK_USPS_ACS_SchemaMapping] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_SchemaMapping_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[USPS_ACS_DownloadLog]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[USPS_ACS_DownloadLog](
	[USPS_ACS_DownloadLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](20) NOT NULL,
	[FileId] [varchar](20) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[Size] [varchar](20) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[FulfilledDate] [varchar](8) NOT NULL,
	[ModifiedDate] [varchar](8) NOT NULL,
	[URL] [varchar](255) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] DateTime,
	[DateModified] DateTime
 CONSTRAINT [PK_USPS_ACS_DownloadLog] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_DownloadLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[USPS_ACS_ExtractFileLog]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO




CREATE TABLE [dbo].[USPS_ACS_ExtractFileLog](
	[USPS_ACS_ExtractFileLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[FilePath] [varchar](255) NOT NULL,
	[Version] [varchar](2) NOT NULL,
	[DetailRecordIndicator] [varchar](1) NOT NULL,
	[CustomerID] [varchar](6) NOT NULL,
	[RecordCount] [varchar](9) NOT NULL,
	[HeaderDate] [varchar](8) NOT NULL,
	[HeaderText] [varchar](1000) NOT NULL,
	[ZipFileName] [varchar](255) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] DateTime,
	[DateModified] DateTime
 CONSTRAINT [PK_USPS_ACS_ExtractFileLog] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFileLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [QP_Prod]
GO

/****** Object:  Table [dbo].[USPS_ACS_ExtractFile]    Script Date: 9/23/2014 10:38:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[USPS_ACS_ExtractFile](
	[USPS_ACS_ExtractFile_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_ExtractFileLog_ID] [int] NULL,
	[RecordText] [varchar](8000) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[IsNotified] [bit] NOT NULL,
 CONSTRAINT [PK_USPS_ACS_ExtractFile] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[USPS_ACS_ExtractFile] ADD  DEFAULT ((0)) FOR [IsNotified]
GO



/****** Object:  Table [dbo].[USPS_ACS_ExtractFile_Work]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

DROP TABLE [dbo].[USPS_ACS_ExtractFile_Work]

CREATE TABLE [dbo].[USPS_ACS_ExtractFile_Work](
	[USPS_ACS_ExtractFile_Work_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_ExtractFile_ID] [int],
	FName varchar(15),
	LName varchar(20),
	PrimaryNumberOld varchar(10),
	PreDirectionalOld varchar(2),
	StreetNameOld varchar(28),
	StreetSuffixOld varchar(4),
	PostDirectionalOld varchar(2),
	UnitDesignatorOld varchar(4),
	SecondaryNumberOld varchar(10),
	CityOld varchar(28),
	StateOld varchar(2),
	Zip5Old varchar(5),
	PrimaryNumberNew varchar(10),
	PreDirectionalNew varchar(2),
	StreetNameNew varchar(28),
	StreetSuffixNew varchar(4),
	PostDirectionalNew varchar(2),
	UnitDesignatorNew varchar(4),
	SecondaryNumberNew varchar(10),
	CityNew varchar(28),
	StateNew varchar(2),
	Zip5New varchar(5),
	Plus4ZipNew varchar(4),
	AddressNew varchar(66),
	Address2New varchar(14)
	
 CONSTRAINT [PK_USPS_ACS_ExtractFile_Work] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_Work_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [QP_Prod]
GO

/****** Object:  Table [dbo].[USPS_ACS_ExtractFile_PartialMatch]    Script Date: 9/23/2014 10:36:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_ExtractFile_PartialMatch](
	[USPS_ACS_ExtractFile_PartialMatch_id] [int] IDENTITY(1,1) NOT NULL,
	[Study_id] [int] NULL,
	[Pop_id] [int] NULL,
	[Status] [varchar](20) NULL,
	[FullMatch] [bit] NULL,
	[popFname] [varchar](42) NULL,
	[popLname] [varchar](42) NULL,
	[popAddr] [varchar](60) NULL,
	[popAddr2] [varchar](42) NULL,
	[popCity] [varchar](42) NULL,
	[popSt] [varchar](2) NULL,
	[popZip5] [varchar](5) NULL,
	[USPS_ACS_ExtractFile_Work_ID] [int] NOT NULL,
	[USPS_ACS_ExtractFile_ID] [int] NULL,
	[FName] [varchar](15) NULL,
	[LName] [varchar](20) NULL,
	[PrimaryNumberOld] [varchar](10) NULL,
	[PreDirectionalOld] [varchar](2) NULL,
	[StreetNameOld] [varchar](28) NULL,
	[StreetSuffixOld] [varchar](4) NULL,
	[PostDirectionalOld] [varchar](2) NULL,
	[UnitDesignatorOld] [varchar](4) NULL,
	[SecondaryNumberOld] [varchar](10) NULL,
	[CityOld] [varchar](28) NULL,
	[StateOld] [varchar](2) NULL,
	[Zip5Old] [varchar](5) NULL,
	[PrimaryNumberNew] [varchar](10) NULL,
	[PreDirectionalNew] [varchar](2) NULL,
	[StreetNameNew] [varchar](28) NULL,
	[StreetSuffixNew] [varchar](4) NULL,
	[PostDirectionalNew] [varchar](2) NULL,
	[UnitDesignatorNew] [varchar](4) NULL,
	[SecondaryNumberNew] [varchar](10) NULL,
	[CityNew] [varchar](28) NULL,
	[StateNew] [varchar](2) NULL,
	[Zip5New] [varchar](5) NULL,
	[Plus4ZipNew] [varchar](4) NULL,
	[AddressNew] [varchar](66) NULL,
	[Address2New] [varchar](14) NULL,
	[strLithocode] [varchar](10) NULL,
 CONSTRAINT [PK_USPS_ACS_ExtractFile_PartialMatch_id] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_PartialMatch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



/* PROCS */

/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertDownloadLog]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertDownloadLog]
	@Key varchar(20), 
	@FileId varchar(20),
	@FileName varchar(255), 
	@Size varchar(20), 
	@Code varchar(20), 
	@Name varchar(50), 
	@FulfilledDate varchar(8), 
	@ModifiedDate varchar(8), 
	@URL varchar(255),
	@Status varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	INSERT INTO [dbo].[USPS_ACS_DownloadLog]
			   ([Key]
			   ,[FileId]
			   ,[FileName]
			   ,[Size]
			   ,[Code]
			   ,[Name]
			   ,[FulfilledDate]
			   ,[ModifiedDate]
			   ,[URL]
			   ,[Status]
			   ,[DateCreated])
		 VALUES
			   (@Key
			   ,@FileId
			   ,@FileName
			   ,@Size
			   ,@Code
			   ,@Name
			   ,@FulfilledDate
			   ,@ModifiedDate
			   ,@URL
			   ,@Status
			   ,GETDATE())

END

GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertExtractFileLog]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertExtractFileLog]
	@FileName varchar(255),
	@FilePath varchar(255),
	@Version varchar(2),
	@DetailRecordIndicator varchar(1),
	@CustomerID varchar(6),
	@RecordCount varchar(9),
	@CreatedDate varchar(8),
	@HeaderText varchar(1000),
	@ZipFileName varchar(255),
	@Status varchar(20)
AS
BEGIN


	INSERT INTO [dbo].[USPS_ACS_ExtractFileLog]
           ([FileName]
           ,[FilePath]
           ,[Version]
           ,[DetailRecordIndicator]
           ,[CustomerID]
           ,[RecordCount]
           ,[HeaderDate]
		   ,[HeaderText]
		   ,[ZipFileName]
           ,[Status]
		   ,[DateCreated])
     VALUES
           (@FileName
           ,@FilePath
           ,@Version
           ,@DetailRecordIndicator
           ,@CustomerID
           ,@RecordCount
           ,@CreatedDate
		   ,@HeaderText
		   ,@ZipFileName
           ,@Status
		   ,GETDATE())

END
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_InsertExtractFileRecord]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_InsertExtractFileRecord]
	@ExtractFileLog_Id int,
	@RecordText varchar(1000),
	@FName varchar(15),
	@LName varchar(20),
	@PrimaryNumberOld varchar(10),
	@PreDirectionalOld varchar(2),
	@StreetNameOld varchar(28),
	@StreetSuffixOld varchar(4),
	@PostDirectionalOld varchar(2),
	@UnitDesignatorOld varchar(4),
	@SecondaryNumberOld varchar(10),
	@CityOld varchar(28),
	@StateOld varchar(2),
	@Zip5Old varchar(5),
	@PrimaryNumberNew varchar(10),
	@PreDirectionalNew varchar(2),
	@StreetNameNew varchar(28),
	@StreetSuffixNew varchar(4),
	@PostDirectionalNew varchar(2),
	@UnitDesignatorNew varchar(4),
	@SecondaryNumberNew varchar(10),
	@CityNew varchar(28),
	@StateNew varchar(2),
	@Zip5New varchar(5),
	@Plus4ZipNew varchar(4),
	@AddressNew varchar(66),
	@Address2New varchar(14)

AS
BEGIN

	DECLARE @ExtractFileRecord_Id int

	INSERT INTO [dbo].[USPS_ACS_ExtractFile]
           ([USPS_ACS_ExtractFileLog_ID]
           ,[RecordText]
           ,[Status]
		   ,[DateCreated])
     VALUES
           (@ExtractFileLog_Id
           ,@RecordText
           ,'New'
		   ,GETDATE())

	SET @ExtractFileRecord_Id = SCOPE_IDENTITY()

	IF @AddressNew <> 'TEMPORARILY AWAY'
	BEGIN
		INSERT INTO [dbo].[USPS_ACS_ExtractFile_Work]
			   ([USPS_ACS_ExtractFile_ID]
			   ,[FName]
			   ,[LName]
			   ,[PrimaryNumberOld]
			   ,[PreDirectionalOld]
			   ,[StreetNameOld]
			   ,[StreetSuffixOld]
			   ,[PostDirectionalOld]
			   ,[UnitDesignatorOld]
			   ,[SecondaryNumberOld]
			   ,[CityOld]
			   ,[StateOld]
			   ,[Zip5Old]
			   ,[PrimaryNumberNew]
			   ,[PreDirectionalNew]
			   ,[StreetNameNew]
			   ,[StreetSuffixNew]
			   ,[PostDirectionalNew]
			   ,[UnitDesignatorNew]
			   ,[SecondaryNumberNew]
			   ,[CityNew]
			   ,[StateNew]
			   ,[Zip5New]  
			   ,[Plus4ZipNew]
			   ,[AddressNew]
			   ,[Address2New])
		 VALUES
			   (@ExtractFileRecord_Id
			    ,@FName
			    ,@LName
				,@PrimaryNumberOld
				,@PreDirectionalOld
				,@StreetNameOld
				,@StreetSuffixOld
				,@PostDirectionalOld
				,@UnitDesignatorOld
				,@SecondaryNumberOld
				,@CityOld
				,@StateOld
				,@Zip5Old
				,@PrimaryNumberNew
				,@PreDirectionalNew
				,@StreetNameNew
				,@StreetSuffixNew
				,@PostDirectionalNew
				,@UnitDesignatorNew
				,@SecondaryNumberNew
				,@CityNew
				,@StateNew
				,@Zip5New
				,@Plus4ZipNew
				,@AddressNew
				,@Address2New)

	END
	ELSE
	BEGIN
		UPDATE [USPS_ACS_ExtractFile]
		SET [Status] = 'TEMPORAILY AWAY'
		where USPS_ACS_ExtractFile_ID =@ExtractFileRecord_Id
	END


END
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_ProcessFile]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_ProcessFile]
@USPS_ACS_ExtractFileLog_ID int
as

--declare @USPS_ACS_ExtractFileLog_ID int
--set @USPS_ACS_ExtractFileLog_ID=2

declare @daysBack int, @headerDate datetime

select @daysBack=numParam_Value 
from qualpro_params 
where strParam_nm='USPS_ACS_SentMailingRange'


select @headerDate=headerDate 
from USPS_ACS_ExtractFileLog 
where USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

if exists (select * from qualpro_params where strParam_nm='EnvName' and strParam_Value <> 'Production')
	set @headerdate=getdate()  -- for non production environments only 

create table #studylist (study_id int, sampleset_id int, flag tinyint)

-- list of studies that have surveys that use the USPS Address Change Service and have mailed items within the last @daysBack days
insert into #studylist
select distinct sd.study_id, ss.sampleset_id, 0 as flag
from survey_def sd
inner join sampleset ss on sd.survey_id=ss.survey_id 
inner join samplepop sp on ss.sampleset_id=sp.sampleset_id
inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where sd.UseUSPSAddrChangeService=1
and sm.datmailed between dateadd(day,-@daysBack,@headerDate) and @headerDate
and ms.intsequence=1 -- only the first mailpiece will have address correction requests

create table #pop (study_id int
	, pop_id int
	, strLithocode varchar(10)
	, Fname varchar(42)
	, Lname varchar(42)
	, addr  varchar(60)
	, addr2  varchar(42)
	, city  varchar(42)
	, st  varchar(2)
	, zip5 varchar(5)
	, zip4 varchar(4)
	)

declare @study varchar(10), @SQL varchar(max)
select top 1 @study=study_id from #StudyList where flag=0
while @@rowcount>0
begin
	set @SQL = 'insert into #pop (study_id, pop_id, strLithocode, fname, lname, addr, addr2, city, st, zip5, zip4)
	select '+@study+', p.pop_id, min(sm.strLithocode), p.Fname, p.Lname, p.addr, p.addr2, p.city, p.st, p.zip5, p.zip4
	from s'+@study+'.population p
	inner join samplepop sp on p.pop_id=sp.pop_id and sp.study_id='+@study+'
	inner join #studylist sl on sp.study_id=sl.study_id and sp.sampleset_id=sl.sampleset_id
	inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
	inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
	inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
	where sm.datmailed >= dateadd(day,-'+convert(varchar,@daysback)+',getdate())
	and ms.intsequence=1 
	group by p.pop_id, p.Fname, p.Lname, p.addr, p.addr2, p.city, p.st, p.zip5, p.zip4'
	
	exec (@SQL)	
	
	update #studyList set flag=1 where study_id=@study
	select top 1 @study=study_id from #StudyList where flag=0
end

create index tmp_ndx on #pop (lname, st, zip5)

select p.study_id, p.pop_id, p.strLithocode, w.USPS_ACS_ExtractFile_Work_ID, w.USPS_ACS_ExtractFile_ID, w.addressnew, w.address2new, w.citynew, w.statenew, w.zip5new, w.Plus4ZipNew, convert(varchar(20),null) as [Status]
, case when p.fname=w.fname 
		and p.addr like '%'+w.StreetNameOld+'%'
		and isnull(p.addr2,'') like '%'+SecondaryNumberOld+'%' 
		and p.city=w.cityold then 1 else 0 
	end as FullMatch
, p.fname as popFname, p.lname as popLname, p.addr as popAddr, p.addr2 as popAddr2, p.city as popCity, p.st as popSt, p.zip5 as popZip5
, w.fname as uspsFname, w.lname as uspsLname, w.primarynumberold, w.streetnameold, w.secondarynumberold, w.cityold, w.stateold, w.zip5old
into #matches
from #pop p 
inner join USPS_ACS_extractfile_work w 
	on p.lname=w.lname 
		and p.st=w.stateold
		and p.zip5=w.zip5old
		and p.addr like '%'+w.PrimaryNumberOld+'%'
inner join USPS_ACS_extractfile f on w.USPS_ACS_ExtractFile_ID=f.USPS_ACS_ExtractFile_ID 
where f.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

-- 1 match:
update #matches 
set [Status]='Completed'
from #matches 
where USPS_ACS_ExtractFile_ID in (	select USPS_ACS_ExtractFile_ID
									from #matches m
									group by USPS_ACS_ExtractFile_ID
									having count(*)=1)

-- >1 match:
update #matches 
set [Status]='MultipleMatches'
from #matches 
where USPS_ACS_ExtractFile_ID in (	select USPS_ACS_ExtractFile_ID
									from #matches m
									group by USPS_ACS_ExtractFile_ID
									having count(*)>1)

-- if any of the MultipleMatches has one and only one FullMatch, delete the partial match(es) and set the [Status] to Completed
if @@rowcount>0
begin
	update #matches 
	set [Status]='1 full match'
	where USPS_ACS_ExtractFile_Work_ID in (	select min(USPS_ACS_ExtractFile_Work_ID) as USPS_ACS_ExtractFile_Work_ID
											from #matches
											where FullMatch=1
											and [Status]='MultipleMatches'
											group by USPS_ACS_ExtractFile_ID
											having count(*)=1 )
	delete #matches
	where [Status]='MultipleMatches'
	and USPS_ACS_ExtractFile_ID in (select USPS_ACS_ExtractFile_ID from #matches where [Status]='1 full match')
	
	update #matches set [Status]='Completed' where [Status]='1 full match'
end

update #matches set [Status]='PartialMatch' where [Status]='Completed' and fullmatch=0

-- 0 match:
update ef 
set [Status]='Not_Found', DateModified=getdate()
from USPS_ACS_extractfile ef
where ef.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID
and [Status]='New'
and USPS_ACS_ExtractFile_ID not in (select USPS_ACS_ExtractFile_ID from #matches)

update ef
set [Status]=m.[Status], DateModified=getdate()
from USPS_ACS_extractfile ef
inner join #matches m on ef.USPS_ACS_ExtractFile_ID=m.USPS_ACS_ExtractFile_ID

insert into USPS_ACS_ExtractFile_PartialMatch (Study_id,Pop_id,strLithocode,[Status],FullMatch,popFname,popLname,popAddr,popAddr2,popCity,popSt,popZip5,
	USPS_ACS_ExtractFile_Work_ID,USPS_ACS_ExtractFile_ID,FName,LName,
	PrimaryNumberOld,PreDirectionalOld,StreetNameOld,StreetSuffixOld,PostDirectionalOld,UnitDesignatorOld,SecondaryNumberOld,CityOld,StateOld,Zip5Old,
	PrimaryNumberNew,PreDirectionalNew,StreetNameNew,StreetSuffixNew,PostDirectionalNew,UnitDesignatorNew,SecondaryNumberNew,CityNew,StateNew,Zip5New,Plus4ZipNew,AddressNew,Address2New)
select m.Study_id,m.Pop_id,m.strLithocode,m.[Status],m.FullMatch,m.popFname,m.popLname,m.popAddr,m.popAddr2,m.popCity,m.popSt,m.popZip5,
	w.USPS_ACS_ExtractFile_Work_ID,w.USPS_ACS_ExtractFile_ID,w.FName,w.LName,
	w.PrimaryNumberOld,w.PreDirectionalOld,w.StreetNameOld,w.StreetSuffixOld,w.PostDirectionalOld,w.UnitDesignatorOld,w.SecondaryNumberOld,w.CityOld,w.StateOld,w.Zip5Old,
	w.PrimaryNumberNew,w.PreDirectionalNew,w.StreetNameNew,w.StreetSuffixNew,w.PostDirectionalNew,w.UnitDesignatorNew,w.SecondaryNumberNew,w.CityNew,w.StateNew,w.Zip5New,w.Plus4ZipNew,w.AddressNew,w.Address2New
from #matches m
inner join USPS_ACS_extractfile_work w on m.USPS_ACS_ExtractFile_Work_ID=w.USPS_ACS_ExtractFile_Work_ID
where m.[status] in ('PartialMatch','MultipleMatches')

select top 1 @study=study_id from #Matches where [status]='Completed'
while @@rowcount>0
begin
	set @SQL = 'update p
	set addr=left(m.AddressNew,60), addr2=m.Address2New, City=m.CityNew, St=m.StateNew, zip5=m.Zip5New, zip4=m.Plus4ZipNew
	, AddrStat=NULL, AddrErr=NULL, Del_Pt=NULL
	from s'+@study+'.population p
	inner join #matches m on p.pop_id=m.pop_id and m.study_id='+@study+'
	where [status]=''Completed'''
	
	exec (@SQL)	
	
	update #matches set [status]='updated' where study_id=@study and [status]='Completed'
	select top 1 @study=study_id from #Matches where [status]='Completed'
end

delete W
from USPS_ACS_extractfile_work w 
inner join USPS_ACS_extractfile f on w.USPS_ACS_ExtractFile_ID=f.USPS_ACS_ExtractFile_ID 
where f.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

drop table #pop
drop table #studyList
drop table #matches

GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectExtractFilesByStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USPS_ACS_SelectExtractFilesByStatus]
	@status varchar(20) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT efl.[USPS_ACS_ExtractFileLog_ID]
		  ,[FileName]
		  ,[FilePath]
		  ,[Version]
		  ,[DetailRecordIndicator]
		  ,[CustomerID]
		  ,[RecordCount]
		  ,[HeaderDate]
		  ,[HeaderText]
		  ,[ZipFileName]
		  ,efl.[Status]
	  FROM [dbo].[USPS_ACS_ExtractFileLog] efl
	  WHERE @status is null or efl.[Status] = @status
END

GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectPartialMatches]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_SelectPartialMatches]
@MarkNotified as bit = 0

AS
BEGIN
	SELECT [USPS_ACS_ExtractFile_PartialMatch_id]
      ,pm.[Study_id]
      ,pm.[Pop_id]
      ,PM.[strLithocode]
      ,pm.[Status]
      ,pm.[FullMatch]
      ,pm.[popFname]
      ,pm.[popLname]
      ,pm.[popAddr]
      ,pm.[popAddr2]
      ,pm.[popCity]
      ,pm.[popSt]
      ,pm.[popZip5]
      ,pm.[USPS_ACS_ExtractFile_Work_ID]
      ,pm.[USPS_ACS_ExtractFile_ID]
      ,pm.[FName]
      ,pm.[LName]
      ,pm.[PrimaryNumberOld]
      ,pm.[PreDirectionalOld]
      ,pm.[StreetNameOld]
      ,pm.[StreetSuffixOld]
      ,pm.[PostDirectionalOld]
      ,pm.[UnitDesignatorOld]
      ,pm.[SecondaryNumberOld]
      ,pm.[CityOld]
      ,pm.[StateOld]
      ,pm.[Zip5Old]
      ,pm.[PrimaryNumberNew]
      ,pm.[PreDirectionalNew]
      ,pm.[StreetNameNew]
      ,pm.[StreetSuffixNew]
      ,pm.[PostDirectionalNew]
      ,pm.[UnitDesignatorNew]
      ,pm.[SecondaryNumberNew]
      ,pm.[CityNew]
      ,pm.[StateNew]
      ,pm.[Zip5New]
      ,pm.[Plus4ZipNew]
      ,pm.[AddressNew]
      ,pm.[Address2New]
	INTO #PartialMatches
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
	WHERE ef.IsNotified = 0

	-- set IsNotified to 1 for each partial match returned
	if @MarkNotified = 1
	begin
		Update ef
			SET IsNotified = 1
		FROM USPS_ACS_ExtractFile ef
		INNER JOIN #PartialMatches pm ON pm.USPS_ACS_ExtractFile_ID = ef.USPS_ACS_ExtractFile_ID
	end

	SELECT *
	FROM #PartialMatches

	DROP TABLE #PartialMatches

END

GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_SelectSchema]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USPS_ACS_SelectSchema]
	@recordtype varchar(1),
	@version varchar(2)
AS
BEGIN

	DECLARE @schema_id int

	SELECT @schema_id = [USPS_ACS_Schema_ID]
	  FROM [dbo].[USPS_ACS_Schemas]
	  WHERE FileVersion = @version
	  

	SELECT [USPS_ACS_Schema_ID]
		  ,[SchemaName]
		  ,[FileVersion]
		  ,[DetailRecordIndicator]
		  ,[RecordLength]
		  ,[ExpiryDate]
	  FROM [dbo].[USPS_ACS_Schemas]
	  WHERE [USPS_ACS_Schema_ID] = @schema_id

	SELECT [USPS_ACS_SchemaMapping_ID]
		  ,[USPS_ACS_Schema_ID]
		  ,[RecordType]
		  ,[DataType]
		  ,[ColumnName]
		  ,[ColumnStart]
		  ,[ColumnWidth]
	  FROM [dbo].[USPS_ACS_SchemaMapping]
	  WHERE [USPS_ACS_Schema_ID] = @schema_id
	  AND RecordType = @recordtype

END


GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_UpdateDownloadLogStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_UpdateDownloadLogStatus]
	@filename varchar(255),
	@status varchar(20)
AS
BEGIN

	UPDATE [dbo].[USPS_ACS_DownloadLog]
	   SET [Status] = @Status,
	       [DateModified] = GETDATE()
	 WHERE [FileName] = @filename

END
GO
/****** Object:  StoredProcedure [dbo].[USPS_ACS_UpdateExtractFileLogStatus]    Script Date: 9/23/2014 10:42:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USPS_ACS_UpdateExtractFileLogStatus]
	@extractFileLog_id int,
	@status varchar(20)
AS
BEGIN

UPDATE [dbo].[USPS_ACS_ExtractFileLog]
   SET [Status] = @status
		,[DateModified] = GETDATE()
   WHERE USPS_ACS_ExtractFileLog_ID = @extractFileLog_id
END

GO

GO


/* DATA */

INSERT INTO [dbo].[USPS_ACS_Schemas]
           ([SchemaName]
           ,[FileVersion]
           ,[DetailRecordIndicator]
           ,[RecordLength]
           ,[ExpiryDate])
     VALUES
           ('ACS Fulfillment File Format'
           ,'00'
           ,'2'
           ,559
           ,CAST('2015-01-24 23:59:59.99' as datetime)
		   )
GO

INSERT INTO [dbo].[USPS_ACS_Schemas]
           ([SchemaName]
           ,[FileVersion]
           ,[DetailRecordIndicator]
           ,[RecordLength]
           ,[ExpiryDate])
     VALUES
           ('ACS Fulfillment File Format New'
           ,'01'
           ,'D'
           ,700
           ,CAST('9999-12-31 23:59:59.99' as datetime)
		   )
GO


DECLARE @Schema_ID int


SELECT @Schema_ID = USPS_ACS_Schema_ID
FROM [USPS_ACS_Schemas]
WHERE FileVersion = '00'


INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CustomerID',2,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CreateDate',8,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalACSRecordCount',16,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalCOACount',25,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalNIXIECount',34,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','ShipmentNumber',43,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','Class',51,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','MediaType',52,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','FILLER',53,507)


INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','SequenceNumber',2,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','SixDigitMailerID',10,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',16,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','MailpieceIdentifier',17,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',26,7)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','MoveEffectiveDate',33,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','MoveType',39,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','DelivierabilityCode',40,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','PostalServiceSiteID',41,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','LastName',44,20)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FirstName-MiddleName-INITIALS',64,15)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','Prefix',79,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','Suffix',85,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','AddressTypeOld',91,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UbanizationNameOld',92,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PrimaryNumberOld',120,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PreDirectionalOld',130,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetNameOld',132,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetSuffixOld',160,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PostDirectionalOld',164,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UnitDesignatorOld',166,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','SecondaryNumberOld',170,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','CityOld',180,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StateOld',208,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','FiveDigitZipCodeOld',210,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','AddressTypeNew',215,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UbanizationNameNew',216,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PrimaryNumberNew',244,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PreDirectionalNew',254,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetNameNew',256,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StreetSuffixNew',284,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PostDirectionalNew',288,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','UnitDesignatorNew',290,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','SecondaryNumberNew',294,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','CityNew',304,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','StateNew',332,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','FiveDigitZipCodeNew',334,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','HYPHEN','Hypen',339,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','Plus4CodeNew',340,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','DPBCNew',344,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','LabelFormatNewAddress',347,66)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FeeNotification',413,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',414,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','PostageDue',415,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','PMB',419,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','NotificationType',427,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','IntelligentMailBarcode',428,31)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',459,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','NineDigitMailerID',460,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','NUMERIC','IMPackageBarcode',469,35)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'2','TEXT','FILLER',504,56)



SELECT @Schema_ID = USPS_ACS_Schema_ID
FROM [USPS_ACS_Schemas]
WHERE FileVersion = '01'

INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','FileVersion',2,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CustomerID',4,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','CreateDate',10,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','ShipmentNumber',18,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalACSRecordCount',28,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalCOACount',37,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TotalNIXIECount',46,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDRecordCount',55,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDACSFeeAmount',64,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDCOACount',75,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDCOAACSFeeAmount',84,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDNixieCount',95,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','TRDNixieACSFeeAmount',104,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDRecordCount',115,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDACSFeeAmount',124,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDCOACount',135,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDCOAACSFeeAmount',144,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDNixieCount',155,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','OCDNixieACSFeeAmount',164,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSRecordCount',175,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSACSFeeAmount',184,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSCOACount',195,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSCOAACSFeeAmount',204,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSNixieCount',215,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','FSNixieFeeAmount',224,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbRecordCount',235,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbACSFeeAmount',244,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbCOACount',255,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbCOAFeeAmount',264,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbNixieCount',275,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','NUMERIC','IMpbNixieFeeAmount',284,11)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','Filler',295,405)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'H','TEXT','EndMarker',700,1)

INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','RecordType',1,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FileVersion',2,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','SequenceNumber',4,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ParticipantID',12,9)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Sequence',21,16)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','MoveEffectiveDate',37,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','MoveType',45,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','DelivierabilityCode',46,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','PostalServiceSiteID',47,3)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','LastName',50,20)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FirstName-MiddleName-INITIALS',70,15)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Prefix',85,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Suffix',91,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','AddressTypeOld',97,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UbanizationNameOld',98,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PrimaryNumberOld',126,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PreDirectionalOld',136,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetNameOld',138,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetSuffixOld',166,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PostDirectionalOld',170,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UnitDesignatorOld',172,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','SecondaryNumberOld',176,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CityOld',186,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StateOld',214,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FiveDigitZipCodeOld',216,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','AddressTypeNew',221,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PRBNew',222,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UbanizationNameNew',230,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PrimaryNumberNew',258,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PreDirectionalNew',268,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetNameNew',270,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StreetSuffixNew',298,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','PostDirectionalNew',302,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','UnitDesignatorNew',304,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','SecondaryNumberNew',308,10)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CityNew',318,28)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','StateNew',346,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FiveDigitZipCodeNew',348,5)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','HYPHEN','Hypen',353,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','Plus4CodeNew',354,4)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','NewDeliveryPoint',358,2)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT ','NewAbbreviateCityName',360,13)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','NewAddressLabel',373,66)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','FeeNotification',439,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXTS','NotificationType',440,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','IntelligentMailBarcode(IMb)',441,31)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','IntelligentMailpackagebarcode(IMpb)',472,35)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','IDTag_UPU',507,16)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','HardcopytoElectronicFlag',523,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','TypeofACS(T_O_F_I)',524,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','FulfillmentDate',525,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ProcessingType(C_P_R_F)',533,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','CaptureType(I_C_F_Blank)',534,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','MadeAvailableDate',535,8)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','ShapeofMail(L_F_P)',543,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','MailActionCode(F_R_D_X_U)',544,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','COA_NixieFlag(C_N)',545,1)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode1',546,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee1',552,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode2',558,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee2',564,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode3',570,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee3',576,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode4',582,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee4',588,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode5',594,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee5',600,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCode6',606,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','NUMERIC','ProductCodeFee6',612,6)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','Filler',618,82)
INSERT INTO [dbo].[USPS_ACS_SchemaMapping]([USPS_ACS_Schema_ID],[RecordType],[DataType],[ColumnName],[ColumnStart],[ColumnWidth]) VALUES(@Schema_ID,'D','TEXT','EndMarker',700,1)

GO

