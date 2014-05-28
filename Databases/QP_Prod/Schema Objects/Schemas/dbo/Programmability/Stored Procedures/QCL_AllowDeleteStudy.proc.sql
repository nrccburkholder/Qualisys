CREATE PROCEDURE QCL_AllowDeleteStudy  
@StudyId INT  
AS  
  
IF EXISTS (SELECT * 
           FROM Survey_def
           WHERE Study_id=@StudyID)
SELECT 0  
ELSE
SELECT 1


