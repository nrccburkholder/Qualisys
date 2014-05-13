<Serializable()> _
Public Class ScheduleEventCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As ScheduleEvent
        Get
            Return DirectCast(MyBase.List(index), ScheduleEvent)
        End Get
    End Property

    Public Function Add(ByVal evnt As ScheduleEvent) As Integer
        Return MyBase.List.Add(evnt)
    End Function

    Public Sub Remove(ByVal evnt As ScheduleEvent)
        MyBase.List.Remove(evnt)
    End Sub
End Class
