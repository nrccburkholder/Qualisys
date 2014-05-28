CREATE procedure sp_sys_MissingADEmployee
as
begin

	print 'The following studies do not have a ADEmployee_ID setup in Config Manager.'
	print ''
	print 'No response data can move to the data mart until this is set.'

	select C.strClient_nm, s.strStudy_nm 
	from study s, client c
	where c.client_ID = s.Client_ID
			and s.ADEmployee_ID is null
end


