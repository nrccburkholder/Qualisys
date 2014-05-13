CREATE procedure Auth_addDefaultCommentfilters 
	@user_ID int
as

if (select count(*) from useraccess ua where user_id = @user_ID) = 0
return

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(16,@user_ID,1,'Age',1,1,1,0)

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(137,@user_ID,1,'AreaCode',1,0,0,0)

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(7,@user_ID,1,'FirstName',1,0,0,0)

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(6,@user_ID,1,'LastName',1,0,0,0)

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(76,@user_ID,1,'Phone',1,0,0,0)

insert into commentfilters (Field_ID,User_ID,bitSA_Display,strFieldLabel,bitSA_Export,bitGeneral_Display,bitGeneral_Export,bitCommentFilter)
values(-1,@user_ID,0,'SampleUnit',0,0,0,1)

------------------
GO
------------------

alter PROCEDURE Auth_Old_NewUser    
  @Client_id INT, @User_id INT, @NTLogin VARCHAR(100), @Email VARCHAR(100)    
AS      
SET NOCOUNT ON      
      
INSERT INTO UserAccess (User_id, strUser_nm, Client_id, intPFReportTemplate_id, intPFSAReportTemplate_id)      
VALUES (@User_id, @NTLogin, @Client_id, 6, 8)      

INSERT INTO UserAccessWA (User_id, Client_id, strEmailList, intEmailFormat, QualityProgram_id, CompDataSet_id, intPFReportTemplate_id, intPFSAReportTemplate_id)      
VALUES (@User_id, @Client_id, @Email, 2, 2, 2, 6, 8)
      
EXEC Auth_addDefaultCommentfilters @User_id    


-----------------
GO
-----------------
/*
Business Purpose: 

This procedure is used to update the metastructure table.  It is used when adding eReports filters.

Created:  7/31/2006 by DC

Modified:
*/    
ALTER PROCEDURE [dbo].[DCL_UpdateStudyTableColumn]  
@StudyId INT,  
@TableId INT,
@FieldId INT,
@customName varchar(42),
@isAvailableFilter bit,
@isCalculated bit,
@formula varchar(5000)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
Update metastructure
SET bitAvailableFilter=@isAvailableFilter,
	strCustomFieldName=@customName
 WHERE field_id = @fieldid 
	AND Table_id=@TableId  
	AND Study_id=@StudyId


  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   


