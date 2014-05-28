CREATE PROC SP_SYS_RemoveOrphanQuestions @Survey_id INT    
AS    
    
IF EXISTS    
(SELECT s.Survey_id, s.QstnCore, s.Language, s.section_id, s.subsection, s.item, s.SubType     
FROM Sel_Qstns s LEFT OUTER JOIN Sel_Qstns sq    
on s.Survey_id=sq.Survey_id    
AND s.SubType=sq.SubType    
AND s.QstnCore=sq.QstnCore    
AND sq.Language=1    
WHERE s.SubType IN (1,2)    
AND s.Survey_id=@Survey_id    
AND s.Language<>1    
AND sq.Language IS NULL)    
BEGIN    
    
 DECLARE @sql VARCHAR(2000)    
     
 SET @sql='SELECT s.Survey_id, s.QstnCore, s.Language, s.section_id, s.subsection, s.item, s.SubType     
 FROM Sel_Qstns s LEFT OUTER JOIN Sel_Qstns sq    
 on s.Survey_id=sq.Survey_id    
 AND s.SubType=sq.SubType    
 AND s.QstnCore=sq.QstnCore    
 AND sq.Language=1    
 WHERE s.SubType IN (1,2)    
 AND s.Survey_id='+CONVERT(VARCHAR,@Survey_id)+'    
 AND s.Language<>1    
 AND sq.Language IS NULL'    
     
 --EXEC Master.dbo.XP_SendMail @Recipients='dba@nationalresearch.com', @Subject='Orphaned Questions Deleted',     
 -- @Query=@sql, @Attach_Results=True, @DBUse='QP_Prod', @Width=500    


EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail',
@recipients='dba@nationalresearch.com',
@subject='Orphaned Questions Deleted',
@body_format='Text',
@importance='High',
@execute_query_database = 'qp_prod',
@attach_query_result_as_file = 1,
@Query=@sql
     
 DELETE s    
 FROM Sel_Qstns s LEFT OUTER JOIN Sel_Qstns sq    
 ON s.Survey_id=sq.Survey_id    
 AND s.SubType=sq.SubType    
 AND s.QstnCore=sq.QstnCore    
 AND sq.Language=1    
 WHERE s.SubType IN (1,2)    
 AND s.Survey_id=@Survey_id    
 AND s.Language<>1    
 AND sq.Language IS NULL    
    
END


