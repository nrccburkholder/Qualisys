/*

	S36 US17 Hospice - Disavowal Disposition	As an authorized Hospice CAHPS vendor, we need to add a new disposition for Hospice Disavowal, so that we can assign & report it when appropriate.

	Tim Butler

	insert into disposition
	insert into cahpsdisposition 
	update hierarchies in cahpsdispositionmapping
	insert into cahpsdispositionmapping

*/

use nrc_datamart
go

declare @surveytype_id int
declare @cahpsdispositionid varchar(3)
declare @CMSdispositionCode int
declare @dispositionid int
declare @label varchar(100)

SET @dispositionid  = 52 /* get the disposition id from QP_Prod.Disposition -- the one we just added */

select @surveytype_id = CahpsTypeId from [dbo].[CahpsType] where label = 'Hospice CAHPS'

begin tran

SET @CMSdispositionCode = 15 --> this comes from the VALUE column in QP_PROD.SurveyTypeDispositions

SET @cahpsdispositionid = CAST(@surveytype_id as varchar(1)) + cast(@CMSdispositionCode as varchar)

if exists (select * from cahpsdispositionmapping where CahpsDispositionId = @cahpsdispositionid and CahpsTypeID = @surveytype_id and DispositionID = @dispositionid)
begin

	update t
	set Cahpshierarchy = Cahpshierarchy + 1
	from cahpsdispositionmapping t
	where CahpsTypeID =  @surveytype_id
	and CahpsHierarchy >= 4

	delete from cahpsdispositionmapping 
	where CahpsDispositionId = @cahpsdispositionid and CahpsTypeID = @surveytype_id and DispositionID = @dispositionid
end

delete from cahpsdisposition 
where CahpsDispositionID = @cahpsdispositionid

delete from Disposition
where dispositionid = @dispositionid


select *
from cahpsdisposition
where CahpsTypeID =@surveytype_id


select *
from cahpsdispositionmapping
where CahpsTypeID = @surveytype_id
order by CahpsHierarchy desc, Label

commit tran

go