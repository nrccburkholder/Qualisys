CREATE PROCEDURE [dbo].[LD_UpdateDRG] @Study_ID int, @DataFile_id int        
AS        
        
begin        
 -- Developed by DK 9/2006        
 -- Created by SJS 10/12/2006        
 -- Modified by dmp 11/09/2006: un-commented code for deleting records > 42 days old        
 -- Modified by dmp 12/15/2006: commented out code for deleting recs >42 days old, per new reqs from CS        
 -- Renamed by ADL 06/20/2007: added the record count log dataset        
 -- ReOrganized by MWB 10/25/07: This procedure is now the driver for DRG and MSDRG updates.  It will check the QLoader    
 --        Qualisys DB to make sure the fields exist.  if they do then the appopriate DRG update    
 --        worker (_Updater) procedure is called, if not it is skipped.    
 -- Purpose: Update Study background data in Qualysis and Datamart for a specified Study and Datafile in the QP_Load DB.        
    
     
 --create the #log table that each of the Update SPs will use.    
 CREATE TABLE #log (RecordType varchar(100), RecordsValue VArchar(50))        
    
    
 if exists (select 'x' from MetaData_view where Study_ID = @Study_ID and strField_nm = 'DRG')    
  begin    
   exec LD_UpdateDRG_Updater @Study_ID , @DataFile_id     
  end     
 else    
  insert into #log (RecordType, RecordsValue) values ('DRG Update Failed', 'Your study does not contain a DRG field.')    
    
    
 if exists (select 'x' from MetaData_view where Study_ID = @Study_ID and strField_nm = 'MSDRG')    
  begin    
   exec LD_UpdateMSDRG_Updater @Study_ID , @DataFile_id     
  end     
 else    
  insert into #log (RecordType, RecordsValue) values ('MSDRG Update Failed', 'Your study does not contain a MSDRG field.')    
     
    
 SELECT * FROM #LOG    
 drop table #log    
    
end


