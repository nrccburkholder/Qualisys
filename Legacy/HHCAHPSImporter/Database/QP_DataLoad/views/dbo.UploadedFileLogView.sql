CREATE VIEW dbo.UploadedFileLogView  
AS  
select    
 a.UploadFile_id,    
 a.OrigFile_Nm,    
 a.File_Nm,    
 a.FileSize,    
 a.UploadAction_id,    
 b.UploadState_id as UploadFileState_id,    
 b.StateParameter as UploadStateParam,    
 b.datOccurred as DateUploadFileStateChange,    
 d.DataFile_id,    
 ci.ClientName,  
 d.Client_ID,    
 d.Study_ID,    
 d.Survey_ID,    
 d.FileType_id,    
 d.PervasiveMapName,    
 d.strFileLocation as DataFileLocation,    
 d.strFile_nm as DataFileName,    
 d.intFileSize as DataFileSize,    
 d.intRecords as DataFileRecords,    
 d.intLoaded,    
 d.datReceived,    
 d.datBegin,    
 d.datEnd,    
 e.datOccurred as DatApplied,  -- TOTAL Hack: I forgot to include the DataFile state change date.  Also, datApplied column is always null. 
 d.datMinDate,    
 d.datMaxDate,    
 d.datDeleted,    
 d.DataSet_id,    
 d.AssocDataFiles,    
 e.State_ID as DataFileState_id,    
 e.StateParameter as DataFileStateParam    
from     
 dbo.UploadFile as a with(nolock)    
 INNER JOIN dbo.UploadFileState as b with(nolock) on a.UploadFile_id=b.UploadFile_id    
 LEFT JOIN dbo.UploadFilesToDataFiles as c with(nolock) on a.UploadFile_id=c.UploadFile_id    
 LEFT JOIN dbo.DataFile as d with(nolock) on c.DataFile_id=d.DataFile_id    
 LEFT JOIN dbo.DataFileState as e with(nolock) on d.DataFile_id=e.DataFile_id    
 LEFT JOIN dbo.ClientDetail as ci with(nolock) on d.Client_ID = ci.Client_id and d.Study_ID=ci.Study_id and d.Survey_ID=ci.Survey_id
 