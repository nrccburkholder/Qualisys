CREATE PROCEDURE SYS_Populate_HandWrittenField @survey INT, @strfield_nm VARCHAR(50), @qstncore INT            
AS            
            
-- 10/20/04 SJS            
-- Function:  To populate the HandwrittenField table based upon the survey, field_nm and qstncore to enable.            
-- Modified 7/13/05 - SJS - Added check to see if HandEntry already mapped, if so print message and return.        
-- Modified 8/19/05 - SJS - Added call to DM proc to add mapped column to big_table if missing.      
           
DECLARE @table_id INT, @field_id INT, @sql VARCHAR(8000), @study_id INT, @server VARCHAR(30)      
            
SELECT @table_id = table_id, @field_id = field_id FROM  qp_prod.dbo.metadata_view             
WHERE study_Id = (SELECT DISTINCT study_id FROM QP_PROD.dbo.clientstudysurvey_view where survey_id = @survey)            
AND strfield_nm = @strfield_nm            
        
IF EXISTS (SELECT * FROM HandWrittenField WHERE survey_id = @Survey and qstncore = @qstncore)        
 BEGIN        
 PRINT 'Hand Entry Already Enabled!'        
  SELECT survey_id, qstncore, item, sampleunit_id, line_id, table_id, field_id FROM HandWrittenField WHERE survey_id = @Survey and qstncore = @qstncore        
 RETURN        
 END        
          
-- Check if the survey has any  non-mail mailingstep methodologies -- We will have to handle them specially.          
IF EXISTS (          
 SELECT * FROM qp_prod.dbo.clientstudysurvey_view css, qp_prod.dbo.mailingmethodology mm, qp_prod.dbo.mailingstep ms           
 WHERE css.survey_id = @survey and css.methodology_id = ms.methodology_id AND css.methodology_id = mm.methodology_id AND ms.mailingstepmethod_id <> 0 AND mm.bitActiveMethodology = 1 )          
 BEGIN           
  PRINT CHAR(10) + CHAR(10) + CHAR(10) +  '                                                    NON - MAIL METHODOLOGY !!!!'  + CHAR(10) + CHAR(10) + CHAR(10)           
  PRINT '                                                    CHECK SCALE LINE VALUE (MAY BE MULTIPLE - Meaning each line mapped to sepearte qstncore) ' + CHAR(10) + CHAR(10) + CHAR(10) + CHAR(10)           
 SET @SQL = '          
 SELECT sc.richtext           
 FROM qp_prod.dbo.sel_qstns sq, qp_prod.dbo.sel_scls sc, qp_prod.dbo.sampleunitsection sus           
 WHERE sq.survey_id = sc.survey_id AND sq.scaleid = sc.qpc_id AND sq.language = sc.language AND sq.survey_id = sus.selqstnssurvey_id AND sq.section_id = sus.selqstnssection          
 AND sq.survey_id = ' + CONVERT(VARCHAR,@survey) + '          
 AND sq.qstncore = ' + CONVERT(VARCHAR,@qstncore) + '          
 AND sc.richtext like ''%[_][_]%'''  
 PRINT (@sql)        
 EXEC (@sql)          
          
 SET @sql = '   
 USE QP_SCAN       
 SELECT *           
 FROM qp_prod.dbo.sel_qstns sq, qp_prod.dbo.sel_scls sc, qp_prod.dbo.sampleunitsection sus           
 WHERE sq.survey_id = sc.survey_id AND sq.scaleid = sc.qpc_id AND sq.language = sc.language AND sq.survey_id = sus.selqstnssurvey_id AND sq.section_id = sus.selqstnssection          
 AND sq.survey_id = ' + CONVERT(VARCHAR,@survey) + '          
 AND sq.qstncore = ' + CONVERT(VARCHAR,@qstncore) + '          
 AND sc.richtext like ''%[_][_]%''' + char(10) + char(10) + '          
                
 DECLARE @LINE INT           
 SET @LINE = 1         
 INSERT INTO HandWrittenField (survey_id, qstncore, item, sampleunit_id, line_id, table_id, field_id)            
 SELECT DISTINCT sq.survey_id, sq.qstncore, sc.item, sus.sampleunit_id, @line AS line_id, ' + CONVERT(VARCHAR,@table_id) + ' AS table_id, ' + CONVERT(VARCHAR,@field_id) + ' AS field_id           
 FROM qp_prod.dbo.sel_qstns sq, qp_prod.dbo.sel_scls sc, qp_prod.dbo.sampleunitsection sus           
 WHERE sq.survey_id = sc.survey_id AND sq.scaleid = sc.qpc_id AND sq.language = sc.language AND sq.survey_id = sus.selqstnssurvey_id AND sq.section_id = sus.selqstnssection          
 AND sq.survey_id = ' + CONVERT(VARCHAR,@survey) + '          
 AND sq.qstncore = ' + CONVERT(VARCHAR,@qstncore) + '          
 AND sc.richtext like ''%[_][_]%'''      
  PRINT (@sql)      
 EXEC (@SQL)          
        
  RETURN          
 END          
            
BEGIN TRAN            
INSERT INTO HandWrittenField (survey_id, qstncore, item, sampleunit_id, line_id, table_id, field_id)            
SELECT DISTINCT qf.survey_id, hwp.qstncore, hwp.item, hwp.sampleunit_id, hwp.line_Id, @table_id AS table_id, @field_id AS field_id             
FROM qp_prod.dbo.questionform qf            
INNER JOIN HandWrittenPos hwp            
ON qf.questionform_id = hwp.questionform_id            
WHERE qf.survey_id = @survey            
AND hwp.qstncore = @qstncore            
            
 IF @@ERROR <> 0                      
   BEGIN                      
      ROLLBACK TRANSACTION            
  PRINT 'ERROR ENCOUNTERED'            
  RETURN                      
   END                      
            
COMMIT TRANSACTION              
      
--Mod 8/19/05 SJSJ      
-- Now add the column to necessary big_table(s) on DataMart if column is missing there.      
SELECT @study_id = study_id FROM qp_prod.dbo.survey_def WHERE survey_id = @survey      
SELECT @server = strParam_Value FROM qp_prod.dbo.qualpro_params WHERE strparam_nm = 'DATAMART'      
      
print 'before Medusa Call'  
SET @SQL = 'EXEC ' + @Server + '.QP_COMMENTS.dbo.sp_HWF_AddColumn ' + CONVERT(VARCHAR,@study_id) + ', ''' +  @strField_nm + ''''      
print @sql      
EXEC (@sql)


