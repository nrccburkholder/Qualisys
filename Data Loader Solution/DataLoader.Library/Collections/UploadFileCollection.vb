Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadFileCollection
    Inherits BusinessListBase(Of UploadFileCollection, UploadFile)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFile = UploadFile.NewUploadFile
        Me.Add(newObj)
        Return newObj
    End Function
End Class