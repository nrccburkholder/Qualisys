select count(distinct datafile_id) from dtsservicelog
--where datOccurred > '11/30/2015' --64
--where datOccurred > '11/23/2015' --71
--where datOccurred > '11/16/2015' --81
--where datOccurred > '11/9/2015' --98
where datOccurred > '12/5/2015' --and datOccurred < '12/1/2015' --103
and strEventData like '%melissadata%' 

select * from dtsservicelog
where datOccurred > '12/5/2015' --and datOccurred < '12/1/2015' --103
and strEventData like '%timed out%'

select count(distinct datafile_id) from dtsservicelog
where datOccurred > '12/5/2015' --and datOccurred < '12/1/2015' --103
and strEventData like '%address%'

select * from datafilestate_history 
where datOccurred > '12/5/2015'
and StateParameter like '%Exception%'
union
select * from datafilestate
where datOccurred > '12/5/2015'
and StateParameter like '%Exception%'



select * from dtsservicelog where datafile_id = 409308
/*
Exception: Could not clean DataFile_id: 409833
The operation has timed out
   at Nrc.Framework.AddressCleaning.NameCollection.Clean(Boolean properCase, Boolean assignIDs, Boolean forceProxy, Int32 dataFileId) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Collections\NameCollection.vb:line 144
   at Nrc.Framework.AddressCleaning.NameProvider.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, MetaGroupCollection& metaGroups, NameCollection names, LoadDatabases loadDB, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\DataProviders\NameProvider.vb:line 114
   at Nrc.Framework.AddressCleaning.Cleaner.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Classes\Cleaner.vb:line 139
   at Nrc.Qualisys.QLoader.AddressCleaner.AddressCleaner.CleanQPLoad(Int32 dataFileID, LoadDatabases loadDB) in G:\BuildAgent3\work\d7f7e53c0af53579\QLoader Solution\AddressCleaner\AddressCleaner.vb:line 116

Exception: Could not clean DataFile_id: 409834
The operation has timed out
   at Nrc.Framework.AddressCleaning.NameCollection.Clean(Boolean properCase, Boolean assignIDs, Boolean forceProxy, Int32 dataFileId) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Collections\NameCollection.vb:line 144
   at Nrc.Framework.AddressCleaning.NameProvider.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, MetaGroupCollection& metaGroups, NameCollection names, LoadDatabases loadDB, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\DataProviders\NameProvider.vb:line 114
   at Nrc.Framework.AddressCleaning.Cleaner.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Classes\Cleaner.vb:line 139
   at Nrc.Qualisys.QLoader.AddressCleaner.AddressCleaner.CleanQPLoad(Int32 dataFileID, LoadDatabases loadDB) in G:\BuildAgent3\work\d7f7e53c0af53579\QLoader Solution\AddressCleaner\AddressCleaner.vb:line 116

Exception: Could not clean DataFile_id: 409308
The operation has timed out
   at Nrc.Framework.AddressCleaning.AddressCollection.Clean(Boolean assignIDs, Boolean forceProxy, Boolean populateGeoCoding, Int32 dataFileId) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Collections\AddressCollection.vb:line 298
   at Nrc.Framework.AddressCleaning.AddressProvider.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, MetaGroupCollection& metaGroups, AddressCollection addresses, LoadDatabases loadDB, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\DataProviders\AddressProvider.vb:line 179
   at Nrc.Framework.AddressCleaning.Cleaner.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Classes\Cleaner.vb:line 142
   at Nrc.Qualisys.QLoader.AddressCleaner.AddressCleaner.CleanQPLoad(Int32 dataFileID, LoadDatabases loadDB) in G:\BuildAgent3\work\d7f7e53c0af53579\QLoader Solution\AddressCleaner\AddressCleaner.vb:line 116

Exception: Could not clean DataFile_id: 409298
The operation has timed out
   at Nrc.Framework.AddressCleaning.NameCollection.Clean(Boolean properCase, Boolean assignIDs, Boolean forceProxy, Int32 dataFileId) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Collections\NameCollection.vb:line 144
   at Nrc.Framework.AddressCleaning.NameProvider.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, MetaGroupCollection& metaGroups, NameCollection names, LoadDatabases loadDB, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\DataProviders\NameProvider.vb:line 114
   at Nrc.Framework.AddressCleaning.Cleaner.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Classes\Cleaner.vb:line 139
   at Nrc.Qualisys.QLoader.AddressCleaner.AddressCleaner.CleanQPLoad(Int32 dataFileID, LoadDatabases loadDB) in G:\BuildAgent3\work\d7f7e53c0af53579\QLoader Solution\AddressCleaner\AddressCleaner.vb:line 116

Exception: Could not clean DataFile_id: 409258
The operation has timed out
   at Nrc.Framework.AddressCleaning.NameCollection.Clean(Boolean properCase, Boolean assignIDs, Boolean forceProxy, Int32 dataFileId) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Collections\NameCollection.vb:line 154
   at Nrc.Framework.AddressCleaning.NameProvider.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, MetaGroupCollection& metaGroups, NameCollection names, LoadDatabases loadDB, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\DataProviders\NameProvider.vb:line 114
   at Nrc.Framework.AddressCleaning.Cleaner.CleanAll(Int32 dataFileID, Int32 studyID, Int32 batchSize, Boolean forceProxy) in G:\BuildAgent3\work\d7f7e53c0af53579\NRC Framework Solution\Nrc.Framework.AddressCleaning\Classes\Cleaner.vb:line 139
   at Nrc.Qualisys.QLoader.AddressCleaner.AddressCleaner.CleanQPLoad(Int32 dataFileID, LoadDatabases loadDB) in G:\BuildAgent3\work\d7f7e53c0af53579\QLoader Solution\AddressCleaner\AddressCleaner.vb:line 116
*/

