Imports NRC.Framework.BusinessLogic

Public Interface IVendor

    Property VendorId() As Integer

End Interface

<Serializable()> _
Public Class Vendor
	Inherits BusinessBase(Of Vendor)
	Implements IVendor

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorId As Integer
    Private mVendorCode As String = String.Empty
    Private mVendorName As String = String.Empty
    Private mPhone As String = String.Empty
    Private mAddr1 As String = String.Empty
    Private mAddr2 As String = String.Empty
    Private mCity As String = String.Empty
    Private mStateCode As String = String.Empty
    Private mProvince As String = String.Empty
    Private mZip5 As String = String.Empty
    Private mZip4 As String = String.Empty
    Private mDateCreated As Date
    Private mDateModified As Date
    Private mAcceptFilesFromVendor As Boolean
    Private mNoResponseChar As String = String.Empty
    Private mSkipResponseChar As String = String.Empty
    Private mDontKnowResponseChar As String = String.Empty
    Private mRefusedResponseChar As String = String.Empty
    Private mMultiRespItemNotPickedChar As String = String.Empty
    Private mLocalFTPLoginName As String = String.Empty
    Private mVendorFileOutgoTypeId As Integer

    Private mContacts As VendorContactCollection

#End Region

#Region " Public Properties "

    Public Property VendorId() As Integer Implements IVendor.VendorId
        Get
            Return mVendorId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorId Then
                mVendorId = value
                PropertyHasChanged("VendorId")
            End If
        End Set
    End Property

    Public Property VendorCode() As String
        Get
            Return mVendorCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorCode Then
                mVendorCode = value
                PropertyHasChanged("VendorCode")
            End If
        End Set
    End Property

    Public Property VendorName() As String
        Get
            Return mVendorName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVendorName Then
                mVendorName = value
                PropertyHasChanged("VendorName")
            End If
        End Set
    End Property

    Public Property Phone() As String
        Get
            Return mPhone
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPhone Then
                mPhone = value
                PropertyHasChanged("Phone")
            End If
        End Set
    End Property

    Public Property Addr1() As String
        Get
            Return mAddr1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddr1 Then
                mAddr1 = value
                PropertyHasChanged("Addr1")
            End If
        End Set
    End Property

    Public Property Addr2() As String
        Get
            Return mAddr2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddr2 Then
                mAddr2 = value
                PropertyHasChanged("Addr2")
            End If
        End Set
    End Property

    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCity Then
                mCity = value
                PropertyHasChanged("City")
            End If
        End Set
    End Property

    Public Property StateCode() As String
        Get
            Return mStateCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStateCode Then
                mStateCode = value
                PropertyHasChanged("StateCode")
            End If
        End Set
    End Property

    Public Property Province() As String
        Get
            Return mProvince
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mProvince Then
                mProvince = value
                PropertyHasChanged("Province")
            End If
        End Set
    End Property

    Public Property Zip5() As String
        Get
            Return mZip5
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mZip5 Then
                mZip5 = value
                PropertyHasChanged("Zip5")
            End If
        End Set
    End Property

    Public Property Zip4() As String
        Get
            Return mZip4
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mZip4 Then
                mZip4 = value
                PropertyHasChanged("Zip4")
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

    Public Property DateModified() As Date
        Get
            Return mDateModified
        End Get
        Set(ByVal value As Date)
            If Not value = mDateModified Then
                mDateModified = value
                PropertyHasChanged("DateModified")
            End If
        End Set
    End Property

    Public Property AcceptFilesFromVendor() As Boolean
        Get
            Return mAcceptFilesFromVendor
        End Get
        Set(ByVal value As Boolean)
            If Not value = mAcceptFilesFromVendor Then
                mAcceptFilesFromVendor = value
                PropertyHasChanged("AcceptFilesFromVendor")
            End If
        End Set
    End Property

    Public Property NoResponseChar() As String
        Get
            Return mNoResponseChar
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mNoResponseChar Then
                mNoResponseChar = value
                PropertyHasChanged("NoResponseChar")
            End If
        End Set
    End Property

    Public Property SkipResponseChar() As String
        Get
            Return mSkipResponseChar
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mSkipResponseChar Then
                mSkipResponseChar = value
                PropertyHasChanged("SkipResponseChar")
            End If
        End Set
    End Property

    Public Property DontKnowResponseChar() As String
        Get
            Return mDontKnowResponseChar
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDontKnowResponseChar Then
                mDontKnowResponseChar = value
                PropertyHasChanged("DontKnowResponseChar")
            End If
        End Set
    End Property

    Public Property RefusedResponseChar() As String
        Get
            Return mRefusedResponseChar
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mRefusedResponseChar Then
                mRefusedResponseChar = value
                PropertyHasChanged("RefusedResponseChar")
            End If
        End Set
    End Property

    Public Property MultiRespItemNotPickedChar() As String
        Get
            Return mMultiRespItemNotPickedChar
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMultiRespItemNotPickedChar Then
                mMultiRespItemNotPickedChar = value
                PropertyHasChanged("MultiRespItemNotPickedChar")
            End If
        End Set
    End Property

    Public Property LocalFTPLoginName() As String
        Get
            Return mLocalFTPLoginName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLocalFTPLoginName Then
                mLocalFTPLoginName = value
                PropertyHasChanged("LocalFTPLoginName")
            End If
        End Set
    End Property

    Public Property VendorFileOutgoTypeId() As Integer
        Get
            Return mVendorFileOutgoTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorFileOutgoTypeId Then
                mVendorFileOutgoTypeId = value
                PropertyHasChanged("VendorFileOutgoTypeId")
            End If
        End Set
    End Property

    Public ReadOnly Property Contacts() As VendorContactCollection
        Get
            If mContacts Is Nothing Then
                mContacts = VendorContact.GetAllByVendor(mVendorId)
            End If

            Return mContacts
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewVendor() As Vendor

        Return New Vendor

    End Function

    Public Shared Function [Get](ByVal vendorId As Integer) As Vendor

        Return VendorProvider.Instance.SelectVendor(vendorId)

    End Function

    Public Shared Function GetByVendorCode(ByVal vendorCode As String) As Vendor

        Return VendorProvider.Instance.SelectVendorByVendorCode(vendorCode)

    End Function

    Public Shared Function GetAll() As VendorCollection

        Return VendorProvider.Instance.SelectAllVendors()

    End Function

    Public Shared Function IsUniqueVendorCode(ByVal vendorId As Integer, ByVal vendorCode As String) As Boolean

        Return VendorProvider.Instance.IsUniqueVendorCode(vendorId, vendorCode)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "VendorCode")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("VendorCode", 25))
        Me.ValidationRules.AddRule(AddressOf ValidateVendorCodeIsUnique, "VendorCode")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "VendorName")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("VendorName", 100))
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "NoResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("NoResponseChar", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsChar, "NoResponseChar")
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsUnique, "NoResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "DontKnowResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("DontKnowResponseChar", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsChar, "DontKnowResponseChar")
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsUnique, "DontKnowResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "RefusedResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("RefusedResponseChar", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsChar, "RefusedResponseChar")
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsUnique, "RefusedResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "SkipResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("SkipResponseChar", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsChar, "SkipResponseChar")
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsUnique, "SkipResponseChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "MultiRespItemNotPickedChar")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("MultiRespItemNotPickedChar", 1))
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsChar, "MultiRespItemNotPickedChar")
        Me.ValidationRules.AddRule(AddressOf ValidateRepsonseCharsIsUnique, "MultiRespItemNotPickedChar")
        'Me.ValidationRules.AddRule(AddressOf Validation.StringRequired, "LocalFTPLoginName")
        Me.ValidationRules.AddRule(AddressOf Validation.StringMaxLength, New Validation.MaxLengthRuleArgs("LocalFTPLoginName", 20))
        Me.ValidationRules.AddRule(AddressOf ValidateFileOutgoType, "VendorFileOutgoTypeId")

    End Sub

