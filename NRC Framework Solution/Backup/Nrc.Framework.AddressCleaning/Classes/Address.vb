Imports NRC.Framework.BusinessLogic

<Serializable()> _
Public Class Address
    Inherits BusinessBase(Of Address)

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDBKey As Integer
    Private mOriginalAddress As New AddressSub
    Private mCleanedAddress As New AddressSub
    Private mWorkingAddress As New AddressSub
    Private mGeoCode As GeoCode = GeoCode.NewGeoCode

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property OriginalAddress() As AddressSub
        Get
            Return mOriginalAddress
        End Get
    End Property

    Public ReadOnly Property CleanedAddress() As AddressSub
        Get
            Return mCleanedAddress
        End Get
    End Property

    Public ReadOnly Property WorkingAddress() As AddressSub
        Get
            Return mWorkingAddress
        End Get
    End Property

    Public ReadOnly Property GeoCode() As GeoCode
        Get
            Return mGeoCode
        End Get
    End Property

#End Region

#Region " Friend Properties "

    Friend Property DBKey() As Integer
        Get
            Return mDBKey
        End Get
        Set(ByVal value As Integer)
            If Not value = mDBKey Then
                mDBKey = value
                PropertyHasChanged("DBKey")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewAddress() As Address

        Return New Address

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mDBKey
        End If

    End Function

#End Region

#Region " Validation Methods "

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

#End Region

#Region " Friend Methods "

    Friend Sub SetCleanedTo(ByVal setToAddr As AddressSub, ByVal addrErr As String)

        SetCleanedTo(setToAddr)

        With mCleanedAddress
            .AddressKey = mWorkingAddress.AddressKey
            .AddressStatus = mWorkingAddress.AddressStatus
            .AddressError = addrErr
        End With

    End Sub

    Friend Sub SetCleanedTo(ByVal setToAddr As AddressSub)

        With mCleanedAddress
            .StreetLine1 = CleanString(setToAddr.StreetLine1, True, True).ToUpper
            .StreetLine2 = CleanString(setToAddr.StreetLine2, True, True).ToUpper
            .City = CleanString(setToAddr.City, True, True).ToUpper
            .State = setToAddr.State.ToUpper
            .Country = setToAddr.Country.ToUpper
            .Province = setToAddr.Province.ToUpper
            .Zip5 = setToAddr.Zip5
            .Zip4 = setToAddr.Zip4
            .Postal = setToAddr.Postal
            .AddressType = setToAddr.AddressType
            .ZipCodeType = setToAddr.ZipCodeType
            .UrbanizationName = setToAddr.UrbanizationName
            .PrivateMailBox = setToAddr.PrivateMailBox
            .DeliveryPoint = setToAddr.DeliveryPoint
            .Carrier = setToAddr.Carrier
            .AddressKey = setToAddr.AddressKey
            .AddressStatus = setToAddr.AddressStatus
            .AddressError = setToAddr.AddressError
        End With

    End Sub

#End Region

End Class