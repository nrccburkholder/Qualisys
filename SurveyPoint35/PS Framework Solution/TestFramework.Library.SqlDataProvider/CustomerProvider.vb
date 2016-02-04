Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Public Class CustomerProvider
    Inherits TestFramework.Library.CustomerProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateCustomer(ByVal rdr As SafeDataReader) As Customer
        Dim obj As Customer = Customer.NewCustomer()
        Dim privateInterface As ICustomer = obj
        obj.BeginPopulate()
        privateInterface.CustomerID = rdr.GetString("CustomerID")
        obj.CompanyName = rdr.GetString("CompanyName")
        obj.ContactName = rdr.GetString("CompanyName")
        obj.ContactTitle = rdr.GetString("ContactTitle")
        obj.Address = rdr.GetString("Address")
        obj.City = rdr.GetString("City")
        obj.Region = rdr.GetString("Region")
        obj.Postalcode = rdr.GetString("PostalCode")
        obj.Country = rdr.GetString("Country")
        obj.Phone = rdr.GetString("Phone")
        obj.Fax = rdr.GetString("Fax")
        obj.EndPopulate()
        Return obj
    End Function

#Region " Overrides "
    Public Overrides Sub DeleteCustomer(ByVal customerID As String)
        Dim cmd As DbCommand = Db(Config.TestDBConnection).GetStoredProcCommand(SP.DeleteCustomer, customerID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function GetCustomer(ByVal customerID As String) As Customer
        Dim cmd As DbCommand = Db(Config.TestDBConnection).GetStoredProcCommand(SP.GetCustomer, customerID)
        Dim newCust As Customer = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                newCust = PopulateCustomer(rdr)
            End While
        End Using
        Return newCust
    End Function
    Public Overrides Function GetCustomers() As Customers
        Dim cmd As DbCommand = Db(Config.TestDBConnection).GetStoredProcCommand(SP.GetCustomers)
        Dim lst As New Customers
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Customers, Customer)(rdr, AddressOf PopulateCustomer)
        End Using
    End Function
    Public Overrides Function InsertCustomer(ByVal instance As Customer) As String
        Dim newCustID As String = String.Empty
        Dim cmd As DbCommand = Db(Config.TestDBConnection).GetStoredProcCommand(SP.InsertCustomer, instance.CompanyName, _
                                                                                instance.ContactName, instance.ContactTitle, instance.Address, _
                                                                                instance.City, instance.Region, instance.Postalcode, instance.Country, _
                                                                                instance.Phone, instance.Fax)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                newCustID = rdr.GetString("CustomerID")
            End While
        End Using
        Return newCustID
    End Function
    Public Overrides Sub UpdateCustomer(ByVal instance As Customer)
        Dim cmd As DbCommand = Db(Config.TestDBConnection).GetStoredProcCommand(SP.UpdateCustomer, instance.CustomerID, instance.CompanyName, instance.ContactName, _
                                                                                instance.ContactTitle, instance.Address, instance.City, instance.Region, _
                                                                                instance.Region, instance.Postalcode, instance.Country, instance.Phone, instance.Fax)
        ExecuteNonQuery(cmd)
    End Sub
#End Region
End Class
