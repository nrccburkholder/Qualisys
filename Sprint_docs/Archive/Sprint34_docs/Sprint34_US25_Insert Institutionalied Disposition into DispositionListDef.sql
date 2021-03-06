/*

S34 US25  As a client service associate I would like the institutionalized disposition to be available in the Qualisys Explorer drop down so that I can select it for ICH & Hospice CAHPS callers

Task 1 - Add institutionalized disposition to default list in DisponsitionList Def

*/

USE QP_Prod

DECLARE @Disposition_id int

SELECT @Disposition_id = Disposition_id
  FROM [QP_Prod].DBO.Disposition d 
  where d.strReportLabel = 'Institutionalized'


IF NOT EXISTS (SELECT 1 FROM [dbo].[DispositionListDef] WHERE [DispositionList_id] = 1 AND [Disposition_id] = @Disposition_id)
BEGIN

	begin tran
	INSERT INTO [dbo].[DispositionListDef]
			   ([DispositionList_id]
			   ,[Disposition_id]
			   ,[Author]
			   ,[datOccurred])
		 VALUES
			   (1
			   ,24
			   ,948
			   ,getDate())

	commit tran

END

  SELECT dld.*, d.*
  FROM [QP_Prod].[dbo].[DispositionListDef] dld
   inner join [QP_Prod].DBO.Disposition d on (d.Disposition_id = dld.Disposition_id)
   where DispositionList_id = 1



