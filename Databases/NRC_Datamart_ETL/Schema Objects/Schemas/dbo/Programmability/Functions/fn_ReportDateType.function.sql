CREATE FUNCTION [dbo].[fn_ReportDateType] 
	(
	@SURVEY_ID int
	)
RETURNS varchar(100)
AS
	BEGIN
	
	declare @fld varchar(100)
	
	select @fld = 
		case min(mf.strField_nm)
			when 'AdmitDate' then 'Admit Date'
			when 'DischargeDate' then 'Discharge Date'
            when 'ServiceDate' then 'Service Date'
            else 'Return Date'
		end
	  from QP_Prod.dbo.survey_def sd, QP_Prod.dbo.metatable mt, QP_Prod.dbo.metafield mf
	 where sd.strCutoffResponse_cd=2
	   and sd.cutofftable_id=mt.table_id
	   and sd.cutofffield_id=mf.field_id
	   and sd.SURVEY_ID = @SURVEY_ID
	
	RETURN @fld
	END


