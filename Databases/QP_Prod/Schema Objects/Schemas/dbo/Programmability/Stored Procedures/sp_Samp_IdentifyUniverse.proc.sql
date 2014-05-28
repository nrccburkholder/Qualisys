/***********************************************************************************************************************************
SP Name: sp_Samp_IdentifyUniverse
Part of:  Sampling Tool
Purpose:  Loads data into the #UNIVERSE table
 
Output:  Updated #Universe table
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 2/29/2000 - Dave Gilsdorf
   changed the two Date parameters to be optional
***********************************************************************************************************************************/

CREATE PROCEDURE sp_Samp_IdentifyUniverse 
 @intStudy_id int,
 @vcDataSet_ids varchar(8000),
 @intSSDR_Table_id int,
 @intSSDR_Field_id int,
 @vcSSDR_From_Date varchar(10) = '01/01/1900',
 @vcSSDR_To_Date varchar(10) = '12/31/2999',
 @vcPopID_EncID_Select varchar(8000),
 @vcBigView_Join varchar(8000)
AS
 DECLARE @vcSQL varchar(8000)
 if @vcSSDR_From_Date='' 
     select @vcSSDR_From_Date = '01/01/1900'
 if @vcSSDR_To_Date = ''  
     select @vcSSDR_To_Date = '12/31/2999'
 /*Populate the DataSet Table*/
 EXECUTE dbo.sp_Samp_IdentifyDataSets @vcDataSet_ids
 /*Format the SQL Statement to populate the Universe table and execute it*/
 EXECUTE dbo.sp_Samp_FormatUnivSQL @intStudy_id, @intSSDR_Table_id, @intSSDR_Field_id, 
   @vcSSDR_From_Date, @vcSSDR_To_Date, @vcPopID_EncID_Select, 
   @vcBigView_Join, @vcSQL OUTPUT

set transaction isolation level read uncommitted

 EXECUTE (@vcSQL)

set transaction isolation level read committed


