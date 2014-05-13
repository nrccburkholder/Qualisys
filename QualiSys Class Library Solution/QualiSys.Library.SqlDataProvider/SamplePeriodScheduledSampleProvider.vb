
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Friend Class SamplePeriodScheduledSampleProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SamplePeriodScheduledSampleProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property

#Region " PeriodDate Procs "
    Private Function PopulateSamplePeriodScheduledSample(ByVal rdr As SafeDataReader) As SamplePeriodScheduledSample
        Dim newObject As SamplePeriodScheduledSample = SamplePeriodScheduledSample.NewSamplePeriodScheduledSample
        newObject.BeginPopulate()
        newObject.SamplePeriodId = rdr.GetInteger("PeriodDef_id")
        newObject.SampleNumber = rdr.GetInteger("SampleNumber")
        newObject.ScheduledSampleDate = rdr.GetDate("datScheduledSample_dt")
        newObject.SampleSetId = rdr.GetNullableInteger("SampleSet_id")
        'If a sample creation date exists, but no samplesetId exists, then we know this was a canceled sample.
        'Canceled samples have dummy dates filled in for the sample creation date
        If (rdr.GetNullableDate("datSampleCreate_dt").HasValue) AndAlso Not newObject.SampleSetId.HasValue Then
            newObject.Canceled = True
        End If
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal samplenumber As Integer) As SamplePeriodScheduledSample
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSamplePeriodScheduledSample, samplePeriodId, samplenumber)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSamplePeriodScheduledSample(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectSamplePeriodScheduledSamples(ByVal samplePeriodId As Integer) As SamplePeriodScheduledSampleCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSamplePeriodScheduledSamples, samplePeriodId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of SamplePeriodScheduledSampleCollection, SamplePeriodScheduledSample)(rdr, AddressOf PopulateSamplePeriodScheduledSample)
        End Using
    End Function

    Public Overrides Sub InsertSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplePeriodScheduledSample, instance.SamplePeriodId, instance.SampleNumber, SafeDataReader.ToDBValue(instance.ScheduledSampleDate))
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSamplePeriodScheduledSample, instance.SamplePeriodId, instance.SampleNumber, SafeDataReader.ToDBValue(instance.ScheduledSampleDate), SafeDataReader.ToDBValue(instance.ActualSampleDate))
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal sampleNumber As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.deleteSamplePeriodScheduledSample, samplePeriodId, sampleNumber)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub InsertSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSamplePeriodScheduledSample, instance.SamplePeriodId, instance.SampleNumber, SafeDataReader.ToDBValue(instance.ScheduledSampleDate))
        ExecuteNonQuery(cmd, tran)
    End Sub

    Public Overrides Sub UpdateSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSamplePeriodScheduledSample, Instance.SamplePeriodId, Instance.SampleNumber, SafeDataReader.ToDBValue(Instance.ScheduledSampleDate), SafeDataReader.ToDBValue(Instance.ActualSampleDate))
        ExecuteNonQuery(cmd, tran)
    End Sub

    Public Overrides Sub DeleteSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal sampleNumber As Integer, ByVal tran As DbTransaction)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.deleteSamplePeriodScheduledSample, samplePeriodId, sampleNumber)
        ExecuteNonQuery(cmd, tran)
    End Sub

#End Region

End Class
