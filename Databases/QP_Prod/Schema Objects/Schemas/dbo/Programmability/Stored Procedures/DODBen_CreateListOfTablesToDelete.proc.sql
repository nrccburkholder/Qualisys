create procedure DODBen_CreateListOfTablesToDelete
AS
create table #ColumnHierarchy(column_name varchar(42), hierarchyOrder int)
insert into #ColumnHierarchy values ('study_id', 1)
insert into #ColumnHierarchy values ('survey_id', 2)
insert into #ColumnHierarchy values ('sampleunit_id', 3)
insert into #ColumnHierarchy values ('dataset_id', 4)
insert into #ColumnHierarchy values ('sampleset_id', 5)
insert into #ColumnHierarchy values ('sampleplanworksheet_id', 6)
insert into #ColumnHierarchy values ('perioddef_id', 7)
insert into #ColumnHierarchy values ('CRITERIASTMT_id', 8)
insert into #ColumnHierarchy values ('table_id', 9)
insert into #ColumnHierarchy values ('questionform_id', 10)
insert into #ColumnHierarchy values ('sentmail_id', 11)
insert into #ColumnHierarchy values ('scheduledmailing_id', 12)
insert into #ColumnHierarchy values ('strlithocode', 13)
insert into #ColumnHierarchy values ('samplepop_Id', 14)
--insert into #ColumnHierarchy values ('enc_id', 15)
--insert into #ColumnHierarchy values ('pop_id', 16)

create table #TablesWithHierarchyColumns (table_name varchar(42), column_name varchar(42), hierarchyOrder int)

insert into #TablesWithHierarchyColumns (table_name, column_name, hierarchyOrder)
select c.table_name, c.column_name, ch.hierarchyOrder
from information_schema.columns c, information_schema.tables t, #ColumnHierarchy ch
where c.column_name=ch.column_name
	and t.table_schema='dbo'
	and t.table_type<>'VIEW'
	and t.table_catalog='QP_PROD'
	and c.table_catalog=t.table_catalog
	and c.table_schema=t.table_schema
	and c.table_name=t.table_name
	and t.table_name <>'DeleteKeysMasterTable'

/************* Table Constraint info ***********/
CREATE TABLE #ConstraintTables(PK_Table varchar(42), PK_Column varchar(42), FK_Table varchar(42), FK_Column varchar(42))

INSERT into #ConstraintTables
SELECT distinct
	PK.TABLE_NAME, 
	PT.COLUMN_NAME,
	FK.TABLE_NAME, 
	CU.COLUMN_NAME 
	--Constraint_Name = C.CONSTRAINT_NAME 
FROM 
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK 
		ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK 
		ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME 
	INNER JOIN 
	INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU 
		ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME 
	INNER JOIN 
	( 
		SELECT 
			i1.TABLE_NAME, i2.COLUMN_NAME 
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1 
			INNER JOIN 
			INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 
			ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME 
			WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY' 
	) PT 
	ON PT.TABLE_NAME = PK.TABLE_NAME 
