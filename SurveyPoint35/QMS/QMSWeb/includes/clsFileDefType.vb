Option Strict On

Public Enum tblFileDefTypes
    FileDefTypeID = 0
    FileDefTypeName = 1
End Enum

<Obsolete("No longer used", True)> _
Public Class clsFileDefType
    Inherits clsDBEntity


    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)
    End Sub



    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "FileDefTypes"

        ''INSERT SQL for Users table        
        Me._sInsertSQL = "INSERT INTO FileDefTypes (FileDefTypeName) "
        Me._sInsertSQL &= "VALUES({1})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE FileDefTypes SET FileDefTypeName = {1} "
        Me._sUpdateSQL &= "WHERE FileDefTypeID = {0}"

        'DELETE SQL for Users table        
        Me._sDeleteSQL &= "DELETE FROM FileDefTypes WHERE FileDefTypeID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT * from fileDefTypes "

    End Sub



    Protected Overrides Function GetInsertSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sInsertSQL

        ''--I had to explicitly form an array because 'Option Strict On' requires it
        ''--djw 7/22/2002
        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefTypeName))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefDescription))), _
        '                    CStr(Details(tblFileDefTypes.ClientID)), _
        '                    CStr(Details(tblFileDefTypes.SurveyID)), _
        '                    CStr(Details(tblFileDefTypes.FileDefTypeID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefTypesQL))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefFormat))), _
        '                    CStr(Details(tblFileDefTypes.FileTypeID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefDelimiter)))}


        'sSQL = String.Format(sSQL, a)


        'Return sSQL

    End Function



    Protected Overrides Function GetUpdateSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sUpdateSQL

        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefTypes.FileDefTypeName)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefTypes.FileDefDescription)))), _
        '                    CStr(Details(CStr(tblFileDefTypes.ClientID))), _
        '                    CStr(Details(CStr(tblFileDefTypes.SurveyID))), _
        '                    CStr(Details(CStr(tblFileDefTypes.FileDefTypeID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefTypes.FileDefTypesQL)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefTypes.FileDefFormat)))), _
        '                    CStr(Details(CStr(tblFileDefTypes.FileTypeID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefTypes.FileDefDelimiter))))}

        'sSQL = String.Format(sSQL, a)

        'Return sSQL

    End Function


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("FileDefTypeID = {0} AND ", Me._iEntityID)
            bIdentity = True
        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblFileDefTypes.FileDefTypeName)) Then
                sWHERESQL &= String.Format("FileDefTypeName = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefTypes.FileDefTypeName))))
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

        'sSQL = String.Format(Me._sDeleteSQL, Details(CStr(tblFileDefTypes.FileDefTypeID)))

        'Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        'dr.Item("FileDefTypeID") = 0
        'dr.Item("FileDefTypeName") = ""
        'dr.Item("FileDefDescription") = ""
        'dr.Item("ClientID") = Me._iClientID
        'dr.Item("SurveyID") = Me._iSurveyID
        'dr.Item("FileDefTypeID") = Me._iFileDefTypeID
        'dr.Item("FileDefTypesQL") = ""
        'dr.Item("FileDefFormat") = ""
        'dr.Item("FileTypeID") = Me._iFileTypeID
        'dr.Item("FileDefDelimiter") = ""
    End Sub



    Default Public Overloads Property Details(ByVal eField As tblFileDefTypes) As Object
        Get
            Return MyBase.Details(eField.ToString)
        End Get

        Set(ByVal Value As Object)
            'Select Case eField
            '    Case tblFileDefTypes.FileDefTypeID
            '        Me._iFileDefTypeID = CInt(Value)
            '    Case tblFileDefTypes.FileDefTypeName
            '        Me._sFileDefTypeName = CStr(Value)
            '    Case tblFileDefTypes.FileDefDescription
            '        Me._sFileDefDescription = CStr(Value)
            '    Case tblFileDefTypes.ClientID
            '        Me._iClientID = CInt(Value)
            '    Case tblFileDefTypes.SurveyID
            '        Me._iSurveyID = CInt(Value)
            '    Case tblFileDefTypes.FileDefTypeID
            '        Me._iFileDefTypeID = CInt(Value)
            '    Case tblFileDefTypes.FileDefTypesQL
            '        Me._sFileDefTypesQL = CStr(Value)
            '    Case tblFileDefTypes.FileDefFormat
            '        Me._sFileDefFormat = CStr(Value)
            '    Case tblFileDefTypes.FileTypeID
            '        Me._iFileTypeID = CInt(Value)
            '    Case tblFileDefTypes.FileDefDelimiter
            '        Me._sFileDefDelimiter = CStr(Value)
            'End Select

            MyBase.Details(eField.ToString) = Value


        End Set

    End Property


End Class
