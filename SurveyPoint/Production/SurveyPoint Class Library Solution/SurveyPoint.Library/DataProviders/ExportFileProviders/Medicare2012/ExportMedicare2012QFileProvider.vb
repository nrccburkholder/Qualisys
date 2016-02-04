Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportMedicare2012QFileProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportMedicare2012QFileProvider
        Private Const mProviderName As String = "ExportMedicare2012QFileProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportMedicare2012QFileProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportMedicare2012QFileProvider)(mProviderName)
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
        Public MustOverride Function CreateQuestionFileCollection(ByVal questionController As ExportMedicare2012QFileController, ByVal exportGroupID As Integer) As ExportMedicare2012QFileCollection
    End Class

End Namespace