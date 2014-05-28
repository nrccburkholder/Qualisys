create procedure APLan_MakeMRD
@cutoff_id integer, @tablename varchar(50) = null
as
exec sp_export_newmrd3 @Cutoff_id, 1, 0, @tablename


