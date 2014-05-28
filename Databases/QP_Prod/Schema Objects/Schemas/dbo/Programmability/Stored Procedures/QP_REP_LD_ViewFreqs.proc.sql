CREATE PROCEDURE [dbo].[QP_REP_LD_ViewFreqs] 
	@Associate			VARCHAR(50),
	@Client				VARCHAR(50),
	@Study				VARCHAR(50),
	@Package			VARCHAR(50),
	@DatLoaded			VARCHAR(50)
AS

DECLARE @DataFile INT

SELECT @DataFile=DataFile_id
FROM qloader.QP_Load.dbo.DataFile df, qloader.QP_Load.dbo.Package p, Study s, Client c
WHERE strClient_nm=@Client
AND c.Client_id=s.Client_id
AND s.Study_id=p.Study_id
AND p.strPackage_nm=@Package
AND p.Package_id=df.Package_id
AND ABS(DATEDIFF(SECOND,df.datBegin,CONVERT(DATETIME,@DatLoaded)))<=1

EXEC qloader.QP_Load.dbo.LD_ViewFreqs @DataFile


