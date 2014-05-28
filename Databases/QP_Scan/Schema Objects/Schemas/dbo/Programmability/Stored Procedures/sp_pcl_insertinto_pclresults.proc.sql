/* This stored procedure will populate the PCLResults table with upto 6 results for each
** call for each questionform_id.
** Created: Daniel Vansteenburg, Cap Gemini America, LLC
** Date:  5/20/1999
** Notes: 
** Modifications:
*/
create procedure dbo.sp_pcl_insertinto_pclresults
 @questionform_id int=NULL,
 @pclresults_id1 int=NULL, 
 @qstncore1 int=NULL, @x1 int=NULL, @y1 int=NULL, @height1 int=NULL,
 @width1 int=NULL, @pagenum1 int=NULL, @side1 int=NULL, @sheet1 int=NULL,
 @selqstns_id1 int=NULL, @begcolumn1 int=NULL, @readmethod1 int=NULL,
 @intrespcol1 int=NULL, @sampleunit_id1 int=NULL,
 @pclresults_id2 int=NULL, 
 @qstncore2 int=NULL, @x2 int=NULL, @y2 int=NULL, @height2 int=NULL,
 @width2 int=NULL, @pagenum2 int=NULL, @side2 int=NULL, @sheet2 int=NULL,
 @selqstns_id2 int=NULL, @begcolumn2 int=NULL, @readmethod2 int=NULL,
 @intrespcol2 int=NULL, @sampleunit_id2 int=NULL,
 @pclresults_id3 int=NULL, 
 @qstncore3 int=NULL, @x3 int=NULL, @y3 int=NULL, @height3 int=NULL,
 @width3 int=NULL, @pagenum3 int=NULL, @side3 int=NULL, @sheet3 int=NULL,
 @selqstns_id3 int=NULL, @begcolumn3 int=NULL, @readmethod3 int=NULL,
 @intrespcol3 int=NULL, @sampleunit_id3 int=NULL,
 @pclresults_id4 int=NULL, 
 @qstncore4 int=NULL, @x4 int=NULL, @y4 int=NULL, @height4 int=NULL,
 @width4 int=NULL, @pagenum4 int=NULL, @side4 int=NULL, @sheet4 int=NULL,
 @selqstns_id4 int=NULL, @begcolumn4 int=NULL, @readmethod4 int=NULL,
 @intrespcol4 int=NULL, @sampleunit_id4 int=NULL,
 @pclresults_id5 int=NULL, 
 @qstncore5 int=NULL, @x5 int=NULL, @y5 int=NULL, @height5 int=NULL,
 @width5 int=NULL, @pagenum5 int=NULL, @side5 int=NULL, @sheet5 int=NULL,
 @selqstns_id5 int=NULL, @begcolumn5 int=NULL, @readmethod5 int=NULL,
 @intrespcol5 int=NULL, @sampleunit_id5 int=NULL,
 @pclresults_id6 int=NULL, 
 @qstncore6 int=NULL, @x6 int=NULL, @y6 int=NULL, @height6 int=NULL,
 @width6 int=NULL, @pagenum6 int=NULL, @side6 int=NULL, @sheet6 int=NULL,
 @selqstns_id6 int=NULL, @begcolumn6 int=NULL, @readmethod6 int=NULL,
 @intrespcol6 int=NULL, @sampleunit_id6 int=NULL
as
 if @pclresults_id1 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id1, @qstncore1, @x1, @y1, @height1,
   @width1, @pagenum1, @side1, @sheet1, @selqstns_id1, @begcolumn1,
   @readmethod1, @intrespcol1, @sampleunit_id1
  )
 end
 if @pclresults_id2 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id2, @qstncore2, @x2, @y2, @height2,
   @width2, @pagenum2, @side2, @sheet2, @selqstns_id2, @begcolumn2,
   @readmethod2, @intrespcol2, @sampleunit_id2
  )
 end
 if @pclresults_id3 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id3, @qstncore3, @x3, @y3, @height3,
   @width3, @pagenum3, @side3, @sheet3, @selqstns_id3, @begcolumn3,
   @readmethod3, @intrespcol3, @sampleunit_id3
  )
 end
 if @pclresults_id4 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id4, @qstncore4, @x4, @y4, @height4,
   @width4, @pagenum4, @side4, @sheet4, @selqstns_id4, @begcolumn4,
   @readmethod4, @intrespcol4, @sampleunit_id4
  )
 end
 if @pclresults_id5 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id5, @qstncore5, @x5, @y5, @height5,
   @width5, @pagenum5, @side5, @sheet5, @selqstns_id5, @begcolumn5,
   @readmethod5, @intrespcol5, @sampleunit_id5
  )
 end
 if @pclresults_id6 is not null
 begin
  INSERT INTO dbo.PCLResults (
   QuestionForm_id, PCLResults_id, QstnCore, X, Y, Height,
   Width, PageNum, Side, Sheet, SelQstns_id, BegColumn,
   ReadMethod, intRespCol, SampleUnit_id
  ) VALUES (
   @questionform_id, @pclresults_id6, @qstncore6, @x6, @y6, @height6,
   @width6, @pagenum6, @side6, @sheet6, @selqstns_id6, @begcolumn6,
   @readmethod6, @intrespcol6, @sampleunit_id6
  )
 end


