Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportWPMedicareRFileControllerProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportWPMedicareRFileControllerProvider
        Private Const mProviderName As String = "ExportWPMedicareRFileControllerProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportWPMedicareRFileControllerProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportWPMedicareRFileControllerProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        ''' <summary>Returns the collection of tables used to write an export answer file.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <returns>Dataset</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function GetResultFileDataSet(ByVal exportGroupID As Integer, ByVal logFileID As Integer, ByVal origLogFileID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, ByVal startDate2401 As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal ActiveOnly As Boolean) As System.Data.DataSet
        ''' <summary>Returns number of respondents for an export group.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <returns>long</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function GetNumberOfRespondentsForExportGroup(ByVal exportGroupID As Integer, ByVal logFileID As Integer, ByVal origLogFileID As Integer, ByVal markSubmitted As Boolean, ByVal rerunUsingLogDates As Boolean, ByVal startDate2401 As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal ActiveOnly As Boolean) As Long

    End Class

End Namespace
