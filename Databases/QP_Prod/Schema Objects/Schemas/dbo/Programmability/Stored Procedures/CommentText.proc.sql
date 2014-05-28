CREATE PROCEDURE CommentText
				 @LithoCode Varchar(10),
				 @Chg varchar(20),
				 @CommentStr Varchar(max),
				 @CommentStrUM Varchar(max)

AS 
BEGIN
SET XACT_ABORT ON
/******************************************************************************************************************************
Unit Test:- Parameters : @Lithocode,
						 @Chg  --To update CommentText Use: 'CommentText'
						 @CommentStr, --Masked Comment
						 @CommentStrUM --UnMasked Comment



						



Step 1:- Execute the sproc only with the lithocode to see the existing Comment text.
EXEC CommentText 19156321,NULL,NULL,NULL


Step 2:- In this case both unmasked and masked comment text is present, So we need to update both of them
EXEC CommentText 19156321,
				   CommentText,
				   'This is in response to your survey regarding my Mother''s stay at St. Charles Mercy Hospital 12/25/01 to 12/31/01.  My Mother was given excellent care by the nursing staff and admissions personnel.  My problem was the co-ordination of care by the five doctors, their associates and the doctors who fill in for Mother''s doctors who do not make visits to your facility.  While I understand that not every doctor can visit every hospital and be efficient in their daily lives, in this case my Mother''s care suffered.  My Mother''s family doctor (Dr. XXXXXXXXXXXXXXXXX) was very caring and informative.  However, she deferred to the cardiologist for co-ordinating her car.  Drs. XXXXXXX & XXXXXXXXXXXX are her cardiologists.  They saw her once and turned her over to Dr. XXXXXX for follow up while she stayed at the hospital.  Dr. XXXXXX seemed to be very knowledgeable and compassionate and yet I feel he did not know my Mother as her own cardiologist would have.  Mother also had doctors for blood problems, kidney problems and stomach problems.  My Mother is 79 years old and was very confused by all of the doctors.  She often could not remember who had been in and what they had told her.  On the day of her release she was told she was able to go home safely at about nine a.m.  From that time on she sat on the edge of the bed waiting for her discharge information.  My 82 year old Father waited with her on pins and needles and was worried how he was going to be able to care for her.  Finally by 4:45 p.m. I asked the nurse if indeed my Mother was going home today.  She had been signed out by four of the doctors caring for her but still needed the approval of the cardiologist.  The nurse immediately got Dr. XXXXX to come speak to us.  He gave us a quick vision of the problem and discharge instructions.  My Father and brother had earlier in the day been told that due to the fact Mother was being discharged on New Year''s Eve, she would be given 3 days medications as many pharmacies would be closed.  Many of her medications had been changed during her stay in the hospital.  When Dr. XXXXX released us and had the nurse make sure we understood his instructions we were not given the medications as promised.  When I asked the nurse where the medications were she told us that there were no orders for medications to take home and that she could not give them to us as Mother had been released.  When we asked her to call the doctor back she said that wouldn''t help as Mother had been discharged and the hospital pharmacy was probably closed.  If it wasn''t enough dealing with Mother''s medical problems and my Father''s concern over her care, now we had to deal with taking her home at 5:15 p.m. and finding a pharmacy that was open to fill the five new prescriptions we had.  My Mother had met her pharmacy limit (insurance) for 2001 and would be eligible January 1, 2002.  Had the hospital given us three days medications we could have made an easier transition to home care.  As it worked out, we found a pharmacy at Kroger''s that was open and a willing pharmacist who gave us very special handling. What medications her insurance carrier ok''d we were loaned one day''s worth so the pharmacist could run the paperwork through the following day when coverage was good.  However, one medication was not ok''d by the insurance carrier and the pharmacist had to call the doctor for a change in the prescription.  Needless to say, the doctor was not able to be reached.  When she tried to call the Academy of Medicine she could not get through for hours.  I myself    called St. Charles for assistance and was told that my Mother had been discharged and medications could not  be dispensed or prescriptions changed.  We were told to call the Academy.  Luckily for us, the pharmacist gave my Mother one evenings worth of medicine and tried all night to reach the Academy with no luck until 10 a.m. the following day.  All of this could have been avoided if indeed someone at the hospital could have followed up and given my Mother the three days medications which were promised by someone in your hospital from Paramount.  I am not telling you of the problem to cause someone trouble but only to help someone in the future.  If anyone else has to go through this after their release, I really feel for them.  This situation was very stressful and aggravating.  I wonder if I had not been there to help my Father (82 years old) how he would been able to cope.  My Father has COPD and was really worried enough.  Please check into this and help someone in the future to avoid this. ABCD',
				   'This is in response to your survey regarding my Mother''s stay at St. Charles Mercy Hospital 12/25/01 to 12/31/01.  My Mother was given excellent care by the nursing staff and admissions personnel.  My problem was the co-ordination of care by the five doctors, their associates and the doctors who fill in for Mother''s doctors who do not make visits to your facility.  While I understand that not every doctor can visit every hospital and be efficient in their daily lives, in this case my Mother''s care suffered.  My Mother''s family doctor (Dr. Josephine Collaco) was very caring and informative.  However, she deferred to the cardiologist for co-ordinating her car.  Drs. Carolyn & Charles Gbur are her cardiologists.  They saw her once and turned her over to Dr. Lorton for follow up while she stayed at the hospital.  Dr. Lorton seemed to be very knowledgeable and compassionate and yet I feel he did not know my Mother as her own cardiologist would have.  Mother also had doctors for blood problems, kidney problems and stomach problems.  My Mother is 79 years old and was very confused by all of the doctors.  She often could not remember who had been in and what they had told her.  On the day of her release she was told she was able to go home safely at about nine a.m.  From that time on she sat on the edge of the bed waiting for her discharge information.  My 82 year old Father waited with her on pins and needles and was worried how he was going to be able to care for her.  Finally by 4:45 p.m. I asked the nurse if indeed my Mother was going home today.  She had been signed out by four of the doctors caring for her but still needed the approval of the cardiologist.  The nurse immediately got Dr. Duran to come speak to us.  He gave us a quick vision of the problem and discharge instructions.  My Father and brother had earlier in the day been told that due to the fact Mother was being discharged on New Year''s Eve, she would be given 3 days medications as many pharmacies would be closed.  Many of her medications had been changed during her stay in the hospital.  When Dr. Duran released us and had the nurse make sure we understood his instructions we were not given the medications as promised.  When I asked the nurse where the medications were she told us that there were no orders for medications to take home and that she could not give them to us as Mother had been released.  When we asked her to call the doctor back she said that wouldn''t help as Mother had been discharged and the hospital pharmacy was probably closed.  If it wasn''t enough dealing with Mother''s medical problems and my Father''s concern over her care, now we had to deal with taking her home at 5:15 p.m. and finding a pharmacy that was open to fill the five new prescriptions we had.  My Mother had met her pharmacy limit (insurance) for 2001 and would be eligible January 1, 2002.  Had the hospital given us three days medications we could have made an easier transition to home care.  As it worked out, we found a pharmacy at Kroger''s that was open and a willing pharmacist who gave us very special handling. What medications her insurance carrier ok''d we were loaned one day''s worth so the pharmacist could run the paperwork through the following day when coverage was good.  However, one medication was not ok''d by the insurance carrier and the pharmacist had to call the doctor for a change in the prescription.  Needless to say, the doctor was not able to be reached.  When she tried to call the Academy of Medicine she could not get through for hours.  I myself    called St. Charles for assistance and was told that my Mother had been discharged and medications could not  be dispensed or prescriptions changed.  We were told to call the Academy.  Luckily for us, the pharmacist gave my Mother one evenings worth of medicine and tried all night to reach the Academy with no luck until 10 a.m. the following day.  All of this could have been avoided if indeed someone at the hospital could have followed up and given my Mother the three days medications which were promised by someone in your hospital from Paramount.  I am not telling you of the problem to cause someone trouble but only to help someone in the future.  If anyone else has to go through this after their release, I really feel for them.  This situation was very stressful and aggravating.  I wonder if I had not been there to help my Father (82 years old) how he would been able to cope.  My Father has COPD and was really worried enough.  Please check into this and help someone in the future to avoid this. ABCD'




--Rollback
EXEC CommentText 19156321,
				   CommentText,
				   'This is in response to your survey regarding my Mother''s stay at St. Charles Mercy Hospital 12/25/01 to 12/31/01.  My Mother was given excellent care by the nursing staff and admissions personnel.  My problem was the co-ordination of care by the five doctors, their associates and the doctors who fill in for Mother''s doctors who do not make visits to your facility.  While I understand that not every doctor can visit every hospital and be efficient in their daily lives, in this case my Mother''s care suffered.  My Mother''s family doctor (Dr. XXXXXXXXXXXXXXXXX) was very caring and informative.  However, she deferred to the cardiologist for co-ordinating her car.  Drs. XXXXXXX & XXXXXXXXXXXX are her cardiologists.  They saw her once and turned her over to Dr. XXXXXX for follow up while she stayed at the hospital.  Dr. XXXXXX seemed to be very knowledgeable and compassionate and yet I feel he did not know my Mother as her own cardiologist would have.  Mother also had doctors for blood problems, kidney problems and stomach problems.  My Mother is 79 years old and was very confused by all of the doctors.  She often could not remember who had been in and what they had told her.  On the day of her release she was told she was able to go home safely at about nine a.m.  From that time on she sat on the edge of the bed waiting for her discharge information.  My 82 year old Father waited with her on pins and needles and was worried how he was going to be able to care for her.  Finally by 4:45 p.m. I asked the nurse if indeed my Mother was going home today.  She had been signed out by four of the doctors caring for her but still needed the approval of the cardiologist.  The nurse immediately got Dr. XXXXX to come speak to us.  He gave us a quick vision of the problem and discharge instructions.  My Father and brother had earlier in the day been told that due to the fact Mother was being discharged on New Year''s Eve, she would be given 3 days medications as many pharmacies would be closed.  Many of her medications had been changed during her stay in the hospital.  When Dr. XXXXX released us and had the nurse make sure we understood his instructions we were not given the medications as promised.  When I asked the nurse where the medications were she told us that there were no orders for medications to take home and that she could not give them to us as Mother had been released.  When we asked her to call the doctor back she said that wouldn''t help as Mother had been discharged and the hospital pharmacy was probably closed.  If it wasn''t enough dealing with Mother''s medical problems and my Father''s concern over her care, now we had to deal with taking her home at 5:15 p.m. and finding a pharmacy that was open to fill the five new prescriptions we had.  My Mother had met her pharmacy limit (insurance) for 2001 and would be eligible January 1, 2002.  Had the hospital given us three days medications we could have made an easier transition to home care.  As it worked out, we found a pharmacy at Kroger''s that was open and a willing pharmacist who gave us very special handling. What medications her insurance carrier ok''d we were loaned one day''s worth so the pharmacist could run the paperwork through the following day when coverage was good.  However, one medication was not ok''d by the insurance carrier and the pharmacist had to call the doctor for a change in the prescription.  Needless to say, the doctor was not able to be reached.  When she tried to call the Academy of Medicine she could not get through for hours.  I myself    called St. Charles for assistance and was told that my Mother had been discharged and medications could not  be dispensed or prescriptions changed.  We were told to call the Academy.  Luckily for us, the pharmacist gave my Mother one evenings worth of medicine and tried all night to reach the Academy with no luck until 10 a.m. the following day.  All of this could have been avoided if indeed someone at the hospital could have followed up and given my Mother the three days medications which were promised by someone in your hospital from Paramount.  I am not telling you of the problem to cause someone trouble but only to help someone in the future.  If anyone else has to go through this after their release, I really feel for them.  This situation was very stressful and aggravating.  I wonder if I had not been there to help my Father (82 years old) how he would been able to cope.  My Father has COPD and was really worried enough.  Please check into this and help someone in the future to avoid this.',
				   'This is in response to your survey regarding my Mother''s stay at St. Charles Mercy Hospital 12/25/01 to 12/31/01.  My Mother was given excellent care by the nursing staff and admissions personnel.  My problem was the co-ordination of care by the five doctors, their associates and the doctors who fill in for Mother''s doctors who do not make visits to your facility.  While I understand that not every doctor can visit every hospital and be efficient in their daily lives, in this case my Mother''s care suffered.  My Mother''s family doctor (Dr. Josephine Collaco) was very caring and informative.  However, she deferred to the cardiologist for co-ordinating her car.  Drs. Carolyn & Charles Gbur are her cardiologists.  They saw her once and turned her over to Dr. Lorton for follow up while she stayed at the hospital.  Dr. Lorton seemed to be very knowledgeable and compassionate and yet I feel he did not know my Mother as her own cardiologist would have.  Mother also had doctors for blood problems, kidney problems and stomach problems.  My Mother is 79 years old and was very confused by all of the doctors.  She often could not remember who had been in and what they had told her.  On the day of her release she was told she was able to go home safely at about nine a.m.  From that time on she sat on the edge of the bed waiting for her discharge information.  My 82 year old Father waited with her on pins and needles and was worried how he was going to be able to care for her.  Finally by 4:45 p.m. I asked the nurse if indeed my Mother was going home today.  She had been signed out by four of the doctors caring for her but still needed the approval of the cardiologist.  The nurse immediately got Dr. Duran to come speak to us.  He gave us a quick vision of the problem and discharge instructions.  My Father and brother had earlier in the day been told that due to the fact Mother was being discharged on New Year''s Eve, she would be given 3 days medications as many pharmacies would be closed.  Many of her medications had been changed during her stay in the hospital.  When Dr. Duran released us and had the nurse make sure we understood his instructions we were not given the medications as promised.  When I asked the nurse where the medications were she told us that there were no orders for medications to take home and that she could not give them to us as Mother had been released.  When we asked her to call the doctor back she said that wouldn''t help as Mother had been discharged and the hospital pharmacy was probably closed.  If it wasn''t enough dealing with Mother''s medical problems and my Father''s concern over her care, now we had to deal with taking her home at 5:15 p.m. and finding a pharmacy that was open to fill the five new prescriptions we had.  My Mother had met her pharmacy limit (insurance) for 2001 and would be eligible January 1, 2002.  Had the hospital given us three days medications we could have made an easier transition to home care.  As it worked out, we found a pharmacy at Kroger''s that was open and a willing pharmacist who gave us very special handling. What medications her insurance carrier ok''d we were loaned one day''s worth so the pharmacist could run the paperwork through the following day when coverage was good.  However, one medication was not ok''d by the insurance carrier and the pharmacist had to call the doctor for a change in the prescription.  Needless to say, the doctor was not able to be reached.  When she tried to call the Academy of Medicine she could not get through for hours.  I myself    called St. Charles for assistance and was told that my Mother had been discharged and medications could not  be dispensed or prescriptions changed.  We were told to call the Academy.  Luckily for us, the pharmacist gave my Mother one evenings worth of medicine and tried all night to reach the Academy with no luck until 10 a.m. the following day.  All of this could have been avoided if indeed someone at the hospital could have followed up and given my Mother the three days medications which were promised by someone in your hospital from Paramount.  I am not telling you of the problem to cause someone trouble but only to help someone in the future.  If anyone else has to go through this after their release, I really feel for them.  This situation was very stressful and aggravating.  I wonder if I had not been there to help my Father (82 years old) how he would been able to cope.  My Father has COPD and was really worried enough.  Please check into this and help someone in the future to avoid this.'


EXEC CommentText 19156321,NULL,NULL,NULL

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Step 1:- 
EXEC CommentText 17994249,NULL,NULL,NULL

Step 2:-
EXEC CommentText 17994249,
				   CommentText,
				   'good keep up the good work',
				   NULL


EXEC CommentText 19091566,NULL,NULL,NULL


EXEC CommentText 19091566,
				   CommentText,
				   'ER needs to be faster at getting people looked at when I was there it took 1½ hrs before I saw any doctor.  Spent 6 hr in the ER room pregnant with hypertension very long time - rest of service is great!',
				    NULL

********************************************************************************************************************************/
DECLARE @Study_ID varchar(10)
DECLARE @questionformID int
DECLARE @CommentID varchar(10)
DECLARE @SqlStr varchar(max)
DECLARE @SqlStr1 varchar(max)
DECLARE @CommentText varchar(max)
DECLARE @CommentTextUM varchar(max)

				 


