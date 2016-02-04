Public Class ListItem(Of T)
    Implements IComparable(Of ListItem(Of T))

    Private mLabel As String
    Private mValue As T

    Public ReadOnly Property Label() As String
        Get
            Return mLabel
        End Get
    End Property

    Public ReadOnly Property Value() As T
        Get
            Return mValue
        End Get
    End Property

    Public Sub New(ByVal lbl As String, ByVal val As T)
        Me.mLabel = lbl
        Me.mValue = val
    End Sub

    Public Function CompareTo(ByVal other As ListItem(Of T)) As Integer Implements System.IComparable(Of ListItem(Of T)).CompareTo
        Return Me.mLabel.CompareTo(other.mLabel)
    End Function

    Public Overrides Function ToString() As String
        Return Label
    End Function

End Class
