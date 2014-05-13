Imports NRC.Framework.BusinessLogic

Public MustInherit Class CommentProvider

#Region " Singleton Implementation "

    Private Shared mInstance As CommentProvider
    Private Const mProviderName As String = "CommentProvider"

    Public Shared ReadOnly Property Instance() As CommentProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of CommentProvider)(mProviderName)
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

    Public MustOverride Function SelectComment(ByVal dataLoadCmntId As Integer) As Comment
    Public MustOverride Function SelectCommentsByLithoCodeId(ByVal lithoCodeId As Integer) As CommentCollection
    Public MustOverride Function InsertComment(ByVal instance As Comment) As Integer
    Public MustOverride Sub UpdateComment(ByVal instance As Comment)
    Public MustOverride Sub DeleteComment(ByVal instance As Comment)

#End Region

End Class

