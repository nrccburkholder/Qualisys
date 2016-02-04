Imports System.Collections.ObjectModel

Namespace DataProviders

    Public MustInherit Class UpdateTypeProvider

#Region " Singleton Implementation "

        Private Shared mInstance As UpdateTypeProvider
        Private Const mProviderName As String = "UpdateTypeProvider"

        Public Shared ReadOnly Property Instance() As UpdateTypeProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of UpdateTypeProvider)(mProviderName)
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

        Public MustOverride Function SelectAll() As UpdateTypeCollection

#End Region

    End Class

End Namespace

