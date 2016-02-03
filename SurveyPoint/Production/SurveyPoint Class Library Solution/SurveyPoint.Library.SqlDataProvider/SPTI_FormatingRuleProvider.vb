'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SPTI_FormatingRuleProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.SPTI_FormatingRuleProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SP Declarations "
    Private NotInheritable Class SP
        Private Sub New()
        End Sub
        Public Const DeleteSPTI_FormattingRule As String = "dbo.SPTI_DeleteSPTI_FormattingRule"
        Public Const InsertSPTI_FormattingRule As String = "dbo.SPTI_InsertSPTI_FormattingRule"
        Public Const SelectAllSPTI_FormattingRules As String = "dbo.SPTI_SelectAllSPTI_FormattingRules"
        Public Const SelectSPTI_FormattingRule As String = "dbo.SPTI_SelectSPTI_FormattingRule"
        Public Const UpdateSPTI_FormattingRule As String = "dbo.SPTI_UpdateSPTI_FormattingRule"
    End Class
#End Region

#Region " SPTI_FormattingRule Procs "

    Private Function PopulateSPTI_FormattingRule(ByVal rdr As SafeDataReader) As SPTI_FormattingRule
        Dim newObject As SPTI_FormattingRule = SPTI_FormattingRule.NewSPTI_FormattingRule
        Dim privateInterface As ISPTI_FormattingRule = newObject
        newObject.BeginPopulate()
        privateInterface.FormatingRuleID = rdr.GetInteger("FormatingRuleID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Description")
        newObject.DateCreated = rdr.GetDate("DateCreated")
        newObject.Active = rdr.GetInteger("Active")
        newObject.Archive = rdr.GetInteger("Archive")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSPTI_FormattingRule(ByVal formatingRuleID As Integer) As SPTI_FormattingRule
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectSPTI_FormattingRule, formatingRuleID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateSPTI_FormattingRule(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllSPTI_FormattingRules() As SPTI_FormattingRuleCollection
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectAllSPTI_FormattingRules)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SPTI_FormattingRuleCollection, SPTI_FormattingRule)(rdr, AddressOf PopulateSPTI_FormattingRule)
        End Using
    End Function

    Public Overrides Function InsertSPTI_FormattingRule(ByVal instance As SPTI_FormattingRule) As Integer
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.InsertSPTI_FormattingRule, instance.Name, instance.Description, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateSPTI_FormattingRule(ByVal instance As SPTI_FormattingRule)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.UpdateSPTI_FormattingRule, instance.FormatingRuleID, instance.Name, instance.Description, SafeDataReader.ToDBValue(instance.DateCreated), instance.Active, instance.Archive)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSPTI_FormattingRule(ByVal formatingRuleID As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteSPTI_FormattingRule, formatingRuleID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
