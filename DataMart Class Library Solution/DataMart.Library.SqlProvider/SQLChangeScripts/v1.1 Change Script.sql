CREATE PROCEDURE [dbo].[DCL_SelectSurveysbyStudyID] 
@StudyId INT
AS
 
SELECT Survey_id, strSurvey_NM, Study_id, strQSurvey_NM
FROM ClientStudySurvey
WHERE study_id=@StudyId
GROUP BY Survey_id, strSurvey_NM, Study_id, strQSurvey_NM
ORDER BY strQSurvey_NM
GO
/*--------------------------------------------------------------------------------------------------*/
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[WeightType](
	[WeightType_ID] [int] IDENTITY(1,1) NOT NULL,
	[WeightTypeLabel] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExportColumnName] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_WeightType] PRIMARY KEY CLUSTERED 
(
	[WeightType_ID] ASC
) ON [PRIMARY],
 CONSTRAINT [IX_WeightTypeLabel] UNIQUE NONCLUSTERED 
(
	[WeightTypeLabel] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
/*--------------------------------------------------------------------------------------------------*/
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeightSet](
	[WeightSet_ID] [int] IDENTITY(1,1) NOT NULL,
	[Study_ID] [int] NOT NULL,
	[WeightType_ID] [int] NOT NULL,
	[EmployeeName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DateAdded] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_WeightSet] PRIMARY KEY CLUSTERED 
