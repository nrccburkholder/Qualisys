Imports NRC.Framework.BusinessLogic

Public Interface IVendorFileStatus
    Property Id() As Integer
End Interface

<Serializable()> _
Public Class VendorFileStatus
    Inherits BusinessBase(Of VendorFileStatus)
    Implements IVendorFileStatus

#Region " Private Fields "
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String = String.Empty
#End Region

#Region " Public Properties "
    Public Property Id() As Integer Implements IVendorFileStatus.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
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
    Public Shared Function NewVendorFileStatus() As VendorFileStatus
        Return New VendorFileStatus
    End Function

    Public Shared Function [Get](ByVal id As Integer) As VendorFileStatus
        Return VendorFileStatusProvider.Instance.SelectVendorFileStatus(id)
    End Function

    Public Shared Function GetAll() As VendorFileStatusCollection
        Return VendorFileStatusProvider.Instance.SelectAllVendorFileStatus()
    End Function
    Public Shared Function GetById(ByVal id As Integer) As VendorFileStatusCollection
        Return VendorFileStatusProvider.Instance.SelectVendorFileStatusById(id)
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
        Id = VendorFileStatusProvider.Instance.InsertVendorFileStatus(Me)
    End Sub

    Protected Overrides Sub Update()
        VendorFileStatusProvider.Instance.UpdateVendorFileStatus(Me)
    End Sub
    Protected Overrides Sub DeleteImmediate()
        VendorFileStatusProvider.Instance.DeleteVendorFileStatus(Me)
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


