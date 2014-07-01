use [QP_Prod] 
--select top 10 * from NRC_DataMart_ETL.dbo.ExtractQueue

--select top 10 * from sampleunit where cahpstype_id <> 0


--EXEC sp_helptext 'dbo.trg_NRC_DataMart_ETL_dbo_SAMPLEUNIT'

 insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData,Source)  
  select 6, SAMPLEUNIT_ID, NULL, 1,'Sprint3 Task 5.X Backfill IsCAHPS CJB 6/30/2014'   from
  sampleunit where CAHPSType_id <> 0