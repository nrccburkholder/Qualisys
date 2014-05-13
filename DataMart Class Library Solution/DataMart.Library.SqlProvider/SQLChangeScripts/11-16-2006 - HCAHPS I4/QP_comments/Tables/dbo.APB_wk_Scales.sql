if exists (select * from dbo.sysobjects where id = object_id(N'dbo.APB_wk_Scales') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table dbo.APB_wk_Scales
GO

CREATE TABLE dbo.APB_wk_Scales (
        ScaleID           int NOT NULL,
        ResponseValue     int NOT NULL,
        strScaleLabel     varchar (256) NOT NULL,
        MinRandValue      smallint NOT NULL DEFAULT 0,
        MaxRandValue      smallint NOT NULL DEFAULT 0,
       PRIMARY KEY CLUSTERED (
        ScaleID,
        ResponseValue
       ) ON 'PRIMARY' 
) ON 'PRIMARY'
GO


CREATE NONCLUSTERED INDEX Idx_APB_wk_Scales_1
    ON dbo.APB_wk_Scales (
        ScaleID,
        MinRandValue,
        MaxRandValue,
        ResponseValue
       ) ON 'PRIMARY'
GO