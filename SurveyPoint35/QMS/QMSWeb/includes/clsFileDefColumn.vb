Option Strict On

Public Enum tblFileDefColumns
    FileDefColumnID = 0
    FileDefID = 1
    ColumnName = 2
    DisplayOrder = 3
    Width = 4

End Enum

<Obsolete("Use QMS.clsFileDefColumns", True)> _
Public Class clsFileDefColumn
    Inherits clsDBEntity

    Private _iFileDefID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)
    End Sub

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "FileDefColumns"

        ''INSERT SQL for Users table        
        Me._sInsertSQL = "INSERT INTO FileDefColumns (FileDefID, ColumnName, Width, DisplayOrder) "
        Me._sInsertSQL &= "SELECT {1}, {2}, {4}, COUNT(FileDefID) + 1 FROM FileDefColumns WHERE FileDefID = {1}"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE FileDefColumns SET FileDefID = {1}, ColumnName = {2}, Width = {4} "
        Me._sUpdateSQL &= "WHERE FileDefColumnID = {0}"

        'DELETE SQL for Users table        
        Me._sDeleteSQL &= "DELETE FROM FileDefColumns WHERE FileDefColumnID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT * from FileDefColumns "

    End Sub

    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        '--I had to explicitly form an array because 'Option Strict On' requires it
        '--djw 7/22/2002
        Dim a As String() = {CStr(Details(tblFileDefColumns.FileDefColumnID)), _
                            CStr(Details(tblFileDefColumns.FileDefID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefColumns.ColumnName))), _
                            CStr(Details(tblFileDefColumns.DisplayOrder)), _
                            CStr(Details(tblFileDefColumns.Width))}

        sSQL = String.Format(sSQL, a)


        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        Dim a As String() = {CStr(Details(tblFileDefColumns.FileDefColumnID)), _
                            CStr(Details(tblFileDefColumns.FileDefID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefColumns.ColumnName))), _
                            CStr(Details(tblFileDefColumns.DisplayOrder)), _
                            CStr(Details(tblFileDefColumns.Width))}
        sSQL = String.Format(sSQL, a)

        Return sSQL

    End Function

    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("FileDefColumnID = {0} AND ", Me._iEntityID)
            bIdentity = True
        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblFileDefColumns.FileDefID)) Then
                sWHERESQL &= String.Format("FileDefID = {0} AND ", Details(tblFileDefColumns.FileDefID))
            End If

            If Not IsDBNull(Me.Details(tblFileDefColumns.ColumnName)) Then
                sWHERESQL &= String.Format("ColumnName = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefColumns.ColumnName))))
            End If

            If Not IsDBNull(Me.Details(tblFileDefColumns.DisplayOrder)) Then
                sWHERESQL &= String.Format("DisplayOrder = {0} AND ", Details(tblFileDefColumns.DisplayOrder))
            End If

            If Not IsDBNull(Me.Details(tblFileDefColumns.Width)) Then
                sWHERESQL &= String.Format("Width = {0} AND ", Details(tblFileDefColumns.Width))
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

        'sSQL = String.Format(Me._sDeleteSQL, Details(CStr(tblFileDefColumns.FileDefColumnID)))

        'Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        'dr.Item("FileDefColumnID") = 0
        'dr.Item("FileDefID") = ""
        'dr.Item("FileDefDescription") = ""
        'dr.Item("ClientID") = Me._iClientID
        'dr.Item("SurveyID") = Me._iSurveyID
        'dr.Item("FileDefColumnID") = Me._iFileDefColumnID
        'dr.Item("FileDefColumnsQL") = ""
        'dr.Item("FileDefFormat") = ""
        'dr.Item("FileDefColumnID") = Me._iFileDefColumnID
        'dr.Item("FileDefDelimiter") = ""
    End Sub

    Default Public Overloads Property Details(ByVal eField As tblFileDefColumns) As Object
        Get
            Return MyBase.Details(eField.ToString)
        End Get

        Set(ByVal Value As Object)
            Select Case eField
                Case tblFileDefColumns.FileDefColumnID
                    Me._iEntityID = CInt(Value)

                Case tblFileDefColumns.FileDefID
                    Me._iFileDefID = CInt(Value)

            End Select

            MyBase.Details(eField.ToString) = Value


        End Set

    End Property

    Public Function GetColumnNames() As DataTable
        Dim sSQL As String

        'Check if ColumnNames table already exists
        If Me._dsEntity.Tables.IndexOf("ColumnNames") > -1 Then
            Me._dsEntity.Tables.Remove("ColumnNames")

        End If

        sSQL = "spFileDefColumns " & Me._iFileDefID
        DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "ColumnNames")

        Return Me._dsEntity.Tables("ColumnNames")

    End Function

End Class
