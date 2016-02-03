'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class VRTDispositionProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.VRTDispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const ImportVRTDisposition As String = "dbo.VRT_ImportDisposition"
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

    Public Overrides Function ImportVRTDisposition(ByVal index As Integer, ByVal instance As VRTDisposition) As String
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ImportVRTDisposition, instance.RespondentID, _
                        index, NullString(instance.CallCode1), NullString(instance.CallCode2), NullString(instance.CallCode3), _
                        NullDate(instance.CallDate1), NullDate(instance.CallDate2), NullDate(instance.CallDate3))
        Dim retVal As String = "Line " & index & ": disposition has been added."
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
    Private Function NullDate(ByVal dte As Nullable(Of DateTime)) As Object
        If Not dte.HasValue Then
            Return DBNull.Value
        Else
            Return dte.Value
        End If
    End Function

#End Region


End Class
