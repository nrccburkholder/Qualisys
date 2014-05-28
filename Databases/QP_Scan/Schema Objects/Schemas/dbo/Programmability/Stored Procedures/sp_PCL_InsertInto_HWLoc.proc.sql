create procedure dbo.sp_PCL_InsertInto_HWLoc
 @questionform_id int,
 @selqstns_id1 int=NULL, @item1 int=NULL, @sampleunit_id1 int=NULL, @line1 int=NULL, @relx1 int=NULL, @rely1 int=NULL, @width1 int=NULL,
 @selqstns_id2 int=NULL, @item2 int=NULL, @sampleunit_id2 int=NULL, @line2 int=NULL, @relx2 int=NULL, @rely2 int=NULL, @width2 int=NULL,
 @selqstns_id3 int=NULL, @item3 int=NULL, @sampleunit_id3 int=NULL, @line3 int=NULL, @relx3 int=NULL, @rely3 int=NULL, @width3 int=NULL,
 @selqstns_id4 int=NULL, @item4 int=NULL, @sampleunit_id4 int=NULL, @line4 int=NULL, @relx4 int=NULL, @rely4 int=NULL, @width4 int=NULL,
 @selqstns_id5 int=NULL, @item5 int=NULL, @sampleunit_id5 int=NULL, @line5 int=NULL, @relx5 int=NULL, @rely5 int=NULL, @width5 int=NULL,
 @selqstns_id6 int=NULL, @item6 int=NULL, @sampleunit_id6 int=NULL, @line6 int=NULL, @relx6 int=NULL, @rely6 int=NULL, @width6 int=NULL
as
 if @selqstns_id1 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id1, @item1, @sampleunit_id1,
   @line1, @relx1, @rely1, @width1
  )
 end
 if @selqstns_id2 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id2, @item2, @sampleunit_id2,
   @line2, @relx2, @rely2, @width2
  )
 end
 if @selqstns_id3 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id3, @item3, @sampleunit_id3,
   @line3, @relx3, @rely3, @width3
  )
 end
 if @selqstns_id4 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id4, @item4, @sampleunit_id4,
   @line4, @relx4, @rely4, @width4
  )
 end
 if @selqstns_id5 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id5, @item5, @sampleunit_id5,
   @line5, @relx5, @rely5, @width5
  )
 end
 if @selqstns_id6 is not null
 begin
  INSERT INTO dbo.HandwrittenLoc (
   QuestionForm_id, SelQstns_id, Item, SampleUnit_id,
   Line_id, RelX, RelY, intWidth
  ) VALUES (
   @questionform_id, @selqstns_id6, @item6, @sampleunit_id6,
   @line6, @relx6, @rely6, @width6
  )
 end


