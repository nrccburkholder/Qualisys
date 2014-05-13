if exists (select * from dbo.sysobjects where id = object_id(N'dbo.ResponseRankOrder ') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table dbo.ResponseRankOrder 
GO

create table ResponseRankOrder (qstncore int, val int, rankOrder int,
		PRIMARY KEY (qstncore, val))
