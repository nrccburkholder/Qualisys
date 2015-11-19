  /*

  TO BE RUN ONLY ON GATOR!!!!!!!!!!!!!!!!


  if NRC_DataMart_ETL backup date is greater than QP_PROD backup date 
  (that is, it happened after the QP_PROD backup), then 
  we need to delete from [NRC_DataMart_ETL].[dbo].[ExtractQueue] any records 
  with a create date > the QP_PROD backup date and < date NRC_Datamart_ETL backup 
  */


  DECLARE @QP_PROD_BackupDate datetime = '2015-11-03 05:22:40.000'
  DECLARE @NRC_Datamart_ETL_BackupDate datetime = '2015-11-03 02:25:35.000'

  IF @QP_PROD_BackupDate < @NRC_Datamart_ETL_BackupDate
  BEGIN

	DELETE from [NRC_DataMart_ETL].[dbo].[ExtractQueue] 
	where ExtractFileID is null 
	and Created between @QP_PROD_BackupDate and @NRC_Datamart_ETL_BackupDate  

  END
  ELSE
  BEGIN
	print 'Nothing to do.  All is well.'
  END
