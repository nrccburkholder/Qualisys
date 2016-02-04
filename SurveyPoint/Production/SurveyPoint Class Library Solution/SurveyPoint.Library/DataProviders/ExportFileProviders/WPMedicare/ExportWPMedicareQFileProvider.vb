Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportWPMedicareQFileProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportWPMedicareQFileProvider
        Private Const mProviderName As String = "ExportWPMedicareQFileProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportWPMedicareQFileProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportWPMedicareQFileProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        ''' <summary>Get collection for question file objects by export group id</summary>
        ''' <param name="exportGroupID"></param>
        ''' <returns>ExportQuestionFileCollection</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CreateQuestionFileCollection(ByVal questionController As ExportWPMedicareQFileController, ByVal exportGroupID As Integer) As ExportWPMedicareQFileCollection
    End Class

End Namespace