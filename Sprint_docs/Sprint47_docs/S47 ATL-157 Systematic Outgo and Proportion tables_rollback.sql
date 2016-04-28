/*
	S47 ATL-157 Implement OAS Systematic Sampling Algorithm
	As an OAS CAHPS vendor, we need to implement systematic sampling, so that we comply with mandatory protocols.
	
	ATL-242 Implement DB stored procedures branching logic between the StaticPlus and Systematic algos
	
*/
use qp_Prod
go
if exists (select * from sys.tables where name = 'SystematicSamplingTarget' and schema_id=1)
	drop table dbo.SystematicSamplingTarget
go
create table dbo.SystematicSamplingTarget
(	SystematicSamplingTarget_id int identity(1,1)
,	SampleQuarter char(6)
,	CCN varchar(20)
,	numLocations smallint
,	SamplingAlgorithmID int
,	RespRateType varchar(15)
,	numResponseRate int
,	AnnualTarget int
,	QuarterTarget int
,	MonthTarget int
,	SamplesetsPerMonth smallint
,	SamplesetTarget numeric(6,2)
,	OutgoNeededPerSampleset int
)

if exists (select * from sys.tables where name = 'SystematicSamplingProportion' and schema_id=1)
	drop table dbo.SystematicSamplingProportion
go
create table dbo.SystematicSamplingProportion
(	SystematicSamplingProportion_id int identity(1,1)
,	SampleQuarter char(6)
,	CCN varchar(20)
,	SampleUnit_id int
,	Sampleset_id int
,	EligibleCount int
,	EligibleProportion numeric(5,3)
,	OutgoNeeded int
)

if not exists (select * from SamplingAlgorithm where AlgorithmName='Systematic')
	insert into SamplingAlgorithm (AlgorithmName) values ('Systematic')

