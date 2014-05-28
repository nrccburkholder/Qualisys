-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[csp_CleanupEventTempTables]
	@ExtractFileID int,
    @RetainTempData bit

AS
BEGIN
	SET NOCOUNT ON

--	declare  @ExtractFileID int
--	set  @ExtractFileID = 539 

	delete from  dbo.SampleSetTemp where ExtractFileID = @ExtractFileID
    delete from  dbo.SamplePopTemp where ExtractFileID = @ExtractFileID
	delete from  dbo.SelectedSampleTemp where ExtractFileID = @ExtractFileID
	delete from  dbo.BackgroundTemp	where ExtractFileID = @ExtractFileID
    delete from  dbo.QuestionFormTemp where ExtractFileID = @ExtractFileID    
    delete from  dbo.BubbleTemp where ExtractFileID = @ExtractFileID
	delete from  dbo.CommentTemp where ExtractFileID = @ExtractFileID
	delete from  dbo.CommentCodeTemp where ExtractFileID = @ExtractFileID	
	delete from  dbo.CommentTextTemp where ExtractFileID = @ExtractFileID
    delete from  dbo.BackgroundTempError where ExtractFileID = @ExtractFileID
	delete from  dbo.CommentTextTempError where ExtractFileID = @ExtractFileID
	delete from  dbo.DispositionLogTemp where ExtractFileID = @ExtractFileID
             
--	if @RetainTempData = 0
--	  begin	    	

       Declare @PrevExtractFileID Int	   

       Set @PrevExtractFileID = (Select Max(ExtractFile.ExtractFileID) As ExtractFileID
                          From ExtractFile with (NOLOCK)
                          Inner Join (Select IncludeEventData,IncludeMetaData
                                      From ExtractFile with (NOLOCK)
                                      Where  ExtractFileID = @ExtractFileID ) x  
                           On ExtractFile.IncludeEventData = x.IncludeEventData And ExtractFile.IncludeMetaData = x.IncludeMetaData
                           Where ExtractFileID < @ExtractFileID
                        )	       

		delete from  dbo.SampleSetTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.SamplePopTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.SelectedSampleTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.BackgroundTemp	where ExtractFileID = @PrevExtractFileID
        delete from  dbo.QuestionFormTemp where ExtractFileID = @PrevExtractFileID	     
		delete from  dbo.BubbleTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.CommentTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.CommentCodeTemp where ExtractFileID = @PrevExtractFileID	
		delete from  dbo.CommentTextTemp where ExtractFileID = @PrevExtractFileID
		delete from  dbo.DispositionLogTemp where ExtractFileID = @PrevExtractFileID
        	
--	  end

	
	    ALTER INDEX ALL ON SampleSetTemp REBUILD	    
	    ALTER INDEX ALL ON SamplePopTemp REBUILD	      
	    ALTER INDEX ALL ON SelectedSampleTemp REBUILD
	    ALTER INDEX ALL ON BackgroundTemp REBUILD
	    ALTER INDEX ALL ON QuestionFormTemp REBUILD
	    ALTER INDEX ALL ON BubbleTemp REBUILD
	    ALTER INDEX ALL ON CommentTemp REBUILD
	    ALTER INDEX ALL ON CommentCodeTemp REBUILD
	    ALTER INDEX ALL ON CommentTextTemp REBUILD
	    ALTER INDEX ALL ON DispositionLogTemp REBUILD
	      
 
    
END


