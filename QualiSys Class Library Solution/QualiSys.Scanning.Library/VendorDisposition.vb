Imports NRC.Framework.BusinessLogic

Public Interface IVendorDisposition

    Property VendorDispositionId() As Integer

End Interface

<Serializable()> _
Public Class VendorDisposition
    Inherits BusinessBase(Of VendorDisposition)
    Implements IVendorDisposition

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorDispositionId As Integer
    Private mVendorId As Integer
    Private mDispositionId As Integer
    Private mVendorDispositionCode As String = String.Empty
    Private mVendorDispositionLabel As String = String.Empty
    Private mVendorDispositionDesc As String = String.Empty
    Private mDateCreated As Date
    Private mQCLDisposition As QualiSys.Library.Disposition = Nothing
    Private misFinal As Integer

#End Region

#Region " Public Properties "

    Public Property VendorDispositionId() As Integer Implements IVendorDisposition.VendorDispositionId
        Get
            Return mVendorDispositionId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorDispositionId Then
                mVendorDispositionId = value
                PropertyHasChanged("VendorDispositionId")
            End If
        End Set
    End Property

    Public Property VendorId() As Integer
        Get
            Return mVendorId
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorId Then
                mVendorId = value
                PropertyHasChanged("VendorId")
            End If
        End Set
    End Property

    Public Property DispositionId() As Integer
        Get
            Return mDispositionId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDispositionId Then
                mDispositionId = value
                PropertyHasChanged("DispositionId")
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

    Public Property VendorDispositionLabel() As String
        Get
            Return mVendorDispositionLabel
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorDispositionLabel Then
                mVendorDispositionLabel = value
                PropertyHasChanged("VendorDispositionLabel")
            End If
        End Set
    End Property

    Public Property VendorDispositionDesc() As String
        Get
            Return mVendorDispositionDesc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorDispositionDesc Then
                mVendorDispositionDesc = value
                PropertyHasChanged("VendorDispositionDesc")
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

    Public ReadOnly Property QCLDisposition() As QualiSys.Library.Disposition
        Get
            If mQCLDisposition Is Nothing Then
                mQCLDisposition = QualiSys.Library.Disposition.Get(mDispositionId)
            End If

            Return mQCLDisposition
        End Get
    End Property

    Public Property isFinal() As Integer
        Get
            Return misFinal
        End Get
        Set(ByVal value As Integer)
            If Not value = misFinal Then
                misFinal = value
                PropertyHasChanged("isFinal")
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

    Public Shared Function NewVendorDisposition() As VendorDisposition

        Return New VendorDisposition

    End Function

    Public Shared Function [Get](ByVal vendorDispositionId As Integer) As VendorDisposition

        Return VendorDispositionProvider.Instance.SelectVendorDisposition(vendorDispositionId)

    End Function

    Public Shared Function GetByVendorId(ByVal vendorId As Integer) As VendorDispositionCollection

        Return VendorDispositionProvider.Instance.SelectVendorDispositionsByVendorId(vendorId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorDispositionId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("VendorId", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateDispositionIdIsValid, "DispositionId")
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("DispositionId", 1))
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "VendorDispositionCode")
        Me.ValidationRules.AddRule(AddressOf ValidateVendorDispositionCodeIsUnique, "VendorDispositionCode")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("VendorDispositionCode", 5))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("VendorDispositionLabel", 250))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("VendorDispositionDesc", 500))

    End Sub

#End Region

#Region "Validation Methods"

    Private Function ValidateDispositionIdIsValid(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If Me.DispositionId = 0 Then
            e.Description = "Disposition Value missing!"
            Return False
        End If

        Return True

    End Function

    Private Function ValidateVendorDispositionCodeIsUnique(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        Dim dispoList As VendorDispositionCollection = TryCast(Me.Parent, VendorDispositionCollection)

        If dispoList IsNot Nothing Then
            For Each dispo As VendorDisposition In dispoList
                If Me.GetIdValue.ToString <> dispo.GetIdValue.ToString AndAlso Me.VendorDispositionCode = dispo.VendorDispositionCode Then
                    e.Description = "This VendorDisposition Code already exists!"
                    Return False
                End If
            Next
        End If

        Return True

    End Function

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        VendorDispositionId = VendorDispositionProvider.Instance.InsertVendorDisposition(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorDispositionProvider.Instance.UpdateVendorDisposition(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorDispositionProvider.Instance.DeleteVendorDisposition(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


