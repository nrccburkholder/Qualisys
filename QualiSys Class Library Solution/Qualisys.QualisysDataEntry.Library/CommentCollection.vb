''' -----------------------------------------------------------------------------
''' Project	 : QDEClasses
''' Class	 : QDEClasses.CommentCollection
''' 
''' -----------------------------------------------------------------------------
''' <summary>
''' Represents a collection of Comment objects in an enumerable collection.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	7/30/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class CommentCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Comment
        Get
            Return DirectCast(MyBase.List(index), Comment)
        End Get
    End Property

    Public Function Add(ByVal comment As Comment) As Integer
        Return MyBase.List.Add(comment)
    End Function

    Public Sub Remove(ByVal comment As Comment)
        MyBase.List.Remove(comment)
    End Sub

End Class
