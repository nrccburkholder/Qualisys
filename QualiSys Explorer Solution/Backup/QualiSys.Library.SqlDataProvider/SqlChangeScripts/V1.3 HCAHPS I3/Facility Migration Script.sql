--Create copies of the sufacility table and sampleunit table before commencing
if object_id('tempdb..#sufacility') is not null Drop Table #sufacility
select *
into #sufacility
from sufacility

if object_id('tempdb..#sampleunit') is not null Drop Table #sampleunit
select *
into #sampleunit
from sampleunit

select *
from #sampleunit
where bithcahps=1


--1 Copy Client_ids from facility table to FacilityClient table
--	NOT NEEDED Already part of upgrade script for Qualisys

--2 Get spreadsheet from Sally with Medicare numbers and names. We will wipe out what we currently have.
--  NOTE: The insert statements should be replaced with the most recent available list from Sally
if object_id('tempdb..#providers') is not null Drop Table #providers
create table #providers (MedicareNumber varchar(20), Medicarename varchar(256))

insert into #providers values ('330264','ST. LUKES CORNWALL - NWBRGH & CRNWLL CAMPUSES')
insert into #providers values ('180115','ROCKCASTLE HOSPITAL / RESP CARE CENTER, INC.')
insert into #providers values ('360130','THE HOS FOR ORTHOPAEDIC AND SPECIALTY SERV.')
insert into #providers values ('330279','CATHOLIC HEALTH SYSTEM / MERCY HOSP BUFFALO')
insert into #providers values ('150012','SAINT JOSEPH REGIONAL MED. CENTER - S. BEND')
insert into #providers values ('150029','SAINT JOSEPH REGIONAL MED. CENTER - MISHAWAKA')
insert into #providers values ('150076','SAINT JOSEPH REGIONAL MED. CENTER - PLYMOUTH')
insert into #providers values ('450137','BAYLOR ALL SAINTS MED. CENTER AT FORT WORTH')
insert into #providers values ('030010','CARONDELET ST MARYS HOSPITAL & HEALTH CENTER')
insert into #providers values ('330091','CATHOLIC HEALTH SYSTEM @ ST. JOSEPH HOSPITAL')
insert into #providers values ('050145','COMMUNITY HOSPITAL OF THE MONTEREY PENINSULA')
insert into #providers values ('450563','BAYLOR REGIONAL MEDICAL CENTER AT GRAPEVINE')
insert into #providers values ('330078','CATHOLIC HEALTH SYSTEM @ SISTERS OF CHARITY')
insert into #providers values ('310061','LOURDES MEDICAL CENTER OF BURLINGTON COUNTY')
insert into #providers values ('360203','SOUTHEASTERN OHIO REGIONAL MEDICAL CENTER')
insert into #providers values ('430095','AVERA HEART HOSPITAL OF SOUTH DAKOTA LLC')
insert into #providers values ('180048','EPHRAIM MCDOWELL REGIONAL MEDICAL CENTER')
insert into #providers values ('361324','MEDCENTRAL HEALTH SYSTEM SHELBY HOSPITAL')
insert into #providers values ('450890','BAYLOR REGIONAL MEDICAL CENTER AT PLANO')
insert into #providers values ('330233','BROOKDALE UNIVERSITY AND MEDICAL CENTER')
insert into #providers values ('440030','MORRISTOWN HAMBLEN HOSPITAL ASSOCIATION')
insert into #providers values ('520019','SACRED HEART - ST MARY''S HOSPITALS, INC')
insert into #providers values ('110082','SAINT JOSEPHS HOSPITAL OF ATLANTA, INC.')
insert into #providers values ('490057','SENTARA VIRGINIA BEACH GENERAL HOSPITAL')
insert into #providers values ('490066','SENTARA WILLIAMSBURG COMMUNITY HOSPITAL')
insert into #providers values ('330102','CATHOLIC HEALTH SYSTEM @ KENMORE MERCY')
insert into #providers values ('440049','METHODIST HEALTHCARE MEMPHIS HOSPITALS')
insert into #providers values ('230069','SAINT JOSEPH MERCY LIVINGSTON HOSPITAL')
insert into #providers values ('050301','UKIAH VALLEY MEDICAL CENTER/HOSPITAL D')
insert into #providers values ('151306','BLOOMINGTON HOSPITAL OF ORANGE COUNTY')
insert into #providers values ('030040','CARONDELET HOLY CROSS HOSPITAL,  INC.')
insert into #providers values ('150056','CLARIAN HEALTH PARTNERS, INCORPORATED')
insert into #providers values ('440168','METHODIST HEALTHCARE FAYETTE HOSPITAL')
insert into #providers values ('330065','NIAGARA FALLS MEMORIAL MEDICAL CENTER')
insert into #providers values ('260017','PHELPS COUNTY REGIONAL MEDICAL CENTER')
insert into #providers values ('050342','PIONEERS MEMORIAL HEALTHCARE DISTRICT')
insert into #providers values ('370019','GREAT PLAINS REGIONAL MEDICAL CENTER')
insert into #providers values ('050169','PRESBYTERIAN INTERCOMMUNITY HOSPITAL')
insert into #providers values ('130007','ST ALPHONSUS REGIONAL MEDICAL CENTER')
insert into #providers values ('230077','ST MARY''S OF MICHIGAN MEDICAL CENTER')
insert into #providers values ('450372','BAYLOR MEDICAL CENTER AT WAXAHACHIE')
insert into #providers values ('140075','MICHAEL REESE HOSPITAL & MED CENTER')
insert into #providers values ('520063','SYNERGY HEALTH ST JOSEPH''S HOSPITAL')
insert into #providers values ('450851','BAYLOR HEART AND VASCULAR HOSPITAL')
insert into #providers values ('230212','SAINT JOSEPH MERCY SALINE HOSPITAL')
insert into #providers values ('020026','ALASKA NATIVE MEDICAL CENTER, PHS')
insert into #providers values ('050739','CENTINELA HOSPITAL MEDICAL CENTER')
insert into #providers values ('050492','COMMUNITY MEDICAL CENTER - CLOVIS')
insert into #providers values ('050060','COMMUNITY REGIONAL MEDICAL CENTER')
insert into #providers values ('050045','EL CENTRO REGIONAL MEDICAL CENTER')
insert into #providers values ('230037','HILLSDALE COMMUNITY HEALTH CENTER')
insert into #providers values ('450865','SETON SOUTHWEST HEALTHCARE CENTER')
insert into #providers values ('520202','ST CLARE''S HOSPITAL OF WESTON INC')
insert into #providers values ('450011','ST. JOSEPH REGIONAL HEALTH CENTER')
insert into #providers values ('500025','SWEDISH MEDICAL CENTER/PROVIDENCE')
insert into #providers values ('381317','TILLAMOOK COUNTY GENERAL HOSPITAL')
insert into #providers values ('450280','BAYLOR MEDICAL CENTER AT GARLAND')
insert into #providers values ('450021','BAYLOR UNIVERSITY MEDICAL CENTER')
insert into #providers values ('050741','DANIEL FREEMAN MEMORIAL HOSPITAL')
insert into #providers values ('361328','DEFIANCE REGIONAL MEDICAL CENTER')
insert into #providers values ('050121','HANFORD COMMUNITY MEDICAL CENTER')
insert into #providers values ('450236','HOPKINS COUNTY MEMORIAL HOSPITAL')
insert into #providers values ('100084','LEESBURG REGIONAL MEDICAL CENTER')
insert into #providers values ('500051','OVERLAKE HOSPITAL MEDICAL CENTER')
insert into #providers values ('140189','SARAH BUSH LINCOLN HEALTH CENTER')
insert into #providers values ('050351','TORRANCE MEMORIAL MEDICAL CENTER')
insert into #providers values ('450187','TRINITY COMMUNITY MEDICAL CENTER')
insert into #providers values ('180080','BAPTIST REGIONAL MEDICAL CENTER')
insert into #providers values ('450079','BAYLOR MEDICAL CENTER AT IRVING')
insert into #providers values ('050196','CENTRAL VALLEY GENERAL HOSPITAL')
insert into #providers values ('450289','HARRIS COUNTY HOSPITAL DISTRICT')
insert into #providers values ('240063','HEALTHEAST ST JOSEPH''S HOSPITAL')
insert into #providers values ('360064','HMHP ST ELIZABETH HEALTH CENTER')
insert into #providers values ('330014','JAMAICA HOSPITAL MEDICAL CENTER')
insert into #providers values ('380017','LEGACY GOOD SAMARITAN HOSPITAL ')
insert into #providers values ('250009','MAGNOLIA REGIONAL HEALTH CENTER')
insert into #providers values ('230004','MERCY GEN HLTH PARTNERS-SHERMAN')
insert into #providers values ('160083','MERCY MEDICAL CENTER-DES MOINES')
insert into #providers values ('160064','MERCY MEDICAL CENTER-NORTH IOWA')
insert into #providers values ('160153','MERCY MEDICAL CENTER-SIOUX CITY')
insert into #providers values ('120028','NORTH HAWAII COMMUNITY HOSPITAL')
insert into #providers values ('030011','CARONDELET ST JOSEPHS HOSPITAL')
insert into #providers values ('050393','DOWNEY REGIONAL MEDICAL CENTER')
insert into #providers values ('050057','KAWEAH DELTA DISTRICT HOSPITAL')
insert into #providers values ('330126','ORANGE REGIONAL MEDICAL CENTER')
insert into #providers values ('050228','SAN FRANCISCO GENERAL HOSPITAL')
insert into #providers values ('050455','SAN JOAQUIN COMMUNITY HOSPITAL')
insert into #providers values ('050335','SONORA REGIONAL MEDICAL CENTER')
insert into #providers values ('120027','ST FRANCIS MEDICAL CENTER-WEST')
insert into #providers values ('100290','VILLAGES REGIONAL HOSPITAL THE')
insert into #providers values ('520152','DOOR COUNTY MEMORIAL HOSPITAL')
insert into #providers values ('240210','HEALTHEAST ST JOHN''S HOSPITAL')
insert into #providers values ('240213','HEALTHEAST WOODWINDS HOSPITAL')
insert into #providers values ('380089','LEGACY MERIDIAN PARK HOSPITAL')
insert into #providers values ('380025','LEGACY MT HOOD MEDICAL CENTER')
insert into #providers values ('280129','NEBRASKA ORTHOPAEDIC HOSPITAL')
insert into #providers values ('450042','PROVIDENCE HEALTHCARE NETWORK')
insert into #providers values ('490005','WINCHESTER MEDICAL CENTER INC')
insert into #providers values ('050122','DAMERON HOSPITAL ASSOCIATION')
insert into #providers values ('330088','EASTERN LONG ISLAND HOSPITAL')
insert into #providers values ('521339','GOOD SAMARITAN HEALTH CENTER')
insert into #providers values ('320083','HEART HOSPITAL OF NEW MEXICO')
insert into #providers values ('360161','HMHP ST JOSEPH HEALTH CENTER')
insert into #providers values ('120002','MAUI MEMORIAL MEDICAL CENTER')
insert into #providers values ('390028','MERCY HOSPITAL OF PITTSBURGH')
insert into #providers values ('160069','MERCY MEDICAL CENTER-DUBUQUE')
insert into #providers values ('390198','MILLCREEK COMMUNITY HOSPITAL')
insert into #providers values ('531310','POWELL VALLEY HOSPITAL - CAH')
insert into #providers values ('451371','SETON EDGAR B DAVIS HOSPITAL')
insert into #providers values ('491305','SHENANDOAH MEMORIAL HOSPITAL')
insert into #providers values ('360012','ST ANNS HOSPITAL OF COLUMBUS')
insert into #providers values ('110006','ST MARY''S HOSPITAL OF ATHENS')
insert into #providers values ('450193','ST. LUKES EPISCOPAL HOSPITAL')
insert into #providers values ('500049','WALLA WALLA GENERAL HOSPITAL')
insert into #providers values ('360259','BAY PARK COMMUNITY HOSPITAL')
insert into #providers values ('050625','CEDARS-SINAI MEDICAL CENTER')
insert into #providers values ('150158','CLARIAN WEST MEDICAL CENTER')
insert into #providers values ('360145','EMH REGIONAL MEDICAL CENTER')
insert into #providers values ('361318','FOSTORIA COMMUNITY HOSPITAL')
insert into #providers values ('361333','FULTON COUNTY HEALTH CENTER')
insert into #providers values ('240187','HUTCHINSON AREA HEALTH CARE')
insert into #providers values ('110132','MEMORIAL HOSPITAL AND MANOR')
insert into #providers values ('110008','NORTHSIDE HOSPITAL CHEROKEE')
insert into #providers values ('140206','NORWEGIAN-AMERICAN HOSPITAL')
insert into #providers values ('100006','ORLANDO REGIONAL HEALTHCARE')
insert into #providers values ('260110','SOUTHEAST MISSOURI HOSPITAL')
insert into #providers values ('241335','ST ELIZABETH MEDICAL CENTER')
insert into #providers values ('280013','THE NEBRASKA MEDICAL CENTER')
insert into #providers values ('360141','WESTERN RESERVE CARE SYSTEM')
insert into #providers values ('050724','BAKERSFIELD HEART HOSPITAL')
insert into #providers values ('180138','BAPTIST HOSPITAL NORTHEAST')
insert into #providers values ('230075','BATTLE CREEK HEALTH SYSTEM')
insert into #providers values ('100002','BETHESDA MEMORIAL HOSPITAL')
insert into #providers values ('330219','ERIE COUNTY MEDICAL CENTER')
insert into #providers values ('361309','HENRY COUNTY HOSPITAL, INC')
insert into #providers values ('120011','KAISER FOUNDATION HOSPITAL')
insert into #providers values ('240066','LAKEVIEW MEMORIAL HOSPITAL')
insert into #providers values ('050110','LOMPOC HEALTHCARE DISTRICT')
insert into #providers values ('230121','MEMORIAL HEALTHCARE CENTER')
insert into #providers values ('230031','MERCY HOSPITAL- PORT HURON')
insert into #providers values ('240001','NORTH MEMORIAL HEALTH CARE')
insert into #providers values ('110005','NORTHSIDE HOSPITAL FORSYTH')
insert into #providers values ('050093','SAINT AGNES MEDICAL CENTER')
insert into #providers values ('330006','ST. JOSEPHS MEDICAL CENTER')
insert into #providers values ('360055','TRUMBULL MEMORIAL HOSPITAL')
insert into #providers values ('070024','WILLIAM W. BACKUS HOSPITAL')
insert into #providers values ('450615','ATLANTA MEMORIAL HOSPITAL')
insert into #providers values ('210061','ATLANTIC GENERAL HOSPITAL')
insert into #providers values ('210039','CALVERT MEMORIAL HOSPITAL')
insert into #providers values ('231334','HERRICK MEMORIAL HOSPITAL')
insert into #providers values ('050526','HUNTINGTON BEACH HOSPITAL')
insert into #providers values ('160047','JENNIE EDMUNDSON HOSPITAL')
insert into #providers values ('390095','MARIAN COMMUNITY HOSPITAL')
insert into #providers values ('390156','MERCY FITZGERALD HOSPITAL')
insert into #providers values ('490093','SENTARA CAREPLEX HOSPITAL')
insert into #providers values ('490007','SENTARA NORFOLK GENL HOSP')
insert into #providers values ('450867','SETON  NORTHWEST HOSPITAL')
insert into #providers values ('120010','ST FRANCIS MEDICAL CENTER')
insert into #providers values ('310021','ST FRANCIS MEDICAL CENTER')
insert into #providers values ('050283','VALLEYCARE MEDICAL CENTER')
insert into #providers values ('380060','ADVENTIST MEDICAL CENTER')
insert into #providers values ('050352','BARTON MEMORIAL HOSPITAL')
insert into #providers values ('420011','CANNON MEMORIAL HOSPITAL')
insert into #providers values ('180103','CENTRAL BAPTIST HOSPITAL')
insert into #providers values ('230197','GENESYS REGIONAL MED CTR')
insert into #providers values ('450824','HEART HOSPITAL OF AUSTIN')
insert into #providers values ('380007','LEGACY EMANUEL HOSPITAL ')
insert into #providers values ('190250','LOUISIANA HEART HOSPITAL')
insert into #providers values ('360118','MEDCENTRAL HEALTH SYSTEM')
insert into #providers values ('050024','PARADISE VALLEY HOSPITAL')
insert into #providers values ('510012','PLEASANT VALLEY HOSPITAL')
insert into #providers values ('240056','RIDGEVIEW MEDICAL CENTER')
insert into #providers values ('230059','SAINT MARY''S HEALTH CARE')
insert into #providers values ('050470','SELMA COMMUNITY HOSPITAL')
insert into #providers values ('490119','SENTARA BAYSIDE HOSPITAL')
insert into #providers values ('230156','ST JOSEPH MERCY HOSPITAL')
insert into #providers values ('360066','ST RITA''S MEDICAL CENTER')
insert into #providers values ('330151','ST. JAMES MERCY HOSPITAL')
insert into #providers values ('450213','UNIVERSITY HEALTH SYSTEM')
insert into #providers values ('180104','WESTERN BAPTIST HOSPITAL')
insert into #providers values ('040134','ARKANSAS HEART HOSPITAL')
insert into #providers values ('280003','BRYANLGH MEDICAL CENTER')
insert into #providers values ('050471','GOOD SAMARITAN HOSPITAL')
insert into #providers values ('070001','HOSPITAL OF ST. RAPHAEL')
insert into #providers values ('120019','KONA COMMUNITY HOSPITAL')
insert into #providers values ('390237','MERCY HOSPITAL SCRANTON')
insert into #providers values ('390116','MERCY SUBURBAN HOSPITAL')
insert into #providers values ('350011','MERITCARE HEALTH SYSTEM')
insert into #providers values ('230029','ST JOSEPH MERCY OAKLAND')
insert into #providers values ('050128','TRI-CITY MEDICAL CENTER')
insert into #providers values ('030102','ARIZONA HEART HOSPITAL')
insert into #providers values ('340072','ASHE MEMORIAL HOSPITAL')
insert into #providers values ('260064','AUDRAIN MEDICAL CENTER')
insert into #providers values ('490018','AUGUSTA MEDICAL CENTER')
insert into #providers values ('521317','CALUMET MEDICAL CENTER')
insert into #providers values ('050225','FEATHER RIVER HOSPITAL')
insert into #providers values ('521325','FLAMBEAU HOSPITAL, INC')
insert into #providers values ('100017','HALIFAX MEDICAL CENTER')
insert into #providers values ('120007','KUAKINI MEDICAL CENTER')
insert into #providers values ('050015','NORTHERN INYO HOSPITAL')
insert into #providers values ('520095','SAUK PRAIRIE MEM HSPTL')
insert into #providers values ('490046','SENTARA LEIGH HOSPITAL')
insert into #providers values ('490044','SENTARA OBICI HOSPITAL')
insert into #providers values ('390258','ST MARY MEDICAL CENTER')
insert into #providers values ('230002','ST MARY MERCY HOSPITAL')
insert into #providers values ('500027','SWEDISH MEDICAL CENTER')
insert into #providers values ('180130','BAPTIST HOSPITAL EAST')
insert into #providers values ('450124','BRACKENRIDGE HOSPITAL')
insert into #providers values ('120006','CASTLE MEDICAL CENTER')
insert into #providers values ('360253','DAYTON HEART HOSPITAL')
insert into #providers values ('521300','EAGLE RIVER MEM HSPTL')
insert into #providers values ('050732','FRESNO HEART HOSPITAL')
insert into #providers values ('330086','MOUNT VERNON HOSPITAL')
insert into #providers values ('520009','ST ELIZABETH HOSPITAL')
insert into #providers values ('230047','ST JOSEPHS HEALTHCARE')
insert into #providers values ('520002','ST MICHAEL''S HOSPITAL')
insert into #providers values ('330399','ST. BARNABAS HOSPITAL')
insert into #providers values ('450878','TEXSAN HEART HOSPITAL')
insert into #providers values ('360211','TRINITY HEALTH SYSTEM')
insert into #providers values ('030100','TUCSON HEART HOSPITAL')
insert into #providers values ('330224','BENEDICTINE HOSPITAL')
insert into #providers values ('230005','BIXBY MEDICAL CENTER')
insert into #providers values ('050039','ENLOE MEDICAL CENTER')
insert into #providers values ('500124','EVERGREEN HEALTHCARE')
insert into #providers values ('521345','HOLY FAMILY HOSPITAL')
insert into #providers values ('520107','HOLY FAMILY MEMORIAL')
insert into #providers values ('520091','HOWARD YOUNG MED CTR')
insert into #providers values ('220066','MERCY MEDICAL CENTER')
insert into #providers values ('520048','MERCY MEDICAL CENTER')
insert into #providers values ('451365','SETON HIGHLAND LAKES')
insert into #providers values ('450056','SETON MEDICAL CENTER')
insert into #providers values ('080003','ST FRANCIS HOSPITAL ')
insert into #providers values ('520037','ST JOSEPH''S HOSPITAL')
insert into #providers values ('330067','ST. FRANCIS HOSPITAL')
insert into #providers values ('490033','WARREN MEMORIAL HOSP')
insert into #providers values ('360029','WOOD COUNTY HOSPITAL')
insert into #providers values ('181315','FORT LOGAN HOSPITAL')
insert into #providers values ('390065','GETTYSBURG HOSPITAL')
insert into #providers values ('120005','HILO MEDICAL CENTER')
insert into #providers values ('100073','HOLY CROSS HOSPITAL')
insert into #providers values ('140133','HOLY CROSS HOSPITAL')
insert into #providers values ('210004','HOLY CROSS HOSPITAL')
insert into #providers values ('170020','HUTCHINSON HOSPITAL')
insert into #providers values ('360035','MOUNT CARMEL HEALTH')
insert into #providers values ('240014','NORTHFIELD HOSPITAL')
insert into #providers values ('521311','OUR LADY OF VICTORY')
insert into #providers values ('100051','SOUTH LAKE HOSPITAL')
insert into #providers values ('330057','ST. PETERS HOSPITAL')
insert into #providers values ('360068','THE TOLEDO HOSPITAL')
insert into #providers values ('110028','UNIVERSITY HOSPITAL')
insert into #providers values ('050308','EL CAMINO HOSPITAL')
insert into #providers values ('100061','MERCY HOSPITAL INC')
insert into #providers values ('110161','NORTHSIDE HOSPITAL')
insert into #providers values ('050013','ST HELENA HOSPITAL')
insert into #providers values ('330004','KINGSTON HOSPITAL')
insert into #providers values ('360156','MEMORIAL HOSPITAL')
insert into #providers values ('390204','NAZARETH HOSPITAL')
insert into #providers values ('260179','ST LUKES HOSPITAL')
insert into #providers values ('350006','TRINITY HOSPITALS')
insert into #providers values ('220095','HEYWOOD HOSPITAL')
insert into #providers values ('260177','LIBERTY HOSPITAL')
insert into #providers values ('140083','LORETTO HOSPITAL')
insert into #providers values ('520089','MERITER HOSPITAL')
insert into #providers values ('240106','REGIONS HOSPITAL')
insert into #providers values ('330203','CROUSE HOSPITAL')
insert into #providers values ('360074','FLOWER HOSPITAL')
insert into #providers values ('330005','KALEIDA HEALTH ')
insert into #providers values ('200008','MERCY HOSPITAL')
insert into #providers values ('380009','OHSU HOSPITAL')
insert into #providers values ('390046','YORK HOSPITAL')


