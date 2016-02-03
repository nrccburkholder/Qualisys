Imports System.Collections.ObjectModel

Namespace DataProviders

    Public MustInherit Class UpdateMappingProvider

#Region " Singleton Implementation "

        Private Shared mInstance As UpdateMappingProvider
        Private Const mProviderName As String = "UpdateMappingProvider"

        Public Shared ReadOnly Property Instance() As UpdateMappingProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of UpdateMappingProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

#Region "Constructors"

        Protected Sub New()

        End Sub

#End Region

#Region "CRUD Methods"

        Public MustOverride Function SelectByUpdateTypeID(ByVal updateTypeID As Integer) As UpdateMappingCollection

#End Region

    End Class

End Namespace
