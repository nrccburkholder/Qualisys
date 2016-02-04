Option Strict On

Public Enum tblFileDefFilters
    FileDefFilterID = 0
    FilterName = 1
    FilterWhere = 2
    ParamName0 = 3
    ParamName1 = 4
    ParamName2 = 5
    DisplayOrder = 6
End Enum

<Obsolete("use QMS.clsFileDefFilters", True)> _
Public Class clsFileDefFilter
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)
    End Sub



    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "FileDefFilters"

        ''INSERT SQL for Users table        
        'Me._sInsertSQL = "INSERT INTO FileDefFilters (FilterName) "
        'Me._sInsertSQL &= "VALUES({1})"

        'UPDATE SQL for Users table
        'Me._sUpdateSQL = "UPDATE FileDefFilters SET FilterName = {1} "
        'Me._sUpdateSQL &= "WHERE FileDefFilterID = {0}"

        'DELETE SQL for Users table        
        'Me._sDeleteSQL &= "DELETE FROM FileDefFilters WHERE FileDefFilterID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT * from FileDefFilters "

    End Sub



    Protected Overrides Function GetInsertSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sInsertSQL

        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FilterName))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FileDefDescription))), _
        '                    CStr(Details(tblFileDefFilters.ClientID)), _
        '                    CStr(Details(tblFileDefFilters.SurveyID)), _
        '                    CStr(Details(tblFileDefFilters.FileDefFilterID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FileDefFiltersQL))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FileDefFormat))), _
        '                    CStr(Details(tblFileDefFilters.FileDefFilterID)), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FileDefDelimiter)))}


        'sSQL = String.Format(sSQL, a)


        'Return sSQL

    End Function



    Protected Overrides Function GetUpdateSQL() As String
        'Dim sSQL As String

        'sSQL = Me._sUpdateSQL

        'Dim a As String() = {DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefFilters.FilterName)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefFilters.FileDefDescription)))), _
        '                    CStr(Details(CStr(tblFileDefFilters.ClientID))), _
        '                    CStr(Details(CStr(tblFileDefFilters.SurveyID))), _
        '                    CStr(Details(CStr(tblFileDefFilters.FileDefFilterID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefFilters.FileDefFiltersQL)))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefFilters.FileDefFormat)))), _
        '                    CStr(Details(CStr(tblFileDefFilters.FileDefFilterID))), _
        '                    DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefFilters.FileDefDelimiter))))}

        'sSQL = String.Format(sSQL, a)

        'Return sSQL

    End Function


    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("FileDefFilterID = {0} AND ", Me._iEntityID)
            bIdentity = True
        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblFileDefFilters.FilterName)) Then
                sWHERESQL &= String.Format("FilterName = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FilterName))))
            End If

            If Not IsDBNull(Me.Details(tblFileDefFilters.FilterWhere)) Then
                sWHERESQL &= String.Format("FilterWhere = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FilterWhere))))
            End If

            'needs work
            'If Not IsDBNull(Me.Details(tblFileDefFilters.ParamName0)) Then
            '    sWHERESQL &= String.Format("ParamName0 = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.FilterName))))
            'End If

            If Not IsDBNull(Me.Details(tblFileDefFilters.DisplayOrder)) Then
                sWHERESQL &= String.Format("DisplayOrder = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefFilters.DisplayOrder))))
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

        'sSQL = String.Format(Me._sDeleteSQL, Details(CStr(tblFileDefFilters.FileDefFilterID)))

        'Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        'dr.Item("FileDefFilterID") = 0
        'dr.Item("FilterName") = ""
        'dr.Item("FileDefDescription") = ""
        'dr.Item("ClientID") = Me._iClientID
        'dr.Item("SurveyID") = Me._iSurveyID
        'dr.Item("FileDefFilterID") = Me._iFileDefFilterID
        'dr.Item("FileDefFiltersQL") = ""
        'dr.Item("FileDefFormat") = ""
        'dr.Item("FileDefFilterID") = Me._iFileDefFilterID
        'dr.Item("FileDefDelimiter") = ""
    End Sub



    Default Public Overloads Property Details(ByVal eField As tblFileDefFilters) As Object
        Get
            Return MyBase.Details(eField.ToString)
        End Get

        Set(ByVal Value As Object)
            Select Case eField
                Case tblFileDefFilters.FileDefFilterID
                    Me._iEntityID = CInt(Value)
            End Select

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property


End Class