delete from medicareLookup

insert into medicareLookup
select *
from #providers

--3  Identify/Insert medicare numbers that are assigned to HCAHPS unit but not in medicare lookup table. 
--   The name will be UNKNOWN. Will provide exception report of the UNKNOWNS

if object_id('tempdb..#UnknownMedicareNumbers') is not null Drop Table #UnknownMedicareNumbers

Select c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm, s.strsampleunit_nm, s.sampleunit_id, s.MedicareNumber,
		s.bitHCAHPS
into #UnknownMedicareNumbers
from sampleunit s, sampleplan sp, survey_def sd, study st, client c
where s.MedicareNumber not in (select MedicareNumber from medicareLookup) 
	and s.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and s.medicarenumber not like '%[^0-9]%'

--exception report of the UNKNOWNS
select *--distinct strclient_nm, strstudy_nm, strsurvey_nm, MedicareNumber
from #UnknownMedicareNumbers


--exception report of bad Medicare Numbers
Select distinct c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm,s.MedicareNumber
from sampleunit s, sampleplan sp, survey_def sd, study st, client c
where s.MedicareNumber not in (select MedicareNumber from medicareLookup) 
	and s.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and s.medicarenumber like '%[^0-9]%'

insert medicareLookup
select DISTINCT MedicareNumber, 'Unknown'
from #UnknownMedicareNumbers

