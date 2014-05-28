CREATE PROCEDURE sp_MailingStep_Save  
-- 	@IsNew 					BIT,   
	@MailingStepID 			INT OUTPUT,  
	@MethodologyID 			INT,   
	@SurveyID 				INT,   
	@intSequence 			INT,   
	@SelCoverID 			INT,   
	@bitSurveyInLine 		BIT,  
	@bitSendSurvey 			BIT,   
	@intIntervalDays 		INT,   
	@bitThankYouItem 		BIT,   
	@strMailingStepName 	VARCHAR(20),  
	@bitFirstSurvey 		BIT,   
	@MailingStepMethodID 	INT,   
	@ExpireInDays 			INT,  
	@ExpireFromStep 		INT OUTPUT  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
-- DECLARE @EFS int  
-- SET @EFS = @ExpireFromStep  

IF @ExpireFromStep=0
SELECT @ExpireFromStep=NULL
  
BEGIN TRAN  
-- IF @IsNew=1   
IF @MailingStepID=0   
   BEGIN  
      -- Insert a record  
      INSERT INTO MailingStep (  
         Methodology_ID, Survey_ID, intSequence, SelCover_ID, bitSurveyInLine,  
         bitSendSurvey, intIntervalDays, bitThankYouItem, strMailingStep_nm,  
         bitFirstSurvey, MailingStepMethod_id, ExpireInDays, ExpireFromStep)   
      VALUES (  
         @MethodologyID, @SurveyID, @intSequence, @SelCoverID, @bitSurveyInline,  
         @bitSendSurvey, @intIntervalDays, @bitThankYouItem, LTRIM(RTRIM(@strMailingStepName)),         
         @bitFirstSurvey, @MailingStepMethodID, @ExpireInDays, @ExpireFromStep)  
  
         -- Case @ExpireFromStep  
         --    VA:     Either positive (previous step) or negative value (new)  
         --            Can't be 0 since the negative sequence number is assigned to it.  
         --    Non-VA: Either positive (current step) or 0 (new).  Can't be negative  
         --            value since the user can't edit it.  
         -- When > 0 then @EFS = @ExpireFromStep  
         -- When = 0 then @EFS = MailingStep_id (@@identity)  
         -- When < 0 then  
  --    If @ExpireFromStep <> -(@intSequence) then @EFS = Previous Step  
         --    Else @EFS = @@identity  
		SELECT @MailingStepID=SCOPE_IDENTITY()
  
--       IF @ExpireFromStep < 1  
--          BEGIN  
--         SET @EFS = @@identity  
--      IF @ExpireFromStep <> (@intSequence) * -1 -- Reference to previous step  
--         SELECT @EFS = MailingStep_id FROM MailingStep  
--         WHERE Methodology_id = @MethodologyID  
--                      AND intSequence = (@ExpireFromStep) * -1  
--          END  
--       UPDATE MailingStep  
--       SET ExpireFromStep = @EFS WHERE MailingStep_id = @@identity  
--         
--       SET @MailingStepID = @@identity  
--       SET @ExpireFromStep = @EFS  
   END  
ELSE -- Update the record  
   BEGIN  
--       IF @ExpireFromStep < 0 -- Current Step  
--          SET @EFS = @MailingStepID  
      UPDATE MailingStep   
      SET Methodology_ID=@MethodologyID,  
          Survey_ID=@SurveyID,  
          intSequence=@intSequence,  
          SelCover_ID=@SelCoverID,  
          bitSurveyInLine=@bitSurveyInline,  
          bitSendSurvey=@bitSendSurvey,  
          intIntervalDays=@intIntervalDays,  
          bitThankYouItem=@bitThankYouItem,  
          strMailingStep_nm=LTRIM(RTRIM(@strMailingStepName)),  
          bitFirstSurvey=@bitFirstSurvey,  
          MailingStepMethod_id=@MailingStepMethodID,  
          ExpireInDays=@ExpireInDays,  
          ExpireFromStep=@ExpireFromStep
--           ExpireFromStep=@EFS  
        WHERE MailingStep_ID=@MailingStepID  
--        SET @ExpireFromStep=@EFS  
   END  
COMMIT TRAN


