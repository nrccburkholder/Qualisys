use [QP_Prod] 
--select top 10 * from NRC_DataMart_ETL.dbo.ExtractQueue

--select top 10 * from sampleunit where cahpstype_id <> 0

--EXEC sp_helptext 'dbo.trg_NRC_DataMart_ETL_dbo_CLIENT'
	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)
		select 1, CLIENT_ID, NULL, 1 ,'Sprint3 Task 5.X Backfill IsCAHPS CJB 6/30/2014' from client
		where client_id in (select client_id from survey_def where survey_ID in (select survey_id from sampleunit where CAHPSType_id in (4,8,10)))

--EXEC sp_helptext 'dbo.trg_NRC_DataMart_ETL_Ins_dbo_SURVEY_DEF'
	insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)
		select 3, SURVEY_ID, NULL, 1 ,'Sprint3 Task 5.X Backfill IsCAHPS CJB 6/30/2014'
		from survey_def where survey_ID in (select survey_id from sampleunit where CAHPSType_id in (4,8,10))

--EXEC sp_helptext 'dbo.trg_NRC_DataMart'

 insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)  
  select 6, SAMPLEUNIT_ID, NULL, 1,'Sprint3 Task 5.X Backfill IsCAHPS CJB 6/30/2014'   from
  sampleunit where CAHPSType_id in (4,8,10)