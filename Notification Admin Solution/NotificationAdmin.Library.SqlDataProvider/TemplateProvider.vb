Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class TemplateProvider
    Inherits NRC.NotificationAdmin.Library.DataProviders.TemplateProvider

    Private Function PopulateTemplate(ByVal rdr As SafeDataReader) As Template

        Dim newObject As Template = Template.NewTemplate
        Dim privateInterface As ITemplate = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Template_id")
        newObject.Name = rdr.GetString("TemplateName")
        newObject.SMTPServer = rdr.GetString("SMTPServer")
        newObject.TemplateString = rdr.GetString("TemplateString")
        newObject.EmailFrom = rdr.GetString("EmailFrom")
        newObject.EmailTo = rdr.GetString("EmailTo")
        newObject.EmailSubject = rdr.GetString("EmailSubject")
        newObject.EmailBCC = rdr.GetString("EmailBCC")
        newObject.EmailCC = rdr.GetString("EmailCC")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectTemplate(ByVal id As Integer) As Template

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplate, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateTemplate(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectTemplateByName(ByVal name As String) As Template

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateByName, name)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateTemplate(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllTemplates() As TemplateCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllTemplates)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of TemplateCollection, Template)(rdr, AddressOf PopulateTemplate)
        End Using

    End Function

    Public Overrides Function InsertTemplate(ByVal instance As Template) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertTemplate, instance.Name, instance.SMTPServer, instance.TemplateString, instance.EmailFrom, instance.EmailTo, instance.EmailSubject, instance.EmailBCC, instance.EmailCC)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateTemplate(ByVal instance As Template)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateTemplate, instance.Id, instance.Name, instance.SMTPServer, instance.TemplateString, instance.EmailFrom, instance.EmailTo, instance.EmailSubject, instance.EmailBCC, instance.EmailCC)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteTemplate(ByVal id As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteTemplate, id)
        ExecuteNonQuery(cmd)

    End Sub

End Class
