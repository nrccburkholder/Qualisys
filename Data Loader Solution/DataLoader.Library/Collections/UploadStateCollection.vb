Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class UploadStateCollection
    Inherits BusinessListBase(Of UploadStateCollection, UploadState)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As UploadState = UploadState.NewUploadState
        Me.Add(newObj)
        Return newObj
    End Function
End Class