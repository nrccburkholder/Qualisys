'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_DeDupRuleProvider
    Inherits DataProviders.SPTI_DeDupRuleProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_DeDupRule As String = "dbo.SPTI_DeleteSPTI_DeDupRule"
        Public Const InsertSPTI_DeDupRule As String = "dbo.SPTI_InsertSPTI_DeDupRule"
        Public Const SelectAllSPTI_DeDupRules As String = "dbo.SPTI_SelectAllSPTI_DeDupRules"
        Public Const SelectAllSPTI_DeDupRulesByFileID As String = "dbo.SPTI_SelectAllSPTI_DeDupRulesByFileID"
        Public Const SelectSPTI_DeDupRule As String = "dbo.SPTI_SelectSPTI_DeDupRule"
        Public Const UpdateSPTI_DeDupRule As String = "dbo.SPTI_UpdateSPTI_DeDupRule"
        Public Const DeleteDeDupRuleAndChildrenByFileID As String = "dbo.SPTI_DeleteDeDupRuleByFileID"
    End Class
#End Region

#Region " SPTI_DeDupRule Procs "

    Private Function PopulateSPTI_DeDupRule(ByVal rdr As SafeDataReader) As SPTI_DeDupRule
        Dim newObject As SPTI_DeDupRule = SPTI_DeDupRule.NewSPTI_DeDupRule
        Dim privateInterface As ISPTI_DeDupRule = newObject
        newObject.BeginPopulate()
        privateInterface.DeDupRuleID = rdr.GetInteger("DeDupRuleID")
        newObject.FileID = rdr.GetInteger("FileID")
        newObject.Name = rdr.GetString("Name")
        newObject.ActiveSI = CBool(rdr.GetInteger("ActiveSI"))        
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_DeDupRule(ByVal deDupRuleID As Integer) As SPTI_DeDupRule
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_DeDupRule, deDupRuleID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_DeDupRule(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_DeDupRules() As SPTI_DeDupRuleCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRules)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_DeDupRuleCollection, SPTI_DeDupRule)(rdr, AddressOf PopulateSPTI_DeDupRule)
        End Using
    End Function
    
    Public Overrides Function SelectAllSPTI_DeDupRulesByFileID(ByVal fileID As Integer) As SPTI_DeDupRule
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_DeDupRulesByFileID, fileID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_DeDupRule(rdr)
            End If
        End Using
    End Function

    Public Overrides Function InsertSPTI_DeDupRule(ByVal instance As SPTI_DeDupRule) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSPTI_DeDupRule, instance.FileID, instance.Name, instance.ActiveSI)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_DeDupRule(ByVal instance As SPTI_DeDupRule)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_DeDupRule, instance.DeDupRuleID, instance.FileID, instance.Name, instance.ActiveSI)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_DeDupRule(ByVal deDupRuleID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_DeDupRule, deDupRuleID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Sub DeleteDeDupRuleAndChildrenByFileID(ByVal fileID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDeDupRuleAndChildrenByFileID, fileID)
        ExecuteNonQuery(cmd)
    End Sub
#End Region


End Class
