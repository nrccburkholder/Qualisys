/*

S39 US 17 T4 Test Prints for all Hospice

Task 17.4 Run Test prints for the affected surveys as follows: 

I had used the following, with �1,2� indicating to send the first two mail steps, if I understand it correctly

Chris Burkholder

*/


select 'exec sp_TESTPrints '+convert(varchar,cssv.survey_id) +', ''DC'', ''DC'',1,0,1,''1,2'',930,''CBurkholder@NationalResearch.com''' from ClientStudySurvey_view cssv
inner join survey_def sd on sd.survey_id = cssv.survey_id where surveytype_id = 11 --Hospice
and clientActive = 1 and studyactive = 1 and surveyactive = 1
and strclient_nm not like 'xx%'
and cssv.strsurvey_nm not like 'xx%'
and strstudy_nm not like 'xx%'

/* --below was run against production on 12/11/2015
exec sp_TESTPrints 17371, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17372, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17373, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17374, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17391, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17405, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17419, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17422, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17423, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17424, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17425, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17426, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17427, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17428, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17429, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17430, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17431, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17432, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17433, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17434, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17435, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17438, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17439, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17440, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17441, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17442, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17443, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17444, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17445, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17446, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17447, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17448, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17449, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17450, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17451, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17452, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17453, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17454, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17455, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17456, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17457, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17458, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17459, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17460, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17462, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17463, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17464, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17467, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17468, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17471, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17472, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17473, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17474, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17475, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17477, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17478, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17510, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17515, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17516, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17517, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17518, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17527, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17528, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17530, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17535, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17537, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17539, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17540, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17544, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17553, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17554, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17566, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17575, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17586, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17588, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17602, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17603, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17604, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17606, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17624, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17625, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17627, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17635, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17660, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17663, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 17765, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 18060, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 18136, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
exec sp_TESTPrints 18734, 'DC', 'DC',1,0,1,'1,2',711,'rbeavers@nrcpicker.com'
*/

--select * from surveytype