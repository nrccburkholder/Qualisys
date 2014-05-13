Imports NRC.Framework.BusinessLogic

Public Interface IVendorContact
	Property VendorContactId As Integer
End Interface

<Serializable()> _
Public Class VendorContact
	Inherits BusinessBase(Of VendorContact)
	Implements IVendorContact

#Region " Private Fields "
	Private mInstanceGuid As Guid = Guid.NewGuid
	Private mVendorContactId As Integer
    Private mVendorId As Integer
    Private mType As String = String.Empty
	Private mFirstName As String = String.Empty
	Private mLastName As String = String.Empty
	Private memailAddr1 As String = String.Empty
	Private memailAddr2 As String = String.Empty
    Private mSendFileArrivalEmail As Boolean = False
    Private mPhone1 As String = String.Empty
	Private mPhone2 As String = String.Empty
	Private mNotes As String = String.Empty
#End Region

#Region " Public Properties "
	Public Property VendorContactId As Integer Implements IVendorContact.VendorContactId
		Get
			Return mVendorContactId
		End Get
		Private Set(ByVal value As Integer)
			If Not value = mVendorContactId Then
				mVendorContactId = value
				PropertyHasChanged("VendorContactId")
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
    Public Property Type() As String
        Get
            Return mType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mType Then
                mType = value
                PropertyHasChanged("Type")
            End If
        End Set
    End Property
    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFirstName Then
                mFirstName = value
                PropertyHasChanged("FirstName")
            End If
        End Set
    End Property
    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLastName Then
                mLastName = value
                PropertyHasChanged("LastName")
            End If
        End Set
    End Property
    Public Property emailAddr1() As String
        Get
            Return memailAddr1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = memailAddr1 Then
                memailAddr1 = value
                PropertyHasChanged("emailAddr1")
            End If
        End Set
    End Property
    Public Property emailAddr2() As String
        Get
            Return memailAddr2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = memailAddr2 Then
                memailAddr2 = value
                PropertyHasChanged("emailAddr2")
            End If
        End Set
    End Property
    Public Property SendFileArrivalEmail() As Boolean
        Get
            Return mSendFileArrivalEmail
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSendFileArrivalEmail Then
                mSendFileArrivalEmail = value
                PropertyHasChanged("SendFileArrivalEmail")
            End If
        End Set
    End Property
    Public Property Phone1() As String
        Get
            Return mPhone1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPhone1 Then
                mPhone1 = value
                PropertyHasChanged("Phone1")
            End If
        End Set
    End Property
    Public Property Phone2() As String
        Get
            Return mPhone2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPhone2 Then
                mPhone2 = value
                PropertyHasChanged("Phone2")
            End If
        End Set
    End Property
    Public Property Notes() As String
        Get
            Return mNotes
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mNotes Then
                mNotes = value
                PropertyHasChanged("Notes")
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
    Public Shared Function NewVendorContact() As VendorContact
        Return New VendorContact
    End Function

    Public Shared Function [Get](ByVal vendorContactId As Integer) As VendorContact
        Return VendorContactProvider.Instance.SelectVendorContact(vendorContactId)
    End Function

    Public Shared Function GetAll() As VendorContactCollection
        Return VendorContactProvider.Instance.SelectAllVendorContacts()
    End Function

    Public Shared Function GetAllByVendor(ByVal vendorId As Integer) As VendorContactCollection
        Return VendorContactProvider.Instance.SelectAllVendorContactsByVendor(vendorId)
    End Function
#End Region
#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorContactId
        End If
    End Function
#End Region
#Region " Validation "
    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "Type")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Type", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("FirstName", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("LastName", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("emailAddr1", 150))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("emailAddr2", 50))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Phone1", 20))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Phone2", 20))
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("Notes", 8000))
        Me.ValidationRules.AddRule(AddressOf Validation.IntegerMinValue, New Validation.IntegerMinValueRuleArgs("VendorId", 1))

    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    Protected Overrides Sub Insert()
        VendorContactId = VendorContactProvider.Instance.InsertVendorContact(Me)
    End Sub

    Protected Overrides Sub Update()
        VendorContactProvider.Instance.UpdateVendorContact(Me)
    End Sub
    Protected Overrides Sub DeleteImmediate()
        VendorContactProvider.Instance.DeleteVendorContact(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


