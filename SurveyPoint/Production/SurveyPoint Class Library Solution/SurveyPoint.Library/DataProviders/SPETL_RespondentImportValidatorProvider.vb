Namespace DataProviders
    Public MustInherit Class SPETL_RespondentImportValidatorProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPETL_RespondentImportValidatorProvider
        Private Const mProviderName As String = "SPETL_RespondentImportValidatorProvider"
        Public Shared ReadOnly Property Instance() As SPETL_RespondentImportValidatorProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPETL_RespondentImportValidatorProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Sub GetTemplateInfo(ByVal instance As SPETL_RespondentImportValidator)
        Public MustOverride Function GetFileDefTable(ByVal fileDefID As Integer) As Data.DataTable
        Public MustOverride Function GetRespondentBaseInformation(ByVal fileDefID As Integer, ByVal scriptID As Integer, ByVal templateID As Integer, ByVal respondentID As Integer) As Data.DataTable
        Public MustOverride Function GetRespondentData(ByVal respondentID As Integer) As Data.DataTable
        Public MustOverride Function GetRespondentProperties(ByVal respondentID As Integer) As Data.DataTable
        Public MustOverride Function GetRespondentEventLog(ByVal respondentID As Integer) As Data.DataTable
    End Class
End Namespace