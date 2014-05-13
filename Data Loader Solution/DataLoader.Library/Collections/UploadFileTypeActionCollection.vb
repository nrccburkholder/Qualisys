Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadFileTypeActionCollection
    Inherits BusinessListBase(Of UploadFileTypeActionCollection, UploadFileTypeAction)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFileTypeAction = UploadFileTypeAction.NewUploadFileTypeAction
        Me.Add(newObj)
        Return newObj
    End Function
End Class
