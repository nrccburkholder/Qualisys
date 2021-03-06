/****** Object:  StoredProcedure [dbo].[copy_criteria]    Script Date: 08/09/2006 13:21:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[copy_criteria]
GO
/****** Object:  StoredProcedure [dbo].[copy_criteria]    Script Date: 08/09/2006 13:21:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure copy_criteria(
 @fromCriteriaID int,
 @newCriteriaID int output)
AS

/* this guy will copy criteria 
It will also copy the sub-criteria underneath. */

/* test code:

rollback
select * from criteria
begin tran
declare @x int
exec dbo.copy_criteria 9,@x output
select @x
select * from criteria

*/


begin


create table #copy_criteria (fromID int primary key,toid int)
/* copy_criteria is used to store the mapping and keep track of what sub criteria we should look for */

/* copy the top level criteria */
insert into Criteria(CriteriaName,SurveyID,CriteriaTypeID,AnswerCategoryID,CriteriaDataTypeID,
  ParameterName,TextValue,ReferenceCriteriaID,ReferenceCriteriaSequence,flag,lvl,Hierarchy)
select  null,SurveyID,CriteriaTypeID,AnswerCategoryID,CriteriaDataTypeID,
  ParameterName,TextValue,ReferenceCriteriaID,ReferenceCriteriaSequence,flag,lvl,hierarchy
from criteria 
where criteriaID = @fromCriteriaID

set @newCriteriaID = @@identity

/* populate into copy_criteria for a look */
insert into #copy_criteria(fromID,toID)
values (@fromCriteriaID,@newCriteriaID)

declare criteriatodo cursor for select fromid,toid 
from #copy_criteria

declare @fromID int -- top level criteria old id
declare @toID int -- top level criteria new id

declare @newfrom int -- new sub criteria old id
declare @newto int   -- new sub criteria new id


/* while we have criteria to look at -- to find subcriteria */
open criteriaToDo 
fetch criteriaToDo into @fromID,@toID
while (@@fetch_Status = 0)
  begin
  declare subcriteria cursor for select criteriaid
  from criteria
  where ReferenceCriteriaID = @fromID
  order by ReferenceCriteriaSequence;


  /* while there are subcriteria for this criteria */
  open subcriteria
  fetch subcriteria into @newFrom
  while (@@fetch_status = 0)
    begin
    /* add the subcriteria */
    insert into Criteria(CriteriaName,SurveyID,CriteriaTypeID,AnswerCategoryID,CriteriaDataTypeID,
      ParameterName,TextValue,ReferenceCriteriaID,ReferenceCriteriaSequence,flag,lvl,Hierarchy)
    select  null,SurveyID,CriteriaTypeID,AnswerCategoryID,CriteriaDataTypeID,
      ParameterName,TextValue,@toID,ReferenceCriteriaSequence,flag,lvl,hierarchy
    from criteria 
    where criteriaID = @newFrom
    
    set @newto = @@identity
    
    /* put the subcriteria into copy_criteria -- as we will have to check this criteria for its own subcriteria */
    insert into #copy_criteria(fromID,toID)
    values (@newFrom,@newTo)
     
    fetch subcriteria into @newFrom
    end
  close subcriteria
  deallocate subcriteria

  delete from #copy_criteria where fromID = @fromID
  fetch criteriaToDo into @fromID,@toID
  end
close criteriaToDo
Deallocate criteriaToDo  

drop table #copy_criteria
end


' 
END
GO
