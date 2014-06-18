use [QP_Prod]

delete 
--select *
from qualpro_params where StrParam_GRP in 
(select 'SurveyRules' union select SurveyType_dsc from SurveyType)


insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - HCAHPS IP','S','HCAHPS IP','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - Home Health CAHPS','S','Home Health CAHPS','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - CGCAHPS','S','CGCAHPS','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - ACOCAHPS','S','ACOCAHPS','1','Rule to determine if this is a CAHPS survey type for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsCAHPS - ICHCAHPS','S','ICHCAHPS','1','Rule to determine if this is a CAHPS survey type for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsMonthlyOnly - HCAHPS IP','S','HCAHPS IP','1','Rule to determine if survey type is Monthly only for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsMonthlyOnly - Home Health CAHPS','S','Home Health CAHPS','1','Rule to determine if survey type is Monthly only for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault - Canada','S','Canada','Specify Outgo','Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault - ACOCAHPS','S','ACOCAHPS','Census','Rule to set default sampling method for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingMethodDefault','S','SurveyRules','Specify Targets','Rule to set default sampling method for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsSamplingMethodDisabled - ACOCAHPS','S','ACOCAHPS','1','Rule to determine if sampling method is enabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SamplingAlgorithmDefault','S','SurveyRules','StaticPlus','Default sampling algorithm')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - HCAHPS IP','S','HCAHPS IP','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - Home Health CAHPS','S','Home Health CAHPS','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - CGCAHPS','S','CGCAHPS','1','Skip Enforcement is required and controls are not enabled in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: SkipEnforcementRequired - ICHCAHPS','S','ICHCAHPS','1','Skip Enforcement is required and controls are not enabled in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: RespRateRecalcDaysNumericDefault','N','SurveyRules',14,'Default Recalc Days in Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: RespRateRecalcDaysNumericDefault - Home Health CAHPS','N','Home Health CAHPS',45,'HHCAHPS Default Recalc Days in Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault','S','SurveyRules','NumberOfDays','Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault - HCAHPS IP','S','HCAHPS IP','CalendarMonths','HCAHPS Resurvey method default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyMethodDefault - Home Health CAHPS','S','Home Health CAHPS','CalendarMonths','HHCAHPS Resurvey method default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault','N','SurveyRules',90,'Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - HCAHPS IP','N','HCAHPS IP',1,'HCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Home Health CAHPS','N','Home Health CAHPS',6,'HHCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Physician','N','Physician',365,'Physician Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Employee','N','Employee',365,'Employee Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - ACOCAHPS','N','ACOCAHPS',0,'ACOCAHPS Resurvey Exclusion Days default for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: ResurveyExclusionPeriodsNumericDefault - ICHCAHPS','N','ICHCAHPS',0,'ICHACOCAHPS Resurvey Exclusion Days default for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ACOCAHPS','S','ACOCAHPS','1','ACOCAHPS Resurvey Exclusion Days disabled for Config Man')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ICHCAHPS','S','ICHCAHPS','1','ACOCAHPS Resurvey Exclusion Days disabled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: HasReportability - HCAHPS IP','S','HCAHPS IP','1','HCAHPS has reportability for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: NotEditableIfSampled - HCAHPS IP','S','HCAHPS IP','1','HCAHPS not editable if sampled for Config Man')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyMethodDisabled - CGCAHPS','S','CGCAHPS','1','Resurvey Method is disabled for MNCM/CGCAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: IsResurveyMethodDisabled - NRC/Picker','S','NRC/Picker','1','Resurvey Method is disabled for NRCPicker')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: MedicareIdTextMayBeBlank - CGCAHPS','S','CGCAHPS','1','Medicare Id Text May Be Blank for CGCAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: MedicareIdTextMayBeBlank - ACOCAHPS','S','ACOCAHPS','1','Medicare Id Text May Be Blank for ACOCAHPS')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: CompliesWithSwitchToPropSamplingDate - HCAHPS IP','S','HCAHPS IP','1','Complies With Switch To Prop Sampling Date for HCAHPS IP')

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS) VALUES
('SurveyRule: BypassInitRespRateNumericEnforcement - HCAHPS IP','S','HCAHPS IP','1','Bypass Init Resp Rate Numeric Enforcement for HCAHPS IP')
