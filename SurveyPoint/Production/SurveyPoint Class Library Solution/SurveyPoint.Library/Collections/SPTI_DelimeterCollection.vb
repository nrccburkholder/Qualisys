Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_DelimeterCollection
    Inherits BusinessListBase(Of SPTI_DelimeterCollection, SPTI_Delimeter)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_Delimeter = SPTI_Delimeter.NewSPTI_Delimeter
        Me.Add(newObj)
        Return newObj
    End Function
End Class
