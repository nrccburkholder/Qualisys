Namespace DataProviders
    Public MustInherit Class VRTDispositionWestProvider

#Region " Singleton Implementation "
        Private Shared mInstance As VRTDispositionWestProvider
        Private Const mProviderName As String = "VRTDispositionWestProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As VRTDispositionWestProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of VRTDispositionWestProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function ImportVRTDisposition(ByVal index As Integer, ByVal instance As VRTDispositionWest) As String
    End Class

End Namespace