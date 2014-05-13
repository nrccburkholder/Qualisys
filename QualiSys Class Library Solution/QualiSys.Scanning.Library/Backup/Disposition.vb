Imports NRC.Framework.BusinessLogic

Public Interface IDisposition

    Property DispositionId() As Integer
    Property VendorDispo() As VendorDisposition

End Interface

<Serializable()> _
Public Class Disposition
	Inherits BusinessBase(Of Disposition)
	Implements IDisposition

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDispositionId As Integer
    Private mLithoCodeId As Integer
    Private mErrorId As TransferErrorCodes
    Private mDispositionDate As Date
    Private mVendorDispositionCode As String = String.Empty
    Private mIsFinal As Boolean
    Private mVendorDispo As VendorDisposition

#End Region

#Region " Public Properties "

    Public Property DispositionId() As Integer Implements IDisposition.DispositionId
        Get
            Return mDispositionId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mDispositionId Then
                mDispositionId = value
                PropertyHasChanged("DispositionId")
            End If
        End Set
    End Property

    Public Property LithoCodeId() As Integer
        Get
            Return mLithoCodeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mLithoCodeId Then
                mLithoCodeId = value
                PropertyHasChanged("LithoCodeId")
            End If
        End Set
    End Property

    Public Property ErrorId() As TransferErrorCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property DispositionDate() As Date
        Get
            Return mDispositionDate
        End Get
        Set(ByVal value As Date)
            If Not value = mDispositionDate Then
                mDispositionDate = value
                PropertyHasChanged("DispositionDate")
            End If
        End Set
    End Property

    Public Property VendorDispositionCode() As String
        Get
            Return mVendorDispositionCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorDispositionCode Then
                mVendorDispositionCode = value
                PropertyHasChanged("VendorDispositionCode")
            End If
        End Set
    End Property

    Public Property IsFinal() As Boolean
        Get
            Return mIsFinal
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsFinal Then
                mIsFinal = value
                PropertyHasChanged("IsFinal")
            End If
        End Set
    End Property

    Public Property VendorDispo() As VendorDisposition Implements IDisposition.VendorDispo
        Get
            Return mVendorDispo
        End Get
        Private Set(ByVal value As VendorDisposition)
            mVendorDispo = value
        End Set
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

    Public Shared Function [Get](ByVal dispositionId As Integer) As Disposition

        Return DispositionProvider.Instance.SelectDisposition(dispositionId)

    End Function

    Public Shared Function GetByLithoCodeId(ByVal lithoCodeId As Integer) As DispositionCollection

        Return DispositionProvider.Instance.SelectDispositionsByLithoCodeId(lithoCodeId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mDispositionId
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

        DispositionId = DispositionProvider.Instance.InsertDisposition(Me)

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


