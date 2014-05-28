Create Function DL_CalcTotalLithoErrors (@SurveyDataLoad_ID int)  
RETURNS int  
as  
Begin  
  
 DECLARE @ReturnVal as int  

 select @ReturnVal =count(*)
 from	DL_LithoCodes DL_l
 where	dL_l.DL_error_ID is not null and  
		DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID  
  
 Return @ReturnVal  
end


