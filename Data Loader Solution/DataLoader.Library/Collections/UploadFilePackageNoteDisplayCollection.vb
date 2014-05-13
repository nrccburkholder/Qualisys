Imports Nrc.Framework.BusinessLogic
Public Class UploadFilePackageNoteDisplayCollection
    Inherits BusinessListBase(Of UploadFilePackageNoteDisplayCollection, UploadFilePackageNoteDisplay)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFilePackageNoteDisplay = UploadFilePackageNoteDisplay.NewUploadFilePackageNoteDisplay
        Me.Add(newObj)
        Return newObj
    End Function

End Class
