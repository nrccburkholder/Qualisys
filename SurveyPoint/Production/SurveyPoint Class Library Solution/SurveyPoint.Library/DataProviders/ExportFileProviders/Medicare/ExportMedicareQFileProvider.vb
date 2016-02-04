Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportMedicareQFileProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportMedicareQFileProvider
        Private Const mProviderName As String = "ExportMedicareQFileProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportMedicareQFileProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportMedicareQFileProvider)(mProviderName)
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
        Public MustOverride Function CreateQuestionFileCollection(ByVal questionController As ExportMedicareQFileController, ByVal exportGroupID As Integer) As ExportMedicareQFileCollection
    End Class

End Namespace