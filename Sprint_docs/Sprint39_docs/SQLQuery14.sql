/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [LDMsgID]
      ,[Datafile_ID]
      ,[Package_ID]
      ,[intVersion]
      ,[Study_ID]
      ,[WarningMsg]
  FROM [QP_Load].[dbo].[LD_LoadWarnings]
  order by datafile_id desc


  select *
  from s4796.Encounter_load
  where HSP_NumDecd is null or ltrim(rtrim(HSP_NumDecd)) = ''''
  and datafile_id = 2016

    select *
  from s4796.Encounter_load
  where HSP_NumLiveDisch is null or ltrim(rtrim(HSP_NumLiveDisch)) = ''''
  and datafile_id = 2016

      select *
  from s4796.Encounter_load
   where HSP_NumNoPub is null or ltrim(rtrim(HSP_NumNoPub)) = ''''
  and datafile_id = 2016

  select *
  from s4796.Encounter_load
  where (HSP_NumDecd is null or ltrim(rtrim(HSP_NumDecd)) = '''')
  and datafile_id = 2016

    select *
  from s4796.Encounter_load
  where (HSP_NumLiveDisch is null or ltrim(rtrim(HSP_NumLiveDisch)) = '''')
  and datafile_id = 2016

      select *
  from s4796.Encounter_load
   where (HSP_NumNoPub is null or ltrim(rtrim(HSP_NumNoPub)) = '''')
  and datafile_id = 2016


       select *
  from s4796.Encounter_load
  where datafile_id = 2017

         select *
  from s4796.Population_load
  where datafile_id = 2017

  select *
  from Destination_View dv
  where dv.package_id = 488

  select *
  from DataFile_408088