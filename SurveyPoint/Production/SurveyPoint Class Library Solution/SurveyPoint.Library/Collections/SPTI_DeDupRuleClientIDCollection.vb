Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_DeDupRuleClientIDCollection
    Inherits BusinessListBase(Of SPTI_DeDupRuleClientIDCollection, SPTI_DeDupRuleClientID)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_DeDupRuleClientID = SPTI_DeDupRuleClientID.NewSPTI_DeDupRuleClientID
        Me.Add(newObj)
        Return newObj
    End Function
    Public Function GetClientIDsString() As String
        Dim tempString As String = ""
        For Each item As SPTI_DeDupRuleClientID In Me
            tempString += item.ClientID & ","
        Next
        If tempString.Length > 0 Then
            tempString = tempString.Substring(0, tempString.Length - 1)
        End If
        Return tempString
    End Function
End Class