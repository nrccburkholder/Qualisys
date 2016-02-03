Imports System.Collections.ObjectModel

Namespace DataProviders

    Public MustInherit Class UpdateFileProvider

#Region " Singleton Implementation "

        Private Shared mInstance As UpdateFileProvider
        Private Const mProviderName As String = "UpdateFileProvider"

        Public Shared ReadOnly Property Instance() As UpdateFileProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of UpdateFileProvider)(mProviderName)
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

        'Public MustOverride Function [Select](ByVal id As Integer) As UpdateFile
        'Public MustOverride Function SelectAll() As ProductCollection
        'Public MustOverride Function SelectByCategoryId(ByVal categoryId As Integer) As ProductCollection
        'Public MustOverride Function Insert(ByVal obj As UpdateFile) As Integer
        'Public MustOverride Sub Update(ByVal obj As UpdateFile)
        'Public MustOverride Sub Delete(ByVal id As Integer)

#End Region

    End Class

End Namespace
