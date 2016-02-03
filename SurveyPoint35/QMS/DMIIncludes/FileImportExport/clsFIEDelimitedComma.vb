Option Explicit On
Option Strict On

Public Class clsFIEDelimitedComma
    Inherits clsFIETextDelimited

    Public Sub New(Optional ByVal sFilename As String = "")
        MyBase.New(sFilename)
        Me._iFileType = FileTypes.COMMA_DELIMITED_TEXT
        Me._sFileFormat = "CSVDelimited"
        Me._sDelimiter = ","

    End Sub

End Class
