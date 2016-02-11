Option Strict On

Public Enum tblFileTypes
    FileTypeID = 0
    FileTypeName = 1
End Enum

<Obsolete("No longer used", True)> _
Public Class clsFileTypes
    Inherits clsDBEntity
    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)
    End Sub



    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "FileTypes"

        ''INSERT SQL for Users table        
        Me._sInsertSQL = "INSERT INTO FileTypes (FileTypeName) "
        Me._sInsertSQL &= "VALUES({1})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE FileTypes SET FileTypeName = {1} "
        Me._sUpdateSQL &= "WHERE FileTypeID = {0}"

        'DELETE SQL for Users table        
        Me._sDeleteSQL &= "DELETE FROM FileTypes WHERE FileTypeID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT * from FileTypes "

    End Sub



    Protected Overrides Function GetInsertSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sInsertSQL

        ''--I had to explicitly form an array because 'Option Strict On' requires it
        ''--djw 7/22/2002
        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileTypeName))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileDefDescription))), _
        '                    CStr(Details(tblFileTypes.ClientID)), _
        '                    CStr(Details(tblFileTypes.SurveyID)), _
        '                    CStr(Details(tblFileTypes.FileTypeID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileTypesQL))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileDefFormat))), _
        '                    CStr(Details(tblFileTypes.FileTypeID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileDefDelimiter)))}


        'sSQL = String.Format(sSQL, a)


        'Return sSQL

    End Function



    Protected Overrides Function GetUpdateSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sUpdateSQL

        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileTypes.FileTypeName)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileTypes.FileDefDescription)))), _
        '                    CStr(Details(CStr(tblFileTypes.ClientID))), _
        '                    CStr(Details(CStr(tblFileTypes.SurveyID))), _
        '                    CStr(Details(CStr(tblFileTypes.FileTypeID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileTypes.FileTypesQL)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileTypes.FileDefFormat)))), _
        '                    CStr(Details(CStr(tblFileTypes.FileTypeID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileTypes.FileDefDelimiter))))}

        'sSQL = String.Format(sSQL, a)

        'Return sSQL

    End Function


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("FileTypeID = {0} AND ", Me._iEntityID)
            bIdentity = True
        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblFileTypes.FileTypeName)) Then
                sWHERESQL &= String.Format("FileTypeName = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileTypes.FileTypeName))))
            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)
        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function



    Protected Overrides Function GetDeleteSQL() As String
        'Dim sSQL As String

        'sSQL = String.Format(Me._sDeleteSQL, Details(CStr(tblFileTypes.FileTypeID)))

        'Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        'dr.Item("FileTypeID") = 0
        'dr.Item("FileTypeName") = ""
        'dr.Item("FileDefDescription") = ""
        'dr.Item("ClientID") = Me._iClientID
        'dr.Item("SurveyID") = Me._iSurveyID
        'dr.Item("FileTypeID") = Me._iFileTypeID
        'dr.Item("FileTypesQL") = ""
        'dr.Item("FileDefFormat") = ""
        'dr.Item("FileTypeID") = Me._iFileTypeID
        'dr.Item("FileDefDelimiter") = ""
    End Sub



    Default Public Overloads Property Details(ByVal eField As tblFileTypes) As Object
        Get
            Return MyBase.Details(eField.ToString)
        End Get

        Set(ByVal Value As Object)
            'Select Case eField
            '    Case tblFileTypes.FileTypeID
            '        Me._iFileTypeID = CInt(Value)
            '    Case tblFileTypes.FileTypeName
            '        Me._sFileTypeName = CStr(Value)
            '    Case tblFileTypes.FileDefDescription
            '        Me._sFileDefDescription = CStr(Value)
            '    Case tblFileTypes.ClientID
            '        Me._iClientID = CInt(Value)
            '    Case tblFileTypes.SurveyID
            '        Me._iSurveyID = CInt(Value)
            '    Case tblFileTypes.FileTypeID
            '        Me._iFileTypeID = CInt(Value)
            '    Case tblFileTypes.FileTypesQL
            '        Me._sFileTypesQL = CStr(Value)
            '    Case tblFileTypes.FileDefFormat
            '        Me._sFileDefFormat = CStr(Value)
            '    Case tblFileTypes.FileTypeID
            '        Me._iFileTypeID = CInt(Value)
            '    Case tblFileTypes.FileDefDelimiter
            '        Me._sFileDefDelimiter = CStr(Value)
            'End Select

            MyBase.Details(eField.ToString) = Value


        End Set

    End Property


End Class
