
USE [QP_Load]
GO


DECLARE @strFunction_Code varchar(5000)

SET @strFunction_Code = 'Function GetHCAHPSDischargeStatus(strDischargeStatus,strVisitType) 
    ''Only consider inpatient records
    If strVisitType = "I" Then
        Select Case strDischargeStatus
            Case "01","1","02","2","03","3","04","4","05","5","06","6","07","7","20","21","40","41","42","43","50","51","61","62","63","64","65","66","69","70","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"
                GetHCAHPSDischargeStatus = strDischargeStatus      
            Case Else
                GetHCAHPSDischargeStatus = "M"    ''code for missing value
        End Select
    Else
        GetHCAHPSDischargeStatus = dbNull
    End If
End Function'

UPDATE [dbo].[Functions]
   SET [strFunction_Code] = @strFunction_Code
 WHERE strFunction_nm = 'GetHCAHPSDischargeStatus' 



 SELECT * 
 FROM [dbo].[Functions] 
 WHERE strFunction_nm = 'GetHCAHPSDischargeStatus' 