IF @LithoCode IN (SELECT STRLITHOCODE FROM sentmailing where strlithocode = ''+@LithoCode+'') 
BEGIN
	
 select @questionformID=qf.questionform_id,      
		 @Study_ID= 's'+cast(sd.study_id AS Varchar(10)),      
		 @CommentID = cast(Cmnt_id AS Varchar(10)),
		 @CommentText   = CAST(c.strCmntText AS Varchar(max)),
		 @CommentTextUM = COALESCE(CAST(c.strCmntTextUM AS Varchar(max)),'NULL')      
  from sentmailing sm      
  inner join questionform qf      
  on qf.sentmail_id = sm.sentmail_id      
  inner join comments c      
  on c.questionform_id = qf.questionform_id      
  inner join survey_def sd      
  on sd.survey_id = qf.survey_id      
  where sm.strlithocode = ''+@LithoCode+''    
  
  PRINT '@LithoCode     :  '+cast(@LithoCode     as varchar)      
  PRINT '@CommentID     :  '+cast(@CommentID     as varchar)      
  PRINT '@CommentText   :  '+cast(@CommentText   as varchar(max))
  PRINT '@CommentTextUM :  '+cast(@CommentTextUM as varchar(max))
END
ELSE
BEGIN
PRINT 'Please provide a valid lithocode.'
RETURN
END




