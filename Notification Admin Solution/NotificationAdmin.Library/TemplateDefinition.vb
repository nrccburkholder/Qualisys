Imports Nrc.Framework.BusinessLogic
Imports NRC.NotificationAdmin.Library.DataProviders

Public Interface ITemplateDefinition

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class TemplateDefinition
    Inherits BusinessBase(Of TemplateDefinition)
    Implements ITemplateDefinition

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mTemplateId As Integer
    Private mName As String = String.Empty
    Private mIsTable As Boolean
    'TP 20080613  Need to be initialized to nothing for proper property check.
    Private mTableDefinitions As TemplateTableDefinitionCollection = Nothing
    'Private mTableDefinitions As New TemplateTableDefinitionCollection

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements ITemplateDefinition.Id
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

    Public Property TemplateId() As Integer
        Get
            Return mTemplateId
        End Get
        Set(ByVal value As Integer)
            If Not value = mTemplateId Then
                mTemplateId = value
                PropertyHasChanged("TemplateId")
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

    Public Property IsTable() As Boolean
        Get
            Return mIsTable
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsTable Then
                mIsTable = value
                PropertyHasChanged("IsTable")
            End If
        End Set
    End Property

    Public ReadOnly Property TableDefinitions() As TemplateTableDefinitionCollection
        Get
            If mTableDefinitions Is Nothing Then
                If Not mIsTable Then
                    mTableDefinitions = New TemplateTableDefinitionCollection
                Else
                    mTableDefinitions = TemplateTableDefinition.GetByDefinitionId(mId)
                End If
            End If
            Return mTableDefinitions
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewTemplateDefinition() As TemplateDefinition

        Return New TemplateDefinition

    End Function

    Public Shared Function [Get](ByVal id As Integer) As TemplateDefinition

        Return TemplateDefinitionProvider.Instance.SelectTemplateDefinition(id)

    End Function

    Public Shared Function GetByTemplateId(ByVal templateId As Integer) As TemplateDefinitionCollection

        Return TemplateDefinitionProvider.Instance.SelectTemplateDefinitionsByTemplateId(templateId)

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

        Id = TemplateDefinitionProvider.Instance.InsertTemplateDefinition(Me)

    End Sub

    Protected Overrides Sub Update()

        TemplateDefinitionProvider.Instance.UpdateTemplateDefinition(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        TemplateDefinitionProvider.Instance.DeleteTemplateDefinition(mId)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
