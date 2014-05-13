Imports Nrc.Framework.BusinessLogic
Imports NRC.NotificationAdmin.Library.DataProviders

Public Interface ITemplate

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class Template
    Inherits BusinessBase(Of Template)
    Implements ITemplate

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
    Private mSMTPServer As String = String.Empty
    Private mTemplateString As String = String.Empty
    Private mEmailFrom As String = String.Empty
    Private mEmailTo As String = String.Empty
    Private mEmailSubject As String = String.Empty
    Private mEmailBCC As String = String.Empty
    Private mEmailCC As String = String.Empty
    Private mDefinitions As TemplateDefinitionCollection

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements ITemplate.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property

    Public Property SMTPServer() As String
        Get
            Return mSMTPServer
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSMTPServer Then
                mSMTPServer = value
                PropertyHasChanged("SMTPServer")
            End If
        End Set
    End Property

    Public Property TemplateString() As String
        Get
            Return mTemplateString
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTemplateString Then
                mTemplateString = value
                PropertyHasChanged("TemplateString")
            End If
        End Set
    End Property

    Public Property EmailFrom() As String
        Get
            Return mEmailFrom
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailFrom Then
                mEmailFrom = value
                PropertyHasChanged("EmailFrom")
            End If
        End Set
    End Property

    Public Property EmailTo() As String
        Get
            Return mEmailTo
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailTo Then
                mEmailTo = value
                PropertyHasChanged("EmailTo")
            End If
        End Set
    End Property

    Public Property EmailSubject() As String
        Get
            Return mEmailSubject
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailSubject Then
                mEmailSubject = value
                PropertyHasChanged("EmailSubject")
            End If
        End Set
    End Property

    Public Property EmailBCC() As String
        Get
            Return mEmailBCC
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailBCC Then
                mEmailBCC = value
                PropertyHasChanged("EmailBCC")
            End If
        End Set
    End Property

    Public Property EmailCC() As String
        Get
            Return mEmailCC
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEmailCC Then
                mEmailCC = value
                PropertyHasChanged("EmailCC")
            End If
        End Set
    End Property

    Public ReadOnly Property Definitions() As TemplateDefinitionCollection
        Get
            If mDefinitions Is Nothing Then
                mDefinitions = TemplateDefinition.GetByTemplateId(mId)
            End If
            Return mDefinitions
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewTemplate() As Template

        Return New Template

    End Function

    Public Shared Function [Get](ByVal id As Integer) As Template

        Return TemplateProvider.Instance.SelectTemplate(id)

    End Function

    Public Shared Function GetByName(ByVal name As String) As Template

        Return TemplateProvider.Instance.SelectTemplateByName(name)

    End Function

    Public Shared Function GetAll() As TemplateCollection

        Return TemplateProvider.Instance.SelectAllTemplates()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        Id = TemplateProvider.Instance.InsertTemplate(Me)

    End Sub

    Protected Overrides Sub Update()

        TemplateProvider.Instance.UpdateTemplate(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        TemplateProvider.Instance.DeleteTemplate(mId)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
