Namespace DataProviders
    Public MustInherit Class ExportFileLogProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportFileLogProvider
        Private Const mProviderName As String = "ExportFileLogProvider"
        Public Shared ReadOnly Property Instance() As ExportFileLogProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportFileLogProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectExportFileLog(ByVal exportLogFileID As Integer) As ExportFileLog
        Public MustOverride Function SelectAllExportFileLogs(ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        Public MustOverride Function SelectExportFileLogByExportGroupID(ByVal exportGroupID As Integer, ByVal StartDate As Date, ByVal EndDate As Date) As ExportFileLogCollection
        Public MustOverride Function InsertExportFileLog(ByVal instance As ExportFileLog) As Integer
        Public MustOverride Sub UpdateExportFileLog(ByVal instance As ExportFileLog)
        Public MustOverride Sub DeleteExportFileLog(ByVal exportLogFileID As Integer)
        'TP 20080415
        Public MustOverride Function CreateFileLog(ByVal exportGroupID As Integer, ByVal userID As Integer, ByVal userName As String, ByVal isActive As Boolean, ByVal markSubmitted As Boolean) As Integer
        'TP 20080415
        Public MustOverride Sub FinishLogFileEntry(ByVal logFile As ExportFileLog)
        'SK 20080424
        Public MustOverride Sub MarkExportFileLogInActive(ByVal exportGroupId As Integer)

    End Class
End Namespace