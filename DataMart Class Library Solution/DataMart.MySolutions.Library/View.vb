Imports Nrc.Framework.BusinessLogic

Public Interface IView
    Property Id() As Integer
    Property ServiceTypeId() As Integer
End Interface

<Serializable()> _
Public Class View
    Inherits BusinessBase(Of View)
    Implements IView

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mServiceTypeId As Integer
    Private mName As String = String.Empty
    Private mIsHcahps As Boolean

    Private mThemes As New ThemeCollection
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IView.Id
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
    Public Property ServiceTypeId() As Integer Implements IView.ServiceTypeId
        Get
            Return mServiceTypeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mServiceTypeId Then
                mServiceTypeId = value
                PropertyHasChanged("ServiceTypeId")
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

    Public Property IsHcahps() As Boolean
        Get
            Return mIsHcahps
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsHcahps Then
                mIsHcahps = value
                PropertyHasChanged("IsHcahps")
            End If
        End Set
    End Property

    Public ReadOnly Property Themes() As ThemeCollection
        Get
            Return mThemes
        End Get
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewView() As View
        Return New View
    End Function

    Public Shared Function NewView(ByVal serviceTypeId As Integer) As View
        Dim v As New View
        v.ServiceTypeId = serviceTypeId
        Return v
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
            Return (MyBase.IsDirty OrElse mThemes.IsDirty)
        End Get
    End Property

    Public Overrides ReadOnly Property IsValid() As Boolean
        Get
            Return (MyBase.IsValid AndAlso mThemes.IsValid)
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
        mId = DataProvider.Instance.InsertView(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateView(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteView(Me.Id)
    End Sub

#End Region

#Region " Public Methods "
    Public Function FindTheme(ByVal themeId As Integer) As Theme
        For Each t As Theme In Me.Themes
            If t.Id = themeId Then
                Return t
            End If
        Next

        Return Nothing
    End Function
#End Region

End Class

<Serializable()> _
Public Class ViewCollection
    Inherits BusinessListBase(Of ViewCollection, View)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As View = View.NewView
        Me.Add(newObj)
        Return newObj
    End Function
End Class

