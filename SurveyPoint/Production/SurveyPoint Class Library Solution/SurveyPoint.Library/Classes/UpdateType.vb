Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IUpdateType
    Property UpdateTypeID() As Integer
End Interface

Public Class UpdateType
    Inherits BusinessBase(Of UpdateType)
    Implements IUpdateType

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mUpdateTypeID As Integer
    Private mName As String = String.Empty
    Private mOrder As Integer
    Private mFromGroupID As UpdateTypeGroups
    Private mToGroupID As UpdateTypeGroups

#End Region

#Region " Public Properties "

    Public Property UpdateTypeID() As Integer Implements IUpdateType.UpdateTypeID
        Get
            Return mUpdateTypeID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mUpdateTypeID Then
                mUpdateTypeID = value
                PropertyHasChanged("UpdateTypeID")
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

    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal value As Integer)
            If Not value = mOrder Then
                mOrder = value
                PropertyHasChanged("Order")
            End If
        End Set
    End Property

    Public Property FromGroupID() As UpdateTypeGroups
        Get
            Return mFromGroupID
        End Get
        Set(ByVal value As UpdateTypeGroups)
            If Not value = mFromGroupID Then
                mFromGroupID = value
                PropertyHasChanged("FromGroupID")
            End If
        End Set
    End Property

    Public Property ToGroupID() As UpdateTypeGroups
        Get
            Return mToGroupID
        End Get
        Set(ByVal value As UpdateTypeGroups)
            If Not value = mToGroupID Then
                mToGroupID = value
                PropertyHasChanged("ToGroupID")
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

    Public Shared Function NewUpdateType() As UpdateType

        Return New UpdateType

    End Function

    Public Shared Function GetAll() As UpdateTypeCollection

        Return UpdateTypeProvider.Instance.SelectAll()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mUpdateTypeID
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

#End Region

#Region " Public Methods "

#End Region

End Class



