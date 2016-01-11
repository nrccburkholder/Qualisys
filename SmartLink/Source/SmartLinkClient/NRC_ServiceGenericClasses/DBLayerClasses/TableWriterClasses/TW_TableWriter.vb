Option Explicit On

Namespace Miscellaneous.TableWriters
    ''' Created by: Elibad
    ''' Created Date: 2008/06/01
    ''' <summary>
    ''' This class is the base for any table writer.
    ''' </summary>
    ''' <remarks>
    ''' This class is the base for any table writer it provides the basic functionality that can be used to create a table writer specialized to an specific table
    ''' 
    ''' This class stores a collection of TableItems that are the valid fields for an specific table
    ''' </remarks>
    Public MustInherit Class TableWriter
        Private _sTableName As String
        Private _sTranslationKeys(0) As String
        Private _bWriteNulls As Boolean
        Private _sDBSourceName As String
        Private _bShowAllExceptions As Boolean = False
        Private _DBFactory As Data.Common.DbProviderFactory
        Private _SQLRunner As NRC.Miscellaneous.Stubborn_SQL_Runner
        Private _sDBConnectionType As String
        Private _sDBConnectionString As String
        Private _iRowsAffected As Integer
        Protected _sPKFieldName As String


#Region "Protected"
        'Protected _DBUpdateCommand As Common.DbCommand
        'Protected _DBInsertCommand As Common.DbCommand

        ''' <summary>
        ''' Stores the main connection object that can be reused during the life of an instance of this class
        ''' </summary>
        Protected _DBConn As Data.Common.DbConnection

        ''' <summary>
        ''' This collection stores all the field elements for the table
        ''' </summary>
        Protected _colElements As New Collection
        ''' <summary>
        ''' This collection stores the mapping information for each field in the table
        ''' </summary>
        Protected _colTranslation As New Dictionary(Of String, String)
        ''' <summary>
        ''' This collection stores all the different ways a record can be uniquely identified
        ''' </summary>
        Protected _colRecordUID As New Dictionary(Of String, String()) 'New Collection

        Protected _colDBCommands As New Collection

        ''' <summary>
        ''' This variable stores the Last primary key used
        ''' </summary>
        ''' <remarks>This variable is protected to allow any child class to write to this variable with the proper information if necesary.</remarks>
        Protected _sLastPrimaryKey As String

        'Protected MustOverride Function GenerateSQL() As String

        Protected MustOverride Function RetrievePK() As String

        Protected MustOverride Function GeneratePKValue() As String

        Protected MustOverride Sub CreateMainSQL()

        ''' <summary>
        ''' Space to create extra translations that an specific table writer can use
        ''' </summary>
        Protected MustOverride Sub AddExtraTranslations()

        ''' <summary>
        ''' Computes any item that needs to be calculated before writing the data to the database
        ''' </summary>
        ''' <remarks>This method will be defined in the different implementations of table writers</remarks>
        Protected Overridable Sub ComputeCalculatedItems()

        End Sub

        Protected Sub New(ByVal TableName As String)
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If
            _sTableName = TableName

            Array.Resize(_sTranslationKeys, 0)
        End Sub


        ''' <summary>
        ''' Adds an element to the colection of items that will be writen to the table in the database
        ''' </summary>
        Protected Sub AddItem(ByRef Item As TableItem)
            If Not _colElements.Contains(Item.ColumnName) Then
                Item.ShowAllExceptions = _bShowAllExceptions
                _colElements.Add(Item, Item.ColumnName.ToUpper)
                AddFieldMapping(Item.ColumnName, Item.ColumnName)
            Else
                Throw New System.Exception("ColumnName already exists. Please make sure the column name does no exist")
            End If
        End Sub

        ''' <summary>
        ''' Adds the information about the groups of fields that can uniquely identified a record
        ''' </summary>
        Protected Sub AddUniqueIdentifier(ByVal Name As String, ByVal FieldNames() As String)
            Dim sErrMessage As String = ""

            If Not _colRecordUID.ContainsKey(Name) Then
                If FieldNames.Length = 1 AndAlso Name.ToUpper.StartsWith("PK_") Then
                    Me._sPKFieldName = FieldNames(0)
                End If
                For Each sField As String In FieldNames
                    sField = sField.Trim
                    If Not _colElements.Contains(sField) Then
                        sErrMessage += "The field '" & sField & "' does not exists in the table " & Me.TableName & ". " & vbCrLf
                    End If
                Next
                If sErrMessage = "" Then
                    _colRecordUID.Add(Name, FieldNames)
                Else
                    sErrMessage += "Please update the table tblDBKeyGroup to reflect the structural changes in the database" & vbCrLf
                    Throw New System.Exception(sErrMessage)
                End If
            Else
                Throw New System.Exception("Record unique identifier already exists, make sure the unique identifier does not exist")
            End If
        End Sub

        ''' <summary>
        ''' Calls the ADO AccessLayer class
        ''' </summary>
        Protected Function DBCommandExecuteScalar(ByVal DBCommandObject As Data.Common.DbCommand) As Object
            Return ADO_AccessLayer.DBCommandExecuteScalar(DBCommandObject)
        End Function

        ''' <summary>
        ''' Calls the ADO AccessLayer class
        ''' </summary>
        Protected Function DBCommandExecuteReader(ByVal DBCommandObject As Data.Common.DbCommand) As Data.Common.DbDataReader
            Return ADO_AccessLayer.DBCommandExecuteReader(DBCommandObject)
        End Function

        ''' <summary>
        ''' Calls the ADO AccessLayer class
        ''' </summary>
        ''' <returns>Integer</returns>
        Protected Function DBCommandExecuteNonQuery(ByVal DBCommandObject As Data.Common.DbCommand) As Integer
            Return ADO_AccessLayer.DBCommandExecuteNonQuery(DBCommandObject)
        End Function

        ''' <summary>
        ''' DBFactory object used to create all the database objects
        ''' </summary>
        Protected Property DBFactory() As Data.Common.DbProviderFactory
            Get
                Return _DBFactory
            End Get
            Set(ByVal value As Data.Common.DbProviderFactory)
                _DBFactory = value
                If _DBConn Is Nothing Then
                    _DBConn = _DBFactory.CreateConnection
                End If
            End Set
        End Property


