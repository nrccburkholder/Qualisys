Option Explicit On
Option Strict On

Public MustInherit Class clsDBEntityJN
    Inherits clsDBEntity

    Private Const LAST_JN_COL_INDEX As Integer = 6

    Protected _dtJournaled As DataTable

    Public Overridable Sub RollBack(ByVal iID As Integer, ByVal dtDateStamp As DateTime)
        Dim dr As DataRow
        Dim sSQL As String

        'get data row to roll back to
        dr = GetRollBackDataRow(iID, dtDateStamp)

        If Not dr Is Nothing Then
            'build update sql for roll back
            CopyIntoTable(dr)
            'execute rollback
            CommitRollBack(_dtJournaled)

        End If

    End Sub

    Protected Overridable Function GetRollBackDataRow(ByVal iID As Integer, ByVal dtDateStamp As DateTime) As DataRow

        Me._drCriteria = Me.NewSearch

        Me.SetIdentityFilter(iID)
        Me._drCriteria.Item("jn_datetime") = dtDateStamp

        Me.Search(Me._drCriteria)

        If Me.MainDataTable.Rows.Count > 0 Then
            Return Me.MainDataTable.Rows(0)

        Else
            Return Nothing

        End If

    End Function

    'Setup data adapter to main table
    Protected Overrides Sub InitDataAdapter()
        'data adapter only has select command
        _da.SelectCommand = SelectCommand()

    End Sub

    Protected Overridable Sub CopyIntoTable(ByVal drRollBack As DataRow)
        Dim i As Integer
        Dim iColumns As Integer = drRollBack.ItemArray.Length - 1
        Dim drJournaled As DataRow = _dtJournaled.NewRow
        Dim sColName As String

        For i = LAST_JN_COL_INDEX To iColumns
            sColName = Me.MainDataTable.Columns(i).ColumnName
            If _dtJournaled.Columns.Contains(sColName) Then
                drJournaled.Item(sColName) = drRollBack.Item(i)

            End If
        Next

        _dtJournaled.Rows.Add(drJournaled)

    End Sub

    Protected MustOverride Sub CommitRollBack(ByVal dt As DataTable)

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        'cannot delete from journal table
        Return Nothing

    End Function

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        'cannot insert into journal table, except thru insert trigger
        Return Nothing

    End Function

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        'cannot update journal table
        Return Nothing

    End Function

    Protected Overrides Sub _FillLookups(Optional ByVal bRelatedRecordsOnly As Boolean = True)
        'Do Nothing, journal table datasets have no lookups

    End Sub

End Class
