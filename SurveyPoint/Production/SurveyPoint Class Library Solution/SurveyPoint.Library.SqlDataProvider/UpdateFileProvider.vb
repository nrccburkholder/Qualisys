Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.Collections.ObjectModel

Friend Class UpdateFileProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.UpdateFileProvider

    'Private Function Populate(ByVal rdr As SafeDataReader) As UpdateFile

    '    Dim newObject As UpdateFile = UpdateFile.NewProduct
    '    newObject.BeginPopulate()
    '    newObject.ProductName = rdr.GetString("ProductName")
    '    newObject.ProductName = rdr.GetString("ProductName")
    '    newObject.SupplierID = rdr.GetInteger("SupplierID")
    '    newObject.CategoryID = rdr.GetInteger("CategoryID")
    '    newObject.QuantityPerUnit = rdr.GetString("QuantityPerUnit")
    '    newObject.UnitPrice = rdr.GetDecimal("UnitPrice")
    '    newObject.UnitsInStock = rdr.GetShort("UnitsInStock")
    '    newObject.UnitsOnOrder = rdr.GetShort("UnitsOnOrder")
    '    newObject.ReorderLevel = rdr.GetShort("ReorderLevel")
    '    newObject.Discontinued = rdr.GetBoolean("Discontinued")
    '    newObject.EndPopulate()

    '    Return newObject

    'End Function

    'Public Overrides Sub Delete(ByVal id As Integer)

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteProduct, id)
    '    ExecuteNonQuery(cmd)

    'End Sub

    'Public Overrides Function Insert(ByVal obj As UpdateFile) As Integer

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertProduct, obj.ProductName, obj.SupplierID, obj.CategoryID, obj.QuantityPerUnit, obj.UnitPrice, obj.UnitsInStock, obj.UnitsOnOrder, obj.ReorderLevel, obj.Discontinued)
    '    Return ExecuteInteger(cmd)

    'End Function

    'Public Overrides Function [Select](ByVal id As Integer) As UpdateFile

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectProduct, id)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        If Not rdr.Read Then
    '            Return Nothing
    '        Else
    '            Return Populate(rdr)
    '        End If
    '    End Using

    'End Function

    'Public Overrides Function SelectAll() As ProductCollection

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllProducts)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        Return PopulateCollection(Of ProductCollection, UpdateFile)(rdr, AddressOf Populate)
    '    End Using

    'End Function

    'Public Overrides Function SelectByCategoryId(ByVal categoryId As Integer) As ProductCollection

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectProductsByCategoryId, categoryId)
    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        Return PopulateCollection(Of ProductCollection, UpdateFile)(rdr, AddressOf Populate)
    '    End Using

    'End Function

    'Public Overrides Sub Update(ByVal obj As UpdateFile)

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateProduct, obj.ProductID, obj.ProductName, obj.SupplierID, obj.CategoryID, obj.QuantityPerUnit, obj.UnitPrice, obj.UnitsInStock, obj.UnitsOnOrder, obj.ReorderLevel, obj.Discontinued)
    '    ExecuteNonQuery(cmd)

    'End Sub

End Class