#End Region

#Region "Validation Methods"

    Private Function ValidateRepsonseCharsIsUnique(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        'This is a candidate for refactoring if any more response characters are added which must be unique and tested here...recursion on string, and substring maybe
        If e.PropertyName = "NoResponseChar" OrElse e.PropertyName = "SkipResponseChar" OrElse e.PropertyName = "DontKnowResponseChar" OrElse e.PropertyName = "RefusedResponseChar" OrElse e.PropertyName = "MultiRespItemNotPickedChar" Then
            If Me.NoResponseChar = Me.SkipResponseChar OrElse Me.NoResponseChar = Me.MultiRespItemNotPickedChar OrElse Me.NoResponseChar = Me.RefusedResponseChar OrElse Me.NoResponseChar = Me.DontKnowResponseChar OrElse _
                Me.SkipResponseChar = Me.MultiRespItemNotPickedChar OrElse Me.SkipResponseChar = Me.RefusedResponseChar OrElse Me.SkipResponseChar = Me.DontKnowResponseChar OrElse _
                Me.MultiRespItemNotPickedChar = Me.RefusedResponseChar OrElse Me.MultiRespItemNotPickedChar = Me.DontKnowResponseChar OrElse _
                Me.RefusedResponseChar = Me.DontKnowResponseChar Then
                e.Description = "Response Characters must be unique!"
                Return False
            End If
        End If

        Return True

    End Function

    Private Function ValidateRepsonseCharsIsChar(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If e.PropertyName = "NoResponseChar" Then
            For Each letter As Char In Me.NoResponseChar.ToCharArray
                If Not Char.IsLetter(letter) Then
                    e.Description = "Response Characters must be a letter only!"
                    Return False
                End If
            Next
        ElseIf e.PropertyName = "SkipResponseChar" Then
            For Each letter As Char In Me.SkipResponseChar.ToCharArray
                If Not Char.IsLetter(letter) Then
                    e.Description = "Response Characters must be a letter only!"
                    Return False
                End If
            Next
        ElseIf e.PropertyName = "DontKnowResponseChar" Then
            For Each letter As Char In Me.DontKnowResponseChar.ToCharArray
                If Not Char.IsLetter(letter) Then
                    e.Description = "Response Characters must be a letter only!"
                    Return False
                End If
            Next
        ElseIf e.PropertyName = "RefusedResponseChar" Then
            For Each letter As Char In Me.RefusedResponseChar.ToCharArray
                If Not Char.IsLetter(letter) Then
                    e.Description = "Response Characters must be a letter only!"
                    Return False
                End If
            Next
        Else
            For Each letter As Char In Me.MultiRespItemNotPickedChar.ToCharArray
                If Not Char.IsLetter(letter) Then
                    e.Description = "Response Characters must be a letter only!"
                    Return False
                End If
            Next
        End If

        Return True

    End Function

    Private Function ValidateVendorCodeIsUnique(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        If Not IsUniqueVendorCode(Me.VendorId, Me.VendorCode) Then
            e.Description = "Vendor Code must be unique!"
            Return False
        End If

        Return True

    End Function

    Private Function ValidateFileOutgoType(ByVal target As Object, ByVal e As Validation.RuleArgs) As Boolean

        For Each outgoType As VendorFileOutgoType In VendorFileOutgoType.GetAll
            If VendorFileOutgoTypeId = outgoType.VendorFileOutgoTypeId Then
                Return True
                Exit Function
            End If
        Next

        'If we made it to here then we do not have a valid vendor file type selected
        e.Description = "Vendor File Outgo Type is not valid!"
        Return False

    End Function

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        VendorId = VendorProvider.Instance.InsertVendor(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorProvider.Instance.UpdateVendor(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorProvider.Instance.DeleteVendor(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


