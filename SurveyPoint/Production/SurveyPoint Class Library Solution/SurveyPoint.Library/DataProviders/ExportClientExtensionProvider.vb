Namespace DataProviders
    Public MustInherit Class ExportClientExtensionProvider


#Region " Singleton Implementation "
        Private Shared mInstance As ExportClientExtensionProvider
        Private Const mProviderName As String = "ExportClientExtensionProvider"
        Public Shared ReadOnly Property Instance() As ExportClientExtensionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportClientExtensionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectClientExtensionByID(ByVal clientExtensionID As Integer) As ExportClientExtension
        Public MustOverride Function SelectAll() As ExportClientExtensionCollection
        Public MustOverride Function SelectClientExtensionsByClientID(ByVal clientID As Integer) As ExportClientExtensionCollection
        Public MustOverride Function SelectClientExtensionsByExportGroupID(ByVal exportGroupID As Integer) As ExportClientExtensionCollection
        Public MustOverride Function SelectClientExtensionsBySurveyID(ByVal surveyID As Integer) As ExportClientExtensionCollection
        Public MustOverride Function Insert(ByVal instance As ExportClientExtension) As Integer
        Public MustOverride Sub Update(ByVal instance As ExportClientExtension)
        Public MustOverride Sub Delete(ByVal clientExtensionID As Integer)
    End Class


End Namespace
