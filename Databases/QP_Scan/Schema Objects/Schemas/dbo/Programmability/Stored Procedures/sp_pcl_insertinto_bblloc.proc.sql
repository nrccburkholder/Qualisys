/* This stored procedure will populate the BubbleLoc table with upto 6 results for each
** call for each questionform_id.
** Created: Daniel Vansteenburg, Cap Gemini America, LLC
** Date:  5/20/1999
** Notes: 
** Modifications:
*/
create procedure dbo.sp_pcl_insertinto_bblloc
 @questionform_id int,
 @selqstns_id1 int=NULL, @item1 int=NULL, @sampleunit_id1 int=NULL,
 @charset1 int=NULL, @val1 int=NULL, @intresptype1 int=NULL, @relx1 int=NULL, @rely1 int=NULL,
 @selqstns_id2 int=NULL, @item2 int=NULL, @sampleunit_id2 int=NULL,
 @charset2 int=NULL, @val2 int=NULL, @intresptype2 int=NULL, @relx2 int=NULL, @rely2 int=NULL,
 @selqstns_id3 int=NULL, @item3 int=NULL, @sampleunit_id3 int=NULL,
 @charset3 int=NULL, @val3 int=NULL, @intresptype3 int=NULL, @relx3 int=NULL, @rely3 int=NULL,
 @selqstns_id4 int=NULL, @item4 int=NULL, @sampleunit_id4 int=NULL,
 @charset4 int=NULL, @val4 int=NULL, @intresptype4 int=NULL, @relx4 int=NULL, @rely4 int=NULL,
 @selqstns_id5 int=NULL, @item5 int=NULL, @sampleunit_id5 int=NULL,
 @charset5 int=NULL, @val5 int=NULL, @intresptype5 int=NULL, @relx5 int=NULL, @rely5 int=NULL,
 @selqstns_id6 int=NULL, @item6 int=NULL, @sampleunit_id6 int=NULL,
 @charset6 int=NULL, @val6 int=NULL, @intresptype6 int=NULL, @relx6 int=NULL, @rely6 int=NULL
as
 if @selqstns_id1 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id1, @item1, @sampleunit_id1,
   @charset1, @val1, @intresptype1, @relx1, @rely1
  )
 end
 if @selqstns_id2 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id2, @item2, @sampleunit_id2,
   @charset2, @val2, @intresptype2, @relx2, @rely2
  )
 end
 if @selqstns_id3 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id3, @item3, @sampleunit_id3,
   @charset3, @val3, @intresptype3, @relx3, @rely3
  )
 end
 if @selqstns_id4 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id4, @item4, @sampleunit_id4,
   @charset4, @val4, @intresptype4, @relx4, @rely4
  )
 end
 if @selqstns_id5 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id5, @item5, @sampleunit_id5,
   @charset5, @val5, @intresptype5, @relx5, @rely5
  )
 end
 if @selqstns_id6 is not null
 begin
  INSERT INTO dbo.BubbleLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   CharSet, Val, intRespType, RelX, RelY
  ) VALUES (
   @questionform_id, @selqstns_id6, @item6, @sampleunit_id6,
   @charset6, @val6, @intresptype6, @relx6, @rely6
  )
 end


