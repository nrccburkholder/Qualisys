Public Class SampleUnitLinkingCollection
    Inherits System.Collections.ObjectModel.Collection(Of SampleUnitLinking)

    Public Function ContainsFromUnit(ByVal sampleUnitId As Integer) As Boolean
        For Each mapping As SampleUnitLinking In Me
            If mapping.FromSampleUnitId = sampleUnitId Then
                Return True
            End If
        Next

        Return False
    End Function
    Public Function ContainsToUnit(ByVal sampleUnitId As Integer) As Boolean
        For Each mapping As SampleUnitLinking In Me
            If mapping.ToSampleUnitId = sampleUnitId Then
                Return True
            End If
        Next

        Return False
    End Function

    Public Function ContainsUnit(ByVal sampleUnitId As Integer) As Boolean
        For Each mapping As SampleUnitLinking In Me
            If mapping.FromSampleUnitId = sampleUnitId OrElse mapping.ToSampleUnitId = sampleUnitId Then
                Return True
            End If
        Next

        Return False
    End Function

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As SampleUnitLinking)
        If item Is Nothing Then
            Throw New ArgumentNullException("item")
        End If
        If Me.ContainsFromUnit(item.FromSampleUnitId) Then
            Throw New InvalidSampleUnitMappingException("The 'From Unit' used in this mapping has already been mapped.")
        End If
        If Me.ContainsToUnit(item.ToSampleUnitId) Then
            Throw New InvalidSampleUnitMappingException("The 'To Unit' used in this mapping has already been mapped.")
        End If

        'Allow insert
        MyBase.InsertItem(index, item)
    End Sub
End Class



