'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportGroupTreeProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportGroupTreeProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " SPU_ExportGroup Procs "

    Private Function PopulateExportGroup(ByVal rdr As SafeDataReader) As ExportGroupTree
        Dim newObject As ExportGroupTree = ExportGroupTree.NewExportGroup
        Dim privateInterface As IExportGroupTree = newObject
        newObject.BeginPopulate()
        privateInterface.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.Name = rdr.GetString("Name")
        newObject.EndPopulate()

        Return newObject
    End Function

    Private Function ReturnBoolean(ByVal rdr As SafeDataReader) As Boolean
        Return CBool(rdr.GetByte("ExportExists"))
    End Function
    Private Function ReturnInteger(ByVal rdr As SafeDataReader) As Integer
        Return rdr.GetInteger("ExportID")
    End Function

    Public Overrides Function CopyExport(ByVal oldExportID As Integer, ByVal newExportGroupName As String) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CopyExport, oldExportID, newExportGroupName)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                'TODO:  this should throw an exception.
                Return 0
            Else
                Return ReturnInteger(rdr)
            End If
        End Using
    End Function
    Public Overrides Function CheckExportGroupByName(ByVal exportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckExportGroupByName, exportGroupName, exportGroupId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                'TODO:  this should throw an exception.
                Return True
            Else
                Return ReturnBoolean(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectExportGroup(ByVal exportGroupID As Integer) As ExportGroupTree
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportGroup, exportGroupID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateExportGroup(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllExportGroups() As ExportGroupTreeCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllExportGroups)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportGroupTreeCollection, ExportGroupTree)(rdr, AddressOf PopulateExportGroup)
        End Using
    End Function

    Public Overrides Sub DeleteExportGroup(ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportGroup, exportGroupID)
        ExecuteNonQuery(cmd)
    End Sub

#End Region


End Class
