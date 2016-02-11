Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportGroupTreeProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportGroupTreeProvider
        Private Const mProviderName As String = "ExportGroupTreeProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportGroupTreeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportGroupTreeProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        ''' <summary>Get an export group by its ID.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function SelectExportGroup(ByVal exportGroupID As Integer) As ExportGroupTree
        ''' <summary>Retrieve all export groups as a tree collection</summary>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function SelectAllExportGroups() As ExportGroupTreeCollection
        ''' <summary>Delete the existing export group</summary>
        ''' <param name="exportGroupID"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub DeleteExportGroup(ByVal exportGroupID As Integer)
        ''' <summary>See if the export group exists by its name.</summary>
        ''' <param name="exportGroupName"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CheckExportGroupByName(ByVal exportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        ''' <summary>Copy the existing export group into a new one.</summary>
        ''' <param name="oldExportID"></param>
        ''' <param name="newExportGroupName"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CopyExport(ByVal oldExportID As Integer, ByVal newExportGroupName As String) As Integer
    End Class

End Namespace