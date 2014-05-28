CREATE procedure sp_bd_temp 
as

select @@options

exec ('set quoted_identifier off select @@options')