select DataFile_id, * from dtsservicelog
where (datOccurred > '12/4/2015 15:53') 
and strEventData like '%melissadata%' and strEventData like '%webresponse%'



select max(p.study_id), dsl.DataFile_id, datediff(minute, min(datOccurred), max(datOccurred)), max(datOccurred)
from dtsservicelog dsl inner join datafile df on dsl.datafile_id= df.datafile_id
inner join package p on df.package_id = p.package_id
where dsl.datafile_id in (
select DataFile_id from dtsservicelog
where (datOccurred > '12/4/2015 15:53') 
and strEventData like '%melissadata%' and strEventData like '%webresponse%')
group by dsl.datafile_id
order by  max(datOccurred) desc

select * from dtsservicelog where datafile_id in ( 408051,407701)
order by datOccurred desc

select top 1 * from package where filetypesettings = 

select top 1 * from datafile where strOrigFile_nm = '272698_crmc_hospital_11082015_11142015.txt' --407946 / 4919
select * from datafile where strOrigFile_nm like '272697_crmc_hospital_11012015_11072015.txt' --408409 / 4919
select * from datafile where strOrigFile_nm like '272848_SJCHS_HOSPITAL_10252015_10312015.txt%'/*
408428
408679 s2228
408702 s2228
408715 s2228
408743 s2228
*/
select study_id, df.datafile_id from package p inner join datafile df on p.package_id = df.package_id
where df.datafile_id in ( 408051,407701)

/*
study_id	datafile_id
4520	407701
2202	408051
*/

select * from datafile where strOrigFile_nm like '272848_SJCHS_HOSPITAL_10252015_10312015.txt%'



select datafile_id,study_id, strfilelocation+strorigfile_nm FileName from package p inner join datafile df on p.package_id = df.package_id where df.datafile_id in (
407995,408325,408821,407979,407980,407978,408917,408587,408584,408604,408603,408719,408770,408790,408792,408794,
408797,408796,407705,407704,408443,408445,407982)
--Harris Health System:
select * from datafile where strOrigFile_nm like '%272410_HarrisHealth_IPOPED_11302015.TXT%' --407995 
select * from datafile where strOrigFile_nm like '%272954_HarrisHealth_IPOPED_12012015.txt%' --408325 

--Intermountain:
--OP
select * from datafile where strOrigFile_nm like '%272262_Intermountain_OP_20151117_to_20151124%' --408821 

--Pharmacy
select * from datafile where strOrigFile_nm like '%Intermountain111315_112015%' --407979 
select * from datafile where strOrigFile_nm like '%Intermountain110615_111315%' --407980 
select * from datafile where strOrigFile_nm like '%Intermountain110115_110815%' --407978 
select * from datafile where strOrigFile_nm like '%Intermountain112215_112915%'-- 408917 (haven’t tried this one, yet)

--JPS Health Network:
select * from datafile where strOrigFile_nm like '%271594_JPS_nrc_weekly_11232015%' --408587 / 408584 
select * from datafile where strOrigFile_nm like '%272526_JPS_nrc_weekly_11302015%' --408604 / 408603 

--Sentara:
select * from datafile where strOrigFile_nm like '%272577_SentaraNRC_MOD%' --408719 
select * from datafile where strOrigFile_nm like '%273035_OP Ca NovPtSat%' --408770  

--Community Health Network:
select * from datafile where strOrigFile_nm like '%272510_CHRH_11_21_15.txt%' --408790  
select * from datafile where strOrigFile_nm like '%272497_CHN_DAT_HCAHPS_EMERGENCY_11162015_11222015%' --408792 
select * from datafile where strOrigFile_nm like '%272499_CHN_DAT_HCAHPS_OUTPATIENT_11162015_11222015%' --408794

--Penn State:
select * from datafile where strOrigFile_nm like '%272492_MSHMC_HOSPITAL_11152015_11212015%' --408797
select * from datafile where strOrigFile_nm like '%272493_MSHMG_OUTPATIENT_11152015_11212015%' --408796

--Lee Memorial: 
select * from datafile where strOrigFile_nm like '%272286_LMHS_OP_11302015.txt%' --407705
select * from datafile where strOrigFile_nm like '%272285_LMHS_IP_11302015.txt%' --not found
select * from datafile where strOrigFile_nm like '%272387_LMHS_LPG_11302015.txt%' --407704
select * from datafile where strOrigFile_nm like '%272386_LMHS_ED_11302015.txt%' --not found

--The Children’s Hospital of Philadelphia:
select * from datafile where strOrigFile_nm like '%272420_CHOP_NRC_20151128.txt%' --not found
select * from datafile where strOrigFile_nm like '%272422_CHOP_NRC_GC_20151128.txt%' --not found

--Cook Children’s:
select * from datafile where strOrigFile_nm like '%272776_CookChildrens_Athena_November_4_data.txt%' --408443 / 408445
select * from datafile where strOrigFile_nm like '%272783_CookChildrens_Meditech_November_25_data.txt%' --not found
select * from datafile where strOrigFile_nm like '%272777_CookChildrens_Meditech_November_04_data.txt%' --not found

--Children’s of CO:
select * from datafile where strOrigFile_nm like '%272472_CHCO_HOSPITAL_20151129.txt%' --407982


select * from datafile where strOrigFile_nm like '%272387_LMHS_LPG_11302015.txt%' --409093

CHOP:

272422_CHOP_NRC_GC_20151128.txt (409077)
271608_CHOP_NRC_GC_20151121.txt (409094)
271608_CHOP_NRC_20151128.txt (409075)

select strorigfile_nm, datafile_id,study_id from package p inner join datafile df on p.package_id = df.package_id where df.datafile_id in 
(409093,409077,409094,409075)
