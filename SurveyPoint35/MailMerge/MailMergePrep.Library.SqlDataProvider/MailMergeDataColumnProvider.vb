Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports MailMergePrep.Library
Public Class MailMergeDataColumnProvider
    Inherits MailMergePrep.Library.MailMergeDataColumnProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateMailMergeDataColumn(ByVal rdr As SafeDataReader) As MailMergeDataColumn
        Dim obj As MailMergeDataColumn = MailMergeDataColumn.NewMailMergeDataColumn
        Dim privateInterface As IMailMergeDataColumn = obj
        obj.BeginPopulate()
        privateInterface.MailMergeDataColumnID = rdr.GetInteger("MM_ColumnID")
        obj.FileColumnName = rdr.GetString("FileColumnName")
        obj.TemplateColumnName = rdr.GetString("TemplateColumnName")
        obj.Width = rdr.GetNullableInteger("Width")
        obj.SchemaType = rdr.GetString("SchemaType")
        If (rdr.GetInteger("IsRequired") = 1) Then
            obj.IsRequired = True
        Else
            obj.IsRequired = False
        End If
        obj.MinValue = rdr.GetNullableInteger("MinValue")
        obj.MaxValue = rdr.GetNullableInteger("MaxValue")
        obj.DefaultOrdinal = rdr.GetInteger("DefaultOrdinal")
        obj.EndPopulate()
        Return obj
    End Function

#Region " Overrides "
    Public Overrides Function GetMailMergeDataColumns() As MailMergeDataColumns
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.GetMailMergeDataColumns)
        Dim lst As New MailMergeDataColumns
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MailMergeDataColumns, MailMergeDataColumn)(rdr, AddressOf PopulateMailMergeDataColumn)
        End Using
    End Function

#End Region
End Class
