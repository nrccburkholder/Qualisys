'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    'Public Const DeleteQUALPRO_PARAMS As String = "dbo.DL_DeleteQUALPRO_PARAMS"
    'Public Const SelectAllQUALPRO_PARAMSs As String = "dbo.FRM_SelectAllParameters"
    'Public Const SelectQUALPRO_PARAMS As String = "dbo.FRM_SelectParameter"
    'Public Const SelectQUALPRO_PARAMSByName As String = "dbo.FRM_SelectParameterByName"
    Public Const UpdateQUALPRO_PARAMS As String = "dbo.Temp_InsertUpdateQualProParams"
    Public Const InsertQUALPRO_PARAMS As String = "dbo.Temp_InsertUpdateQualProParams"
End Class
#End Region
