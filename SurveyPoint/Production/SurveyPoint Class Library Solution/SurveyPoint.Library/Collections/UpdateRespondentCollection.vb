Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Class UpdateRespondentCollection
    Inherits BusinessListBase(Of UpdateRespondentCollection, UpdateRespondent)

    Public ReadOnly Property UpdatedCount() As Integer
        Get
            Dim updated As Integer = 0

            For Each resp As UpdateRespondent In Me
                If resp.Status = RespondentStatusTypes.Updated OrElse resp.Status = RespondentStatusTypes.InsertedMissingCodeUpdated Then
                    updated += 1
                End If
            Next

            Return updated
        End Get
    End Property

    Public ReadOnly Property CanUpdateCount() As Integer
        Get
            Dim canUpdate As Integer = 0

            For Each resp As UpdateRespondent In Me
                If resp.Status = RespondentStatusTypes.CanUpdate Then
                    canUpdate += 1
                End If
            Next

            Return canUpdate
        End Get
    End Property

    Public ReadOnly Property InsertedMissingCount() As Integer
        Get
            Dim inserted As Integer = 0

            For Each resp As UpdateRespondent In Me
                If resp.Status = RespondentStatusTypes.InsertedMissingCode OrElse resp.Status = RespondentStatusTypes.InsertedMissingCodeUpdated OrElse resp.Status = RespondentStatusTypes.InsertedMissingCodeNotUpdated Then
                    inserted += 1
                End If
            Next

            Return inserted
        End Get
    End Property

    Public Sub ChangeStatus(ByVal changeList As UpdateRespondentCollection, ByVal newStatus As RespondentStatusTypes)

        For Each change As UpdateRespondent In changeList
            For Each resp As UpdateRespondent In Me
                If change.RespondentID = resp.RespondentID Then
                    resp.FirstName = change.FirstName
                    resp.LastName = change.LastName
                    resp.Status = newStatus
                    Exit For
                End If
            Next
        Next

    End Sub

End Class