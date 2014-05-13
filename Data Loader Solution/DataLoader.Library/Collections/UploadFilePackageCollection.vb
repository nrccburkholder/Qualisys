Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadFilePackageCollection
    Inherits BusinessListBase(Of UploadFilePackageCollection, UploadFilePackage)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadFilePackage = UploadFilePackage.NewUploadFilePackage
        Me.Add(newObj)
        Return newObj
    End Function
End Class

