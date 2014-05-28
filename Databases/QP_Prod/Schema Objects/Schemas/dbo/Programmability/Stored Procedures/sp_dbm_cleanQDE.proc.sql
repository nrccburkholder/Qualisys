/*********************************************************************************************************    
sp_dbm_cleanQDE    
Created by: Michael Beltz     
Purpose: proc is designed to clean up QDEComments and QDEForm after records are submitted to Qualisys    
    
History Log:    
Created on: 7/16/09    
Modified  :     
*********************************************************************************************************/    
    
CREATE proc sp_dbm_cleanQDE (@batchsize INT = 1500)    
as    
begin    
    
                
set @batchsize = 1500    
     
CREATE TABLE #sm_All (                
  sentmail_id INT,                  
  strLithoCode varchar(10)                
 )        
CREATE TABLE #sm_All_QDE (                              
  strLithoCode varchar(10)                
 )        
    
 CREATE TABLE #sentmailing (                
  sentmail_id INT,                
  strLithoCode varchar(10)          
 )                
     
 INSERT INTO #sm_All_QDE (strlithocode)                
 SELECT distinct strlithocode              
 FROM QDEForm (nolock)               
    
    
--looking for all records in the sentmailing record that    
--has been deleted (bubbledata from sp_dbm_systemclean)    
--for more then 6 months    
 print 'Get All Records that have been expired for 6 months.'          
 INSERT INTO #sm_All (SentMail_id, strLithoCode)              
 SELECT DISTINCT sm.sentmail_id, sm.strLithoCode            
 FROM sentmailing sm (NOLOCK),  #sm_All_QDE QDE              
 WHERE sm.strlithocode = QDE.strlithocode and     
  getdate() >= dateadd(year,3,sm.datexpire) AND     
  sm.datdeleted IS NOT NULL and     
  sm.datexpire is not null              
           
              
 SET ROWCOUNT @batchsize                
 INSERT INTO #sentmailing (sentmail_id, strlithocode)                
 SELECT sentmail_id, strlithocode                
 FROM #sm_All                
                
 WHILE @@ROWCOUNT > 0                
 BEGIN                
 SET ROWCOUNT 0                
  
 print 'Delete QDECommentsSelCodes'    
 Delete csc    
 from	qdeform f, qdecomments c, #sentmailing s, QDECommentSelCodes CSC    
 where	f.form_ID = c.form_Id and    
		c.cmnt_ID = csc.cmnt_ID and
		s.strlithocode = f.strlithocode    

            
 print 'Delete QDEComments'    
 Delete c    
 from qdeform f, qdecomments c, #sentmailing s    
 where f.form_ID = c.form_Id and    
   s.strlithocode = f.strlithocode    
    
 print 'Delete QDEForm'    
 Delete f    
 from qdeform f, #sentmailing s    
 where s.strlithocode = f.strlithocode    
    
    
    
    
 DELETE a                
 FROM #SentMailing t, #sm_All a                
 WHERE a.SentMail_id=t.SentMail_id     
    
   TRUNCATE TABLE #sentmailing                
   if @@error <> 0                
   begin                
    DROP TABLE #sentmailing                
    return                
   end                
    
   SET ROWCOUNT @batchsize                
    
   INSERT INTO #sentmailing (sentmail_id, strLithoCode)                
   SELECT sentmail_id, strLithoCode                
   FROM #sm_All       
          
END            
    
        
 SET ROWCOUNT 0                
 DROP TABLE #sentmailing       
    
end


