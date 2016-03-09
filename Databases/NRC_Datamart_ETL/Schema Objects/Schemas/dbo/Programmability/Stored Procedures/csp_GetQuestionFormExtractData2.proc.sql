CREATE PROCEDURE [dbo].[csp_GetQuestionFormExtractData2]
@ExtractFileID INT
AS
/*
--			S42 US13 OAS: Language in which Survey Completed As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs. 02/04/2016 TSB
*/
SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm


	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

--    declare @ExtractFileID int
--	set @ExtractFileID = 527

	CREATE TABLE #ttt
	(
		Tag int not null,
		Parent int null,
			
	    [questionForm!1!id] nvarchar(200) NOT NULL,
	    [questionForm!1!samplePopID] nvarchar(200) NULL,
	    [questionForm!1!isComplete] nvarchar(5) NULL,
	    [questionForm!1!returnDate] smalldatetime NULL,
        [questionForm!1!receiptType_id] int NULL,
        [questionForm!1!DatMailed] datetime NULL, 
        [questionForm!1!DatExpire] datetime NULL, 
        [questionForm!1!DatGenerated] datetime NULL, 
        [questionForm!1!DatPrinted] datetime NULL, 
        [questionForm!1!DatBundled] datetime NULL, 
        [questionForm!1!DatUndeliverable] datetime NULL, 	   
        [questionForm!1!DatFirstMailed] datetime NULL, 	 
	    [questionForm!1!deleteEntity] nvarchar(5) NULL,
		[questionForm!1!LangID] int NULL,
	    
	    [bubbleData!2!nrcQuestionCore] int NULL,
	    [bubbleData!2!sampleunitid] nvarchar(200) NULL,
	    
	    [rvals!3!v] int NULL,
	    
	    [comment!4!Cmnt_id] int NULL,
		--[comment!4!Cmnt_id!hide] int NULL,
	    [comment!4!nrcQuestionCore] int NULL,
	    [comment!4!commentType] nvarchar(50) NULL,
	    [comment!4!commentValence] nvarchar(50) NULL,
	    [comment!4!isSuppressedOnWeb] nvarchar(5) NULL,
	    [comment!4!sampleunitid] nvarchar(200) NULL,
        [comment!4!datEntered] smalldatetime NULL,
	    
	    [codes!5!cd] int NULL,
	    
	    [masked!6!seq!hide] int null,
	    [masked!6!t!element] text null,
	    
	    [unmasked!7!seq!hide] int null,
	    [unmasked!7!t!element] text null
  )
  

  declare @TestString nvarchar(40)
    set @TestString = '%[' + NCHAR(0) + NCHAR(1) + NCHAR(2) + NCHAR(3) + NCHAR(4) + NCHAR(5) + NCHAR(6) + NCHAR(7) + NCHAR(8) + NCHAR(11) + NCHAR(12) + NCHAR(14) + NCHAR(15) + NCHAR(16) + NCHAR(17) + NCHAR(18) + NCHAR(19) + NCHAR(20) + NCHAR(21) + NCHAR(22) + NCHAR(23) + NCHAR(24) + NCHAR(25) + NCHAR(26) + NCHAR(27) + NCHAR(28) + NCHAR(29) + NCHAR(30) + NCHAR(31) + ']%'
  
  delete from CommentTextTempError where ExtractFileID = @ExtractFileID

  insert Into CommentTextTempError
  select *
  from CommentTextTemp
  where ExtractFileID = @ExtractFileID 
    and PATINDEX (@TestString, BlockData COLLATE Latin1_General_BIN) > 0   

  -- insert records for inserted/updated records
  insert #ttt
  	select 1 as Tag, NULL as Parent,
  		   strLithoCode As questionform_id,
  		   samplepop_id,
  		   isComplete,
  		   returnDate,
  		   ReceiptType_ID,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed,
  		   NULL, -- deleteEntity defaults to FALSE
		   [LangID], 

		   NULL,NULL,
		   NULL,
		   NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from QuestionFormTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID and IsDeleted = 0
  
  -- insert records for deleted records
  insert #ttt
  	select 1 as Tag, NULL as Parent,  		   
  		   strLithoCode As questionform_id, samplepop_id, NULL, NULL, NULL                     
           ,NULL,NULL,NULL,NULL,NULL,NULL,NULL
           ,'true' as deleteEntity,
		   NULL, -- LangID

		   NULL,NULL,
		   NULL,
		   NULL,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from QuestionFormTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID and IsDeleted = 1
  
       
  -- insert comments
  insert #ttt
  	select 4 as Tag, 1 as Parent,
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,

 		   Cmnt_id,
		   nrcQuestionCore,
		   commentType,
		   commentValence,
		   isSuppressedOnWeb,
		   SAMPLEUNIT_ID,
           datEntered,
		   
		   NULL,
		   NULL,NULL,
		   NULL,NULL
	  from CommentTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
      
  -- insert comment codes
  insert #ttt
  	select 5 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   code,
		   NULL,NULL,
		   NULL,NULL
	  from CommentCodeTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
      
  -- insert comment text
  insert #ttt
  	select 6 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   
		   BlockNum, BlockData,
		   
		   NULL,NULL
	  from CommentTextTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
	   and IsMasked <> 0
       and not exists (select 1
                      from CommentTextTempError with (NOLOCK)
                      where CommentTextTemp.LithoCode = CommentTextTempError.LithoCode
                       and CommentTextTemp.Cmnt_id = CommentTextTempError.Cmnt_id
                        and CommentTextTemp.IsMasked = CommentTextTempError.IsMasked 
                       and CommentTextTemp.BlockNum = CommentTextTempError.BlockNum
                       and CommentTextTempError.ExtractFileID = @ExtractFileID)    
      
  -- insert comment text
  insert #ttt
  	select 7 as Tag, 4 as Parent,  	
  	  	   LithoCode As questionform_id, NULL, NULL, NULL, NULL, NULL,
		   NULL, -- LangID

           NULL,NULL,NULL,NULL,NULL,NULL,NULL,

		   NULL,NULL,
		   NULL,
		   Cmnt_id,NULL,NULL,NULL,NULL,NULL,NULL,
		   NULL,
		   
		   NULL,NULL,
		   
		   BlockNum, BlockData
		   
	  from CommentTextTemp With (NOLOCK)
	 where ExtractFileID = @ExtractFileID
	   and IsMasked = 0
       and not exists (select 1
                      from CommentTextTempError with (NOLOCK)
                      where CommentTextTemp.LithoCode = CommentTextTempError.LithoCode
                       and CommentTextTemp.Cmnt_id = CommentTextTempError.Cmnt_id
                        and CommentTextTemp.IsMasked = CommentTextTempError.IsMasked 
                       and CommentTextTemp.BlockNum = CommentTextTempError.BlockNum
                       and CommentTextTempError.ExtractFileID = @ExtractFileID)  
  
  select *
    from #ttt With (NOLOCK)
    ORDER BY  [questionForm!1!id], [bubbleData!2!nrcQuestionCore],[rvals!3!v],
			[comment!4!Cmnt_id], [codes!5!cd], [masked!6!seq!hide], [unmasked!7!seq!hide]
     for xml explicit
  

  drop table #ttt

  	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
GO
