/*
	S47 ATL-157 Implement OAS Systematic Sampling Algorithm
	As an OAS CAHPS vendor, we need to implement systematic sampling, so that we comply with mandatory protocols.
	
	ATL-242 Implement DB stored procedures branching logic between the StaticPlus and Systematic algos
	
*/
use qp_Prod
go
if exists (select * from sys.tables where name = 'SystematicSamplingTarget' and schema_id=1)
	drop table dbo.SystematicSamplingTarget

if exists (select * from sys.tables where name = 'SystematicSamplingProportion' and schema_id=1)
	drop table dbo.SystematicSamplingProportion

if exists (select * from SamplingAlgorithm where AlgorithmName='Systematic')
begin
	delete from SamplingAlgorithm where AlgorithmName = 'Systematic'
	declare @maxID int
	select @maxID=max(SamplingAlgorithmID) from SamplingAlgorithm 
	DBCC CHECKIDENT ('SamplingAlgorithm', RESEED, @maxID);
end
