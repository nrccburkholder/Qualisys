Namespace DataProviders

    Public MustInherit Class SPTI_DeDupRuleColumnMapProvider

#Region " Singleton Implementation "
        Private Shared mInstance As SPTI_DeDupRuleColumnMapProvider
        Private Const mProviderName As String = "SPTI_DeDupRuleColumnMapProvider"
        Public Shared ReadOnly Property Instance() As SPTI_DeDupRuleColumnMapProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of SPTI_DeDupRuleColumnMapProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSPTI_DeDupRuleColumnMap(ByVal iD As Integer) As SPTI_DeDupRuleColumnMap
        Public MustOverride Function SelectAllSPTI_DeDupRuleColumnMaps() As SPTI_DeDupRuleColumnMapCollection
        Public MustOverride Function SelectAllSPTI_DeDupRuleColumnMapsByDeDupRuleID(ByVal deDupRuleID As Integer) As SPTI_DeDupRuleColumnMapCollection
        Public MustOverride Function InsertSPTI_DeDupRuleColumnMap(ByVal instance As SPTI_DeDupRuleColumnMap) As Integer
        Public MustOverride Sub UpdateSPTI_DeDupRuleColumnMap(ByVal instance As SPTI_DeDupRuleColumnMap)
        Public MustOverride Sub DeleteSPTI_DeDupRuleColumnMap(ByVal iD As Integer)
    End Class
End Namespace