/*

S70 RTP-1672 Prioritize Qualisys-HCAHPS above RT-HCAHPS - Rollback.sql

3/7/2017

Chris Burkholder

*/

Use [QP_Prod]
GO

delete from QUALPRO_PARAMS where strparam_nm = 'SurveyRule: SamplingToolPriority - RT'

GO