(
	[WeightSet_ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WeightSet]  WITH CHECK ADD  CONSTRAINT [FK_WeightSet_WeightType] FOREIGN KEY([WeightType_ID])
REFERENCES [dbo].[WeightType]

GO
/*--------------------------------------------------------------------------------------------------*/
GO

Create Procedure DCL_InsertWeightType
	@WeightTypeLabel varchar(42),
	@ExportColumnName varchar(8)
as

INSERT WeightType (WeightTypeLabel,ExportColumnName)
VALUES (@weightTypeLabel,@ExportColumnName)

Select scope_identity()
GO
/*--------------------------------------------------------------------------------------------------*/
GO
Create Procedure DCL_UpdateWeightType
	@WeightTypeId int,
	@WeightTypeLabel varchar(42),
	@ExportColumnName varchar(8)
as

UPDATE WeightType 
	SET WeightTypeLabel=@weightTypeLabel,
		ExportColumnName=@ExportColumnName
	WHERE WeightType_Id=@WeightTypeId
GO
/*--------------------------------------------------------------------------------------------------*/
GO
Create Procedure DCL_DELETEWeightType
	@WeightTypeId int
as

DELETE WeightType 
	WHERE WeightType_Id=@WeightTypeId
GO
/*--------------------------------------------------------------------------------------------------*/
GO

sp_addmessage @msgnum = 50013,
              @severity = 15,
              @msgtext = 'Weights already exist for some samplepops in the database.'
              
GO
/*--------------------------------------------------------------------------------------------------*/
GO
/*******************************************************************************
 *
 * Description:
 *           This procedure will load weights into the study owned 'WeightValue' table.  It
 *			 also does several checks, etc.
 *				1.  If the replace option is false, it will verify that none of the samplepops already
 *					have a weight value.  If 1 or more have a weight value, exit the SP
 *				2.  Deletes any samplepops from a different study
 *				3.  If replace is true and the new value is null, delete the old record from the 'WeightValue' table
 *              4.  If replace is true and the new value is not null, update the value and weightsetID in the old record
 *				5.  Insert all new values that are not for an existing record
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           1.0  05/15/2006 by DC
 *
 ******************************************************************************/

CREATE procedure [dbo].[DCL_InsertWeightValues]
	@studyID int,
	@tempTableName varchar(100),
	@replace bit =0,
	@WeightTypeID int,
	@EmployeeName varchar(42)
as

declare @sel varchar(7000), @badPopCount int, @WeightSet_id int, @updateCount int, @InsertCount int, @NullWeightCount as int
set @badPopCount=0
set @updateCount=0
set @InsertCount=0
set @NullWeightCount=0

create table #messages (message varchar(1000))
create table #counts (type varchar(42), freq int)

/*Check to See if weights already exist if the replace option is off*/
create table #AlreadySampledPops (samplepop_id int, weightValue float)
set @sel='
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''[s' + convert(varchar,@studyID)+'].[WeightValue]'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1)
	BEGIN
		insert #AlreadySampledPops (samplepop_id, weightValue)
		select t.samplepop_id, t.weightValue
		from '+ @tempTableName + ' t, s'+ convert(varchar,@studyId) + '.WeightValue wv
		WHERE t.samplepop_id=wv.samplepop_id and
				wv.weightType_ID='+ convert(varchar,@weightTypeID) + '
	END'

exec (@sel)
	IF @@ERROR>0 
	BEGIN
		GOTO Cleanup
	END

IF @Replace=0
BEGIN
		IF EXISTS (select top 1 samplepop_id from #AlreadySampledPops)
		BEGIN
			RAISERROR (50013,15,1)
			GOTO Cleanup
		END
END

/*get a list of SamplePops from other studies*/
	create table #badPops (samplepop_id int)
	set @sel='insert #badPops (samplepop_id)
		select t.samplepop_id
		from '+ @tempTableName + ' t left join s'+ convert(varchar,@studyId) + '.big_table_view bv
		on t.samplepop_id=bv.samplepop_id
		where bv.samplepop_id is null

		INSERT INTO #counts values (''badPopCount'', @@rowcount)'

	exec (@sel)
	IF @@ERROR>0 
	BEGIN
		GOTO Cleanup
	END

	IF EXISTS (select freq from #counts where type='badPopCount' and freq>0)
	BEGIN
		set @sel='DELETE T
				  FROM '+ @tempTableName + ' t, #badPops b
				  WHERE t.samplepop_id=b.samplepop_id'

		exec (@sel)
		IF @@ERROR>0 
		BEGIN
			GOTO Cleanup
		END

	END

/***************************************************************************************
				START TRANSACTIONAL CHANGES
****************************************************************************************/
BEGIN TRAN

	/*Create a weightSet Record*/
	INSERT WeightSet (study_id, weightType_id, EmployeeName, dateAdded)
				  Values (@studyId, @weightTypeID, @EmployeeName , getDate())

	IF @@ERROR>0 
	BEGIN
		ROLLBACK TRAN
		GOTO Cleanup
	END
	SET @WeightSet_id=SCOPE_IDENTITY()

	IF @Replace=1
	BEGIN
		/*Delete Existing Weight Records if a null weight is found and Replace is true*/
		set @sel='DELETE wv
					  FROM '+ @tempTableName + ' t, s'+ convert(varchar,@studyId) + '.WeightValue wv
					  WHERE t.samplepop_id=wv.samplepop_id and
							wv.weightType_ID='+ convert(varchar,@weightTypeID) + ' and
							t.weightValue is null

					  INSERT INTO #counts values (''NullWeightCount'', @@rowcount)'

		exec (@sel)
		IF @@ERROR>0 
		BEGIN
			ROLLBACK TRAN
			GOTO Cleanup
		END

		/*Delete Existing Weight Records from tempTable so we won't insert them again later*/
		set @sel='DELETE t
					  FROM '+ @tempTableName + ' t, #AlreadySampledPops a
					  WHERE t.samplepop_id=a.samplepop_id'

		exec (@sel)
		IF @@ERROR>0 
		BEGIN
			ROLLBACK TRAN
			GOTO Cleanup
		END

		/*Update the existing records*/
		set @sel='UPDATE wv
					  SET WeightSet_id= ' +convert(varchar,@WeightSet_ID) + ',
						  WeightValue=a.WeightValue
					  FROM #AlreadySampledPops a, s'+ convert(varchar,@studyId) + '.WeightValue wv
					  WHERE a.samplepop_id=wv.samplepop_id and
							wv.weightType_ID='+ convert(varchar,@weightTypeID) + '

				  INSERT INTO #counts values (''updateCount'', @@rowcount)'

		exec (@sel)
		IF @@ERROR>0 
		BEGIN
			ROLLBACK TRAN
			GOTO Cleanup
		END
	END

	/*INSERT Weight Records; Create the weight Table if needed*/
	set @sel='
	IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''[s' + convert(varchar,@studyID)+'].[WeightValue]'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1)
	BEGIN
		SET ANSI_NULLS ON
		SET QUOTED_IDENTIFIER ON
		CREATE TABLE [s' + convert(varchar,@studyID)+'].[WeightValue](
			[SamplePop_ID] [int] NOT NULL,
			[WeightType_ID] [int] NOT NULL,
			[WeightValue] [float] NOT NULL,
			[WeightSet_ID] [int] NOT NULL,
		 CONSTRAINT [PK_WeightValue] PRIMARY KEY CLUSTERED 
		(
			[SamplePop_ID] ASC,
			[WeightType_ID] ASC
		) ON [PRIMARY]
		) ON [PRIMARY]
	END'

	exec (@sel)
	IF @@ERROR>0 
	BEGIN
		ROLLBACK TRAN
		GOTO Cleanup
	END

	set @sel='INSERT s'+ convert(varchar,@studyId) + '.WeightValue (samplepop_id, weighttype_id, weightValue, WeightSet_ID)
				  SELECT samplepop_id, ' + convert(varchar,@WeightTypeID) + ', weightValue, ' + convert(varchar,@WeightSet_ID) + '
				  FROM '+ @tempTableName + '

			  INSERT INTO #counts values (''insertCount'', @@rowcount)'

	exec (@sel)
	IF @@ERROR>0 
	BEGIN
		ROLLBACK TRAN
		GOTO Cleanup
	END
	
	--Delete the APB data cache for anything using this weight type
	exec APB_MN_DeleteCacheByWeightType @WeightTypeID

COMMIT TRAN

select @badPopCount=freq from #counts where type='badPopCount'
select @NullWeightCount=freq from #counts where type='NullWeightCount'
select @updateCount=freq from #counts where type='updateCount'
select @insertCount=freq from #counts where type='insertCount'

INSERT INTO #messages (message) values ('Load completed successfully.')
INSERT INTO #messages (message) values (convert(varchar, @NullWeightCount) + ' records were deleted because the weight value was null.')
INSERT INTO #messages (message) values (convert(varchar, @badPopCount) + ' records from other studies were not loaded.')
INSERT INTO #messages (message) values (convert(varchar, @updateCount) + ' existing records were updated.')
INSERT INTO #messages (message) values (convert(varchar, @InsertCount) + ' new records were added.')

Select *
from #messages

/*Cleanup*/
Cleanup:
	set @sel='IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N''' + @tempTableName+ ''') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1)
		BEGIN	
			DROP TABLE '+ @tempTableName + '
		END'

	exec (@sel)
GO
/*--------------------------------------------------------------------------------------------------*/
GO
Create Procedure DCL_SelectWeightType
	@WeightTypeId int
as

Select WeightType_Id, WeightTypeLabel, ExportColumnName
FROM WeightType 
WHERE WeightType_Id=@WeightTypeId
GO
/*--------------------------------------------------------------------------------------------------*/
GO
Create Procedure DCL_SelectWeightTypes
as

Select WeightType_Id, WeightTypeLabel, ExportColumnName
FROM WeightType 
GO
/*--------------------------------------------------------------------------------------------------*/
GO
CREATE PROCEDURE DCL_IsWeightTypeDeletable
	@WeightTypeId int
as

Select top 1 WeightType_Id
FROM WeightSet 
WHERE WeightType_Id=@WeightTypeId
GO
/*--------------------------------------------------------------------------------------------------*/
GO
CREATE PROCEDURE [dbo].[DCL_DeleteWeightSet]
@WeightSetId INT
AS
declare @study_id int, @sel varchar(1000)

select @study_id=study_id
from weightset
where weightset_id=@weightsetId

set @sel='delete 
		  from s' + convert(varchar,@study_id) + '.weightvalue
		  where weightset_id=' + convert(varchar, @weightsetid) + '

		  delete 
		  from weightset
		  where weightset_id=' + convert(varchar, @weightsetid)

exec (@sel)
GO
/*--------------------------------------------------------------------------------------------------*/
GO
