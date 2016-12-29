Imports Nrc.Framework.BusinessLogic

<Serializable()>
Public Class AddressName
    Inherits BusinessBase(Of AddressName)

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mDBKey As Integer
    Private mOriginalAddress As New AddressSub
    Private mCleanedAddress As New AddressSub
    Private mWorkingAddress As New AddressSub
    Private mGeoCode As GeoCode = GeoCode.NewGeoCode

    Private mOriginalName As New NameSub
    Private mCleanedName As New NameSub
    Private mWorkingName As New NameSub

    Private mTitle As String = String.Empty
    Private mFirstName As String = String.Empty
    Private mMiddleInitial As String = String.Empty
    Private mLastName As String = String.Empty
    Private mSuffix As String = String.Empty
    Private mNewTitle As String = String.Empty
    Private mNewFirstName As String = String.Empty
    Private mNewMiddleInitial As String = String.Empty
    Private mNewLastName As String = String.Empty
    Private mNewSuffix As String = String.Empty
    Private mNameStatus As String = String.Empty

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

    Public ReadOnly Property OriginalName() As NameSub
        Get
            Return mOriginalName
        End Get
    End Property

    Public ReadOnly Property CleanedName() As NameSub
        Get
            Return mCleanedName
        End Get
    End Property

    Public ReadOnly Property WorkingName() As NameSub
        Get
            Return mWorkingName
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

    Public Shared Function NewAddressName() As AddressName

        Return New AddressName

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

    Friend Sub SetAddressCleanedTo(ByVal setToAddr As AddressSub, ByVal addrErr As String)

        SetAddressCleanedTo(setToAddr)

        With mCleanedAddress
            .AddressKey = mWorkingAddress.AddressKey
            .AddressStatus = mWorkingAddress.AddressStatus
            .AddressError = addrErr
        End With

    End Sub

    Friend Sub SetNameCleanedTo(ByVal setToName As NameSub, ByVal nameStat As String)

        SetNameCleanedTo(setToName)

        mCleanedName.NameStatus = nameStat

    End Sub

    Friend Sub SetAddressCleanedTo(ByVal setToAddr As AddressSub)

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

    Friend Sub SetNameCleanedTo(ByVal setToName As NameSub)

        With mCleanedName
            .Title = CleanString(setToName.Title, True, True)
            .FirstName = CleanString(setToName.FirstName, True, True)
            .MiddleInitial = CleanString(setToName.MiddleInitial, True, True)
            .LastName = CleanString(setToName.LastName, True, True)
            .Suffix = CleanString(setToName.Suffix, True, True)
            .NameStatus = setToName.NameStatus
        End With

    End Sub

#End Region

End Class