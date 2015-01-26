Imports system.Data.common
Namespace DataProvider

    Public MustInherit Class SamplePeriodScheduledSampleProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SamplePeriodScheduledSampleProvider
        Private Const mProviderName As String = "SamplePeriodScheduledSampleProvider"
        Public Shared ReadOnly Property Instance() As SamplePeriodScheduledSampleProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SamplePeriodScheduledSampleProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSamplePeriodScheduledSamples(ByVal samplePeriodId As Integer) As SamplePeriodScheduledSampleCollection
        Public MustOverride Function SelectSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal sampleNumber As Integer) As SamplePeriodScheduledSample
        Public MustOverride Sub InsertSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample, ByVal tran As DbTransaction)
        Public MustOverride Sub InsertSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample)
        Public MustOverride Sub UpdateSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample, ByVal tran As DbTransaction)
        Public MustOverride Sub UpdateSamplePeriodScheduledSample(ByVal instance As SamplePeriodScheduledSample)
        Public MustOverride Sub DeleteSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal sampleNumber As Integer)
        Public MustOverride Sub DeleteSamplePeriodScheduledSample(ByVal samplePeriodId As Integer, ByVal sampleNumber As Integer, ByVal tran As DbTransaction)
    End Class
End Namespace
