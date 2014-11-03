CREATE PROCEDURE LD_GetDataFilesByDatasetId
@DataSet_id INT
AS

SELECT df.DataFile_id, df.intVersion, df.FileType_id, df.Package_id, df.strFileLocation, df.strFile_nm,
 df.intFileSize, df.intRecords, df.datReceived, df.datBegin, df.datEnd, df.intLoaded, df.datMinDate,
 df.datMaxDate, df.DataSet_id, dfs.State_id, dfs.StateDescription, p.Client_id, p.Study_id,
 AssocDataFiles, CONVERT(VARCHAR,datReceived)+' ('+df.strFile_nm+')' DisplayName, strOrigFile_nm FileName
FROM DataFile df, DataFileState dfs, Package p
WHERE df.DataSet_id=@DataSet_id
AND dfs.DataFile_id=df.DataFile_id
AND df.Package_id=p.Package_id
