Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class TemplateTableDefinitionProvider
    Inherits NRC.NotificationAdmin.Library.DataProviders.TemplateTableDefinitionProvider

    Private Function PopulateTemplateTableDefinition(ByVal rdr As SafeDataReader) As TemplateTableDefinition

        Dim newObject As TemplateTableDefinition = TemplateTableDefinition.NewTemplateTableDefinition
        Dim privateInterface As ITemplateTableDefinition = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("TemplateTableDefinitions_id")
        newObject.TemplateDefinitionId = rdr.GetInteger("TemplateDefinitions_id")
        newObject.ColumnName = rdr.GetString("ColumnName")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectTemplateTableDefinition(ByVal id As Integer) As TemplateTableDefinition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateTableDefinition, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateTemplateTableDefinition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectTemplateTableDefinitionsByTemplateDefinitionId(ByVal definitionId As Integer) As TemplateTableDefinitionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateTableDefinitionsByTemplateDefinitionId, definitionId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of TemplateTableDefinitionCollection, TemplateTableDefinition)(rdr, AddressOf PopulateTemplateTableDefinition)
        End Using

    End Function

    Public Overrides Function InsertTemplateTableDefinition(ByVal instance As TemplateTableDefinition) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTemplateTableDefinition, instance.TemplateDefinitionId, instance.ColumnName)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateTemplateTableDefinition(ByVal instance As TemplateTableDefinition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateTemplateTableDefinition, instance.Id, instance.TemplateDefinitionId, instance.ColumnName)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteTemplateTableDefinition(ByVal id As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTemplateTableDefinition, id)
        ExecuteNonQuery(cmd)

    End Sub

End Class