IF @Chg = 'CommentText' and @CommentStr is not null and @CommentStrUM is null
BEGIN 

		BEGIN TRY
				BEGIN TRANSACTION
				--NRC10
				UPDATE COMMENTS
				SET strCmntText = @CommentStr
				where Cmnt_id in (@CommentID)
				
				--MEDUSA
				SELECT @SqlStr = 'UPDATE DATAMART.QP_Comments.'+@Study_ID+'.Comments SET strCmntText ='''+REPLACE(@CommentStr, '''', '''''')+''' WHERE cmnt_id ='+CAST(@CommentID as varchar)
				EXEC (@SqlStr)
		
				PRINT 'Comment String has been updated to "'+@CommentStr+'" in NRC10 & MEDUSA'
				COMMIT TRANSACTION
			 END TRY
			 
			 BEGIN CATCH
			 IF @@TRANCOUNT > 0
			 ROLLBACK TRAN
				PRINT('Text change Transactioin has been rolledback')
				END CATCH
			END




IF @Chg = 'CommentText' and @CommentStr is not null and @CommentStrUM is not null
	BEGIN
		BEGIN TRY
				BEGIN TRANSACTION
				--NRC10
				UPDATE COMMENTS
				SET strCmntText = @CommentStr,strCmntTextUM=@CommentStrUM
				where Cmnt_id in (@CommentID)


				
				--MEDUSA
				SELECT @SqlStr = 'UPDATE DATAMART.QP_Comments.'+@Study_ID+'.Comments SET strCmntText ='''+REPLACE(@CommentStr, '''', '''''')+''',strCmntTextUM='''+REPLACE(@CommentStrUM, '''', '''''')+''' WHERE cmnt_id ='+CAST(@CommentID as varchar)
				EXEC (@SqlStr)

				--SELECT @SqlStr1 = 'UPDATE DATAMART.QP_Comments.'+@Study_ID+'.Comments SET strCmntTextUM ='''+REPLACE(@CommentStrUM, '''', '''''')+''' WHERE cmnt_id ='+CAST(@CommentID as varchar)
				--EXEC (@SqlStr1)


				PRINT 'Comment masked String has been updated to   "'+@CommentStr+'" in NRC10 & MEDUSA'
				PRINT 'Comment Unmasked String has been updated to "'+@CommentStrUM+'" in NRC10 & MEDUSA'
				COMMIT TRANSACTION
			END TRY

			BEGIN CATCH
				IF @@TRANCOUNT > 0
				ROLLBACK TRAN
					PRINT('Text change Transactioin has been rolledback')
			END CATCH

	END
END


