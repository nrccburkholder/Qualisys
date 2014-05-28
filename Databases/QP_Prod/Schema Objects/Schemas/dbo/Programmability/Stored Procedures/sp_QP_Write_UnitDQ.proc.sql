/****** Object:  Stored Procedure dbo.sp_QP_Write_UnitDQ    Script Date: 6/9/99 4:36:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_QP_Write_UnitDQ    Script Date: 3/12/99 4:16:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_QP_Write_UnitDQ    Script Date: 12/7/98 2:34:55 PM ******/
create procedure sp_QP_Write_UnitDQ (@studyid numeric, @surveyid numeric, @samplesetid numeric)
as 
declare @sqlstr varchar(255)
declare @snum varchar(5)
select @snum = 'S'+rtrim(convert(varchar,@studyid))
select @sqlstr = "insert into UnitDQ (study_id, survey_id, sampleUnit_id, sampleset_id, pop_id, DQRule_id) select " + rtrim(convert(varchar,@studyid)) + ", " + rtrim(convert(varchar,@surveyid)) + ", m.sampleUnit_id, " + rtrim(convert(varchar,@samplesetid)) + ", u.pop_id, u.DQRule_id from " + @snum + ".universe u, " + @snum + ".unitmembership m where u.pop_id = m.pop_id" 
execute (@sqlstr)
if @@error <> 0
 begin
  raiserror(14043, 16, -1, 'Failed to write Unit Disqualifactions')
  return(1)
 end
return(0)


