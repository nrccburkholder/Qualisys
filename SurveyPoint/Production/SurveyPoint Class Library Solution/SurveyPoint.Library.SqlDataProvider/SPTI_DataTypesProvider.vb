'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_DataTypesProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_DataTypesProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_DataType As String = "dbo.SPTI_DeleteSPTI_DataType"
        Public Const InsertSPTI_DataType As String = "dbo.SPTI_InsertSPTI_DataType"
        Public Const SelectAllSPTI_DataTypes As String = "dbo.SPTI_SelectAllSPTI_DataTypes"
        Public Const SelectSPTI_DataType As String = "dbo.SPTI_SelectSPTI_DataType"
        Public Const UpdateSPTI_DataType As String = "dbo.SPTI_UpdateSPTI_DataType"
    End Class
#End Region

#Region " SPTI_DataType Procs "

    Private Function PopulateSPTI_DataType(ByVal rdr As SafeDataReader) As SPTI_DataType
        Dim newObject As SPTI_DataType = SPTI_DataType.NewSPTI_DataType
        Dim privateInterface As ISPTI_DataType = newObject
        newObject.BeginPopulate()
        privateInterface.DateTypeID = rdr.GetInteger("DateTypeID")
        newObject.Name = rdr.GetString("Name")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_DataType(ByVal dateTypeID As Integer) As SPTI_DataType
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_DataType, dateTypeID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_DataType(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DataTypes() As SPTI_DataTypeCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DataTypes)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DataTypeCollection, SPTI_DataType)(rdr, AddressOf PopulateSPTI_DataType)
        End Using
    End Function

    Public Overrides Function InsertSPTI_DataType(ByVal instance As SPTI_DataType) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_DataType, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_DataType(ByVal instance As SPTI_DataType)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_DataType, instance.DateTypeID, instance.Name, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_DataType(ByVal dateTypeID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_DataType, dateTypeID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
