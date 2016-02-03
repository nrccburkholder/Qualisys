Option Explicit On
Option Strict On

Public Class clsFIEDelimited
    Inherits clsFIETextDelimited

    Public Sub New(Optional ByVal sFilename As String = "", Optional ByVal sDelimiter As String = "")
        MyBase.New(sFilename)
        Me._iFileType = FileTypes.OTHER_DELIMITED_TEXT
        Me._sFileFormat = String.Format("Delimited({0})", sDelimiter)
        Me._sDelimiter = sDelimiter

    End Sub

End Class