Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class EmailBlastProvider

#Region " Singleton Implementation "
    Private Shared mInstance As EmailBlastProvider
    Private Const mProviderName As String = "EmailBlastProvider"
    Public Shared ReadOnly Property Instance() As EmailBlastProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of EmailBlastProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectEmailBlast(ByVal id As Integer) As EmailBlast
    Public MustOverride Function SelectAllEmailBlasts() As EmailBlastCollection
    Public MustOverride Function SelectEmailBlastsByMAILINGSTEPId(ByVal mAILINGSTEPId As Integer) As EmailBlastCollection
    Public MustOverride Function SelectEmailBlastsByEmailBlastId(ByVal emailBlastId As Integer) As EmailBlastCollection
    Public MustOverride Function InsertEmailBlast(ByVal instance As EmailBlast) As Integer
    Public MustOverride Sub UpdateEmailBlast(ByVal instance As EmailBlast)
    Public MustOverride Sub DeleteEmailBlast(ByVal instance As EmailBlast)
End Class

