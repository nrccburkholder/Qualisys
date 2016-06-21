select max(datafile_id) from qloader.qp_load.s2934.population_load 

select * from qloader.qp_load.s2934.population_load with (nolock) where datafile_id = 402623 and AddrStat is null

select count(*) from qloader.qp_load.s2934.population_load with (nolock) where datafile_id = 402623 

select * from qloader.qp_load.s2934.population_load with (nolock) where datafile_id = 402625 

-------------
-------------

select FIPS_ST,st,zip5,* from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1987 and FIPS_ST is null

select count(*) /*FIPS_ST,st,zip5,*/ from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1987 and FIPS_ST is not null

--dbo.AC_UpdateRecord @SQLTableName='s4701.POPULATION_Load', @UpdateFieldList='Addr = ''3073 DANNY DR'', City = ''LOS ANGELES'', ST = ''CA'', ZIP5 = NULL, AddrStat = ''AE02'', AddrErr = ''NC'', Zip4 = ''9006'', Del_Pt = NULL, Addr2 = NULL, Province = NULL, Postal_Code = NULL, FIPS_ST = UL, FIPS_CNTY = 0, TimeZone = NULL', @KeyFieldName='pop_id', @DBKey=11546

select FIPS_ST,st,zip5,* from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1988 and FIPS_ST is null

select count(*) /*FIPS_ST,st,zip5,*/ from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1988 and FIPS_ST is not null

select FIPS_ST,st,zip5,* from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1989 and FIPS_ST is null

select count(*) /*FIPS_ST,st,zip5,*/ from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1989 and FIPS_ST is not null

select distinct datafile_id from qloader.qp_load.s4701.population_load

select * from qualpro_params where strparam_grp = 'AddressCleaner'

select FIPS_ST,st,zip5,* from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1995 and FIPS_ST is null

select count(*) /*FIPS_ST,st,zip5,*/ from qloader.qp_load.s4701.population_load with (nolock) where datafile_id = 1995 and FIPS_ST is not null
-----------------------------
select FIPS_ST,st,zip5,* from qloader.qp_load.s5305.population_load with (nolock) where datafile_id = 402617 and AddrStat is null

select FIPS_ST,st,zip5,* from qloader.qp_load.s5305.population_load with (nolock) where datafile_id = 402617 and ADDR like '5801%PU%L%K%I%'
order by addr

select count(*) /*FIPS_ST,st,zip5,*/ from qloader.qp_load.s5305.population_load with (nolock) where datafile_id = 402617 and FIPS_ST is not null

select * from qualpro_params where strparam_nm in ('WebServiceProxyServer','AddressWebServiceURL')
/*
https://addresscheck.melissadata.net/v2/SOAP/Service.svc
isa01
*/

select * from qualpro_params where strparam_value like ('%qloader%')

select dbo.SurveyProperty('FacilitiesArePracticeSites',4,null)

select * from qualpro_params where strparam_nm like '%conc%'