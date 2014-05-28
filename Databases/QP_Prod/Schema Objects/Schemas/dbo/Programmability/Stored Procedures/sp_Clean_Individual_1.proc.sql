--Drop proc sp_Clean_Individual_1
CREATE Procedure sp_Clean_Individual_1
as
set nocount on 

declare @questionform_id as int
declare @samplepop_id as int
declare @sentmail_id as int
declare @Ident as int

while @Ident < (select max(Ident) from delPCLNeeded) 
   begin
	--select @questionform_id = questionform_id, @samplepop_id = samplepop_id, 
	--@sentmail_id = sentmail_id 
 	select *
	from delpclneeded (NoLock)
	where Ident = @Ident

	/*begin transaction
	delete si
	from scls_individual si 
	where si.questionform_id = @questionform_id
	commit transaction

	begin transaction
	delete ti
	from textbox_individual ti
	where ti.sentmail_id = @sentmail_id
	commit transaction

	begin transaction 
	delete qi
	from qstns_individual qi
	where qi.questionform_id = @questionform_id
	commit transaction */

	select @Ident = @Ident + 1
 end


