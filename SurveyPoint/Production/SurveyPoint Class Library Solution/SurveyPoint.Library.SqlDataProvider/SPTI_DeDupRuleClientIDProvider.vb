'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_DeDupRuleClientIDProvider
    Inherits DataProviders.SPTI_DeDupRuleClientIDProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_DeDupRuleClientID As String = "dbo.SPTI_DeleteSPTI_DeDupRuleClientID"
        Public Const InsertSPTI_DeDupRuleClientID As String = "dbo.SPTI_InsertSPTI_DeDupRuleClientID"
        Public Const SelectAllSPTI_DeDupRuleClientIDs As String = "dbo.SPTI_SelectAllSPTI_DeDupRuleClientIDs"
        Public Const SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID As String = "dbo.SPTI_SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID"
        Public Const SelectSPTI_DeDupRuleClientID As String = "dbo.SPTI_SelectSPTI_DeDupRuleClientID"
        Public Const UpdateSPTI_DeDupRuleClientID As String = "dbo.SPTI_UpdateSPTI_DeDupRuleClientID"
        Public Const GetClientName As String = "dbo.SPTI_GetClientName"
    End Class
#End Region

#Region " SPTI_DeDupRuleClientID Procs "

    Private Function PopulateSPTI_DeDupRuleClientID(ByVal rdr As SafeDataReader) As SPTI_DeDupRuleClientID
        Dim newObject As SPTI_DeDupRuleClientID = SPTI_DeDupRuleClientID.NewSPTI_DeDupRuleClientID
        Dim privateInterface As ISPTI_DeDupRuleClientID = newObject
        newObject.BeginPopulate()
        privateInterface.ID = rdr.GetInteger("ID")
        newObject.DeDupRuleID = rdr.GetInteger("DeDupRuleID")
        newObject.ClientID = rdr.GetInteger("ClientID")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_DeDupRuleClientID(ByVal iD As Integer) As SPTI_DeDupRuleClientID
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_DeDupRuleClientID, iD)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_DeDupRuleClientID(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DeDupRuleClientIDs() As SPTI_DeDupRuleClientIDCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRuleClientIDs)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DeDupRuleClientIDCollection, SPTI_DeDupRuleClientID)(rdr, AddressOf PopulateSPTI_DeDupRuleClientID)
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleClientIDCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRuleClientIDsByDeDupRuleID, deDupRuleID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DeDupRuleClientIDCollection, SPTI_DeDupRuleClientID)(rdr, AddressOf PopulateSPTI_DeDupRuleClientID)
        End Using
    End Function

    Public Overrides Function GetClientName(ByVal clientID As Integer) As String
        Dim retVal As String = String.Empty
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetClientName, clientID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                retVal = rdr.GetString("Name")
            End While
        End Using
        Return retVal
    End Function

    Public Overrides Function InsertSPTI_DeDupRuleClientID(ByVal instance As SPTI_DeDupRuleClientID) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_DeDupRuleClientID, instance.DeDupRuleID, instance.ClientID)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_DeDupRuleClientID(ByVal instance As SPTI_DeDupRuleClientID)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_DeDupRuleClientID, instance.ID, instance.DeDupRuleID, instance.ClientID)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_DeDupRuleClientID(ByVal iD As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_DeDupRuleClientID, iD)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
