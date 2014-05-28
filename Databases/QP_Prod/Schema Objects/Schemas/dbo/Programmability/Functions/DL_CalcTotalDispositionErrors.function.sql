Create Function DL_CalcTotalDispositionErrors (@SurveyDataLoad_ID int)  
RETURNS int  
as  
Begin  
  
 DECLARE @ReturnVal as int  

 select @ReturnVal =count(*)
 from DL_Dispositions DL_q, DL_LithoCodes DL_l  
 where DL_q.DL_lithoCode_ID = DL_l.DL_lithoCode_ID and   
   dL_q.DL_error_ID is not null and  
   DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID  
  
 Return @ReturnVal  
end


