Imports Nrc.QualiSys.QLoader.Library

Public MustInherit Class LoadToLiveDefinitionProvider

#Region " Singleton Implementation "

    Private Shared mInstance As LoadToLiveDefinitionProvider
    Private Const mProviderName As String = "LoadToLiveDefinitionProvider"

    Public Shared ReadOnly Property Instance() As LoadToLiveDefinitionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviders.DataProviderFactory.CreateInstance(Of LoadToLiveDefinitionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectLoadToLiveDefinition(ByVal id As Integer) As LoadToLiveDefinition
    Public MustOverride Function SelectAllLoadToLiveDefinitions() As LoadToLiveDefinitionCollection
    Public MustOverride Function SelectLoadToLiveDefinitionsByDataFileID(ByVal dataFileID As Integer) As LoadToLiveDefinitionCollection
    Public MustOverride Function InsertLoadToLiveDefinition(ByVal instance As LoadToLiveDefinition) As Integer
    Public MustOverride Sub UpdateLoadToLiveDefinition(ByVal instance As LoadToLiveDefinition)
    Public MustOverride Sub DeleteLoadToLiveDefinition(ByVal LoadToLiveDefinition As LoadToLiveDefinition)
    Public MustOverride Function LoadToLiveDuplicateCheck(ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage, ByVal definitions As LoadToLiveDefinitionCollection) As DataTable
    Public MustOverride Sub LoadToLiveDeleteDuplicate(ByVal row As DataRow, ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage)
    Public MustOverride Sub LoadToLiveUpdate(ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage, ByVal definitions As LoadToLiveDefinitionCollection, ByRef qualisysRecCount As Integer, ByRef datamartRecCount As Integer, ByRef catalystRecCount As Integer)

End Class

