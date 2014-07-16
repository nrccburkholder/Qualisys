Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class ModeSectionMappingCollection
    Inherits BusinessListBase(Of ModeSectionMappingCollection, ModeSectionMapping)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As ModeSectionMapping = ModeSectionMapping.NewModeSectionMapping
        Me.Add(newObj)
        Return newObj
    End Function

    Public Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)
        For Each sectionMapping As ModeSectionMapping In Me.Items
            If sectionMapping.IsNew Then
                'New
                changes.AddRange(AuditLog.CompareObjects(Of ModeSectionMapping)(Nothing, sectionMapping, "Id", AuditLogObject.SectionMapping))
            End If
        Next

        For Each sectionMapping As ModeSectionMapping In Me.DeletedList
            If Not sectionMapping.IsNew Then
                'Deleted
                changes.AddRange(AuditLog.CompareObjects(Of ModeSectionMapping)(sectionMapping, Nothing, "Id", AuditLogObject.SectionMapping))
            End If
        Next

        Return changes
    End Function

End Class
