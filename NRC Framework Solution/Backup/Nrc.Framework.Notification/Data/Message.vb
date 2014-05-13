Imports Nrc.Framework.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

''' <summary>Message class.  This section contains methods specific to DB retrieval.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Partial Public Class Message

    ''' <summary>Loads the message object with its template specific variables.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadTemplateData()

        'Retrieve the template data.
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateByName, Me.mTemplateName)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Me.mTemplateString = rdr.GetString("TemplateString")
                Me.mTemplateName = rdr.GetString("TemplateName")
                Me.mSmtpServer = rdr.GetString("SMTPServer")
                Me.mFrom.Email = rdr.GetString("EmailFrom")
                ParseEmailString(Me.mTo, rdr.GetString("EmailTo"))
                ParseEmailString(Me.mCc, rdr.GetString("EmailCC"))
                ParseEmailString(Me.mBcc, rdr.GetString("EmailBCC"))
                Me.mSubject = rdr.GetString("EmailSubject")
                Me.mTemplateID = rdr.GetInteger("Template_id")
            End While
        End Using

        LoadTemplateSchema()

    End Sub

    ''' <summary>Poplulates the table definition objects.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadTemplateSchema()

        'Retrive the template schema data.
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectTemplateDefinitionsTemplateTableDefinitions, Me.mTemplateID)
        Dim currentDefinitionID As Integer = 0

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Dim isTable As Boolean = rdr.GetBoolean("IsTable")
                Dim definitionName As String = rdr.GetString("TemplateDefinitionsName")

                If Not isTable Then
                    Me.mTemplateFields.Add(definitionName)
                Else
                    If Not Me.mTemplateTables.ContainsKey(definitionName) Then
                        Me.mTemplateTables.Add(definitionName, New List(Of String))
                    End If
                    Me.mTemplateTables(definitionName).Add(rdr.GetString("ColumnName"))
                End If
            End While
        End Using

    End Sub

    ''' <summary>Helper method to parse a semicolon delimited string into individual emails.</summary>
    ''' <param name="obj">the address collection you are using.</param>
    ''' <param name="delimitedString">the semicolon delimited string you are using.</param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ParseEmailString(ByRef obj As AddressCollection, ByVal delimitedString As String)

        If delimitedString.Length > 0 AndAlso delimitedString.IndexOf(";"c) > -1 Then
            Dim strEmails As String() = delimitedString.Split(";"c)

            For Each email As String In strEmails
                If email.Length > 0 Then
                    obj.Add(email)
                End If
            Next
        ElseIf delimitedString.Length > 0 Then
            obj.Add(delimitedString)
        End If

    End Sub

#Region " SP Declarations "

    ''' <summary>Private class to hold stored procedure definitions.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private NotInheritable Class SP

        Private Sub New()

        End Sub

        Public Const SelectTemplateByName As String = "dbo.NS_SelectTemplateByTemplateName"
        Public Const SelectTemplateDefinitionsTemplateTableDefinitions As String = "dbo.NS_SelectTemplateDefinitionsTemplateTableDefinitions"

    End Class

#End Region

End Class
