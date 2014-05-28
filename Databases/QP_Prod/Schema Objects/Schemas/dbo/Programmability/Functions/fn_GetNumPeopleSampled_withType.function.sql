Create Function fn_GetNumPeopleSampled_withType (@SampleSet_ID int, @MailingStepMethod_ID int) RETURNS INT    
as    
begin    
 declare @numSampled int    
    
 select @numSampled = count(qf.QuestionForm_ID)    
 from survey_Def sd, Sampleset ss, questionform qf, samplepop sp,  
  scheduledmailing scm, mailingStep ms         
 where ss.survey_Id = sd.survey_ID and      
  qf.survey_Id = sd.survey_ID and      
  sp.sampleset_Id = ss.sampleset_ID and      
  sp.samplepop_ID = qf.samplepop_ID and    
  sp.samplepop_ID = scm.samplepop_ID and  
  scm.mailingStep_ID = ms.mailingStep_ID and  
  ss.Sampleset_ID = @SampleSet_ID and  
  ms.MailingStepMethod_ID = @MailingStepMethod_ID
  
    
 return isnull(@numSampled, 0)    
    
end


