Imports Nrc.Framework.BusinessLogic

Public Interface IServiceType
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class ServiceType
    Inherits BusinessBase(Of ServiceType)
    Implements IServiceType

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
    Private mPrivilegeId As Integer

    Private mViews As New ViewCollection
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IServiceType.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                Mid = value
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
            value = value.Trim
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Public Property PrivilegeId() As Integer
        Get
            Return mPrivilegeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mPrivilegeId Then
                mPrivilegeId = value
                PropertyHasChanged("PrivilegeId")
            End If
        End Set
    End Property

    Public ReadOnly Property Views() As ViewCollection
        Get
            Return mViews
        End Get
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewServiceType() As ServiceType
        Return New ServiceType
    End Function

    Public Shared Function GetAll() As ServiceTypeCollection
        Return DataProvider.Instance.SelectAllServiceTypes()
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

    Public Overrides ReadOnly Property IsDirty() As Boolean
        Get
            Return (MyBase.IsDirty OrElse Me.mViews.IsDirty)
        End Get
    End Property

    Public Overrides ReadOnly Property IsValid() As Boolean
        Get
            Return (MyBase.IsValid AndAlso mViews.IsValid)
        End Get
    End Property


#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Name")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, _
                                   New Validation.MaxLengthRuleArgs("Name", 100))
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        mId = DataProvider.Instance.InsertServiceType(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateServiceType(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteServiceType(mId)
    End Sub

#End Region

#Region " Public Methods "
    Public Function FindView(ByVal viewId As Integer) As View
        For Each v As View In Me.Views
            If v.Id = viewId Then
                Return v
            End If
        Next

        Return Nothing
    End Function

    Public Function FindTheme(ByVal themeId As Integer) As Theme
        For Each v As View In Me.Views
            Dim t As Theme = v.FindTheme(themeId)
            If t IsNot Nothing Then Return t
        Next
        Return Nothing
    End Function
#End Region

End Class

<Serializable()> _
Public Class ServiceTypeCollection
    Inherits BusinessListBase(Of ServiceTypeCollection, ServiceType)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ServiceType = ServiceType.NewServiceType
        Me.Add(newObj)
        Return newObj
    End Function

    Public Function FindServiceType(ByVal serviceTypeId As Integer) As ServiceType
        For Each st As ServiceType In Me
            If st.Id = serviceTypeId Then
                Return st
            End If
        Next

        Return Nothing
    End Function

    Public Function FindView(ByVal viewId As Integer) As View
        For Each st As ServiceType In Me
            Dim v As View = st.FindView(viewId)
            If v IsNot Nothing Then Return v
        Next

        Return Nothing
    End Function

    Public Function FindTheme(ByVal themeId As Integer) As Theme
        For Each st As ServiceType In Me
            Dim t As Theme = st.FindTheme(themeId)
            If t IsNot Nothing Then Return t
        Next

        Return Nothing
    End Function
End Class

