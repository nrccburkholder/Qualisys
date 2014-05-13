<Serializable()> _
Public Class AddressSub

#Region " Private Members "

    Private mStreetLine1 As String = String.Empty
    Private mStreetLine2 As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mCountry As String = String.Empty
    Private mZip5 As String = String.Empty
    Private mZip4 As String = String.Empty
    Private mProvince As String = String.Empty
    Private mPostal As String = String.Empty
    Private mDeliveryPoint As String = String.Empty
    Private mAddressStatus As String = String.Empty
    Private mAddressError As String = String.Empty
    Private mCarrier As String = String.Empty
    Private mAddressKey As String = String.Empty
    Private mAddressType As AddressTypes = AddressTypes.None
    Private mZipCodeType As ZipCodeTypes = ZipCodeTypes.None
    Private mUrbanizationName As String = String.Empty
    Private mPrivateMailBox As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property StreetLine1() As String
        Get
            Return mStreetLine1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStreetLine1 Then
                mStreetLine1 = value
            End If
        End Set
    End Property

    Public Property StreetLine2() As String
        Get
            Return mStreetLine2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStreetLine2 Then
                mStreetLine2 = value
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
            End If
        End Set
    End Property

    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mState Then
                mState = value
            End If
        End Set
    End Property

    Public Property Country() As String
        Get
            Return mCountry
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCountry Then
                mCountry = value
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
            End If
        End Set
    End Property

    Public Property Postal() As String
        Get
            Return mPostal
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPostal Then
                mPostal = value
            End If
        End Set
    End Property

    Public Property DeliveryPoint() As String
        Get
            Return mDeliveryPoint
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDeliveryPoint Then
                mDeliveryPoint = value
            End If
        End Set
    End Property

    Public Property AddressStatus() As String
        Get
            Return mAddressStatus
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddressStatus Then
                mAddressStatus = value
            End If
        End Set
    End Property

    Public Property AddressError() As String
        Get
            Return mAddressError
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddressError Then
                mAddressError = value
            End If
        End Set
    End Property

    Public Property Carrier() As String
        Get
            Return mCarrier
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mCarrier Then
                mCarrier = value
            End If
        End Set
    End Property

#End Region

#Region " Friend Properties "

    Friend Property AddressKey() As String
        Get
            Return mAddressKey
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mAddressKey Then
                mAddressKey = value
            End If
        End Set
    End Property

#End Region

#Region " ReadOnly Properties "

    Public Property AddressType() As AddressTypes
        Get
            Return mAddressType
        End Get
        Friend Set(ByVal value As AddressTypes)
            If Not value = mAddressType Then
                mAddressType = value
            End If
        End Set
    End Property

    Public Property ZipCodeType() As ZipCodeTypes
        Get
            Return mZipCodeType
        End Get
        Friend Set(ByVal value As ZipCodeTypes)
            If Not value = mZipCodeType Then
                mZipCodeType = value
            End If
        End Set
    End Property

    Public Property UrbanizationName() As String
        Get
            Return mUrbanizationName
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mUrbanizationName Then
                mUrbanizationName = value
            End If
        End Set
    End Property

    Public Property PrivateMailBox() As String
        Get
            Return mPrivateMailBox
        End Get
        Friend Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mPrivateMailBox Then
                mPrivateMailBox = value
            End If
        End Set
    End Property

#End Region

End Class