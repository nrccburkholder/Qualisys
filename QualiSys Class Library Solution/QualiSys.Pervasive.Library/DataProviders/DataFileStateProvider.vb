Public MustInherit Class DataFileStateProvider

#Region " Singleton Implementation "

    Private Shared mInstance As DataFileStateProvider
    Private Const mProviderName As String = "DataFileStateProvider"

    Public Shared ReadOnly Property Instance() As DataFileStateProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DataFileStateProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public MustOverride Method Declarations "

    Public MustOverride Function SelectDataFileState(ByVal id As Integer) As DataFileState
    Public MustOverride Function SelectAllDataFileStates() As DataFileStateCollection
    Public MustOverride Function SelectDataFileStatesByDataFileId(ByVal dataFileId As Integer) As DataFileStateCollection
    Public MustOverride Function SelectDataFileStatesByStateId(ByVal stateId As Integer) As DataFileStateCollection
    Public MustOverride Function InsertDataFileState(ByVal instance As DataFileState) As Integer
    Public MustOverride Sub UpdateDataFileState(ByVal instance As DataFileState)
    Public MustOverride Sub DeleteDataFileState(ByVal DataFileState As DataFileState)
    Public MustOverride Sub ChangeDataFileState(ByVal dataFileID As Integer, ByVal stateID As DataFileStates, ByVal stateParam As String)

#End Region

End Class

