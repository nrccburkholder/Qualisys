Imports NRC.Framework.BusinessLogic
<Serializable()> _
Public Class TransferResultsNavigatorTreeCollection
    Inherits BusinessListBase(Of TransferResultsNavigatorTreeCollection, TransferResultsNavigatorTree)

#Region " Base Class Overrides "

    Protected Overrides Function AddNewCore() As Object

        Dim newObj As TransferResultsNavigatorTree = TransferResultsNavigatorTree.NewTransferResultsNavigatorTree
        Me.Add(newObj)
        Return newObj

    End Function

#End Region

#Region " Public Methods "

    Public Function GetErrorsOnly() As TransferResultsNavigatorTreeCollection

        Dim errorData As New TransferResultsNavigatorTreeCollection

        For Each item As TransferResultsNavigatorTree In Me
            If item.DataLoadHasSurveyErrors OrElse item.DataLoadHasBadLithos OrElse item.SurveyDataLoadHasErrors Then
                errorData.Add(item)
            End If
        Next

        Return errorData

    End Function

#End Region

End Class

