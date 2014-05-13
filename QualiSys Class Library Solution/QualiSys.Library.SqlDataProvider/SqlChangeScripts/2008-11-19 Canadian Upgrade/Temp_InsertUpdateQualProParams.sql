/****** 
Create this SP at the beginning of Qualisys installation and drop it after insatllation is 
Complete
 ******/
USE [QP_Prod]
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'Temp_InsertUpdateQualProParams' AND type = 'P')
   DROP PROCEDURE Temp_InsertUpdateQualProParams
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Temp_InsertUpdateQualProParams
@strParam_Nm varchar(50),
@strParam_Type char(1),
@strParam_Grp varchar(20),
@strParam_Value varchar(255),
@numParam_Value int,
@datParam_Value datetime,
@Comments varchar(255)

AS

IF EXISTS(SELECT * FROM QualPro_Params WHERE strParam_Nm = @strParam_Nm)
    UPDATE QualPro_Params
    SET strParam_Type = @strParam_Type, strParam_Grp = @strParam_Grp, 
        strParam_Value = @strParam_Value, numParam_Value = @numParam_Value, 
        datParam_Value = @datParam_Value, Comments = @Comments
    WHERE strParam_Nm = @strParam_Nm
ELSE
    INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, 
                                strParam_Value, numParam_Value, datParam_Value, Comments)
    VALUES (@strParam_Nm, @strParam_Type, @strParam_Grp, @strParam_Value, @numParam_Value, 
            @datParam_Value, @Comments)
GO
