Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadFileHistoryCollection
    Inherits BusinessListBase(Of UploadFileHistoryCollection, UploadFileHistory)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFileHistory = UploadFileHistory.NewUploadFileHistory
        Me.Add(newObj)
        Return newObj
    End Function
End Class