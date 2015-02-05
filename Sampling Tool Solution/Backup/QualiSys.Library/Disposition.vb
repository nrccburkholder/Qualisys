Imports NRC.Framework.BusinessLogic

Public Interface IDisposition
	Property Id As Integer
End Interface

<Serializable()> _
Public Class Disposition
	Inherits BusinessBase(Of Disposition)
	Implements IDisposition

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDispositionLabel As String = String.Empty
    Private mActionId As Integer
    Private mReportLabel As String = String.Empty
    Private mMustHaveResults As Boolean = False
    Private mHCAHPSDispositions As HCAHPSDispositionCollection
    Private mHHCAHPSDispositions As HHCAHPSDispositionCollection

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IDisposition.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                mHCAHPSDispositions = HCAHPSDisposition.GetByDispositionId(mId)
                mHHCAHPSDispositions = HHCAHPSDisposition.GetByDispositionId(mId)
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property DispositionLabel() As String
        Get
            Return mDispositionLabel
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDispositionLabel Then
                mDispositionLabel = value
                PropertyHasChanged("DispositionLabel")
            End If
        End Set
    End Property

    Public Property ActionId() As Integer
        Get
            Return mActionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mActionId Then
                mActionId = value
                PropertyHasChanged("ActionId")
            End If
        End Set
    End Property

    Public Property ReportLabel() As String
        Get
            Return mReportLabel
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mReportLabel Then
                mReportLabel = value
                PropertyHasChanged("ReportLabel")
            End If
        End Set
    End Property

    Public ReadOnly Property HCAHPSValue() As String
        Get
            If mHCAHPSDispositions Is Nothing Then
                mHCAHPSDispositions = HCAHPSDisposition.GetByDispositionId(mId)
            End If

            If mHCAHPSDispositions.Count > 0 Then
                Return mHCAHPSDispositions.Item(0).HCAHPSValue
            Else
                Return String.Empty
            End If
        End Get
    End Property

    Public ReadOnly Property HCAHPSHierarchy() As Integer
        Get
            If mHCAHPSDispositions Is Nothing Then
                mHCAHPSDispositions = HCAHPSDisposition.GetByDispositionId(mId)
            End If

            If mHCAHPSDispositions.Count > 0 Then
                Return mHCAHPSDispositions.Item(0).HCAHPSHierarchy
            Else
                Return 0
            End If
        End Get
    End Property

    Public ReadOnly Property HHCAHPSValue() As String
        Get
            If mHHCAHPSDispositions Is Nothing Then
                mHHCAHPSDispositions = HHCAHPSDisposition.GetByDispositionId(mId)
            End If

            If mHHCAHPSDispositions.Count > 0 Then
                Return mHHCAHPSDispositions.Item(0).HHCAHPSValue
            Else
                Return String.Empty
            End If
        End Get
    End Property

    Public ReadOnly Property HHCAHPSHierarchy() As Integer
        Get
            If mHHCAHPSDispositions Is Nothing Then
                mHHCAHPSDispositions = HHCAHPSDisposition.GetByDispositionId(mId)
            End If

            If mHHCAHPSDispositions.Count > 0 Then
                Return mHHCAHPSDispositions.Item(0).HHCAHPSHierarchy
            Else
                Return 0
            End If
        End Get
    End Property

    Public Property MustHaveResults() As Boolean
        Get
            Return mMustHaveResults
        End Get
        Set(ByVal value As Boolean)
            If Not value = mMustHaveResults Then
                mMustHaveResults = value
                PropertyHasChanged("MustHaveResults")
            End If
        End Set
    End Property

#End Region

#Region " Public Readonly Properties "

    Public ReadOnly Property Action() As DispositionAction
        Get
            Return CType(mActionId, DispositionAction)
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewDisposition() As Disposition

        Return New Disposition

    End Function

    Public Shared Function [Get](ByVal id As Integer) As Disposition

        Return DispositionProvider.Instance.SelectDisposition(id)

    End Function

    Public Shared Function GetAll() As DispositionCollection

        Return DispositionProvider.Instance.SelectAllDispositions()

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

        Id = DispositionProvider.Instance.InsertDisposition(Me)

    End Sub

    Protected Overrides Sub Update()

        DispositionProvider.Instance.UpdateDisposition(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        DispositionProvider.Instance.DeleteDisposition(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


