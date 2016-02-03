'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class VRTDispositionWestProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.VRTDispositionWestProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const ImportVRTDisposition As String = "dbo.VRT_ImportDispositionWest"
    End Class
#End Region

#Region " SPTI_DeDupRule Procs "

    'Private Function PopulateVRTDisposition(ByVal rdr As SafeDataReader) As VRTDisposition
    '    Dim newObject As SPTI_DeDupRule = SPTI_DeDupRule.NewSPTI_DeDupRule
    '    Dim privateInterface As ISPTI_DeDupRule = newObject
    '    newObject.BeginPopulate()

    '    newObject.EndPopulate()

    '    Return newObject
    'End Function

    Public Overrides Function ImportVRTDisposition(ByVal index As Integer, ByVal instance As VRTDispositionWest) As String
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ImportVRTDisposition, instance.RespondentID, _
                        index, NullString(instance.CallOutcome), ParseNullDate(instance.DateTimeStamp), instance.CallType)
        Dim retVal As String = "Line " & index & ": Disposition added."
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                'Do nothing.
            Else
                retVal = CStr(rdr("ErrDescription"))
            End If
        End Using
        Return retVal
    End Function
    Private Function NullString(ByVal str As String) As Object
        If str = "" OrElse str = String.Empty Then
            Return DBNull.Value
        Else
            Return str
        End If
    End Function
    Private Function ParseNullDate(ByVal dte As String) As Object
        Dim theDate As Nullable(Of DateTime)
        Dim strArray() As String = dte.Split("."c)
        If IsDate((strArray(1) & "/" & strArray(2) & "/" & strArray(0) & " " & strArray(3) & ":" & strArray(4) & ":" & strArray(5))) Then
            theDate = CDate((strArray(1) & "/" & strArray(2) & "/" & strArray(0) & " " & strArray(3) & ":" & strArray(4) & ":" & strArray(5)))
        End If
        If Not theDate.HasValue Then
            Return DBNull.Value
        Else
            Return theDate.Value
        End If
    End Function

#End Region


End Class
