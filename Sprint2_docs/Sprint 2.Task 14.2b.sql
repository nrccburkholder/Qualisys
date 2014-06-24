/*
Story 14: As an Authorized Vendor, we want to calculate if a returned survey is complete per the ICH-CAHPS definition, so that we 
can correctly report the final disposition
Task 14.2: Refactor the procedure in the Medusa etl that uses the function so the function can be dropped.
*/
use qp_comments
go
alter procedure dbo.ACOCAHPS_FixDispositions
as
if object_id('tempdb..#aco') is not null
	drop table #aco

select sp.SAMPLEPOP_ID, sp.study_id
, convert(tinyint,null) as ATACnt, convert(tinyint,null) as ATAComplete, convert(tinyint,null) as MeasuresCnt, convert(tinyint,null) as MeasuresComplete
, convert(tinyint,null) as ACODisposition, convert(tinyint,null) as RecalcACODisposition, convert(varchar(50), NULL) as TableName
into #aco
from qualisys.qp_prod.dbo.samplepop sp
inner join qualisys.qp_prod.dbo.sampleset ss on sp.sampleset_id=ss.sampleset_id
inner join qualisys.qp_prod.dbo.survey_def sd on ss.survey_id=sd.survey_id
where sd.surveytype_id=10
order by sp.samplepop_id

exec dbo.ACODispositionRecalc 

select * from #aco

-- update #aco set acodisposition=null, tablename=null
declare @SQL nvarchar(max)

/*
-- updating the ACODisposition column in #ACO isn't necessary, but if you want to look at what the BT.ACODisposition values are before you update them, this is how you do it:
set @SQL = ''
select @SQL = @SQL + '
update a set ACODisposition=bt.ACODisposition
from #aco a
inner join s'+convert(varchar,study_id)+'.big_table_'+tablename+' bt on a.samplepop_id=bt.samplepop_id'
from (select distinct study_id, tablename from #aco where tablename is not null) x

exec sp_executesql @SQL
*/

