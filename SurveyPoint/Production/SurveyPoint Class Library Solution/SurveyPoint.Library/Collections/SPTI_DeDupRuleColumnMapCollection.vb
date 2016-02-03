Imports Nrc.Framework.BusinessLogic
<Serializable()> _
Public Class SPTI_DeDupRuleColumnMapCollection
    Inherits BusinessListBase(Of SPTI_DeDupRuleColumnMapCollection, SPTI_DeDupRuleColumnMap)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_DeDupRuleColumnMap = SPTI_DeDupRuleColumnMap.NewSPTI_DeDupRuleColumnMap
        Me.Add(newObj)
        Return newObj
    End Function
    Friend Function GetColumnMapCriteria(ByVal QMSAlias As String, ByVal templateAlias As String) As String
        Dim retVal As String = ""
        If QMSAlias.Length > 0 Then
            QMSAlias += "."
        End If
        If templateAlias.Length > 0 Then
            templateAlias += "."
        End If
        For Each item As SPTI_DeDupRuleColumnMap In Me
            retVal += "(" & QMSAlias & item.QMSColumnName & " = " & templateAlias & item.FileTemplateColumnName & ") and"
        Next
        If retVal.Length > 0 Then
            retVal = retVal.Substring(0, retVal.Length - 4)
        End If
        Return retVal
    End Function
End Class