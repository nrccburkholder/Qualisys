
select *
FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.sampleset_id
			WHERE dsk.DataSourceID = 1
				AND dsk.EntityTypeID = 8 -- SampleSet  
				AND lt.DataFileID = 7112

select *
FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.id
			INNER JOIN SamplePopulation sp ON dsk.DataSourceKeyID = sp.SamplePopulationID
			WHERE dsk.DataSourceID = 1
				AND dsk.EntityTypeID = 7
				AND lt.DataFileID = 7112
--begin tran
--INSERT dbo.SamplePopulation (
--				SamplePopulationID
--				,SampleSetID
--				,DispositionID
--				,CahpsDispositionID
--				,FirstName
--				,LastName
--				,City
--				,Province
--				,PostalCode
--				,IsMale
--				,Age
--				,DrNPI
--				,ClinicNPI
--				,LanguageID
--				,AdmitDate
--				,ServiceDate
--				,DischargeDate
--				,DrNPI_Initial
--				,ClinicNPI_Initial
--				,SupplementalQuestionCount --s18 US17
--				,[NumberOfMailAttempts]  -- S28 US31
--				,[NumberOfPhoneAttempts] -- S28 US31  
--				)
SELECT DISTINCT lt.SamplePopulationID
				,lt.SampleSetID
				,0
				,0
				,lt.FirstName
				,lt.LastName
				,lt.City
				,lt.Province
				,lt.PostalCode
				,lt.IsMale
				,lt.Age
				,CASE 
					WHEN PATINDEX('%[^0-9]%', lt.DrNPI) = 0
						THEN lt.DrNPI
					ELSE NULL
					END
				,CASE 
					WHEN PATINDEX('%[^0-9]%', lt.ClinicNPI) = 0
						THEN lt.ClinicNPI
					ELSE NULL
					END
				,lt.LanguageID
				,CAST(lt.AdmitDate AS DATE)
				,CAST(lt.ServiceDate AS DATE)
				,CAST(lt.DischargeDate AS DATE)
				,lt.DrNPI
				,lt.ClinicNPI
				,lt.SupplementalQuestionCount --s18 US17
				,lt.NumberOfMailAttempts -- S28 US31
				,lt.NumberOfPhoneAttempts -- S28 US31
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			LEFT JOIN LOAD_TABLES.SamplePopulationError lte WITH (NOLOCK) ON lte.DataFileID = 7112
				AND lt.id = lte.id
			WHERE lt.DataFileID = 7112
				AND lt.isInsert <> 0
				AND lt.isDelete = 0
				AND lte.id IS NULL

-- rollback tran

select *
from ETL.DataSourceKey
where DataSourceKeyID in (
189271861
,189271862
,189271863
,189271864
,189271865
,189271866
,189271867
,189271868
,189271869
,189271870
,189271871
,189271872
,189271873
,189271874
,189271875
,189271876
,189271877
,189271878
,189271879
)
and EntityTypeID = 7

select *
from SamplePopulation sp
where samplepopulationid in (
189271861
,189271862
,189271863
,189271864
,189271865
,189271866
,189271867
,189271868
,189271869
,189271870
,189271871
,189271872
,189271873
,189271874
,189271875
,189271876
,189271877
,189271878
,189271879
)


select *
from SampleSet
where SampleSetID = 189270854


select *
from ETL.DataSourceKey
where DataSourceKeyID in (
189270854
)
and EntityTypeID = 8
