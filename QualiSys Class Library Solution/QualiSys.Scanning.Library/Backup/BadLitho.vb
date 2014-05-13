Imports NRC.Framework.BusinessLogic

Public Interface IBadLitho

    Property BadLithoId() As Integer

End Interface

<Serializable()> _
Public Class BadLitho
	Inherits BusinessBase(Of BadLitho)
	Implements IBadLitho

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mBadLithoId As Integer
    Private mDataLoadId As Integer
    Private mBadLithoCode As String = String.Empty
    Private mDateCreated As Date

#End Region

#Region " Public Properties "

    Public Property BadLithoId() As Integer Implements IBadLitho.BadLithoId
        Get
            Return mBadLithoId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mBadLithoId Then
                mBadLithoId = value
                PropertyHasChanged("BadLithoId")
            End If
        End Set
    End Property

    Public Property DataLoadId() As Integer
        Get
            Return mDataLoadId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataLoadId Then
                mDataLoadId = value
                PropertyHasChanged("DataLoadId")
            End If
        End Set
    End Property

    Public Property BadLithoCode() As String
        Get
            Return mBadLithoCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mBadLithoCode Then
                mBadLithoCode = value
                PropertyHasChanged("BadLithoCode")
            End If
        End Set
    End Property

    Public Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
        Set(ByVal value As Date)
            If Not value = mDateCreated Then
                mDateCreated = value
                PropertyHasChanged("DateCreated")
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

    Public Shared Function NewBadLitho() As BadLitho

        Return New BadLitho

    End Function

    Public Shared Function [Get](ByVal badLithoId As Integer) As BadLitho

        Return BadLithoProvider.Instance.SelectBadLitho(badLithoId)

    End Function

    Public Shared Function GetByDataLoadId(ByVal dataLoadId As Integer) As BadLithoCollection

        Return BadLithoProvider.Instance.SelectBadLithosByDataLoadId(dataLoadId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mBadLithoId
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

        BadLithoId = BadLithoProvider.Instance.InsertBadLitho(Me)

    End Sub

    Protected Overrides Sub Update()

        BadLithoProvider.Instance.UpdateBadLitho(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        BadLithoProvider.Instance.DeleteBadLitho(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


