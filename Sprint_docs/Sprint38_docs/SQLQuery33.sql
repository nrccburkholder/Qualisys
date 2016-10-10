

DECLARE @subscriber varchar(20) = 'DIEFSSQL02'

EXEC sp_dropsubscription 'EFS_DataStore','EpisodeProvider',@subscriber,'ExtractDataStore'

 exec sp_droparticle 
	@publication = 'EFS_DataStore'
	, @article = 'EpisodeProvider'


EXEC sp_dropsubscription 'EFS_DataStore','ResponseScaleOption',@subscriber,'ExtractDataStore'

  exec sp_droparticle 
	@publication = 'EFS_DataStore'
	, @article = 'ResponseScaleOption'


 /*
	The table alter code goes here.
 */


exec sp_addarticle @publication = N'EFS_DataStore', 
	@article = N'EpisodeProvider', 
	@source_owner = N'pe', 
	@source_object = N'EpisodeProvider', 
	@type = N'logbased', @description = N'', 
	@creation_script = N'', 
	@pre_creation_cmd = N'drop', 
	@schema_option = 0x000000000803509F, 
	@identityrangemanagementoption = N'none', 
	@destination_table = N'EpisodeProvider', 
	@destination_owner = N'pe', 
	@status = 24, 
	@vertical_partition = N'false', 
	@ins_cmd = N'CALL [sp_MSins_peEpisodeProvider]',
	@del_cmd = N'CALL [sp_MSdel_peEpisodeProvider]', 
	@upd_cmd = N'SCALL [sp_MSupd_peEpisodeProvider]'


EXEC sp_addsubscription 'EFS_DataStore','EpisodeProvider',@subscriber,'ExtractDataStore'

exec sp_addarticle @publication = N'EFS_DataStore', 
	@article = N'ResponseScaleOption', 
	@source_owner = N'element', 
	@source_object = N'ResponseScaleOption', 
	@type = N'logbased', 
	@description = N'', 
	@creation_script = N'', 
	@pre_creation_cmd = N'drop',
    @schema_option = 0x000000000803509F, 
	@identityrangemanagementoption = N'none', 
	@destination_table = N'ResponseScaleOption', 
	@destination_owner = N'element', 
	@status = 24, 
	@vertical_partition = N'false', 
	@ins_cmd = N'CALL [sp_MSins_elementResponseScaleOption]', 
	@del_cmd = N'CALL [sp_MSdel_elementResponseScaleOption]', 
	@upd_cmd = N'SCALL [sp_MSupd_elementResponseScaleOption]'

EXEC sp_addsubscription 'EFS_DataStore','ResponseScaleOption',@subscriber,'ExtractDataStore'


