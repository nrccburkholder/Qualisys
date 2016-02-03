Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportGroupProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportGroupProvider
        Private Const mProviderName As String = "ExportGroupProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportGroupProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportGroupProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        ''' <summary>Get an export group by its id</summary>
        ''' <param name="exportGroupID"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function SelectExportGroup(ByVal exportGroupID As Integer) As ExportGroup
        ''' <summary>Get all export groups in the data store</summary>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function SelectAllExportGroups() As ExportGroupCollection
        ''' <summary>Insert a new export group</summary>
        ''' <param name="instance"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function InsertExportGroup(ByVal instance As ExportGroup) As Integer
        ''' <summary>Update an existing export group</summary>
        ''' <param name="instance"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub UpdateExportGroup(ByVal instance As ExportGroup)
        ''' <summary>Delete an existing export group.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub DeleteExportGroup(ByVal exportGroupID As Integer)
        ''' <summary>Checks by export name if an export group exists in the data store.</summary>
        ''' <param name="exportGroupName"></param>
        ''' <returns>true if exists else false</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CheckExportGroupByName(ByVal exportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        ''' <summary>Copies an exist export group into a new one.</summary>
        ''' <param name="oldExportID"></param>
        ''' <param name="newExportGroupName"></param>
        ''' <returns>The new export group id.</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CopyExport(ByVal oldExportID As Integer, ByVal newExportGroupName As String) As Integer
        ''' <summary>Deletes an export group and all of its child relations in the data store.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub DeleteExportGroupAll(ByVal exportGroupID As Integer)
        ''' <summary>Deletes all of an export groups child relations.</summary>
        ''' <param name="exportGroupID"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub DeleteExportGroupChildren(ByVal exportGroupID As Integer)
        ''' <summary>This method populates the ExportGroupExtension collection from the fields of the export group.</summary>
        ''' <param name="group"></param>
        ''' <returns></returns>
        ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function PopulateExportGroupExtensionCollection(ByVal group As ExportGroup) As ExportGroupExtensionCollection

        ''' <summary>You should not be able to save or run an export if one is currently running.  This method check if a export is currently running.</summary>
        ''' <returns>True if an export is running, false if not.</returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function CheckForRunningExport() As Boolean
    End Class

End Namespace