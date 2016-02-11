'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportFileLayoutProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportFileLayoutProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SPU_FileLayout Procs "

    Private Function PopulateExportFileLayout(ByVal rdr As SafeDataReader) As ExportFileLayout
        Dim newObject As ExportFileLayout = ExportFileLayout.NewExportFileLayout
        Dim privateInterface As IFileLayout = newObject
        newObject.BeginPopulate()
        privateInterface.FileLayoutID = rdr.GetInteger("FileLayoutID")
        newObject.FilelayoutName = rdr.GetString("FilelayoutName")
        newObject.VersionNumber = rdr.GetString("VersionNumber")
        newObject.ImplementationDate = rdr.GetDate("ImplementationDate")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectFileLayout(ByVal fileLayoutID As Integer) As ExportFileLayout
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileLayout, fileLayoutID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateExportFileLayout(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllFileLayouts() As ExportFileLayoutCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportFileLayouts)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportFileLayoutCollection, ExportFileLayout)(rdr, AddressOf PopulateExportFileLayout)
        End Using
    End Function

#End Region


End Class