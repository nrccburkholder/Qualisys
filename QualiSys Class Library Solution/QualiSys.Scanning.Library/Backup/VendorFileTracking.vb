Imports NRC.Framework.BusinessLogic

Public Interface IVendorFileTracking

    Property VendorFileTrackingId() As Integer

End Interface

<Serializable()> _
Public Class VendorFileTracking
    Inherits BusinessBase(Of VendorFileTracking)
    Implements IVendorFileTracking

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorFileTrackingId As Integer
    Private mMemberId As Integer
    Private mActionDesc As String = String.Empty
    Private mVendorFileID As Integer
    Private mActionDate As Date

#End Region

#Region " Public Properties "

    Public Property VendorFileTrackingId() As Integer Implements IVendorFileTracking.VendorFileTrackingId
        Get
            Return mVendorFileTrackingId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorFileTrackingId Then
                mVendorFileTrackingId = value
                PropertyHasChanged("VendorFileTrackingId")
            End If
        End Set
    End Property

    Public Property MemberId() As Integer
        Get
            Return mMemberId
        End Get
        Set(ByVal value As Integer)
            If Not value = mMemberId Then
                mMemberId = value
                PropertyHasChanged("MemberId")
            End If
        End Set
    End Property

    Public Property ActionDesc() As String
        Get
            Return mActionDesc
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mActionDesc Then
                mActionDesc = value
                PropertyHasChanged("ActionDesc")
            End If
        End Set
    End Property

    Public Property VendorFileID() As Integer
        Get
            Return mVendorFileID
        End Get
        Set(ByVal value As Integer)
            If Not value = mVendorFileID Then
                mVendorFileID = value
                PropertyHasChanged("VendorFileID")
            End If
        End Set
    End Property

    Public Property ActionDate() As Date
        Get
            Return mActionDate
        End Get
        Set(ByVal value As Date)
            If Not value = mActionDate Then
                mActionDate = value
                PropertyHasChanged("ActionDate")
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

    Public Shared Function NewVendorFileTracking() As VendorFileTracking

        Return New VendorFileTracking

    End Function

    Public Shared Function [Get](ByVal id As Integer) As VendorFileTracking

        Return VendorFileTrackingProvider.Instance.SelectVendorFileTracking(id)

    End Function

    Public Shared Function GetAll() As VendorFileTrackingCollection

        Return VendorFileTrackingProvider.Instance.SelectAllVendorFileTrackings()

    End Function

    Public Shared Function GetByVendorFileID(ByVal vendorFileID As Integer) As VendorFileTrackingCollection

        Return VendorFileTrackingProvider.Instance.SelectVendorFileTrackingsByVendorFileID(vendorFileID)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFileTrackingId
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

        VendorFileTrackingId = VendorFileTrackingProvider.Instance.InsertVendorFileTracking(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorFileTrackingProvider.Instance.UpdateVendorFileTracking(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorFileTrackingProvider.Instance.DeleteVendorFileTracking(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Shared Sub LogAction(ByVal vendorFileID As Integer, ByVal actionDesc As String, ByVal memberID As Integer)

        'Create a new instance
        Dim fileTrack As VendorFileTracking = VendorFileTracking.NewVendorFileTracking

        'Set the properties
        With fileTrack
            .VendorFileID = vendorFileID
            .ActionDesc = actionDesc
            .MemberId = memberID
            .ActionDate = Now
        End With

        'Save this entry
        fileTrack.Save()

    End Sub
#End Region

End Class