#End Region

#Region "Public"
        ''' <summary>
        ''' Space to define the colection of Elements that will be writen to the database
        ''' </summary>
        ''' <remarks>
        ''' These element list should match to the fields in the table that the table writer will be writing to.
        ''' </remarks>
        Public MustOverride Sub CreateElementsCollection()

        ''' <summary>
        ''' The Field name of the UJK field
        ''' </summary>
        Public ReadOnly Property PKFieldName() As String
            Get
                Return _sPKFieldName
            End Get
        End Property


        Public Sub OpenConnection()
            If _DBConn.State <> ConnectionState.Open Then
                _DBConn.Open()
            End If
        End Sub

        Public Sub CloseConnection()
            If _DBConn IsNot Nothing Then
                If _DBConn.State = ConnectionState.Open Then
                    _DBConn.Close()
                End If
            End If

            For Each cmd As Common.DbCommand In _colDBCommands
                cmd.Dispose()
            Next

            _colDBCommands.Clear()

        End Sub

        ''' <summary>
        ''' Defines the Connection string that will be used to connect to the database
        ''' </summary>
        Public Property DBConnectionString() As String
            Get
                Return _sDBConnectionString
            End Get
            Set(ByVal value As String)
                _sDBConnectionString = value

                If _DBConn IsNot Nothing Then
                    Dim bConWasOpen As Boolean = False
                    If _DBConn.State = ConnectionState.Open Then
                        _DBConn.Close()
                        bConWasOpen = True
                    End If
                    _DBConn.ConnectionString = value

                    If bConWasOpen Then
                        _DBConn.Open()
                    End If

                End If

            End Set
        End Property

        ''' <summary>
        ''' Defines the type of connection string format
        ''' </summary>
        Public Property DBConnectionType() As String
            Get
                Return _sDBConnectionType
            End Get
            Set(ByVal value As String)
                If value.ToUpper.Contains("SQL") Then
                    Me.DBFactory = Data.SqlClient.SqlClientFactory.Instance
                ElseIf value.ToUpper.Contains("OLEDB") Then
                    Me.DBFactory = Data.OleDb.OleDbFactory.Instance
                ElseIf value.ToUpper.Contains("ODBC") Then
                    Me.DBFactory = Data.Odbc.OdbcFactory.Instance
                Else
                    Throw New System.Exception("DBConnectionType not supported. Please use a different Connection type")
                End If

                _sDBConnectionType = value
            End Set
        End Property

        ''' <summary>
        ''' Creates values for key fields and writes a collection of SLWritable objects to a given table in the smartlink database
        ''' </summary>

        Public Sub Write()
            'Dim strSQL As String
            Dim myCMD As Data.Common.DbCommand = Nothing
            Dim sPKValue As String = ""
            'Dim colIgnore As Collection
            Static sActiveFields As String

            If _colElements Is Nothing OrElse _colElements.Count <= 0 Then
                Me.CreateElementsCollection()
                Me.AddExtraTranslations()
            End If

            _iRowsAffected = 0
            ComputeCalculatedItems()

            If _DBConn.State <> ConnectionState.Open Then
                _DBConn.Open()
            End If

            If Not _colDBCommands.Contains("INSERT") Then
                Me.CreateMainSQL()
                sActiveFields = GetActiveFieldList()
            End If

            If Not Me.WriteNulls AndAlso sActiveFields <> GetActiveFieldList() Then
                Me.CreateMainSQL()
                sActiveFields = GetActiveFieldList()
            End If

            sPKValue = Me.RetrievePK

            If sPKValue <> "" Then
                myCMD = CType(_colDBCommands.Item("UPDATE"), Common.DbCommand)
            Else
                myCMD = CType(_colDBCommands.Item("INSERT"), Common.DbCommand)
                sPKValue = Me.GeneratePKValue
            End If

            _sLastPrimaryKey = sPKValue

            Me.SetValue(Me.PKFieldName, sPKValue)

            For Each dbParam As Common.DbParameter In myCMD.Parameters
                dbParam.Value = Me.Item(dbParam.ParameterName.Substring(1)).DBValue
            Next

            'For Each Field As TableItem In _colElements
            '    If Me.WriteNulls OrElse Field.IsFilled Then
            '        myCMD.Parameters.Add(Field.DBParameter)
            '    End If
            'Next

            _iRowsAffected = Me.SQLRunner.ExecuteNonQuery(myCMD)
        End Sub

        Private Function GetActiveFieldList() As String
            Dim sResult As String = ""
            Dim iFieldPosition As Integer = 0
            For Each Field As TableItem In _colElements
                iFieldPosition += 1
                If Not Field.IsNull Then
                    If sResult = "" Then
                        sResult = iFieldPosition.ToString
                    Else
                        sResult += ", " & iFieldPosition.ToString
                    End If
                End If
            Next
            Return sResult
        End Function

        ''' <summary>
        ''' Retrieves the Number of rows that were affected for the write method
        ''' </summary>
        ''' <value>Returns 1 or 0</value>
        Public ReadOnly Property RowsAffected() As Integer
            Get
                Return _iRowsAffected
            End Get
        End Property

        ''' <summary>
        ''' Adds a translation mapping to identify a table column using an alias
        ''' </summary>
        Public Sub AddFieldMapping(ByVal ColumnName As String, ByVal AliasName As String)
            ColumnName = ColumnName.ToUpper
            AliasName = AliasName.ToUpper

            If _colElements Is Nothing OrElse _colElements.Count <= 0 Then
                Me.CreateElementsCollection()
                Me.AddExtraTranslations()
            End If

            If _colElements.Contains(ColumnName) Then
                If _colTranslation.ContainsValue(ColumnName) Then
                    'Throw New System.Exception("There is already another Alias pointing to this column." & vbCrLf _
                    '    & "Table: " & Me.TableName & vbCrLf _
                    '    & "Column Name: " & ColumnName & vbCrLf _
                    '    & "Alias: " & AliasName)
                    For Each kpFieldMapping As KeyValuePair(Of String, String) In _colTranslation
                        If kpFieldMapping.Value = ColumnName Then
                            _colTranslation.Remove(kpFieldMapping.Key)
                            Exit For
                        End If
                    Next
                End If
                If _colTranslation.ContainsKey(AliasName) Then
                    ColumnName = ColumnName.Trim() & ", " & _colTranslation.Item(AliasName).ToString.Trim
                    _colTranslation.Remove(AliasName)
                End If

                '_colTranslation.Add(ColumnName, AliasName) 'Collection Add method receives the Key as the second parameter
                _colTranslation.Add(AliasName, ColumnName) 'Dictionary Add method receives the Key as teh first parameter
                Array.Resize(_sTranslationKeys, _sTranslationKeys.Length + 1)
                _sTranslationKeys(_sTranslationKeys.Length - 1) = AliasName
            Else
                Throw New System.Exception("Column name '" & ColumnName & "' does not exist. Please use a valid column name")
            End If
        End Sub

        ''' <summary>
        ''' Adds the translation mapping for how some values will be translated for an specific field
        ''' </summary>
        Public Sub AddValueTranslation(ByVal ColumnName As String, ByVal ValueToUse As String, ByVal ValueAlias As String)
            ColumnName = ColumnName.ToUpper
            ValueAlias = ValueAlias.ToUpper

            If _colElements Is Nothing OrElse _colElements.Count <= 0 Then
                Me.CreateElementsCollection()
                Me.AddExtraTranslations()
            End If

            If _colElements.Contains(ColumnName) Then
                CType(_colElements.Item(ColumnName), TableItem).AddValueTranslation(ValueToUse, ValueAlias)
            Else
                Throw New System.Exception("Column name '" & ColumnName & "' does not exist. Please use a valid column name")
            End If
        End Sub

        ''' <summary>
        ''' Retrieves the Primary key value of the last record written to the database
        ''' </summary>
        Public ReadOnly Property LastPrimaryKey() As String
            Get
                Return _sLastPrimaryKey
            End Get
        End Property

        ''' <summary>
        ''' Sets the value to be written to the database
        ''' </summary>
        Public Sub SetValue(ByVal Field As String, ByVal Value As Object)
            Field = Field.ToUpper

            If _colElements Is Nothing OrElse _colElements.Count <= 0 Then
                Me.CreateElementsCollection()
                Me.AddExtraTranslations()
            End If

            If _colTranslation.ContainsKey(Field) AndAlso Value IsNot Nothing Then
                If _colTranslation.Item(Field).ToString.IndexOf(",") >= 0 Then
                    For Each sColumn As String In _colTranslation.Item(Field).ToString.Split(","c)
                        sColumn = sColumn.Trim
                        If _colElements.Contains(sColumn) Then
                            CType(_colElements.Item(sColumn), TableItem).SetValue(Value)
                        End If
                    Next
                Else
                    CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem).SetValue(Value)
                End If

                'If _colElements.Contains(_colTranslation.Item(Field).ToString) And Value IsNot Nothing Then
                '    Dim TempItem As TableItem = Nothing

                '    TempItem = CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem)
                '    TempItem.SetValue(Value)
                'End If
            End If
        End Sub

        ''' <summary>
        ''' Sets the value to be written to the database
        ''' </summary>
        Public Sub SetValue(ByVal Field As String, ByVal Value As String)
            Field = Field.ToUpper

            If _colElements Is Nothing OrElse _colElements.Count <= 0 Then
                Me.CreateElementsCollection()
                Me.AddExtraTranslations()
            End If

            If _colTranslation.ContainsKey(Field) AndAlso Value IsNot Nothing Then
                If _colTranslation.Item(Field).ToString.IndexOf(",") >= 0 Then
                    For Each sColumn As String In _colTranslation.Item(Field).ToString.Split(","c)
                        sColumn = sColumn.Trim
                        If _colElements.Contains(sColumn) Then
                            CType(_colElements.Item(sColumn), TableItem).SetValue(Value)
                        End If
                    Next
                Else
                    CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem).SetValue(Value)
                End If

                'If _colElements.Contains(_colTranslation.Item(Field).ToString) And Value IsNot Nothing Then
                '    Dim TempItem As TableItem = Nothing

                '    TempItem = CType(_colElements.Item(_colTranslation.Item(Field).ToString), TableItem)
                '    TempItem.SetValue(Value)
                'End If
            End If
        End Sub

        ''' <summary>
        ''' Array of strings with all the translation mapping information the table writer will be using
        ''' </summary>
        ''' Public ReadOnly Property SLCollection() As Collection
        '''   Get
        '''       Return _colElements
        '''   End Get
        ''' End Property

        Public ReadOnly Property TranslationKeys() As String()
            Get
                Return _sTranslationKeys
            End Get
        End Property

        ''' <summary>
        ''' Name of the source database
        ''' </summary>
        ''' Public Property DBRetryCount() As Integer
        '''    Get
        '''        Return _iDBRetryCount
        '''    End Get
        '''    Set(ByVal value As Integer)
        '''        _iDBRetryCount = value
        '''    End Set
        ''' End Property
        ''' Public Property DBRetryInterval() As Integer
        '''    Get
        '''        Return _iDBRetryInterval
        '''    End Get
        '''    Set(ByVal value As Integer)
        '''        _iDBRetryInterval = value
        '''    End Set
        ''' End Property

        Public Property DBSourceName() As String
            Get
                Return _sDBSourceName
            End Get
            Set(ByVal value As String)
                _sDBSourceName = value
            End Set
        End Property

        ''' <summary>
        ''' Name of the table where the data will be writen to
        ''' </summary>
        Public ReadOnly Property TableName() As String
            Get
                Return _sTableName
            End Get
        End Property

        ''' <summary>
        ''' Defines if the class will throw all exceptions
        ''' </summary>
        ''' <remarks>If this is false then all the exception messages will be stored in the Warnings property</remarks>
        Public Property ShowAllExceptions() As Boolean
            Get
                Return _bShowAllExceptions
            End Get
            Set(ByVal value As Boolean)
                _bShowAllExceptions = value
                If _colElements.Count > 0 Then
                    For Each FieldItem As TableItem In _colElements
                        FieldItem.ShowAllExceptions = _bShowAllExceptions
                    Next
                End If
            End Set
        End Property

        ''' <summary>
        ''' This class executes any SQL code that we need to try executing until sucess
        ''' </summary>
        Public Property SQLRunner() As NRC.Miscellaneous.Stubborn_SQL_Runner
            Get
                Return Me._SQLRunner
            End Get
            Set(ByVal value As NRC.Miscellaneous.Stubborn_SQL_Runner)
                Me._SQLRunner = value
            End Set
        End Property

        ''' <summary>
        ''' Gets the Warnings comming from each field parsed by the table writer
        ''' </summary>
        Public ReadOnly Property Warnings() As String
            Get
                Dim sResult As String = String.Empty

                For Each Field As TableItem In _colElements
                    sResult = sResult & Field.Warnings
                Next

                Return sResult
            End Get
        End Property

        ''' <summary>
        ''' Defines whether the Null values should be writen to the database
        ''' </summary>
        Public Property WriteNulls() As Boolean
            Get
                Return _bWriteNulls
            End Get
            Set(ByVal value As Boolean)
                _bWriteNulls = value
            End Set
        End Property

        ''' <summary>
        ''' Clears the values, warnings, and filled flag of all the fields inside the table writer
        ''' </summary>
        Public Sub ClearValues()
            For Each Field As TableItem In _colElements
                Field.Clear()
            Next
        End Sub

        ''' <summary>
        ''' Identifies if the table writer contains an specific field
        ''' </summary>
        ''' <returns>Boolean</returns>
        Public Function Contains(ByVal FieldName As String) As Boolean
            Return _colElements.Contains(FieldName)
        End Function

        ''' <summary>
        ''' Retrieves a table item object for an specific field
        ''' </summary>
        Public ReadOnly Property Item(ByVal FieldName As String) As TableItem
            Get
                If _colElements.Contains(FieldName) Then
                    Return CType(_colElements.Item(FieldName), TableItem)
                Else
                    Dim sMessage As String = ""
                    If _colElements.Count = 0 Then
                        sMessage = "The field collection is empty"
                    Else
                        sMessage = "The field " & FieldName & " does not exist in the field collection for table " & Me.TableName
                    End If
                    Throw New Exception(sMessage)
                End If
            End Get
        End Property


#End Region

#Region "Private Methods"


#End Region

    End Class

End Namespace

