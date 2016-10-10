
select *
from ETL.DataSourceKey dsk
where dsk.DataSourceKeyID in (
189270843

)
and dsk.EntityTypeID = 8



select *
from ETL.DataSourceKey
where DataSourceKeyID = 189270852

select *
from LOAD_TABLES.SamplePopulation
where SampleSetID = 189271612


select *
from LOAD_TABLES.sampleset
where ID = 1534682

select *
from dbo.SampleSet
where SampleSetID = 189270843



select *
from Gator.QP_prod.dbo.Samplepop
where samplepop_id in (
123061552,
123061547
)



select *
from LOAD_TABLES.SamplePopulation
where id in (
123061552,
123061547
)


select * from LOAD_TABLES.QuestionForm

select *
from dbo.samplepopulation
where SamplePopulationid in(
189271890,
189271891
)


select *
from ETL.DataSourceKey dsk
where Created > '2015-10-03 22:54:36.000'