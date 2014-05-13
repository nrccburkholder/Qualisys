Imports Nrc.QualiSys.Pervasive.Library.Navigation

Namespace DataProvider

    Public MustInherit Class NavigationProvider

#Region " Singleton Implementation "

        Private Shared mInstance As NavigationProvider
        Private Const mProviderName As String = "NavigationProvider"

        Public Shared ReadOnly Property Instance() As NavigationProvider
            <DebuggerHidden()> Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of NavigationProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region " Constructors "

        Protected Sub New()

        End Sub

#End Region

#Region " Public MustOverride Methods "

        Public MustOverride Function GetNavigationTreeByUser(ByVal userName As String, ByVal initialDepth As InitialPopulationDepth, ByVal includeGroups As Boolean, ByVal dataFileState As DataFileStates) As NavigationTree

#End Region

    End Class

End Namespace