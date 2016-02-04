Option Strict On

Public Enum tblFileDefs
    FileDefID = 0
    FileDefName = 1
    FileDefDescription = 2
    ClientID = 3
    SurveyID = 4
    FileDefTypeID = 5
    FileTypeID = 6
    FileDefDelimiter = 7
    ClientName = 8
    SurveyName = 9
    FileDefTypeName = 10
    FileTypeName = 11

End Enum

<Obsolete("Use QMS.clsFileDefs", True)> _
Public Class clsFileDef
    Inherits clsDBEntity

    Protected _iClientID As Integer = 0
    Protected _iSurveyID As Integer = 0
    Protected _iFileDefTypeID As Integer = 0
    Protected _iFileTypeID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)
    End Sub

    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "FileDefs"

        ''INSERT SQL for Users table        
        Me._sInsertSQL = "INSERT INTO FileDefs (FileDefName, FileDefDescription, ClientID, SurveyID, FileDefTypeID, FileTypeID, FileDefDelimiter) "
        Me._sInsertSQL &= "VALUES({1},{2},{3},{4},{5},{6},{7})"

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE FileDefs SET FileDefName = {1}, FileDefDescription = {2}, ClientID = {3}, SurveyID = {4}, "
        Me._sUpdateSQL &= "FileDefTypeID = {5}, FileTypeID = {6}, FileDefDelimiter = {7} "
        Me._sUpdateSQL &= "WHERE FileDefID = {0}"

        'DELETE SQL for Users table
        'Me._sDeleteSQL = "DELETE FROM SurveyInstanceEvents WHERE FileDefID = {0}; "
        Me._sDeleteSQL &= "DELETE FROM FileDefs WHERE FileDefID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT fd.*, IsNULL(c.name,'NONE') as ClientName, IsNull(s.Name,'NONE') as SurveyName, FileDefTypeName, FileTypeName "
        Me._sSelectSQL &= "FROM FileDefs fd INNER JOIN "
        Me._sSelectSQL &= "FileDefTypes fdt ON fd.FileDefTypeID = fdt.FileDefTypeID INNER JOIN "
        Me._sSelectSQL &= "FileTypes ft ON fd.FileTypeID = ft.FileTypeID LEFT OUTER JOIN "
        Me._sSelectSQL &= "Surveys s ON fd.SurveyID = s.SurveyID LEFT OUTER JOIN "
        Me._sSelectSQL &= "Clients c ON fd.ClientID = c.ClientID "

    End Sub



    Protected Overrides Function GetInsertSQL() As String
        Dim sSQL As String

        sSQL = Me._sInsertSQL

        '--I had to explicitly form an array because 'Option Strict On' requires it
        '--djw 7/22/2002
        Dim a As String() = {CStr(Details(tblFileDefs.FileDefID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefName))), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefDescription))), _
                            CStr(Details(tblFileDefs.ClientID)), _
                            CStr(Details(tblFileDefs.SurveyID)), _
                            CStr(Details(tblFileDefs.FileDefTypeID)), _
                            CStr(Details(tblFileDefs.FileTypeID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefDelimiter)))}


        sSQL = String.Format(sSQL, a)


        Return sSQL

    End Function

    Protected Overrides Function GetUpdateSQL() As String
        Dim sSQL As String

        sSQL = Me._sUpdateSQL

        Dim a As String() = {CStr(Details(tblFileDefs.FileDefID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefName))), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefDescription))), _
                            CStr(Details(tblFileDefs.ClientID)), _
                            CStr(Details(tblFileDefs.SurveyID)), _
                            CStr(Details(tblFileDefs.FileDefTypeID)), _
                            CStr(Details(tblFileDefs.FileTypeID)), _
                            DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefDelimiter)))}

        sSQL = String.Format(sSQL, a)

        Return sSQL

    End Function

    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("FileDefID = {0} AND ", Me._iEntityID)
            bIdentity = True
        End If

        If Not bIdentity Then

            If Not IsDBNull(Me.Details(tblFileDefs.FileDefName)) Then
                sWHERESQL &= String.Format("FileDefName = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefs.FileDefName)))))
            End If

            If Not IsDBNull(Me.Details(tblFileDefs.FileDefDescription)) Then
                sWHERESQL &= String.Format("FileDefDescription = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(CStr(tblFileDefs.FileDefDescription)))))
            End If

            If Not IsDBNull(Me.Details(tblFileDefs.ClientID)) Then
                sWHERESQL &= String.Format("fd.ClientID = {0} AND ", Details(tblFileDefs.ClientID))
            End If

            If Not IsDBNull(Me.Details(tblFileDefs.SurveyID)) Then
                sWHERESQL &= String.Format("fd.SurveyID = {0} AND ", Details(tblFileDefs.SurveyID))
            End If

            If Not IsDBNull(Me.Details(tblFileDefs.FileDefTypeID)) Then
                sWHERESQL &= String.Format("fd.FileDefTypeID = {0} AND ", Details(tblFileDefs.FileDefTypeID))
            End If


            If Not IsDBNull(Me.Details(tblFileDefs.FileTypeID)) Then
                sWHERESQL &= String.Format("fd.FileTypeID = {0} AND ", Details(tblFileDefs.FileTypeID))
            End If

            If Not IsDBNull(Me.Details(tblFileDefs.FileDefDelimiter)) Then
                sWHERESQL &= String.Format("FileDefDelimiter = {0} AND ", DMI.DataHandler.QuoteString(CStr(Details(tblFileDefs.FileDefDelimiter))))
            End If


        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)
        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    Protected Overrides Function GetDeleteSQL() As String
        Dim sSQL As String

        sSQL = String.Format(Me._sDeleteSQL, Details(CStr(tblFileDefs.FileDefID)))

        Return sSQL

    End Function

    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)
        dr.Item("FileDefID") = 0
        dr.Item("FileDefName") = ""
        dr.Item("FileDefDescription") = ""
        dr.Item("ClientID") = Me._iClientID
        dr.Item("SurveyID") = Me._iSurveyID
        dr.Item("FileDefTypeID") = Me._iFileDefTypeID
        dr.Item("FileTypeID") = Me._iFileTypeID
        dr.Item("FileDefDelimiter") = ""

    End Sub

    Default Public Overloads Property Details(ByVal eField As tblFileDefs) As Object
        Get
            Return MyBase.Details(eField.ToString)
        End Get

        Set(ByVal Value As Object)
            Select Case eField
                Case tblFileDefs.FileDefID
                    Me._iEntityID = CInt(Value)
                Case tblFileDefs.ClientID
                    Me._iClientID = CInt(Value)
                Case tblFileDefs.SurveyID
                    Me._iSurveyID = CInt(Value)
                Case tblFileDefs.FileDefTypeID
                    Me._iFileDefTypeID = CInt(Value)
                Case tblFileDefs.FileTypeID
                    Me._iFileTypeID = CInt(Value)
            End Select

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Protected Overrides Function Create() As DataSet
        Dim ds As DataSet
        Dim sSQL As New StringBuilder()

        If Not IsDBNull(Details(tblFileDefs.ClientID)) And Not IsDBNull(Details(tblFileDefs.SurveyID)) And _
            Not IsDBNull(Me.Details(tblFileDefs.FileDefTypeID)) And Not IsDBNull(Me.Details(tblFileDefs.FileTypeID)) Then

            sSQL.Append("SELECT 0 AS FileDefID, '' AS FileDefName, '' AS FileDefDescription, ")
            sSQL.AppendFormat("{0} AS ClientID, ", Me.Details(tblFileDefs.ClientID))
            sSQL.AppendFormat("{0} AS SurveyID, ", Me.Details(tblFileDefs.SurveyID))
            sSQL.AppendFormat("{0} AS FileDefTypeID, ", Me.Details(tblFileDefs.FileDefTypeID))
            sSQL.AppendFormat("{0} AS FileTypeID, ", Me.Details(tblFileDefs.FileTypeID))
            sSQL.Append("'' AS FileDefDelimiter, ")
            sSQL.AppendFormat("ISNULL((SELECT Name FROM Clients WHERE ClientID = {0}),'NONE') AS ClientName, ", Me.Details(tblFileDefs.ClientID))
            sSQL.AppendFormat("ISNULL((SELECT Name FROM Surveys WHERE SurveyID = {0}),'NONE') AS SurveyName, ", Me.Details(tblFileDefs.SurveyID))
            sSQL.Append("FileDefTypeName, FileTypeName ")
            sSQL.Append("FROM FileDefTypes CROSS JOIN FileTypes WHERE ")
            sSQL.AppendFormat("FileDefTypeID = {0} AND ", Me.Details(tblFileDefs.FileDefTypeID))
            sSQL.AppendFormat("FileTypeID = {0}", Me.Details(tblFileDefs.FileTypeID))

            If Not Me._dsEntity Is Nothing Then
                Me._dsEntity = Nothing
            End If

            If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL.ToString, Me._sTableName) Then
                Me._iEntityID = -1

                Return Me._dsEntity

            End If

        End If

        Return MyBase.Create()

    End Function

    Public Function GetColumns() As DataTable
        Dim fdc As New clsFileDefColumn(ConnectionString)
        Dim dt As DataTable

        'Remove existing FileDefColumns table
        If Me._dsEntity.Tables.IndexOf("FileDefColumns") > -1 Then
            Me._dsEntity.Tables.Remove("FileDefColumns")

        End If

        'Get FileDefColumns
        fdc.Details(tblFileDefColumns.FileDefID) = Me._iEntityID
        dt = fdc.GetDetails().Tables("FileDefColumns").Copy
        'Add position column to datatable for fixed width file types
        dt.Columns.Add("Position")

        'Add datatable to dataset
        Me._dsEntity.Tables.Add(dt)
        ReCalcColumnPositions()

        'Remove existing ColumnNames table
        If Me._dsEntity.Tables.IndexOf("ColumnNames") > -1 Then
            Me._dsEntity.Tables.Remove("ColumnNames")

        End If

        'Get ColumnNames table and add to dataset
        dt = fdc.GetColumnNames.Copy
        Me._dsEntity.Tables.Add(dt)

        Return Me._dsEntity.Tables("FileDefColumns")

    End Function

    Public Sub ReCalcColumnPositions()
        Dim dr As DataRow
        Dim iCurrentPosition As Integer = 0

        If Me._dsEntity.Tables.IndexOf("FileDefColumns") > -1 Then
            For Each dr In Me._dsEntity.Tables("FileDefColumns").Rows
                dr("Position") = iCurrentPosition
                If Not IsDBNull(dr("Width")) Then iCurrentPosition += CInt(dr("Width"))

            Next

        End If

    End Sub

    Public Sub ReOrderColumns()
        Dim dv As DataView
        Dim drv As DataRowView
        Dim iRowIndex As Integer = 0
        Dim sb As New System.Text.StringBuilder("")

        If Me._dsEntity.Tables.IndexOf("FileDefColumns") > -1 Then
            'get data table view sorted in new order
            dv = Me._dsEntity.Tables("FileDefColumns").DefaultView
            dv.Sort = "DisplayOrder"

            For Each drv In dv

                iRowIndex += 1
                'Update datarow and database if DisplayOrder is different from Row Index
                If CInt(drv.Item("DisplayOrder")) <> iRowIndex Then
                    drv.Item("DisplayOrder") = iRowIndex
                    sb.AppendFormat("UPDATE FileDefColumns SET DisplayOrder = {1} WHERE FileDefColumnId = {0}; ", drv.Item("FileDefColumnId"), iRowIndex)

                End If

            Next

            'If updates were made, commit changes and update database
            If sb.Length > 0 Then
                Me._dsEntity.Tables("FileDefColumns").AcceptChanges()
                DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sb.ToString)

            End If

        End If

    End Sub

    Public Overrides Property DataSet() As DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables("FileDefs").Rows.Count > 0 Then
                With Me._dsEntity.Tables("FileDefs").Rows(0)
                    Me._iEntityID = CInt(.Item("FileDefID"))
                    If IsDBNull(.Item("ClientID")) Then
                        Me._iClientID = 0
                    Else
                        Me._iClientID = CInt(.Item("ClientID"))
                    End If
                    If IsDBNull(.Item("SurveyID")) Then
                        Me._iSurveyID = 0
                    Else
                        Me._iSurveyID = CInt(.Item("SurveyID"))
                    End If
                    Me._iFileDefTypeID = CInt(.Item("FileDefTypeID"))
                    Me._iFileTypeID = CInt(.Item("FileTypeID"))

                End With

            End If

        End Set

    End Property


End Class
