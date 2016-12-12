/*

S63 ATL-1183 PullSubmissionData_Questionnaire.sql

Lanny Boswell

12/9/2016

create procedure CIHI.PullSubmissionData_Questionnaire

*/

use QP_Prod
go

if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_Questionnaire')
       drop procedure CIHI.PullSubmissionData_Questionnaire
go