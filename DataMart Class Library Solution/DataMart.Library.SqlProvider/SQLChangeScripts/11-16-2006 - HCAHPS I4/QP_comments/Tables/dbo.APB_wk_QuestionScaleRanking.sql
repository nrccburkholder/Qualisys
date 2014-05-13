if exists (select * from dbo.sysobjects where id = object_id(N'dbo.APB_wk_QuestionScaleRanking ') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table dbo.APB_wk_QuestionScaleRanking 
GO

CREATE TABLE dbo.APB_wk_QuestionScaleRanking (
        Qstncore 	  int NOT NULL,
        ResponseValue     int NOT NULL,
        strScaleLabel     varchar (256) NOT NULL,
        max_RankOrder    int NULL,
        RankOrder         int NULL
       PRIMARY KEY CLUSTERED (
        Qstncore,
        ResponseValue
       ) ON 'PRIMARY' 
) ON 'PRIMARY'
GO