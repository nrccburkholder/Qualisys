CREATE PROCEDURE [dbo].[QP_Rep_SampleUnitClasses] @client VARCHAR(40), @study VARCHAR(10), @survey VARCHAR(10), @associate VARCHAR(20)
AS
-- Created 5/26/05 SS - Dashboard proc/report that calls procedure that populates the sampleunitclasses sit - "Show All Units" page.
-- Modified 1/9/2007 Deying -- fixed ambiguous survey name and study name problem
DECLARE @survey_id INT, @Study_id int, @Client_id int

SELECT @Client_id = Client_id from Client where strClient_nm = @Client

SELECT @Study_id = Study_id FROM Study where strStudy_nm = @Study and Client_id = @Client_id

SELECT @survey_id = survey_id FROM Survey_Def WHERE strsurvey_nm = @survey and Study_id = @Study_id
EXEC dbo.SP_NORMS_CurrentValues @survey_id


