Imports Nrc.Framework.BusinessLogic
Imports NRC.NotificationAdmin.Library.DataProviders

Public Interface ITemplateTableDefinition

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class TemplateTableDefinition
    Inherits BusinessBase(Of TemplateTableDefinition)
    Implements ITemplateTableDefinition

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mTemplateDefinitionId As Integer
    Private mColumnName As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements ITemplateTableDefinition.Id
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

    Public Property TemplateDefinitionId() As Integer
        Get
            Return mTemplateDefinitionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mTemplateDefinitionId Then
                mTemplateDefinitionId = value
                PropertyHasChanged("TemplateDefinitionId")
            End If
        End Set
    End Property

    Public Property ColumnName() As String
        Get
            Return mColumnName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mColumnName Then
                mColumnName = value
                PropertyHasChanged("ColumnName")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewTemplateTableDefinition() As TemplateTableDefinition

        Return New TemplateTableDefinition

    End Function

    Public Shared Function [Get](ByVal id As Integer) As TemplateTableDefinition

        Return TemplateTableDefinitionProvider.Instance.SelectTemplateTableDefinition(id)

    End Function

    Public Shared Function GetByDefinitionId(ByVal definitionId As Integer) As TemplateTableDefinitionCollection

        Return TemplateTableDefinitionProvider.Instance.SelectTemplateTableDefinitionsByTemplateDefinitionId(definitionId)

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

        Id = TemplateTableDefinitionProvider.Instance.InsertTemplateTableDefinition(Me)

    End Sub

    Protected Overrides Sub Update()

        TemplateTableDefinitionProvider.Instance.UpdateTemplateTableDefinition(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        TemplateTableDefinitionProvider.Instance.DeleteTemplateTableDefinition(mId)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
