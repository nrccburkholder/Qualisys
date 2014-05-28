/*    
Business Purpose:     
This procedure is used to support the Qualisys Class Library.  It inserts a record into the
samplePlan table
    
Created:  2/21/2006 by Dan Christensen   
    
Modified:    
 */   
CREATE PROCEDURE [dbo].[QCL_InsertSamplePlan]      
@employee_id INT,
@survey_id int     
AS       

INSERT INTO SamplePlan (employee_id, survey_id, DatCreate_DT)
VALUES(@employee_id, @survey_id,getDate())

SELECT SCOPE_IDENTITY()


