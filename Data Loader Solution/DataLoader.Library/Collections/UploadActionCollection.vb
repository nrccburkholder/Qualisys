Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadActionCollection
    Inherits BusinessListBase(Of UploadActionCollection, UploadAction)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadAction = UploadAction.NewUploadAction
        Me.Add(newObj)
        Return newObj
    End Function
End Class