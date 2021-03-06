/*
select top 1000 * from ParadoxQuestions
where core in (18952,43350)
or short like '%HCAHPS: Language mainly spoken in home%'
*/

if not exists (select 1 from qualpro_params where strparam_nm = 'LanguageSpeakQstnCore50860StartDate')
begin
	insert into qualpro_params
	select Replace(StrParam_Nm, '43350','50860'), StrParam_Type, StrParam_Grp, StrParam_Value, NumParam_Value, '2014-07-01', Replace(Comments, '43350','50860') from qualpro_params 
	where strparam_nm like '%43350%'
end
