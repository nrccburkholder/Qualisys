Imports Nrc.Framework.BusinessLogic
Public Class UploadFilePackageNoteCollection
    Inherits BusinessListBase(Of UploadFilePackageNoteCollection, UploadFilePackageNote)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFilePackageNote = UploadFilePackageNote.NewUploadFilePackageNote
        Me.Add(newObj)
        Return newObj
    End Function

End Class
