Option Explicit On

Namespace Miscellaneous.TableWriters
    ''' <summary>
    ''' Table driven table writter
    ''' </summary>
    ''' <remarks>Table driven table writter</remarks>
    Public NotInheritable Class TW_TableWriter_MSSQLGeneric
        Inherits TableWriter_UJK

        'The fields listed in this collection are special cases when creating the Main SQL statements
        Private _colIgnoreFields As New Collection


        Public Sub New(ByVal TableName As String, Optional ByVal WriteNulls As Boolean = True)
            MyBase.New(TableName, "")
            Me.WriteNulls = WriteNulls
            Me.DBFactory = Data.SqlClient.SqlClientFactory.Instance

            'The following fields are special cases for the UPDATE Statement
            Dim colIgnoreList As New Collection
            _colIgnoreFields.Add(colIgnoreList, "UPDATE")

            colIgnoreList.Add("", "CREATEDATE")
            colIgnoreList.Add("", "MODDATE")
            colIgnoreList.Add("", TableName.ToUpper & "_UJK")
            colIgnoreList.Add("", "SOURCEAGENCYNAME")
            colIgnoreList.Add("", TableName.ToUpper & "_SOURCEID")
            colIgnoreList.Add("", "FILLMISSINGUJKRETRYCOUNT")

            'The following fields are special cases for the INSERT Statement
            colIgnoreList = New Collection
            _colIgnoreFields.Add(colIgnoreList, "INSERT")

            colIgnoreList.Add("", "CREATEDATE")
            colIgnoreList.Add("", "MODDATE")
            colIgnoreList.Add("", TableName.ToUpper & "_UJK")
            colIgnoreList.Add("", "FILLMISSINGUJKRETRYCOUNT")
        End Sub

        Public Function GetSqlType(ByVal sType As String) As System.Type
            Dim tResult As System.Type = Nothing
            Dim sqlType As String = sType.ToUpper.Trim

            If "BINARY, IMAGE, TIMESTAMP, VARBINARY".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlBinary", False, False)
            ElseIf "BIT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlBoolean", False, False)
            ElseIf "TINYINT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlByte", False, False)
            ElseIf "DATETIME, SMALLDATETIME".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlDateTime", False, False)
            ElseIf "DECIMAL".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlDecimal", False, False)
            ElseIf "FLOAT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlDouble", False, False)
            ElseIf "UNIQUEIDENTIFIER".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlGuid", False, False)
            ElseIf "SMALLINT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlInt16", False, False)
            ElseIf "INT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlInt32", False, False)
            ElseIf "BIGINT".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlInt64", False, False)
            ElseIf "MONEY, SMALLMONEY".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlMoney", False, False)
            ElseIf "REAL".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlSingle", False, False)
            ElseIf "CHAR, NCHAR, TEXT, NTEXT, NVARCHAR, VARCHAR".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlString", False, False)
            ElseIf "XML".Contains(sqlType) Then
                tResult = Type.GetType("System.Data.SqlTypes.SqlXml", False, False)
            End If

            Return tResult
        End Function


        Public Overrides Sub CreateElementsCollection()
            Dim TempItem As TableItem
            Dim dReader As Data.Common.DbDataReader = Nothing
            Dim dCmd As Data.Common.DbCommand = Nothing
            Dim Conn As Data.Common.DbConnection = Nothing
            Dim tNewType As System.Type = Nothing
            Dim sQueryResult As String = ""

            Try
                Conn = Me.DBFactory.CreateConnection
                Conn.ConnectionString = Me.DBConnectionString
                Conn.Open()

                dCmd = Conn.CreateCommand

                dCmd.CommandText = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '" & Me.TableName & "'"

                sQueryResult = CType(DBCommandExecuteScalar(dCmd), String)

                If sQueryResult Is Nothing OrElse Not sQueryResult = Me.TableName Then
                    Throw New System.Exception("The table " & Me.TableName & "does not exist in the database")
                End If

            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position") = "Testing for table Existence"
                Throw
            Finally
                If dReader IsNot Nothing Then
                    dReader.Close()
                End If
            End Try

            Try
                If Conn.State <> ConnectionState.Open Then
                    Conn.Open()
                End If
                If dCmd Is Nothing Then
                    dCmd = Conn.CreateCommand
                End If

                dCmd.CommandText = "SELECT *" & vbCrLf _
                    & "FROM INFORMATION_SCHEMA.COLUMNS" & vbCrLf _
                    & "WHERE TABLE_NAME = '" & Me.TableName & "'" & vbCrLf _
                    & "ORDER BY ORDINAL_POSITION"

                dReader = DBCommandExecuteReader(dCmd)

                Do While dReader.Read()
                    'tNewType = GetSqlType(CStr(dReader("DATA_TYPE")))

                    If dReader("CHARACTER_MAXIMUM_LENGTH").ToString <> String.Empty Then
                        TempItem = New TableItem(dReader("COLUMN_NAME").ToString, CStr(dReader("DATA_TYPE")), CType(dReader("CHARACTER_MAXIMUM_LENGTH").ToString, Integer))
                    Else
                        TempItem = New TableItem(dReader("COLUMN_NAME").ToString, CStr(dReader("DATA_TYPE"))) 'dReader("DATA_TYPE").ToString
                    End If

                    Me.AddItem(TempItem)
                Loop
            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position") = "Creating field collection"
                Throw
            Finally
                If dReader IsNot Nothing Then
                    dReader.Close()
                End If
            End Try

            Try
                Dim sKeyName As String = String.Empty
                Dim sFieldList(0) As String

                If Conn.State <> ConnectionState.Open Then
                    Conn.Open()
                End If
                If dCmd Is Nothing Then
                    dCmd = Conn.CreateCommand
                End If

                dCmd.CommandText = "SELECT   tc.TABLE_NAME" & vbCrLf _
                    & "       , tc.CONSTRAINT_NAME" & vbCrLf _
                    & "       , tc.CONSTRAINT_TYPE" & vbCrLf _
                    & "       , cu.COLUMN_NAME" & vbCrLf _
                    & "FROM     INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc" & vbCrLf _
                    & "INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE cu" & vbCrLf _
                    & "         ON tc.CONSTRAINT_NAME = cu.CONSTRAINT_NAME" & vbCrLf _
                    & "WHERE    CONSTRAINT_TYPE = 'PRIMARY KEY'" & vbCrLf _
                    & "	AND tc.TABLE_NAME = '" & Me.TableName & "'" & vbCrLf _
                    & "ORDER BY tc.CONSTRAINT_NAME" & vbCrLf _
                    & "       , cu.ORDINAL_POSITION" & vbCrLf

                dReader = DBCommandExecuteReader(dCmd)

                Array.Resize(sFieldList, 0)

                Do While dReader.Read()
                    'Grab first key name
                    If sKeyName = "" Then
                        sKeyName = dReader("CONSTRAINT_NAME").ToString
                        If dReader("CONSTRAINT_TYPE").ToString.ToUpper = "PRIMARY KEY" _
                            AndAlso Not sKeyName.ToUpper.StartsWith("PK_") Then
                            sKeyName = "PK_" & sKeyName
                        End If
                    End If

                    Array.Resize(sFieldList, sFieldList.Length + 1)
                    sFieldList(sFieldList.Length - 1) = dReader("COLUMN_NAME").ToString
                Loop

                If sFieldList.Length > 0 Then
                    Me.AddUniqueIdentifier(sKeyName, sFieldList)
                End If
            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position") = "Adding PK field name to unique identifiers collection"
                Throw
            Finally
                If dReader IsNot Nothing Then
                    dReader.Close()
                End If
            End Try

            Try
                If Conn.State <> ConnectionState.Open Then
                    Conn.Open()
                End If
                If dCmd Is Nothing Then
                    dCmd = Conn.CreateCommand
                End If

                dCmd.CommandText = "IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tblDBKeyGroup')" & vbCrLf _
                    & vbCrLf & "SELECT *" & vbCrLf _
                    & vbCrLf & "FROM tblDBKeyGroup" & vbCrLf _
                    & vbCrLf & "WHERE TABLENAME = '" & Me.TableName & "'" & vbCrLf _
                    & vbCrLf & "ORDER BY KeyGroupOrder"

                dReader = DBCommandExecuteReader(dCmd)

                Do While dReader.Read()
                    Me.AddUniqueIdentifier(dReader("KeyName").ToString, dReader("KeyFieldNames").ToString.Split(","c))
                Loop
            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreateElementsCollection::Position") = "Adding user defined key groups to the collection"
                Throw
            Finally
                If dReader IsNot Nothing Then
                    dReader.Close()
                End If
                If dCmd IsNot Nothing Then
                    dCmd.Dispose()
                End If
                If Conn.State = ConnectionState.Open Then
                    Conn.Close()
                End If
            End Try

        End Sub

        Protected Overrides Sub AddExtraTranslations()

        End Sub


        Protected Overrides Function RetrievePK(ByVal UIDEntry As KeyValuePair(Of String, String())) As String
            Dim sWhereClause As String = ""
            Dim sSQL As String
            Dim dbCMD As Common.DbCommand
            Dim sResult As String

            If _colDBCommands.Contains(UIDEntry.Key) Then
                dbCMD = CType(_colDBCommands.Item(UIDEntry.Key), Common.DbCommand)
            Else
                If UIDEntry.Value.Length = 0 Then
                    Return String.Empty
                End If

                dbCMD = _DBConn.CreateCommand()

                For Each sField As String In UIDEntry.Value
                    sField = sField.Trim()
                    sWhereClause += "AND " & sField & " = @" & sField & vbCrLf
                    dbCMD.Parameters.Add(New SqlClient.SqlParameter("@" & sField, _
                        CType(System.Enum.Parse(GetType(SqlDbType), _
                            Me.Item(sField).FormatType, True),  _
                            SqlDbType), _
                        Me.Item(sField).Lenght))
                Next

                sSQL = "SELECT TOP 1 " & Me.PKFieldName & vbCrLf _
                    & vbCrLf & "FROM " & Me.TableName & vbCrLf _
                    & vbCrLf & "WHERE " & sWhereClause.Substring(4)

                dbCMD.CommandText = sSQL
                dbCMD.Prepare()

                _colDBCommands.Add(dbCMD, UIDEntry.Key)
            End If


            For Each sField As String In UIDEntry.Value
                sField = sField.Trim()

                If Not Me.Item(sField).IsNull Then
                    dbCMD.Parameters("@" & sField).Value = Me.Item(sField).DBValue
                Else
                    Return String.Empty
                End If
            Next

            sResult = CType(Me.SQLRunner.ExecuteScalar(dbCMD), String)
            If sResult Is Nothing Then
                Return String.Empty
            Else
                Return sResult
            End If
        End Function

        '****************************************************************************************
        '   This method creates the sql from the collection passed in from the Write     *
        '   method.                                                                             *
        '   Output: The update sql statement as a string.                                       *
        '****************************************************************************************

        Protected Overrides Sub CreateMainSQL()
            Dim colIgnoreFields As Collection
            Dim strSQL As String
            Dim dbCMD As Common.DbCommand

            strSQL = "UPDATE " & Me.TableName & " WITH (ROWLOCK) " & vbCrLf _
                & "SET" & vbCrLf

            If _colDBCommands.Contains("UPDATE") Then
                dbCMD = CType(_colDBCommands.Item("UPDATE"), Common.DbCommand)
                dbCMD.Parameters.Clear()
            Else
                dbCMD = _DBConn.CreateCommand()
                _colDBCommands.Add(dbCMD, "UPDATE")
            End If

            Try
                Dim bFirst As Boolean = True

                dbCMD.Parameters.Add(New SqlClient.SqlParameter("@" & Me.PKFieldName, CType(System.Enum.Parse(GetType(SqlDbType), Me.Item(Me.PKFieldName).FormatType, True), SqlDbType), Me.Item(Me.PKFieldName).Lenght))

                colIgnoreFields = CType(_colIgnoreFields.Item("UPDATE"), Collection)

                For Each field As TableItem In _colElements
                    If (Not field.IsNull Or Me.WriteNulls) _
                        AndAlso Not colIgnoreFields.Contains(field.ColumnName.ToUpper) _
                        AndAlso Not dbCMD.Parameters.Contains("@" & field.ColumnName) Then
                        If bFirst Then
                            strSQL += "   " & field.ColumnName & " = @" & field.ColumnName & vbCrLf
                            bFirst = False
                        Else
                            strSQL += "   , " & field.ColumnName & " = @" & field.ColumnName & vbCrLf
                        End If
                        dbCMD.Parameters.Add(New SqlClient.SqlParameter("@" & field.ColumnName, CType(System.Enum.Parse(GetType(SqlDbType), field.FormatType, True), SqlDbType), field.Lenght))
                    End If
                Next
            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreatemainSQL::Position") = "Error occurred when creating the UPDATE statement."
                Throw 'New System.Exception("Error Occurred [" & ex.Message & "] when creating the UPDATE statement.", ex)
            End Try

            If Me.Contains("FillMissingUJKRetryCount") Then
                'There is no need to add parameter for @MissingUJKCount at this point
                'because it already exists
                strSQL += "   , FillMissingUJKRetryCount = CASE WHEN @MissingUJKCount <> 0 THEN FillMissingUJKRetryCount + 1 ELSE FillMissingUJKRetryCount END" & vbCrLf
            End If

            If Me.Contains("ModDate") Then
                strSQL += "   , ModDate = getdate()" & vbCrLf
            End If

            strSQL += " WHERE " & Me.PKFieldName & " = @" & Me.PKFieldName & vbCrLf

            If Me.Contains("SourceModDate") Then
                'There is no need to add parameter for @SourceModDate at this point
                'because it already exists
                strSQL += "     AND (SourceModDate >= @SourceModDate OR SourceModDate IS NULL)"
            End If

            dbCMD.CommandText = strSQL
            dbCMD.Prepare()

            Dim sColumns As String
            Dim sValues As String

            If _colDBCommands.Contains("INSERT") Then
                dbCMD = CType(_colDBCommands.Item("INSERT"), Common.DbCommand)
                dbCMD.Parameters.Clear()
            Else
                dbCMD = _DBConn.CreateCommand()
                _colDBCommands.Add(dbCMD, "INSERT")
            End If

            Try
                'these variables hold the sql for colums and values part of the insert statement
                sColumns = "   " & Me.PKFieldName & vbCrLf
                sValues = "   @" & Me.PKFieldName & vbCrLf
                dbCMD.Parameters.Add(New SqlClient.SqlParameter("@" & Me.PKFieldName, CType(System.Enum.Parse(GetType(SqlDbType), Me.Item(Me.PKFieldName).FormatType, True), SqlDbType), Me.Item(Me.PKFieldName).Lenght))

                If Me.Contains("CreateDate") Then
                    sColumns += "   , CreateDate" & vbCrLf
                    sValues += "   , getdate()" & vbCrLf
                End If

                If Me.Contains("ModDate") Then
                    sColumns += "   , ModDate" & vbCrLf
                    sValues += "   , getdate()" & vbCrLf
                End If


                colIgnoreFields = CType(_colIgnoreFields.Item("INSERT"), Collection)

                'fill in columns with the column names and values from the collection
                For Each field As TableItem In _colElements
                    If (Not field.IsNull Or Me.WriteNulls) _
                        AndAlso Not colIgnoreFields.Contains(field.ColumnName.ToUpper) _
                        AndAlso Not dbCMD.Parameters.Contains("@" & field.ColumnName) Then
                        sColumns += "   , " & field.ColumnName & vbCrLf
                        sValues += "   , @" & field.ColumnName & vbCrLf
                        dbCMD.Parameters.Add(New SqlClient.SqlParameter("@" & field.ColumnName, CType(System.Enum.Parse(GetType(SqlDbType), field.FormatType, True), SqlDbType), field.Lenght))
                    End If
                Next

                strSQL = "INSERT INTO " & Me.TableName & vbCrLf _
                    & "(" & sColumns & ")" & vbCrLf _
                    & "VALUES " & "(" & sValues & ")"


                dbCMD.CommandText = strSQL
                dbCMD.Prepare()
            Catch ex As Exception
                ex.Data("TW_TableWriter_MSSQLGeneric::CreatemainSQL::Position") = "Error occurred when creating the INSERT statement."
                Throw 'New System.Exception("Error Occurred [" & ex.Message & "] when creating the INSERT statement.", ex)
            End Try

        End Sub

        ''' <summary>
        ''' Retrieves the UJK from a separated table and assings the key to the specified field in the current table
        ''' </summary>
        ''' <param name="SourceID">Key value of the record in the table in the source database</param>
        ''' <param name="TableName">Name of the table where the UJK will be retrieved</param>
        Public Overrides Function PopulateForeignUJK(ByVal SourceID As String, ByVal TableName As String) As Boolean

            Dim strSQL As String
            Dim dbCMD As Data.Common.DbCommand = Nothing
            'Dim sAgencyName As String = Me.SourceAgencyName
            Dim objScalar As Object
            Dim sCMDName As String

            'open the connection if it is closed
            Me.OpenConnection()

            Try
                If Not Me.Contains(TableName & "_UJK") Then
                    Return True
                End If

                sCMDName = TableName.ToUpper & "_FIND_PK"

                If _colDBCommands.Contains(sCMDName) Then
                    dbCMD = CType(_colDBCommands.Item(sCMDName), Common.DbCommand)
                Else
                    strSQL = "SELECT " & TableName & "_UJK" & vbCrLf _
                        & "FROM " & TableName & " (NOLOCK)" & vbCrLf _
                        & "WHERE SourceAgencyName = @SourceAgencyName" & vbCrLf _
                        & "   AND " & TableName & "_SourceID = @SourceID"

                    dbCMD = _DBConn.CreateCommand()
                    dbCMD.CommandText = strSQL
                    dbCMD.Parameters.Add(New SqlClient.SqlParameter("@SourceAgencyName", SqlDbType.VarChar, Me.Item("SourceAgencyName").Lenght))
                    dbCMD.Parameters.Add(New SqlClient.SqlParameter("@SourceID", SqlDbType.VarChar, Me.Item(TableName & "_SourceID").Lenght))

                    dbCMD.Prepare()

                    _colDBCommands.Add(dbCMD, sCMDName)
                End If

                dbCMD.Parameters("@SourceID").Value = SourceID
                dbCMD.Parameters("@SourceAgencyName").Value = Me.SourceAgencyName

                objScalar = Me.SQLRunner.ExecuteScalar(dbCMD)
                If objScalar IsNot Nothing Then
                    SetValue(TableName & "_UJK", CType(objScalar, String))
                    Return True
                Else
                    'We will return false only when the foreign field exists 
                    'and the query is unable to retrieve the UJK value
                    Return False
                End If

            Catch ex As Exception
                Throw New System.Exception("Failure executing sql stament [" & dbCMD.CommandText & "]. ", ex)
            End Try
        End Function

        Protected Overrides Sub ComputeCalculatedItems()
            MyBase.ComputeCalculatedItems()

            If Not Me.ShowAllExceptions AndAlso Me.Contains("ETLWarnings") AndAlso Me.Warnings.Length > 0 Then
                Me.SetValue("ETLWarnings", Me.Warnings)
            End If

            If Not Me.ShowAllExceptions AndAlso Me.Contains("Warnings") AndAlso Me.Warnings.Length > 0 Then
                Me.SetValue("Warnings", Me.Warnings)
            End If

            If Me.Contains("SourceAgencyName") Then
                Me.SetValue("SourceAgencyName", Me.SourceAgencyName)
            End If

            If Me.Contains("InactiveRecordFlag") AndAlso Me.Item("InactiveRecordFlag").IsNull Then
                Me.SetValue("InactiveRecordFlag", False)
            End If

        End Sub

        Protected Overrides Sub Finalize()
            MyBase.Finalize()
        End Sub
    End Class


End Namespace

