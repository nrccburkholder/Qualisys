Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class QDispositionProvider
    Inherits Nrc.QualiSys.Library.DataProvider.QDispositionProvider

    Private Function PopulateDisposition(ByVal rdr As SafeDataReader) As QDisposition

        Dim newObj As New QDisposition
        ReadOnlyAccessor.DispositionName(newObj) = rdr.GetString("strDispositionLabel")
        ReadOnlyAccessor.DispositionId(newObj) = rdr.GetInteger("Disposition_id")
        ReadOnlyAccessor.DispositionAction(newObj) = CType(rdr.GetInteger("Action_id"), DispositionAction)
        Return newObj

    End Function

    Public Overrides Function [Select](ByVal dispositionId As Integer) As QDisposition

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQDisposition, dispositionId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDisposition(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As QDispositionCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQDispositionsBySurvey, surveyId)

        'Get the data reader 
        Dim dispositions As New QDispositionCollection
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                dispositions.Add(PopulateDisposition(rdr))
            End While
        End Using
        Return dispositions

    End Function

End Class
