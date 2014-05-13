Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadFilePackageDisplayCollection
    Inherits BusinessListBase(Of UploadFilePackageDisplayCollection, UploadFilePackageDisplay)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFilePackageDisplay = UploadFilePackageDisplay.NewUploadFilePackageDisplay
        Me.Add(newObj)
        Return newObj
    End Function
End Class