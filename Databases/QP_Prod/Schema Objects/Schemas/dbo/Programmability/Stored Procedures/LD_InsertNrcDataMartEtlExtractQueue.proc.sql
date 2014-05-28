CREATE PROCEDURE [dbo].[LD_InsertNrcDataMartEtlExtractQueue]
    @SamplePopID  INT
AS

SET NOCOUNT ON

INSERT INTO NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, Source)

VALUES (7, @SamplePopID, NULL, 0, 'Load to live')

SET NOCOUNT OFF


