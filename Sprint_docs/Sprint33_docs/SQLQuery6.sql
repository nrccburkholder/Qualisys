

select * 
FROM [QP_Prod].[dbo].[SiteGroup] sg
inner join [QP_Prod].[dbo].PracticeSite ps on ps.SiteGroup_ID = sg.SiteGroup_ID
inner join [QP_Prod].[dbo].SAMPLEUNIT su on su.SUFacility_ID =  ps.PracticeSite_ID



/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [QP_Prod].[dbo].[PracticeSite]
  inner join QP_Prod.dbo.SAMPLEUNIT su with (NOLOCK) on practiceSite.PracticeSite_ID = su.SUFacility_ID
  where su.CAHPSType_id  = 4 -- CGCAHPS

--PIH Physicians
--Central Maine Medical Group

update [QP_Prod].[dbo].[SampleUnit]
SET [CAHPSType_id] = [CAHPSType_id]
where SAMPLEUNIT_ID in (
111292,
190181
)

/*



  UPDATE [QP_Prod].[dbo].[SiteGroup]
   SET [bitActive] = bitActive

UPDATE sg
	SET sg.[bitActive] = sg.bitActive
FROM [QP_Prod].[dbo].[SiteGroup] sg
inner join [QP_Prod].[dbo].PracticeSite ps on ps.SiteGroup_ID = sg.SiteGroup_ID
inner join [QP_Prod].[dbo].SAMPLEUNIT su on su.SUFacility_ID =  ps.PracticeSite_ID

  UPDATE [QP_Prod].[dbo].[PracticeSite]
   SET [bitActive] = bitActive

*/

   select *
from NRC_DataMart_ETL.dbo.ExtractQueue
where [source] = 'trg_NRC_DataMart_ETL_dbo_PracticeSite'
order by Created desc




select *
  FROM [QP_Prod].[dbo].[PracticeSite] ps
  inner join [QP_Prod].[dbo].SAMPLEUNIT su on su.SUFacility_ID =  ps.PracticeSite_ID


 

    select *
from NRC_DataMart_ETL.dbo.ExtractQueue
where [source] = 'trg_NRC_DataMart_ETL_dbo_SiteGroup'
order by Created desc




 