Create Function DL_CalcDistinctLithosInError (@SurveyDataLoad_ID int)
RETURNS int
as
Begin

	DECLARE @ReturnVal as int
	DECLARE @Lithos table (DL_LithoCode_ID int)
	--create table #Lithos (DL_LithoCode_ID int)

	insert into @Lithos
	select	distinct DL_d.DL_LithoCode_ID 
	from	DL_Dispositions DL_d, DL_LithoCodes DL_l
	where	DL_d.DL_lithoCode_ID = DL_l.DL_lithoCode_ID and 
			dL_d.DL_error_ID is not null and
			DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID


	insert into @Lithos
	select	distinct DL_q.DL_LithoCode_ID 
	from	DL_QuestionResults DL_q, DL_LithoCodes DL_l
	where	DL_q.DL_lithoCode_ID = DL_l.DL_lithoCode_ID and 
			dL_q.DL_error_ID is not null and
			DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID

	insert into @Lithos
	select	distinct DL_h.DL_LithoCode_ID 
	from	DL_HandEntry DL_h, DL_LithoCodes DL_l
	where	DL_h.DL_lithoCode_ID = DL_l.DL_lithoCode_ID and 
			dL_h.DL_error_ID is not null and
			DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID

	insert into @Lithos
	select	distinct DL_c.DL_LithoCode_ID 
	from	DL_Comments DL_c, DL_LithoCodes DL_l
	where	DL_c.DL_lithoCode_ID = DL_l.DL_lithoCode_ID and 
			DL_c.DL_error_ID is not null and
			DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID

	insert into @Lithos
	select	distinct DL_l.DL_LithoCode_ID 
	from	DL_LithoCodes DL_l
	where	DL_l.DL_error_ID is not null and
			DL_l.SurveyDataLoad_ID = @SurveyDataLoad_ID


	Select  @ReturnVal = count(distinct DL_LithoCode_ID) from @Lithos
	

	Return @ReturnVal
end