WHERE
	--We only care if the PK table is in our list, because only then do we need to worry
	--about the order we delete tables in
	PK.Table_name in (select distinct table_name from #TablesWithHierarchyColumns)
ORDER BY 
	1,3

--We know need to find any tables that don't have one of our key columns, but are relational to a table that does have
--a key column.  We need to identify these because we will get errors if we delete the table with a key column before we
--delete the relational table
WHILE @@rowcount>0
BEGIN
	INSERT into #ConstraintTables
	SELECT distinct
		PK.TABLE_NAME, 
		PT.COLUMN_NAME,
		FK.TABLE_NAME, 
		CU.COLUMN_NAME
		--Constraint_Name = C.CONSTRAINT_NAME 
	FROM 
		INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
		INNER JOIN 
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK 
			ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME 
		INNER JOIN 
		INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK 
			ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME 
		INNER JOIN 
		INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU 
			ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME 
		INNER JOIN 
		( 
			SELECT 
				i1.TABLE_NAME, i2.COLUMN_NAME 
			FROM 
				INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1 
				INNER JOIN 
				INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 
				ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME 
				WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY' 
		) PT 
		ON PT.TABLE_NAME = PK.TABLE_NAME 
	WHERE
		--Follow the hierarchy to get all child tables
		PK.Table_name in (select distinct FK_Table from #ConstraintTables)
		--Don't get cases we've already grabbed
		AND Not Exists (select * from #ConstraintTables ct where pk.table_name=ct.PK_Table and fk.table_name=ct.FK_Table and PT.column_name=ct.PK_Column and cu.column_name=ct.fk_column)
	ORDER BY 
		1,3
END

/************* Table Index Info **************/

declare @empty varchar(1)
select @empty = ''

-- 35 is the length of the name field of the master.dbo.spt_values table
declare @IgnoreDuplicateKeys varchar(35),
    @Unique varchar(35),
    @IgnoreDuplicateRows varchar(35),
    @Clustered varchar(35),
    @Hypotethical varchar(35),
    @Statistics varchar(35),
    @PrimaryKey varchar(35),
    @UniqueKey varchar(35),
    @AutoCreate varchar(35),
    @StatsNoRecompute varchar(35)

select @IgnoreDuplicateKeys = name from master.dbo.spt_values 
    where type = 'I' and number = 1 --ignore duplicate keys
select @Unique = name from master.dbo.spt_values 
    where type = 'I' and number = 2 --unique
select @IgnoreDuplicateRows = name from master.dbo.spt_values 
    where type = 'I' and number = 4 --ignore duplicate rows
select @Clustered = name from master.dbo.spt_values 
    where type = 'I' and number = 16 --clustered
select @Hypotethical = name from master.dbo.spt_values 
    where type = 'I' and number = 32 --hypotethical
select @Statistics = name from master.dbo.spt_values 
    where type = 'I' and number = 64 --statistics
select @PrimaryKey = name from master.dbo.spt_values 
    where type = 'I' and number = 2048 --primary key
select @UniqueKey = name from master.dbo.spt_values 
    where type = 'I' and number = 4096 --unique key
select @AutoCreate = name from master.dbo.spt_values 
    where type = 'I' and number = 8388608 --auto create
select @StatsNoRecompute = name from master.dbo.spt_values 
    where type = 'I' and number = 16777216 --stats no recompute

select o.name as table_name,
  i.name as index_name,
  convert(varchar(210), --bits 16 off, 1, 2, 16777216 on
      case when (i.status & 16)<>0 then @Clustered else 'non'+@Clustered end
      + case when (i.status & 1)<>0 then ', '+@IgnoreDuplicateKeys else @empty end
      + case when (i.status & 2)<>0 then ', '+@Unique else @empty end
      + case when (i.status & 4)<>0 then ', '+@IgnoreDuplicateRows else @empty end
      + case when (i.status & 64)<>0 then ', '+@Statistics else
      case when (i.status & 32)<>0 then ', '+@Hypotethical else @empty end end
      + case when (i.status & 2048)<>0 then ', '+@PrimaryKey else @empty end
      + case when (i.status & 4096)<>0 then ', '+@UniqueKey else @empty end
      + case when (i.status & 8388608)<>0 then ', '+@AutoCreate else @empty end
      + case when (i.status & 16777216)<>0 then ', '+@StatsNoRecompute else @empty end) as indexdescription ,
	index_col(o.name,indid, 1) as indexcolumn1,
	index_col(o.name,indid, 2) as indexcolumn2,
	index_col(o.name,indid, 3) as indexcolumn3
into #indexes
from sysindexes i, sysobjects o, (select distinct table_name from #TablesWithHierarchyColumns) tbk 
where i.id = OBJECT_ID(tbk.table_name) 
	  and i.id = o.id 
      and indid > 0 and indid < 255 --all the clustered (=1), non clusterd (>1 and <251), and text or image (=255) 
      and o.type = 'U' --user table
      --ignore the indexes for the autostat
      and (i.status & 64) = 0 --index with duplicates
      and (i.status & 8388608) = 0 --auto created index
      and (i.status & 16777216)= 0 --stats no recompute
      order by o.name

create table #orderColumns(id int identity(1,1), table_name varchar(42), column_name varchar(42), hierarchyOrder int,
							indexExists bit default 0, CompositeIndex bit default 0, 
							systemTable bit default 0, ExistsinContraintBoundDelete bit default 0,
							constraintBound bit default 0, Exclude bit default 0)

insert into #orderColumns (table_name, column_name, hierarchyOrder,	indexExists, CompositeIndex)
select tbk.*,
		case 
			when tbk.column_name=indexcolumn1 then 1
			else 0
		end, 
		case 
			when indexcolumn2 is not null then 1
			else 0
		end
from #TablesWithHierarchyColumns tbk left join #indexes i
	on tbk.table_name=i.table_name
		and tbk.column_name=indexcolumn1 
order by 1,4 desc,5,3,2 

--update system tables field
update #orderColumns
set systemTable=1
where table_name in ('AcctOutgo','ActionPlan','APRollup','APUnit','APUnitLink','archive','AuditLog',
			'BDUS_MetaFieldLookup','BubbleLoc','BUBBLEPOS','BUBBLEPOS_d','BundlingCodes','BUSINESSRULE','capacity',
			'CODEQSTNS','CODESCLS','CODETXTBOX','commentautoexportlog','CommentErrors','COMMENTLINEPOS','CommentLoc',
			'COMMENTPOS','Comments','Comments_Extract','Comments_Extract_History','comments_for_extract',
			'CommentSkipSurveys','CommentStartDates','CommentSurveyCodeList','CRITERIACLAUSE','CRITERIAINLIST',
			'CRITERIASTMT','CUTOFF','DATA_SET','DATASETMEMBER','DispositionListSurvey','DispositionLog',
			'DTS_Builder_Load_History','DTSStudy','ExpectedReturns','ExpectedReturns_Vertical','Extract_Exceptions',
			'Extract_Web_QuestionForm','ExtractExclusion','FG_MailingWork','FG_PreMailingWork','FG_PreMailingWork_TP',
			'FGPopCode','FGPopCode_TP','FGPopCover','FGPopCover_TP','FGPopSection','FGPopSection_TP','FirstSurveyReturn',
			'FormGenError','FormGenLog','Generation_Rollbacks','GroupedPrint','HandEntry_Log','HCAHPSUpdateLog',
			'HOUSEHOLDRULE','MAILINGMETHODOLOGY','MAILINGSTEP','MAILINGSUMMARY','MetaLookup','MetaStructure',
			'METATABLE','NextMailingStep','NonMailGen_NotifyLog','NPSENTMAILING','NRCNorm_1999_4','NRCNorm_2000_1',
			'NRCNorm_2000_2','NRCNorm_2000_3','NRCNorm_2000_4','NRCNorm_2001_1','NRCNorm_2001_2','NRCNorm_2001_3',
			'NRCNorm_2001_4','NRCNorm_2002_1','NRCNorm_2002_2','NRCNorm_2002_3','NRCNorm_2002_4','NRCNorm_2003_1',
			'NRCNorm_2003_2','NRCNorm_2003_3','NRCNorm_2003_4','NRCNorm_2004_1','NRCNorm_2004_2','NRCNorm_2004_3',
			'NRCNorm_2004_4','NRCNorm_2005_1','NRCNorm_2005_2','NRCNorm_2005_3','NRCNorm_2005_4','NRCNorm_2006_1',
			'NRCNorm_2006_2','NRCNorm_2006_3','PCL_Cover','PCL_Cover_TP','PCL_LOGO','PCL_Logo_TP','PCL_PCL','PCL_PCL_TP',
			'PCL_QSTNS','PCL_Qstns_TP','PCL_SCLS','PCL_Scls_TP','PCL_SKIP','PCL_Skip_TP','PCL_TEXTBOX','PCL_Textbox_TP',
			'PCLGen_Wrap_test','PCLGENLOG','PCLNeeded','PCLNeeded_TP','PCLOUTPUT','PCLOUTPUT2','PCLQuestionForm',
			'PCLResults','Period','PeriodDates','PeriodDef','Problem_Comments_Extract','QDEComments','QDEForm',
			'QUALPRO_SYSLOGS','QUESTIONFORM','QuestionForm_Extract','QuestionForm_Extract_History','QUESTIONRESULT',
			'QuestionResult2','RECURRINGENCOUNTER','REPORTINGHIERARCHY','RespRateCount','ReturnRates',
			'Rollback_BubbleItemPos','Rollback_BubbleLoc','Rollback_BubblePos','Rollback_CommentLinePos','Rollback_CommentLoc',
			'Rollback_CommentPos','Rollback_FormGenError','Rollback_HandWrittenLoc','Rollback_HandWrittenPos',
			'Rollback_NPSentMailing','Rollback_PCLGenLog','Rollback_PCLNeeded','Rollback_PCLOutput','Rollback_PCLOutput2',
			'Rollback_PCLQuestionForm','Rollback_PCLResults','Rollback_Questionform','Rollback_QuestionForm_Extract',
			'Rollback_ScheduledMailing','Rollback_SentMailing','rollbacks','SAMPLEDATASET','SAMPLEPLAN',
			'SamplePlanWorksheet','SAMPLEPOP','SAMPLESET','SAMPLESETUNITTARGET','sampleunikeyscount','SAMPLEUNIT',
			'SampleUnitLinkage','SAMPLEUNITSECTION','SampleUnitService','SampleUnitTree','SAMPLEUNITTREEINDEX',
			'SCANEXPORTERROR','SCANIMPORTERROR','ScanningResets','Scheduled_TP','SCHEDULEDMAILING','Sel_Cover',
			'SEL_LOGO','Sel_Logo_1650','SEL_PCL','SEL_QSTNS','SEL_SCLS','SEL_SKIP','SEL_TEXTBOX','SELECTEDSAMPLE',
			'SENTMAILING','SetExpiration_Queue','SkipIdentifier','SPWDQCounts','STUDY','STUDY_EMPLOYEE','STUDYCOMPARISON',
			'STUDYDELIVERYDATE','STUDYREPORTTYPE','SURVEY_CONTACT','SURVEY_DEF','Survey_SurveyTypeDef','SurveyLanguage',
			'surveysize','surveystatus','SurveyValidationResults','TAGEXCEPTION','TAGFIELD','targetinfo','teamstaus_resprate',
			'TeamStatus_SampleInfo','teamstatus_sampling','teamstatus_scheduledwork','teamstatus_targetpercents','TestPrint_Log',
			'TOCL','UNIKEYS','UnikeysSummary','UNITDQ','UpdateBackGroundInfo_Log','WebPrefLog','WebSurveyFields',
			'WebSurveyGUID','WebSurveyQueue','WebSurveyValues') 

--update Exists in Archive Script field
update #orderColumns
set ExistsinContraintBoundDelete=1
where table_name in ('DATASETMEMBER','QUESTIONFORM','RECURRINGENCOUNTER','SAMPLEPOP','SCHEDULEDMAILING',
'SELECTEDSAMPLE','TOCL','BubbleLoc','BUSINESSRULE','CommentLoc','CRITERIACLAUSE','CRITERIASTMT',
'CUTOFF','DATA_SET','DispositionListSurvey','HOUSEHOLDRULE','MAILINGMETHODOLOGY','MAILINGSTEP','METATABLE',
'PCLGENLOG','PCLResults','Period','QDEComments','QDEForm','REPORTINGHIERARCHY','SAMPLEDATASET','SAMPLEPLAN',
'SAMPLESET','SAMPLEUNIT','SAMPLEUNITSECTION','STUDY','STUDY_EMPLOYEE','STUDYCOMPARISON','STUDYDELIVERYDATE',
'STUDYREPORTTYPE','SURVEY_DEF','Survey_SurveyTypeDef','TAGEXCEPTION','TAGFIELD','QUESTIONRESULT','QuestionResult2',
'SENTMAILING','UNITDQ','AcctOutgo','ActionPlan') 

--update the exclude field
update #orderColumns
set Exclude=1
where table_name in ('capacity') 

--update the ConstraintBound field
update #orderColumns
set ConstraintBound=1
where table_name in (
			select distinct pk_table
			from #ConstraintTables
			union 
			select distinct fk_table
			from #ConstraintTables)

--Join Columns for Each Table
select oc.*
from #orderColumns oc,
	(select table_name, min(id) as id
		from #orderColumns
		group by table_name) m
where oc.id=m.id
order by 2

--Tables With Foreign Key Constraints
--Will need to manually clean up the list because references involving multiple columns 
--have a cartisian join of all referencial columns.  This is most common when the key is
--using table_id and field_id.  You will see rows in the table saying that the table_id is the PK
--and field_id is the FK.  Just delete these.
--select *
--from #ConstraintTables
--order by 1,3

drop table #TablesWithHierarchyColumns
drop table #ColumnHierarchy
drop table #indexes
drop table #orderColumns
drop table #ConstraintTables


