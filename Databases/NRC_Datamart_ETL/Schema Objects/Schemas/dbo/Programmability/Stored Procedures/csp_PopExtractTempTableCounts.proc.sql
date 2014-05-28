-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec csp_PopExtractTempTableCounts 4
CREATE PROCEDURE [dbo].[csp_PopExtractTempTableCounts]
	@ExtractFileID int
AS
BEGIN
	SET NOCOUNT ON

--	declare  @ExtractFileID int
--	set  @ExtractFileID = 2

    delete from ExtractTempTableCounts where ExtractFileID = @ExtractFileID

    insert into dbo.ExtractTempTableCounts
    select @ExtractFileID,'SampleSetTemp',Sum(Tot),Sum(Deletes)
    from (select count(*) as Tot,0 As Deletes
          from  dbo.SampleSetTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
          union 
          select 0,count(*)
          from  dbo.SampleSetTemp with (NOLOCK) where ExtractFileID = @ExtractFileID and isDeleted = 1 
         )x
    union --all    
    select @ExtractFileID,'SamplePopTemp',Sum(Tot),Sum(Deletes)
    from (select count(*) as Tot,0 As Deletes
          from  dbo.SamplePopTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
          union 
          select 0,count(*)
          from  dbo.SamplePopTemp with (NOLOCK) where ExtractFileID = @ExtractFileID and isDeleted = 1 
         )x   
    union all
    select @ExtractFileID,'SelectedSampleTemp',count(*),0
    from  dbo.SelectedSampleTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
    union all    
    select @ExtractFileID,'BackgroundTemp',IsNull(count(*),0),0
     from BackgroundTemp with (NOLOCK)
      left join BackgroundTempError with (NOLOCK) 
       on BackgroundTemp.ExtractFileID = BackgroundTempError.ExtractFileID 
          and BackgroundTemp.samplepop_id = BackgroundTempError.samplepop_id
          --and BackgroundTemp.sampleunit_id = BackgroundTempError.sampleunit_id 
          and BackgroundTemp.name = BackgroundTempError.name                    
      where BackgroundTemp.ExtractFileID = @ExtractFileID
       and BackgroundTempError.samplepop_id is null
    union all
    select @ExtractFileID,'BackgroundTempError',sum(count),0
    from  dbo.BackgroundTempError with (NOLOCK) where ExtractFileID = @ExtractFileID
    union all
    select @ExtractFileID,'QuestionFormTemp',Sum(Tot),Sum(Deletes)
    from (select count(*) as Tot,0 As Deletes
          from  dbo.QuestionFormTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
          union 
          select 0,count(*)
          from  dbo.QuestionFormTemp with (NOLOCK) where ExtractFileID = @ExtractFileID and isDeleted = 1 
         )x      
    union all
    select @ExtractFileID,'BubbleTemp',count(*),0
    from  dbo.BubbleTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
    union all
    select @ExtractFileID,'CommentTemp',count(*),0
    from  dbo.CommentTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
    union all
    select @ExtractFileID,'CommentCodeTemp',count(*),0
    from  dbo.CommentCodeTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
   union all
    select @ExtractFileID,'CommentTextTemp',count(*),0
    from  dbo.CommentTextTemp with (NOLOCK) where ExtractFileID = @ExtractFileID
   union all
   select @ExtractFileID,'CommentTextTempError',count(*),0
    from  dbo.CommentTextTempError with (NOLOCK) where ExtractFileID = @ExtractFileID   
   union all    
    select @ExtractFileID,'DispositionLogTemp',count(*),0
    from dbo.DispositionLogTemp with (NOLOCK) where ExtractFileID = @ExtractFileID      
         
   
END