set @SQL = ''
select @SQL = @SQL + '
update bt set ACODisposition=a.RecalcACODisposition
from #aco a
inner join s'+convert(varchar,study_id)+'.big_table_'+tablename+' bt on a.samplepop_id=bt.samplepop_id where isnull(bt.ACODisposition,255)<>isnull(a.RecalcACODisposition,255)'
from (select distinct study_id, tablename from #aco where tablename is not null) x

exec sp_executesql @SQL

drop table #ACO
go
alter procedure [dbo].[ACODispositionRecalc] 
@Samplepop_id INT, @Disposition tinyint OUTPUT, @Verbose bit = 0
AS
BEGIN
	-- declare @samplepop_id int set @samplepop_id=95467168
	DECLARE @ATACnt INT, @Cnt INT, @ATAComplete bit, @MeasuresComplete bit, @study varchar(10), @SQL nvarchar(max), @Qtr varchar(10)

	set @sql=''
	select @SQL = @SQL + '
	update a set tablename=right(bt.tablename,6)
	from #aco a 
	inner join s'+convert(varchar,study_id)+'.big_table_view bt on a.samplepop_id=bt.samplepop_id'
	from (	select distinct study_id
			from #aco a
			inner join sys.schemas ss on ss.name='s'+convert(varchar,a.study_id)
			inner join sys.views sv on ss.schema_id=sv.schema_id
			where sv.name='Big_Table_View') S
	
	exec sp_executesql @SQL
	
	if object_id('tempdb..#QR') is not null
		drop table #QR
		
	create table #QR (samplepop_id int, qstncore int, intResponseVal int, VertVal int)
	
	set @sql=''
	select @sql=@SQL+'
	insert into #QR (samplepop_id, qstncore, intResponseVal) select sr.samplepop_id, '+replace(sc.name,'Q','')+','+sc.name+' from '+ss.name+'.'+st.name+' sr inner join #ACO a on sr.samplepop_id=a.samplepop_id;'
	from (select distinct study_id, tablename from #ACO where tablename is not null) a 
	inner join sys.schemas ss on ss.name='s'+convert(varchar,a.study_id)
	inner join sys.tables st on ss.schema_id=st.schema_id
	inner join sys.columns sc on st.object_id=sc.object_id
	where st.name='study_results_'+a.tablename
	and sc.name in ('Q050175', 'Q050176', 'Q050177', 'Q050178', 'Q050179', 'Q050180', 'Q050181', 'Q050182', 'Q050183', 'Q050184', 'Q050185', 'Q050186', 'Q050187', 'Q050189', 'Q050190', 
			'Q050191', 'Q050192', 'Q050193', 'Q050194', 'Q050195', 'Q050196', 'Q050197', 'Q050198', 'Q050200', 'Q050201', 'Q050202', 'Q050203', 'Q050209', 'Q050210', 'Q050211', 'Q050212', 
			'Q050213', 'Q050214', 'Q050215', 'Q050216', 'Q050217', 'Q050218', 'Q050220', 'Q050221', 'Q050222', 'Q050223', 'Q050224', 'Q050225', 'Q050226', 'Q050229', 'Q050230', 'Q050231', 
			'Q050232', 'Q050233', 'Q050234', 'Q050235', 'Q050236', 'Q050237', 'Q050238', 'Q050239', 'Q050240', 'Q050241', 'Q050243', 'Q050245', 'Q050247', 'Q050248', 'Q050249', 'Q050250', 
			'Q050251', 'Q050252', 'Q050253', 'Q050255', 'Q050256', 'Q050699', 'Q050700', 'Q050725', 'Q050726', 'Q050727', 'Q050728', 'Q050729', 'Q050730', 'Q050731', 'Q050732', 'Q050733', 
			'Q050734', 'Q050735', 'Q050736', 'Q050737', 'Q050738', 'Q050739', 'Q050740')
	exec sp_executesql @SQL

	set @SQL=''
	select @SQL = @SQL + '
	update qr
	set vertval=v.intResponseVal
	from #qr qr
	inner join s'+convert(varchar,study_id)+'.study_results_vertical_'+tablename+' v on v.samplepop_id=qr.samplepop_id and qr.QstnCore=v.qstncore'
	from (select distinct study_id, tablename from #aco where tablename is not null) x
	
	exec sp_executesql @SQL
	
	if exists (select * from #QR where intresponseval<>vertval)
	begin
		select * from #QR where intresponseval<> vertval
		RAISERROR (N'vertical doesn''t match horizontal for one or more samplepops.', -- Message text.
           10, -- Severity,
            1); -- State,           
	end
	
	
	with ACO_cte (samplepop_id, ACOCAHPSValue, ACOCAHPSHierarchy)
	as (select a.samplepop_id, ad.ACOCAHPSValue, ad.ACOCAHPSHierarchy
		from #ACO a 
		inner join dispositionlog dl on dl.samplepop_id=a.samplepop_id
		inner join acocahpsdispositions ad on dl.disposition_id=ad.disposition_id
		where ad.ACOCAHPSValue not in (10,31,33,34)
		and a.samplepop_id not in (select samplepop_id from #qr)
		)		
	update a set RecalcACODisposition=cte.ACOCAHPSValue
	from #aco a
	inner join ACO_cte cte on a.samplepop_id=cte.samplepop_id
	inner join (select samplepop_id, min(ACOCAHPSHierarchy) as minACOCAHPSHierarchy
				from ACO_cte
				group by samplepop_id) sub
		on cte.samplepop_id=sub.samplepop_id and cte.ACOCAHPSHierarchy=sub.minACOCAHPSHierarchy

	-- Non-response when there is not indication of bad address or telephone number			
	update #aco
	set RecalcACODisposition=33 
	where samplepop_id not in (select samplepop_id from #qr)
	and RecalcACODisposition is null
	and tablename is not null

		
	update #QR set intResponseVal=intResponseVal%10000  -- get rid of the ETL's skip enforcement.

	-- the rest of the code is copied from qp_prod.dbo.ACOCAHPSCompleteness, except 
	-- * the #ACOQF table has been changed to #ACO 
	-- * questionform_id has been changed to samplepop_id
	-- * Disposition has been changed to RecalcACODisposition
	-- * this version already has RecalcACODisposition populated for non-returns, so the assignment of RecalcACOdisposition=255 is a little different
	update #ACO set ATAcnt=0, ATAcomplete=0, MeasuresCnt=0, MeasuresComplete=0

	update #ACO set RecalcACOdisposition=255
	from #ACO qf
	left join #QR qr on qf.samplepop_id=qr.samplepop_id
	where qr.samplepop_id is null
	and RecalcACOdisposition is null
		
	-- if Q1 invokes the skip, ignore questions 5 through 43
	delete q2_43 
	from #QR q1
	inner join #QR q2_43 on q1.samplepop_id=q2_43.samplepop_id	
	where q1.qstncore=50175 and q1.intresponseval in (2,-5,-6,-8,-9)
	and q2_43.qstncore in (
						50176, --02		Q2. Is this the provider you usually see if you need a check-up want advice about a health problem or get sick or hurt?
						50177, --03		Q3. How long have you been going to this provider?
						50178, --04		Q4. In the last 6 months how many times did you visit this provider to get care for yourself? 
						50179, --05		Q5. In the last 6 months did you phone this providers office to get an appointment for an illness injury or condition that needed care right away? 
						50181, --06		Q7. In the last 6 months did you make any appointments for a check-up or routine care with this provider?
						50183, --07		Q9. In the last 6 months did you phone this providers office with a medical question during regular office hours?
						50185, --08		Q11. In the last 6 months did you phone this providers office with a medical question after regular office hours?
						50187, --09		Q13. Some offices remind patients about tests treatment or appointments in between their visits. In the last 6 months did you get any reminders from this providers office between visits?
						50189, --10		Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
						50190, --11		Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
						50191, --12		Q17. In the last 6 months how often did this provider listen carefully to you?
						50192, --13		Q18. In the last 6 months did you talk with this provider about any health questions or concerns?
						50194, --14		Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
						50195, --15		Q21. When you visited this provider in the last 6 months how often did he or she have your medical records?
						50196, --16		Q22. In the last 6 months how often did this provider show respect for what you had to say?
						50197, --17		Q23. In the last 6 months how often did this provider spend enough time with you?
						50198, --18		Q24. In the last 6 months did this provider order a blood test x-ray or other test for you?
						50200, --19		Q26. In the last 6 months did you and this provider talk about starting or stopping a prescription medicine?
						50209, --20		Q35. In the last 6 months did you and this provider talk about having surgery or any type of procedure?
						50213, --21		Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
						50214, --22		Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
						50215, --23		Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
						50216, --24		Q42. In the last 6 months how often were clerks and receptionists at this providers office as helpful as you thought they should be?
						50217  --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
						)
						
	-- if Q4 invokes the skip, ignore questions 5 through 43
	delete q5_43
	from #QR q4
	inner join #QR q5_43 on q4.samplepop_id=q5_43.samplepop_id	
	where q4.qstncore=50178 and q4.intresponseval in (0,-5,-6,-8,-9)
	and q5_43.qstncore in (
						50179, --05		Q5. In the last 6 months did you phone this providers office to get an appointment for an illness injury or condition that needed care right away? 
						50181, --06		Q7. In the last 6 months did you make any appointments for a check-up or routine care with this provider?
						50183, --07		Q9. In the last 6 months did you phone this providers office with a medical question during regular office hours?
						50185, --08		Q11. In the last 6 months did you phone this providers office with a medical question after regular office hours?
						50187, --09		Q13. Some offices remind patients about tests treatment or appointments in between their visits. In the last 6 months did you get any reminders from this providers office between visits?
						50189, --10		Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
						50190, --11		Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
						50191, --12		Q17. In the last 6 months how often did this provider listen carefully to you?
						50192, --13		Q18. In the last 6 months did you talk with this provider about any health questions or concerns?
						50194, --14		Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
						50195, --15		Q21. When you visited this provider in the last 6 months how often did he or she have your medical records?
						50196, --16		Q22. In the last 6 months how often did this provider show respect for what you had to say?
						50197, --17		Q23. In the last 6 months how often did this provider spend enough time with you?
						50198, --18		Q24. In the last 6 months did this provider order a blood test x-ray or other test for you?
						50200, --19		Q26. In the last 6 months did you and this provider talk about starting or stopping a prescription medicine?
						50209, --20		Q35. In the last 6 months did you and this provider talk about having surgery or any type of procedure?
						50213, --21		Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
						50214, --22		Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
						50215, --23		Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
						50216, --24		Q42. In the last 6 months how often were clerks and receptionists at this providers office as helpful as you thought they should be?
						50217  --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
						)
	-- the flu shot questions are a series of three yes/no questions, but they only count as a single question for completeness.					
	update #QR set qstncore=50231 where qstncore in (50232,50233)
	
	-- the race question on the phone survey is a series of 16 yes/no questions, but they only count as a single question for completeness.					
	update #QR set qstncore=50725 where qstncore between 50726 and 50740
	
	update qf
	set ATAcnt=sub.cnt, ATAcomplete=case when sub.cnt >= (53 * 0.50) then 1 else 0 end
	from #ACO qf
	inner join (SELECT samplepop_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
					50175, --01	Q1. Our records show that you visited the provider named below in the last 6 months. Is that right?
					50176, --02		Q2. Is this the provider you usually see if you need a check-up want advice about a health problem or get sick or hurt?
					50177, --03		Q3. How long have you been going to this provider?
					50178, --04		Q4. In the last 6 months how many times did you visit this provider to get care for yourself? 
					50179, --05		Q5. In the last 6 months did you phone this providers office to get an appointment for an illness injury or condition that needed care right away? 
					50181, --06		Q7. In the last 6 months did you make any appointments for a check-up or routine care with this provider?
					50183, --07		Q9. In the last 6 months did you phone this providers office with a medical question during regular office hours?
					50185, --08		Q11. In the last 6 months did you phone this providers office with a medical question after regular office hours?
					50187, --09		Q13. Some offices remind patients about tests treatment or appointments in between their visits. In the last 6 months did you get any reminders from this providers office between visits?
					50189, --10		Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
					50190, --11		Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
					50191, --12		Q17. In the last 6 months how often did this provider listen carefully to you?
					50192, --13		Q18. In the last 6 months did you talk with this provider about any health questions or concerns?
					50194, --14		Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
					50195, --15		Q21. When you visited this provider in the last 6 months how often did he or she have your medical records?
					50196, --16		Q22. In the last 6 months how often did this provider show respect for what you had to say?
					50197, --17		Q23. In the last 6 months how often did this provider spend enough time with you?
					50198, --18		Q24. In the last 6 months did this provider order a blood test x-ray or other test for you?
					50200, --19		Q26. In the last 6 months did you and this provider talk about starting or stopping a prescription medicine?
					50209, --20		Q35. In the last 6 months did you and this provider talk about having surgery or any type of procedure?
					50213, --21		Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
					50214, --22		Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
					50215, --23		Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
					50216, --24		Q42. In the last 6 months how often were clerks and receptionists at this providers office as helpful as you thought they should be?
					50217, --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
					50218, --26		Q44. Specialists are doctors like surgeons heart doctors allergy doctors skin doctors and other doctors who specialize in one area of health care. Is the provider named in Question 1 of this Survey a specialist?
					50222, --27		Q48. Your health care team includes all the doctors nurses and other people you see for health care. In the last 6 months did you and anyone on your health care team talk about specific things you could do to prevent illness?
					50223, --28		Q49. In the last 6 months did you and anyone on your health care team talk about a healthy diet and healthy eating habits?
					50224, --29		Q50. In the last 6 months did you and anyone on your health care team talk about the exercise or physical activity you get?
					50225, --30		Q51. In the last 6 months did anyone on your health care team talk with you about specific goals for your health?
					50226, --31		Q52. In the last 6 months did you take any prescription medicine?
					50229, --32		Q55. In the last 6 months did anyone on your health care team ask you if there was a period of time when you felt sad empty or depressed?
					50230, --33		Q56. In the last 6 months did you and anyone on your health care team talk about things in your life that worry you or cause you stress?
					50231, --34		Q57A – 57C*. Since August 1 2013 did anyone on your health care team… -- these three questions are treated as a single question
					50234, --35		Q58. In general how would you rate your overall health?
					50235, --36		Q59. In general how would you rate your overall mental or emotional health?
					50236, --37		Q60. In the last 12 months have you seen a doctor or other health provider 3 or more times for the same condition or problem?
					50238, --38		Q62. Do you now need or take medicine prescribed by a doctor?
					50240, --39		Q64. During the last 4 weeks how much of the time did your physical health interfere with your social activities (like visiting with friends relatives etc.)?
					50241, --40		Q65. What is your age?
					50699, --41		Q66. Are you male or female?
					50243, --42		Q67. What is the highest grade or level of school that you have completed?
					50700, --43		Q68. How well do you speak English?
					50245, --44		Q69. Do you speak a language other than English at home?
					50247, --45		Q71. Are you deaf or do you have serious difficulty hearing?
					50248, --46		Q72. Are you blind or do you have serious difficulty seeing even when wearing glasses?
					50249, --47		Q73. Because of a physical mental or emotional condition do you have serious difficulty concentrating remembering or making decisions?
					50250, --48		Q74. Do you have serious difficulty walking or climbing stairs?
					50251, --49		Q75. Do you have difficulty dressing or bathing?
					50252, --50		Q76. Because of a physical mental or emotional condition do you have difficulty doing errands alone such as visiting a doctors office or shopping?
					50253, --51		Q77. Are you of Hispanic Latino or Spanish origin?
					50255, --52		Q79A – 79E4*. What is your race? (mail Survey)
					50725, --52		Q79A – 79E4*. What is your race? (phone Survey)	-- phone race question dealt with in the below IF EXISTS() query.
					50256  --53		Q80. Did someone help you complete this Survey?
					)
				group by samplepop_id) sub
		on qf.samplepop_id=sub.samplepop_id

	update qf
	set MeasuresCnt=sub.cnt, MeasuresComplete=case when sub.cnt >= 1 then 1 else 0 end
	from #ACO qf
	inner join (SELECT samplepop_id, COUNT(distinct qstncore) as cnt
				FROM #QR
				WHERE intResponseVal >= 0
				AND QstnCore IN (
					50180, -- Q6. In the last 6 months when you phoned this providers office to get an appointment for care you needed right away how often did you get an appointment as soon as you needed?
					50182, -- Q8. In the last 6 months when you made an appointment for a check-up or routine care with this provider how often did you get an appointment as soon as you needed?
					50184, -- Q10. In the last 6 months when you phoned this providers office during regular office hours how often did you get an answer to your medical question that same day?
					50186, -- Q12. In the last 6 months when you phoned this providers office after regular office hours how often did you get an answer to your medical question as soon as you needed?
					50189, -- Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
					50190, -- Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
					50191, -- Q17. In the last 6 months how often did this provider listen carefully to you?
					50193, -- Q19. In the last 6 months how often did this provider give you easy to understand information about these health questions or concerns?
					50194, -- Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
					50196, -- Q22. In the last 6 months how often did this provider show respect for what you had to say?
					50197, -- Q23. In the last 6 months how often did this provider spend enough time with you?
					50201, -- Q27. Did you and this provider talk about the reasons you might want to take a medicine?
					50202, -- Q28. Did you and this provider talk about the reasons you might not want to take a medicine?
					50203, -- Q29. When you and this provider talked about starting or stopping a prescription medicine did this provider ask what you thought was best for you?
					50210, -- Q36. Did you and this provider talk about the reasons you might want to have the surgery or procedure?
					50211, -- Q37. Did you and this provider talk about the reasons you might not want to have the surgery or procedure?
					50212, -- Q38. When you and this provider talked about having surgery or a procedure did this provider ask what you thought was best for you?
					50213, -- Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
					50214, -- Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
					50215, -- Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
					50220, -- Q46. In the last 6 months how often was it easy to get appointments with specialists?
					50221, -- Q47. In the last 6 months how often did the specialist you saw most seem to know the important information about your medical history?
					50222, -- Q48. Your health care team includes all the doctors nurses and other people you see for health care. In the last 6 months did you and anyone on your health care team talk about specific things you could do to prevent illness?
					50223, -- Q49. In the last 6 months did you and anyone on your health care team talk about a healthy diet and healthy eating habits?
					50224, -- Q50. In the last 6 months did you and anyone on your health care team talk about the exercise or physical activity you get?
					50225, -- Q51. In the last 6 months did anyone on your health care team talk with you about specific goals for your health?
					50229, -- Q55. In the last 6 months did anyone on your health care team ask you if there was a period of time when you felt sad empty or depressed?
					50230, -- Q56. In the last 6 months did you and anyone on your health care team talk about things in your life that worry you or cause you stress?
					50234, -- Q58. In general how would you rate your overall health?
					50235, -- Q59. In general how would you rate your overall mental or emotional health?
					50237, -- Q61. Is this a condition or problem that has lasted for at least 3 months?
					50239, -- Q63. Is this medicine to treat a condition that has lasted for at least 3 months?
					50240, -- Q64. During the last 4 weeks how much of the time did your physical health interfere with your social activities (like visiting with friends relatives etc.)?
					50249, -- Q73. Because of a physical mental or emotional condition do you have serious difficulty concentrating remembering or making decisions?
					50250, -- Q74. Do you have serious difficulty walking or climbing stairs?
					50251, -- Q75. Do you have difficulty dressing or bathing?
					50252  -- Q76. Because of a physical mental or emotional condition do you have difficulty doing errands alone such as visiting a doctors office or shopping?
					)
				group by samplepop_id) sub
		on qf.samplepop_id=sub.samplepop_id

	update #ACO 
	set RecalcACOdisposition=
		case when ATAComplete=1 and MeasuresComplete=1
			then 10 -- complete
		when ATAComplete=0 and MeasuresComplete=1
			then 31 -- partial
		else
			34 -- blank/incomplete
		end
	where RecalcACOdisposition is null

END
go
