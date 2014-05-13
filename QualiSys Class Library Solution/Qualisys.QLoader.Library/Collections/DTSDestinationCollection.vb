Public Class DTSDestinationCollection
    Inherits CollectionBase

#Region " Public Properties "

    Default Public Property Item(ByVal index As Integer) As DTSDestination
        Get
            Return DirectCast(MyBase.List.Item(index), DTSDestination)
        End Get
        Set(ByVal Value As DTSDestination)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Default Public ReadOnly Property Item(ByVal name As String) As DTSDestination
        Get
            Return FindByName(name)
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Sub Add(ByVal dest As DTSDestination)

        MyBase.List.Add(dest)

    End Sub

#End Region

#Region " Private Methods "

    Private Function FindByName(ByVal name As String) As DTSDestination

        For Each dest As DTSDestination In MyBase.List
            If dest.TableName.ToUpper = name.ToUpper Then Return dest
        Next

        Return Nothing

    End Function

#End Region

End Class
