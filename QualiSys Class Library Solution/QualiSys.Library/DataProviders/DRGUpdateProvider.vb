Namespace DataProvider


    Public MustInherit Class DRGUpdateProvider

#Region " Singleton Implementation "
        Private Shared mInstance As DRGUpdateProvider
        Private Const mProviderName As String = "DRGUpdateProvider"

        Public Shared ReadOnly Property Instance() As DRGUpdateProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of DRGUpdateProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region


        Protected Sub New()

        End Sub


        Public MustOverride Function [Select](ByVal studyid As Integer) As Collection(Of DRGUpdate)

        Public MustOverride Function Rollback(ByVal datafile As DRGUpdate) As DataTable

        Public MustOverride Sub UpdateFileStateDRG(ByVal datafile_id As Integer, ByVal State_id As Integer, ByVal StateParameter As String, ByVal StateDescription As String, ByVal Member_id As Integer)

    End Class


End Namespace