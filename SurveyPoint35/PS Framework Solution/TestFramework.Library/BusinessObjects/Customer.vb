Imports PS.Framework.BusinessLogic
#Region " Key Interface "
Public Interface ICustomer
    Property CustomerID() As String
End Interface
#End Region


#Region " Customer Class "
Public Class Customer
    Inherits BusinessBase(Of Customer)
    Implements ICustomer
#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mCustomerID As String = String.Empty
    Private mCompanyName As String = String.Empty
    Private mContactName As String = String.Empty
    Private mContactTitle As String = String.Empty
    Private mAddress As String = String.Empty
    Private mCity As String = String.Empty
    Private mRegion As String = String.Empty
    Private mPostalcode As String = String.Empty
    Private mCountry As String = String.Empty
    Private mPhone As String = String.Empty
    Private mFax As String = String.Empty
#End Region
#Region " Properties "
    Public Property CustomerID() As String Implements ICustomer.CustomerID
        Get
            Return Me.mCustomerID
        End Get
        Set(ByVal value As String)
            Me.mCustomerID = value
        End Set
    End Property
    Public Property CompanyName() As String
        Get
            Return Me.mCompanyName
        End Get
        Set(ByVal value As String)
            If Not value = Me.mCompanyName Then
                Me.mCompanyName = value
                PropertyHasChanged("CompanyName")
            End If
        End Set
    End Property    
    Public Property ContactName() As String
        Get
            Return Me.mContactName
        End Get
        Set(ByVal value As String)
            If Not value = Me.mContactName Then
                Me.mContactName = value
                PropertyHasChanged("ContactName")
            End If
        End Set
    End Property
    Public Property ContactTitle() As String
        Get
            Return Me.mContactTitle
        End Get
        Set(ByVal value As String)
            If Not value = Me.mContactTitle Then
                Me.mContactTitle = value
                PropertyHasChanged("ContactTitle")
            End If
        End Set
    End Property
    Public Property Address() As String
        Get
            Return Me.mAddress
        End Get
        Set(ByVal value As String)
            If Not value = Me.mAddress Then
                Me.mAddress = value
                PropertyHasChanged("Address")
            End If
        End Set
    End Property
    Public Property City() As String
        Get
            Return Me.mCity
        End Get
        Set(ByVal value As String)
            If Not value = Me.mCity Then
                Me.mCity = value
                PropertyHasChanged("City")
            End If
        End Set
    End Property
    Public Property Region() As String
        Get
            Return Me.mRegion
        End Get
        Set(ByVal value As String)
            If Not value = Me.mRegion Then
                Me.mRegion = value
                PropertyHasChanged("Region")
            End If
        End Set
    End Property
    Public Property Postalcode() As String
        Get
            Return Me.mPostalcode
        End Get
        Set(ByVal value As String)
            If Not value = Me.mPostalcode Then
                Me.mPostalcode = value
                PropertyHasChanged("Postalcode")
            End If
        End Set
    End Property
    Public Property Country() As String
        Get
            Return Me.mCountry
        End Get
        Set(ByVal value As String)
            If Not value = Me.mCountry Then
                Me.mCountry = value
                PropertyHasChanged("Country")
            End If
        End Set
    End Property
    Public Property Phone() As String
        Get
            Return Me.mPhone
        End Get
        Set(ByVal value As String)
            If Not value = Me.mPhone Then
                Me.mPhone = value
                PropertyHasChanged("Phone")
            End If
        End Set
    End Property
    Public Property Fax() As String
        Get
            Return Me.mFax
        End Get
        Set(ByVal value As String)
            If Not value = Me.mFax Then
                Me.mFax = value
                PropertyHasChanged("Fax")
            End If
        End Set
    End Property
#End Region
#Region " Constructors "
    Public Sub New()
        Me.CreateNew()
    End Sub
#End Region
#Region " Factory Calls "
    Public Shared Function NewCustomer() As Customer
        Return New Customer
    End Function
    Public Shared Function GetCustomer(ByVal customerID As String) As Customer
        Return CustomerProvider.Instance.GetCustomer(customerID)
    End Function
    Public Shared Function GetCustomers() As Customers
        Return CustomerProvider.Instance.GetCustomers()
    End Function
#End Region
#Region " Overrides "
    Protected Overrides Sub Delete()
        CustomerProvider.Instance.DeleteCustomer(Me.mCustomerID)
    End Sub

    Protected Overrides Sub Insert()
        Me.mCustomerID = CustomerProvider.Instance.InsertCustomer(Me)
    End Sub

    Protected Overrides Sub Update()
        CustomerProvider.Instance.UpdateCustomer(Me)
    End Sub
#End Region
#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()

    End Sub
#End Region
End Class
#End Region


#Region " Customers Collection Class "
Public Class Customers
    Inherits BusinessListBase(Of Customer)

End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class CustomerProvider
#Region " Singleton Implementation "
    Private Shared mInstance As CustomerProvider
    Private Const mProviderName As String = "CustomerProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As CustomerProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of CustomerProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetCustomers() As Customers
    Public MustOverride Function GetCustomer(ByVal customerID As String) As Customer
    Public MustOverride Sub DeleteCustomer(ByVal customerID As String)
    Public MustOverride Sub UpdateCustomer(ByVal instance As Customer)
    Public MustOverride Function InsertCustomer(ByVal instance As Customer) As String
#End Region
End Class
#End Region