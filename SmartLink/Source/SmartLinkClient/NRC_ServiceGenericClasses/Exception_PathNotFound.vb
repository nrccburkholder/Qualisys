'This class adds a Path property to the exception class and can be used to
'track invalid directories or file paths..
Namespace Miscellaneous

    Public Class Exception_PathNotFound
        Inherits Exception

        Private _strPath As String

        Public Property Path() As String
            Get
                Return _strPath
            End Get
            Set(ByVal value As String)
                _strPath = value
            End Set
        End Property

        Public Sub New(ByVal Path As String)
            MyBase.New("An exception occurred when trying access this path: " & Path)
            Me._strPath = Path
        End Sub

        Public Sub New(ByVal Path As String, ByVal Inner As Exception)
            MyBase.New("An exception occurred when trying access this path: " & Path, Inner)
            Me._strPath = Path
        End Sub

    End Class

End Namespace
