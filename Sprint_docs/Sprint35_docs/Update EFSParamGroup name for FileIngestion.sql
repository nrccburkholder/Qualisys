/*

	Update EFSParamGroup name for FileIngestion

	Tim Butler

*/

  use DataStore

  EXEC audit.SetAuditUserContext 'tbutler', 'script'

  update [DataStore].[common].[EFSParamGroup]
	SET GroupName = 'EFS.FileIngestion'
  where GroupName = 'Prototype.FileIngestion'
