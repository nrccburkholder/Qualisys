Imports NRC.Framework.BusinessLogic

Public Interface IVendorFileOutgoType

    Property VendorFileOutgoTypeId() As Integer

End Interface

<Serializable()> _
Public Class VendorFileOutgoType
	Inherits BusinessBase(Of VendorFileOutgoType)
	Implements IVendorFileOutgoType

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mVendorFileOutgoTypeId As Integer
    Private mOutgoTypeName As String = String.Empty
    Private mOutgoTypeDescription As String = String.Empty
    Private mFileExtension As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property VendorFileOutgoTypeId() As Integer Implements IVendorFileOutgoType.VendorFileOutgoTypeId
        Get
            Return mVendorFileOutgoTypeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mVendorFileOutgoTypeId Then
                mVendorFileOutgoTypeId = value
                PropertyHasChanged("VendorFileOutgoTypeId")
            End If
        End Set
    End Property

    Public Property OutgoTypeName() As String
        Get
            Return mOutgoTypeName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOutgoTypeName Then
                mOutgoTypeName = value
                PropertyHasChanged("OutgoTypeName")
            End If
        End Set
    End Property

    Public Property OutgoTypeDescription() As String
        Get
            Return mOutgoTypeDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mOutgoTypeDescription Then
                mOutgoTypeDescription = value
                PropertyHasChanged("OutgoType_desc")
            End If
        End Set
    End Property

    Public Property FileExtension() As String
        Get
            Return mFileExtension
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFileExtension Then
                mFileExtension = value
                PropertyHasChanged("FileExtension")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} (*{1})", mOutgoTypeName, mFileExtension)
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewVendorFileOutgoType() As VendorFileOutgoType

        Return New VendorFileOutgoType

    End Function

    Public Shared Function [Get](ByVal vendorFileOutgoTypeId As Integer) As VendorFileOutgoType

        Return VendorFileOutgoTypeProvider.Instance.SelectVendorFileOutgoType(vendorFileOutgoTypeId)

    End Function

    Public Shared Function GetAll() As VendorFileOutgoTypeCollection

        Return VendorFileOutgoTypeProvider.Instance.SelectAllVendorFileOutgoTypes()

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mVendorFileOutgoTypeId
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

        VendorFileOutgoTypeId = VendorFileOutgoTypeProvider.Instance.InsertVendorFileOutgoType(Me)

    End Sub

    Protected Overrides Sub Update()

        VendorFileOutgoTypeProvider.Instance.UpdateVendorFileOutgoType(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        VendorFileOutgoTypeProvider.Instance.DeleteVendorFileOutgoType(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


