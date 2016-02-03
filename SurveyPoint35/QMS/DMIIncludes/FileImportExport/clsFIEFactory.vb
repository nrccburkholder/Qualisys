Public Class clsFIEFactory

    Public Shared Function Make(ByVal eFileType As FileTypes, ByVal sFilename As String, Optional ByVal sOptions As String = "") As clsFileImportExport

        Select Case eFileType
            Case FileTypes.FIXED_WIDTH_TEXT
                Return New clsFIEFixedWidth(sFilename)

            Case FileTypes.COMMA_DELIMITED_TEXT
                Return New clsFIEDelimitedComma(sFilename)

            Case FileTypes.TAB_DELIMITED_TEXT
                Return New clsFIEDelimitedTab(sFilename)

            Case FileTypes.OTHER_DELIMITED_TEXT
                Return New clsFIEDelimited(sFilename, sOptions)

            Case Else
                Return Nothing

        End Select

    End Function

End Class
