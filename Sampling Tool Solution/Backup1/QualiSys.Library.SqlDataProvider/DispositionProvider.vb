Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class DispositionProvider
	Inherits QualiSys.Library.DispositionProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property

#Region " Disposition Procs "

    Private Function PopulateDisposition(ByVal rdr As SafeDataReader) As Disposition

        Dim newObject As Disposition = Disposition.NewDisposition
        Dim privateInterface As IDisposition = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("Disposition_id")
        newObject.DispositionLabel = rdr.GetString("strDispositionLabel")
        newObject.ActionId = rdr.GetInteger("Action_id")
        newObject.ReportLabel = rdr.GetString("strReportLabel")
        newObject.MustHaveResults = rdr.GetBoolean("MustHaveResults")
        newObject.EndPopulate()

        Return newObject

    End Function

    Public Overrides Function SelectDisposition(ByVal id As Integer) As Disposition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDisposition, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDisposition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectAllDispositions() As DispositionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllDispositions)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of DispositionCollection, Disposition)(rdr, AddressOf PopulateDisposition)
        End Using

    End Function

    Public Overrides Function InsertDisposition(ByVal instance As Disposition) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDisposition, instance.DispositionLabel, instance.ActionId, instance.ReportLabel, instance.MustHaveResults)
        Return ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateDisposition(ByVal instance As Disposition)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDisposition, instance.Id, instance.DispositionLabel, instance.ActionId, instance.ReportLabel, instance.MustHaveResults)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteDisposition(ByVal instance As Disposition)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDisposition, instance.Id)
            ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