--4 Populate medicare number in the facility table based on the current sample unit information. 
--5 Need exception report that shows facilities with multiple medicare numbers
--6 Need exception report of HCAHPS sample units that were not assigned a facility

if object_id('tempdb..#FacilityMedicareCombos') is not null Drop Table #FacilityMedicareCombos

select distinct sufacility_id, medicareNumber
into #FacilityMedicareCombos
from sampleunit
where medicareNumber is not null 
	and sufacility_id is not null

if object_id('tempdb..#FacilitiesWithMultipleMedicareIDs') is not null Drop Table #FacilitiesWithMultipleMedicareIDs

select sufacility_id
into #FacilitiesWithMultipleMedicareIDs
from #FacilityMedicareCombos
group by sufacility_id
having count(distinct MedicareNumber)>1

delete
from #FacilityMedicareCombos
where sufacility_id in 
	(select sufacility_id
		from #FacilitiesWithMultipleMedicareIDs)

--exception report that shows facilities with multiple medicare numbers
Select distinct sf.sufacility_id, sf.strfacility_nm, city, state, s.MedicareNumber,
	   c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm
from #FacilitiesWithMultipleMedicareIDs fm, sufacility sf, 
	sampleunit s, sampleplan sp, survey_def sd, study st, client c
where fm.sufacility_id=sf.sufacility_id
	and fm.sufacility_id=s.sufacility_id
	and s.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and s.MedicareNumber is not null

update sufacility
set medicareNumber=fm.medicareNumber
from sufacility sf, #FacilityMedicareCombos fm
where sf.sufacility_id=fm.sufacility_id
	and fm.medicarenumber not like '%[^0-9]%'

--exception report of HCAHPS sample units that were not assigned a facility
Select c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm, s.strsampleunit_nm, s.sampleunit_id
from sampleunit s, sampleplan sp, survey_def sd, study st, client c
where (s.sufacility_id <=0 or s.sufacility_id is null)
	and s.sampleplan_id=sp.sampleplan_id
	and sp.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and bitHCAHPS=1


--7 Drop client_id column from Facility table and drop medicare number from sample unit and survey_def
--  NOTE: Dropping client_id is not needed because this is already part of upgrade script for Qualisys

Alter table sampleunit
	drop column medicareNumber

Alter table survey_def
	drop column medicareNumber