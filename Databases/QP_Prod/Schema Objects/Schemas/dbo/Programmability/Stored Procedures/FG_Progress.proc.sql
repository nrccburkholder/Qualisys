CREATE PROCEDURE FG_Progress
AS
SELECT RowCnt, si.name FROM TempDB.dbo.sysobjects so(NOLOCK), TempDB.dbo.sysindexes si(NOLOCK) WHERE (so.name LIKE '#bvuk%' OR so.name LIKE '#pop%') AND so.id=si.id AND si.indid IN (0,1)


