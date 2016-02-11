'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_DelimeterProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_DelimeterProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_Delimeter As String = "dbo.SPTI_DeleteSPTI_Delimeter"
        Public Const InsertSPTI_Delimeter As String = "dbo.SPTI_InsertSPTI_Delimeter"
        Public Const SelectAllSPTI_Delimeters As String = "dbo.SPTI_SelectAllSPTI_Delimeters"
        Public Const SelectSPTI_Delimeter As String = "dbo.SPTI_SelectSPTI_Delimeter"
        Public Const UpdateSPTI_Delimeter As String = "dbo.SPTI_UpdateSPTI_Delimeter"
    End Class
#End Region

#Region " SPTI_Delimeter Procs "

    Private Function PopulateSPTI_Delimeter(ByVal rdr As SafeDataReader) As SPTI_Delimeter
        Dim newObject As SPTI_Delimeter = SPTI_Delimeter.NewSPTI_Delimeter
        Dim privateInterface As ISPTI_Delimeter = newObject
        newObject.BeginPopulate()
        privateInterface.DelimeterID = rdr.GetInteger("DelimeterID")
        newObject.Name = rdr.GetString("Name")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_Delimeter(ByVal delimeterID As Integer) As SPTI_Delimeter
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_Delimeter, delimeterID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_Delimeter(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_Delimeters() As SPTI_DelimeterCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_Delimeters)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DelimeterCollection, SPTI_Delimeter)(rdr, AddressOf PopulateSPTI_Delimeter)
        End Using
    End Function

    Public Overrides Function InsertSPTI_Delimeter(ByVal instance As SPTI_Delimeter) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_Delimeter, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_Delimeter(ByVal instance As SPTI_Delimeter)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_Delimeter, instance.DelimeterID, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_Delimeter(ByVal delimeterID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_Delimeter, delimeterID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
