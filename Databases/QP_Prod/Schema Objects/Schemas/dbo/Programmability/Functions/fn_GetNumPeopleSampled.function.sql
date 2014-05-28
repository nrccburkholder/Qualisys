Create Function fn_GetNumPeopleSampled (@SampleSet_ID int) RETURNS INT
as
begin
	declare @numSampled int

	select @numSampled = count(qf.QuestionForm_ID)
	from survey_Def sd, Sampleset ss, questionform qf, samplepop sp  
	where ss.survey_Id = sd.survey_ID and  
	  qf.survey_Id = sd.survey_ID and  
	  sp.sampleset_Id = ss.sampleset_ID and  
	  sp.samplepop_ID = qf.samplepop_ID and   
	  ss.Sampleset_ID = @SampleSet_ID

	return isnull(@numSampled, 0)

end


