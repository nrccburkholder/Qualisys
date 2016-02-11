Option Explicit On
Option Strict On

Public Class clsFIEDelimitedTab
    Inherits clsFIETextDelimited

    Public Sub New(Optional ByVal sFilename As String = "")
        MyBase.New(sFilename)
        Me._iFileType = FileTypes.TAB_DELIMITED_TEXT
        Me._sFileFormat = "TabDelimited"
        Me._sDelimiter = vbTab

    End Sub

End Class
