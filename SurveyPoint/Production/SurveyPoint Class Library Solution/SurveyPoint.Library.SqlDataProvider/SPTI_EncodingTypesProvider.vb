'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_EncodingTypesProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_EncodingTypesProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_EncodingType As String = "dbo.SPTI_DeleteSPTI_EncodingType"
        Public Const InsertSPTI_EncodingType As String = "dbo.SPTI_InsertSPTI_EncodingType"
        Public Const SelectAllSPTI_EncodingTypes As String = "dbo.SPTI_SelectAllSPTI_EncodingTypes"
        Public Const SelectSPTI_EncodingType As String = "dbo.SPTI_SelectSPTI_EncodingType"
        Public Const UpdateSPTI_EncodingType As String = "dbo.SPTI_UpdateSPTI_EncodingType"
    End Class
#End Region

#Region " SPTI_EncodingType Procs "

    Private Function PopulateSPTI_EncodingType(ByVal rdr As SafeDataReader) As SPTI_EncodingType
        Dim newObject As SPTI_EncodingType = SPTI_EncodingType.NewSPTI_EncodingType
        Dim privateInterface As ISPTI_EncodingType = newObject
        newObject.BeginPopulate()
        privateInterface.EncodingTypeID = rdr.GetInteger("EncodingTypeID")
        newObject.Name = rdr.GetString("Name")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_EncodingType(ByVal encodingTypeID As Integer) As SPTI_EncodingType
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_EncodingType, encodingTypeID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_EncodingType(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_EncodingTypes() As SPTI_EncodingTypeCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_EncodingTypes)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_EncodingTypeCollection, SPTI_EncodingType)(rdr, AddressOf PopulateSPTI_EncodingType)
        End Using
    End Function

    Public Overrides Function InsertSPTI_EncodingType(ByVal instance As SPTI_EncodingType) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_EncodingType, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_EncodingType(ByVal instance As SPTI_EncodingType)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_EncodingType, instance.EncodingTypeID, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_EncodingType(ByVal encodingTypeID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_EncodingType, encodingTypeID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
