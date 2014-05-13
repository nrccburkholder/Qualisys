/* 
-- Begin work area

Select * from Functions where strFunction_Nm = 'GetHCAHPSAdmissionSource'

select * from FunctionGroup where FunctionGroup_id = 13

select * from FunctionGroup where FunctionGroup_id = 2

-- Set results to text format
Select strFunction_Code from Functions where strFunction_Nm = 'GetHCAHPSAdmissionSource'

-- End work area
*/

-------------------------------------------------------------------------
-- Copyright © National Research Corporation
--
-- Project Name:        HCAHPS XML v3.0
--
-- Created By:          Jeffrey J. Fleming
--       Date:          04-16-2008
--
-- Description:
-- This script will insert the GetHCAHPSAdmissionSource into the Functions table
--
-- Revisions:
--              Date            By              Description
-------------------------------------------------------------------------

DECLARE @FuncCode varchar(5000)

-- Set the FunctionCode
SET @FuncCode = 'Function GetHCAHPSAdmissionSource(strAdmitSource,strVisitType)
    ''Only consider inpatient records
    If strVisitType = "I" Then
       Select Case UCase(strAdmitSource)
            Case "1","2","4","5","6","7","8","D","E"
                GetHCAHPSAdmissionSource = strAdmitSource
            Case "3","A"
                GetHCAHPSAdmissionSource = "9"    ''code for missing value
            Case Else    
                GetHCAHPSAdmissionSource = "9"    ''code for missing value
        End Select
    Else
        GetHCAHPSAdmissionSource = dbNull
    End If
End Function'

--Update the existing function
UPDATE Functions
SET strFunction_Code = @FuncCode
WHERE strFunction_Nm = 'GetHCAHPSAdmissionSource'
