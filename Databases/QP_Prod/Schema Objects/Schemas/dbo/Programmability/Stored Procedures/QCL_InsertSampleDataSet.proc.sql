CREATE PROCEDURE [dbo].[QCL_InsertSampleDataSet]  
 @SampleSet_id int,   
 @dataSet_Id int  
AS  
  
insert into sampledatasetlog select @sampleset_id, @dataset_id, getdate()
INSERT INTO dbo.SampleDataSet values (@SampleSet_id, @dataSet_Id)


