  
MWB 11162007  
This procedure returns all files that were logged in a certain date range.  
If you want to not have an upper or lower bound then just send in NULL.  
  
CREATE PROCEDURE sp_SPU_GetFileTrackingLogByDate          
 (@FromDate datetime = NULL, @ToDate dateTime = NULL  
  )        
          
AS           
BEGIN          
  
Select  from SPU_FileTrackingLog  
Where DatFileLoaded between   
Isnull(@FromDate,DatFileLoaded) and isnull(@ToDate,DatFileLoaded)   
  
  
End   