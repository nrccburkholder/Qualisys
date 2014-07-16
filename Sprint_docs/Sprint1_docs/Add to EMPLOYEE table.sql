select * from employee where stremployee_last_nm like '%Fivash%' --930 

select * from employee where STREMPLOYEE_LAST_NM like '%willey%' 

select * from STUDY_EMPLOYEE where employee_id = 24073

select * from STUDY_EMPLOYEE where employee_id = 24076

/*

INSERT INTO [dbo].[STUDY_EMPLOYEE](EMPLOYEE_ID, Study_ID)
select 24076, STUDY_ID from STUDY_EMPLOYEE where employee_id = 24073

*/

--select * from employee where STREMPLOYEE_LAST_NM like '%butler%' 

/*

INSERT INTO [dbo].[EMPLOYEE]
           ([STREMPLOYEE_FIRST_NM]
           ,[STREMPLOYEE_LAST_NM]
           ,[STREMPLOYEE_TITLE]
           ,[STRNTLOGIN_NM]
           ,[strPhoneExt]
           ,[strEmail]
           ,[FullAccess]
           ,[Dashboard_FullAccess]
           ,[bitActive]
           ,[role_id]
           ,[Country_id])
     VALUES
           ('Josh'
           ,'Butler'
           ,'QS'
           ,'Willey'
           ,'x2516'
           ,'jwilley@nationalresearch.com'
           ,1
           ,0
           ,1
           ,0
           ,1)

*/


/*

update [dbo].[EMPLOYEE]
	SET [STREMPLOYEE_LAST_NM] = 'Willey',
	[STRNTLOGIN_NM] = 'jwilley'
where employee_id = 24076

*/