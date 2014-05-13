Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class TemplateDefinitionProvider
    Inherits NRC.NotificationAdmin.Library.DataProviders.TemplateDefinitionProvider

    Private Function PopulateTemplateDefinition(ByVal rdr As SafeDataReader) As TemplateDefinition

        Dim newObject As TemplateDefinition = TemplateDefinition.NewTemplateDefinition
        Dim privateInterface As ITemplateDefinition = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("TemplateDefinitions_id")
        newObject.TemplateId = rdr.GetInteger("Template_id")
        newObject.Name = rdr.GetString("TemplateDefinitionsName")
        newObject.IsTable = rdr.GetBoolean("IsTable")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectTemplateDefinition(ByVal id As Integer) As TemplateDefinition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateDefinition, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateTemplateDefinition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectTemplateDefinitionsByTemplateId(ByVal templateId As Integer) As TemplateDefinitionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateDefinitionsByTemplateId, templateId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of TemplateDefinitionCollection, TemplateDefinition)(rdr, AddressOf PopulateTemplateDefinition)
        End Using

    End Function

    Public Overrides Function InsertTemplateDefinition(ByVal instance As TemplateDefinition) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTemplateDefinition, instance.TemplateId, instance.Name, instance.IsTable)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateTemplateDefinition(ByVal instance As TemplateDefinition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateTemplateDefinition, instance.Id, instance.TemplateId, instance.Name, instance.IsTable)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteTemplateDefinition(ByVal id As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTemplateDefinition, id)
        ExecuteNonQuery(cmd)

    End Sub


End Class
