CREATE PROCEDURE [dbo].[tst_JobPrepareEventTest]
@isDeleted BIT
AS
delete QuestionFormTemp
	delete CommentCodeTemp
	delete CommentTemp
    delete dbo.CommentTextTemp
    delete dbo.CommentTextTempError
	delete BubbleTemp
	delete BackgroundTemp
    delete dbo.BackgroundTempError
    delete SampleSetTemp
	delete SelectedSampleTemp
	delete SamplePopTemp
    delete ExtractTempTableCounts
	delete ExtractHistory where IsMetaData = 0
	delete ExtractQueue  where IsMetaData = 0
	delete ExtractFile where IncludeEventData = 1

   declare @ExtractFileID int
   set @ExtractFileID = (Select Max(ExtractFileID) from ExtractFile)

   DBCC CHECKIDENT ('ExtractFile', reseed, @ExtractFileID )
	
	--exec tst_JobPrepareEventTest2 1214, @isDeleted
   
	exec tst_JobPrepareEventTest2 28
	exec tst_JobPrepareEventTest2 30

    insert into ExtractQueue( EntityTypeID, PKey1, PKey2, IsMetaData, IsDeleted)
    select 8, 2, 1, 0 ,1

	RETURN


