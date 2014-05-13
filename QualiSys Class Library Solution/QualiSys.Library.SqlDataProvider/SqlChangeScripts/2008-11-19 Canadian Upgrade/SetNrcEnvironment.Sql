/* Pass "Production", "Testing" or "Staging" to set the environment
This is neccessary for other scripts that have conditional logic around 
environment name
Run this after Creating Temp_InsertUpdateQualProParams stored procedure and
before running any insert\update that involves Temp_InsertUpdateQualProParams
 */

 USE [QP_Prod]
IF EXISTS (SELECT name FROM sysobjects 
         WHERE name = 'SetNrcEnvironment' AND type = 'P')
   DROP PROCEDURE SetNrcEnvironment
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SetNrcEnvironment
@EnvironmentName varchar(20)
As
	IF Upper(@EnvironmentName) = 'PRODUCTION'
		Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'EnvName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Environment', --strParam_GRP
				'PRODUCTION', --strParam_Value
				1, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	IF Upper(@EnvironmentName) = 'TESTING'
		Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'EnvName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Environment', --strParam_GRP
				'TESTING', --strParam_Value
				2, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
	IF Upper(@EnvironmentName) = 'STAGING'
		Begin
			Exec [Temp_InsertUpdateQualProParams] 
				'EnvName', --strParam_nm
				'S', --strParam_type can be "N","S" or "D"
				'Environment', --strParam_GRP
				'STAGING', --strParam_Value
				3, --numParam_Value
				Null, --datParam_Value
				Null --Please enter the description
		End
