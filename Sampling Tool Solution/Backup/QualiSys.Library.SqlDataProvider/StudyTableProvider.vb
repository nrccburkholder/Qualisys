Imports Nrc.Framework.Data

Public Class StudyTableProvider
    Inherits Nrc.QualiSys.Library.DataProvider.StudyTableProvider


    Private Function PopulateStudyTable(ByVal rdr As SafeDataReader) As StudyTable

        Dim newObj As New StudyTable

        ReadOnlyAccessor.StudyTableId(newObj) = rdr.GetInteger("Table_id")
        ReadOnlyAccessor.StudyTableIsView(newObj) = CType(rdr("IsView"), Boolean)

        newObj.Name = rdr.GetString("strTable_nm")
        newObj.Description = rdr.GetString("strTable_dsc")
        newObj.StudyId = rdr.GetInteger("Study_id")

        Return newObj

    End Function

    Public Overrides Function [Select](ByVal tableId As Integer) As StudyTable

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTable, tableId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateStudyTable(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectByStudyId(ByVal studyId As Integer) As Collection(Of StudyTable)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllStudyTables, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of StudyTable)(rdr, AddressOf PopulateStudyTable)
        End Using

    End Function

    Public Overrides Function SelectFromStudyTable(ByVal studyId As Integer, ByVal tableName As String, ByVal whereClause As String, ByVal rowsToReturn As Integer) As DataTable

        Dim sql As New SqlCommandBuilder

        sql.AddLine("SELECT TOP {0} *", rowsToReturn)
        sql.AddLine("FROM S{0}.{1} (NOLOCK)", studyId, tableName)
        sql.AddLine(whereClause)

        Dim cmd As DbCommand = Db.GetSqlStringCommand(sql.ToString)
        cmd.CommandTimeout = 120

        Dim ds As DataSet = ExecuteDataSet(cmd)
        If Not ds Is Nothing AndAlso ds.Tables.Count = 1 Then
            Return ds.Tables(0)
        Else
            Throw New Exception("Query did not return properly.")
        End If

    End Function


    Private Function PopulateStudyTableColumn(ByVal rdr As SafeDataReader) As StudyTableColumn

        Dim newObj As New StudyTableColumn

        ReadOnlyAccessor.StudyTableColumnId(newObj) = rdr.GetInteger("Field_id")

        newObj.Name = rdr.GetString("strField_nm")
        newObj.Description = rdr.GetString("strField_Dsc")
        Select Case rdr.GetString("strFieldDataType").ToUpper
            Case "S"
                newObj.DataType = StudyTableColumnDataTypes.String
            Case "I"
                newObj.DataType = StudyTableColumnDataTypes.Integer
            Case "D"
                newObj.DataType = StudyTableColumnDataTypes.DateTime
        End Select
        newObj.IsKey = CType(rdr("bitKeyField_Flg"), Boolean)
        newObj.Length = rdr.GetInteger("intFieldLength")
        newObj.IsUserField = rdr.GetBoolean("bitUserField_Flg")
        newObj.TableId = rdr.GetInteger("Table_id")
        newObj.IsMatchField = rdr.GetBoolean("bitMatchField_Flg")
        newObj.IsPosted = rdr.GetBoolean("bitPostedField_Flg")

        Return newObj

    End Function

    Public Overrides Function SelectStudyTableColumns(ByVal studyId As Integer, ByVal tableId As Integer) As Collection(Of StudyTableColumn)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTableColumns, studyId, tableId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of StudyTableColumn)(rdr, AddressOf PopulateStudyTableColumn)
        End Using

    End Function

    Public Overrides Function SelectStudyTableColumn(ByVal tableId As Integer, ByVal fieldId As Integer) As StudyTableColumn

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudyTableColumn, tableId, fieldId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateStudyTableColumn(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectHouseHoldingFieldsBySurveyId(ByVal surveyId As Integer) As StudyTableColumnCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectHouseHoldingFieldsBySurveyId, surveyId)
        Dim columns As New StudyTableColumnCollection

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                columns.Add(PopulateStudyTableColumn(rdr))
            End While
        End Using

        Return columns

    End Function

End Class
