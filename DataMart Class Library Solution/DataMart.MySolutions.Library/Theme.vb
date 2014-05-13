Imports Nrc.Framework.BusinessLogic

Public Interface ITheme
    Property Id() As Integer
    Property ViewId() As Integer
End Interface

<Serializable()> _
Public Class Theme
    Inherits BusinessBase(Of Theme)
    Implements ITheme

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mViewId As Integer
    Private mName As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements ITheme.Id
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
    Public Property ViewId() As Integer Implements ITheme.ViewId
        Get
            Return mViewId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mViewId Then
                mViewId = value
                PropertyHasChanged("ViewId")
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

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewTheme() As Theme
        Return New Theme
    End Function

    Public Shared Function NewTheme(ByVal viewId As Integer) As Theme
        Dim t As New Theme
        t.ViewId = viewId
        Return t
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
        mId = DataProvider.Instance.InsertTheme(Me)
    End Sub

    Protected Overrides Sub Update()
        DataProvider.Instance.UpdateTheme(Me)
    End Sub

    Protected Overrides Sub DeleteImmediate()
        DataProvider.Instance.DeleteTheme(mId)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class

<Serializable()> _
Public Class ThemeCollection
    Inherits BusinessListBase(Of ThemeCollection, Theme)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As Theme = Theme.NewTheme
        Me.Add(newObj)
        Return newObj
    End Function
End Class

