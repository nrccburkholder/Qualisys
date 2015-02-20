Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class SampleUnitSectionMappingCollection
    Inherits BusinessListBase(Of SampleUnitSectionMappingCollection, SampleUnitSectionMapping)

    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SampleUnitSectionMapping = SampleUnitSectionMapping.NewSampleUnitSectionMapping
        Me.Add(newObj)
        Return newObj
    End Function

    Public Function GetChanges() As List(Of AuditLogChange)
        Dim changes As New List(Of AuditLogChange)
        For Each sectionMapping As SampleUnitSectionMapping In Me.Items
            If sectionMapping.IsNew Then
                'New
                changes.AddRange(AuditLog.CompareObjects(Of SampleUnitSectionMapping)(Nothing, sectionMapping, "Id", AuditLogObject.SectionMapping))
            End If
        Next

        For Each sectionMapping As SampleUnitSectionMapping In Me.DeletedList
            If Not sectionMapping.IsNew Then
                'Deleted
                changes.AddRange(AuditLog.CompareObjects(Of SampleUnitSectionMapping)(sectionMapping, Nothing, "Id", AuditLogObject.SectionMapping))
            End If
        Next

        Return changes
    End Function

End Class
