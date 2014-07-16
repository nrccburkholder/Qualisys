Imports Nrc.Framework.BusinessLogic.Configuration

Friend Class CmsRecodeReader
    Implements IDataReader

#Region " Private Members "

    Protected mReader As IDataReader

    Private mHeaderColumnNames As New List(Of String)
    Private mPatientAdminColumnNames As New List(Of String)
    Private mStrataColumnNames As New List(Of String)
    Private mMiscColumnNames As New List(Of String)
    Private mHDOSLColumnNames As New List(Of String)

    Private mPatientResponseColumnAliases As New Dictionary(Of String, PatientResponseColumn)
    Private mPatientResponseOptionalColumnAliases As New Dictionary(Of String, PatientResponseColumn)

    Private mHeaderSchema As DataTable
    Private mResponseSchema As DataTable
    Private mStrataSchema As DataTable
    Private mMiscSchema As DataTable
    Private mHDOSLSchema As DataTable

    Private mCurrentResultSet As Integer
    Private mHasMultipleFacility As Boolean

    Private mLanguageSpeakOldCoreUsedTPS As Boolean

#End Region

#Region " Enums "

    Protected Enum CmsColumnType
        None = 0
        Header = 1
        PatientAdmin = 2
        PatientResponse = 3
        PatientResponseMarkAll = 4
        Strata = 5
        Misc = 6
        HDOSL = 7
        PatientResponseOptional = 8
    End Enum

#End Region

#Region " Properties "

    Public ReadOnly Property LanguageSpeakOldCoreUsedTPS() As Boolean
        Get
            Return mLanguageSpeakOldCoreUsedTPS
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal reader As IDataReader)

        mReader = reader
        mHasMultipleFacility = False

        'Initialize the list of columns
        InitSchemaTable()

        'Initialize the question cores for each response
        InitResponseColumnAliases()

    End Sub

    Public Sub New(ByVal reader As IDataReader, ByVal hasMultipleFacility As Boolean)

        mReader = reader
        mHasMultipleFacility = hasMultipleFacility

        'Initialize the list of columns
        InitSchemaTable()

        'Initialize the question cores for each response
        InitResponseColumnAliases()

    End Sub

#End Region

#Region " Schema Initialization "

    Protected Sub InitCoreSchemaTable()

        'Create the 4 empty schema tables
        mHeaderSchema = mReader.GetSchemaTable.Clone
        mStrataSchema = mReader.GetSchemaTable.Clone
        mMiscSchema = mReader.GetSchemaTable.Clone
        mResponseSchema = mReader.GetSchemaTable.Clone
        mHDOSLSchema = mReader.GetSchemaTable.Clone

        'Strata Schema
        AddStringColumnToSchema("strata-name", 50, CmsColumnType.Strata)
        AddIntegerColumnToSchema("dsrs-eligible", CmsColumnType.Strata)
        AddIntegerColumnToSchema("dsrs-samplesize", CmsColumnType.Strata)

        'Misc Schema
        AddIntegerColumnToSchema("DeletedCount", CmsColumnType.Misc)

        'HDOSL Schema
        AddIntegerColumnToSchema("determination-of-service-line", True, CmsColumnType.HDOSL)

    End Sub

    Protected Overridable Sub InitSchemaTable()

        'Initialize common core sections
        InitCoreSchemaTable()

        'Header Schema
        AddStringColumnToSchema("provider-name", 50, CmsColumnType.Header)
        AddStringColumnToSchema("provider-id", 20, CmsColumnType.Header)
        AddStringColumnToSchema("npi", 10, CmsColumnType.Header)
        AddIntegerColumnToSchema("discharge-yr", CmsColumnType.Header)
        AddIntegerColumnToSchema("discharge-month", CmsColumnType.Header)
        AddStringColumnToSchema("survey-mode", 1, CmsColumnType.Header)
        AddIntegerColumnToSchema("number-eligible-discharge", CmsColumnType.Header)
        AddIntegerColumnToSchema("sample-size", CmsColumnType.Header)
        AddIntegerColumnToSchema("sample-type", CmsColumnType.Header)

        'Results Schema
        'Admin section
        AddStringColumnToSchema("provider-id", 20, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("discharge-yr", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("discharge-month", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("patient-id", 16, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("principal-reason-admission", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("discharge-status", 2, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("strata-name", 50, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("survey-status", 2, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("number-attempts", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("language", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("lag-time", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("supplemental-question-count", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("gender", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("patient-age", 2, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("SampSet", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("complete", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("discharge-date", 40, CmsColumnType.PatientAdmin)

        'Result section
        AddStringColumnToSchema("nurse-courtesy-respect", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("nurse-listen", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("nurse-explain", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("call-button", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("dr-courtesy-respect", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("dr-listen", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("dr-explain", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("cleanliness", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("quiet", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("bathroom-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("bathroom-help", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("med-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("pain-control", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("help-pain", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("new-med-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("med-for", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("side-effects", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("discharge-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("help-after-discharge", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("symptoms", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("overall-rate", 2, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("recommend", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("overall-health", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("education", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("ethnic", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("race-white", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-african-amer", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-asian", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-hi-pacific-islander", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-amer-indian-ak", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("language-speak", 1, CmsColumnType.PatientResponse)

        'Optional Result Section
        AddStringColumnToSchema("ct-preferences", 1, CmsColumnType.PatientResponseOptional)     '09-18-2012 JJF - Added new question
        AddStringColumnToSchema("ct-understanding", 1, CmsColumnType.PatientResponseOptional)   '09-18-2012 JJF - Added new question
        AddStringColumnToSchema("ct-purpose-med", 1, CmsColumnType.PatientResponseOptional)     '09-18-2012 JJF - Added new question
        AddStringColumnToSchema("er-admission", 1, CmsColumnType.PatientResponseOptional)       '09-18-2012 JJF - Added new question
        AddStringColumnToSchema("mental-health", 1, CmsColumnType.PatientResponseOptional)      '09-18-2012 JJF - Added new question

    End Sub

    Private Function AddSchemaColumn(ByVal columnName As String, ByVal nullable As Boolean, ByVal columnType As CmsColumnType, ByRef schemaTable As DataTable) As DataRow

        Select Case columnType
            Case CmsColumnType.Header
                schemaTable = mHeaderSchema
                AddHeaderColumn(columnName)

            Case CmsColumnType.Strata
                schemaTable = mStrataSchema
                AddStrataColumn(columnName)

            Case CmsColumnType.Misc
                schemaTable = mMiscSchema
                AddMiscColumn(columnName)

            Case CmsColumnType.PatientAdmin
                schemaTable = mResponseSchema
                AddPatientAdminColumn(columnName)

            Case CmsColumnType.PatientResponse
                schemaTable = mResponseSchema
                AddPatientResponseColumn(columnName, False)

            Case CmsColumnType.PatientResponseMarkAll
                schemaTable = mResponseSchema
                AddPatientResponseColumn(columnName, True)

            Case CmsColumnType.PatientResponseOptional
                schemaTable = mResponseSchema
                AddPatientResponseOptionalColumn(columnName, False)

            Case CmsColumnType.HDOSL
                schemaTable = mHDOSLSchema
                AddHDOSLColumn(columnName)

            Case Else
                Throw New ArgumentOutOfRangeException("Unknown CMS Column Type.")

        End Select

        Dim newRow As DataRow = schemaTable.NewRow
        newRow("ColumnName") = columnName
        newRow("ColumnOrdinal") = schemaTable.Rows.Count
        newRow("NumericScale") = 255
        newRow("IsUnique") = False
        newRow("IsKey") = DBNull.Value
        newRow("BaseServerName") = DBNull.Value
        newRow("BaseCatalogName") = DBNull.Value
        newRow("BaseColumnName") = columnName
        newRow("BaseSchemaName") = DBNull.Value
        newRow("BaseTableName") = DBNull.Value
        newRow("AllowDBNull") = nullable
        newRow("IsAliased") = DBNull.Value
        newRow("IsExpression") = DBNull.Value
        newRow("IsIdentity") = False
        newRow("IsAutoIncrement") = False
        newRow("IsRowVersion") = False
        newRow("IsHidden") = DBNull.Value
        newRow("IsLong") = False
        newRow("IsReadOnly") = True
        newRow("XmlSchemaCollectionDatabase") = DBNull.Value
        newRow("XmlSchemaCollectionOwningSchema") = DBNull.Value
        newRow("XmlSchemaCollectionName") = DBNull.Value
        newRow("UdtAssemblyQualifiedName") = DBNull.Value

        Return newRow

    End Function

    Protected Sub AddStringColumnToSchema(ByVal columnName As String, ByVal columnLength As Integer, ByVal columnType As CmsColumnType)

        AddStringColumnToSchema(columnName, columnLength, False, columnType)

    End Sub

    Protected Sub AddStringColumnToSchema(ByVal columnName As String, ByVal columnLength As Integer, ByVal nullable As Boolean, ByVal columnType As CmsColumnType)

        Dim schemaTable As DataTable = Nothing
        Dim row As DataRow = AddSchemaColumn(columnName, nullable, columnType, schemaTable)
        row("ColumnSize") = columnLength
        row("NumericPrecision") = 255
        row("DataType") = GetType(String)
        row("ProviderType") = 22
        row("ProviderSpecificDataType") = GetType(System.Data.SqlTypes.SqlString)
        row("DataTypeName") = "varchar"
        row("NonVersionedProviderType") = 22
        schemaTable.Rows.Add(row)

    End Sub

    Protected Sub AddIntegerColumnToSchema(ByVal columnName As String, ByVal columnType As CmsColumnType)

        AddIntegerColumnToSchema(columnName, False, columnType)

    End Sub

    Protected Sub AddIntegerColumnToSchema(ByVal columnName As String, ByVal nullable As Boolean, ByVal columnType As CmsColumnType)

        Dim schemaTable As DataTable = Nothing
        Dim row As DataRow = AddSchemaColumn(columnName, nullable, columnType, schemaTable)
        row("ColumnSize") = 4
        row("NumericPrecision") = 10
        row("DataType") = GetType(System.Int32)
        row("ProviderType") = 8
        row("ProviderSpecificDataType") = GetType(System.Data.SqlTypes.SqlInt32)
        row("DataTypeName") = "int"
        row("NonVersionedProviderType") = 8
        schemaTable.Rows.Add(row)

    End Sub

    Protected Overridable Sub InitResponseColumnAliases()

        AddResponseColumnAlias("nurse-courtesy-respect", "Q018876")
        AddResponseColumnAlias("nurse-listen", "Q018878")
        AddResponseColumnAlias("nurse-explain", "Q018879")
        AddResponseColumnAlias("call-button", "Q018882")
        AddResponseColumnAlias("dr-courtesy-respect", "Q018875")
        AddResponseColumnAlias("dr-listen", "Q018877")
        AddResponseColumnAlias("dr-explain", "Q018884")
        AddResponseColumnAlias("cleanliness", "Q018888")
        AddResponseColumnAlias("quiet", "Q018889")
        AddResponseColumnAlias("bathroom-screener", "Q018894")
        AddResponseColumnAlias("bathroom-help", "Q018896")
        AddResponseColumnAlias("med-screener", "Q018907")
        AddResponseColumnAlias("pain-control", "Q018910")
        AddResponseColumnAlias("help-pain", "Q018911")
        AddResponseColumnAlias("new-med-screener", "Q018916")
        AddResponseColumnAlias("med-for", "Q022560")
        AddResponseColumnAlias("side-effects", "Q022547")
        AddResponseColumnAlias("discharge-screener", "Q018929")
        AddResponseColumnAlias("help-after-discharge", "Q018935")
        AddResponseColumnAlias("symptoms", "Q018937")
        AddResponseColumnAlias("overall-rate", "Q018941")
        AddResponseColumnAlias("recommend", "Q018943")
        AddResponseColumnAlias("overall-health", "Q018945")
        AddResponseColumnAlias("education", "Q018949")
        AddResponseColumnAlias("ethnic", "Q025541")
        AddResponseColumnAlias("race-white", "Q023296a")
        AddResponseColumnAlias("race-african-amer", "Q023296b")
        AddResponseColumnAlias("race-asian", "Q023296c")
        AddResponseColumnAlias("race-hi-pacific-islander", "Q023296d")
        AddResponseColumnAlias("race-amer-indian-ak", "Q023296e")
        AddResponseColumnAlias("language-speak", "Q018952")
        AddResponseColumnAlias("language-speak", "Q043350") '08-09-2011 JJF - Added new core for the language question (43350)
        AddResponseColumnAlias("language-speak", "Q050860") '06-02-2014 CJB - Added new core for the language question (50860)

        AddResponseOptionalColumnAlias("ct-preferences", "Q046863")     '09-18-2012 JJF - Added new question
        AddResponseOptionalColumnAlias("ct-understanding", "Q046864")   '09-18-2012 JJF - Added new question
        AddResponseOptionalColumnAlias("ct-purpose-med", "Q046865")     '09-18-2012 JJF - Added new question
        AddResponseOptionalColumnAlias("er-admission", "Q046866")       '09-18-2012 JJF - Added new question
        AddResponseOptionalColumnAlias("mental-health", "Q046867")      '09-18-2012 JJF - Added new question

    End Sub

    Protected Sub AddResponseColumnAlias(ByVal aliasName As String, ByVal actualColumnName As String)

        If Not mPatientResponseColumnAliases(aliasName).CoreList.Contains(actualColumnName) Then
            mPatientResponseColumnAliases(aliasName).CoreList.Add(actualColumnName)
        End If

    End Sub

    Protected Sub AddResponseOptionalColumnAlias(ByVal aliasName As String, ByVal actualColumnName As String)

        If Not mPatientResponseOptionalColumnAliases(aliasName).CoreList.Contains(actualColumnName) Then
            mPatientResponseOptionalColumnAliases(aliasName).CoreList.Add(actualColumnName)
        End If

    End Sub

    Private Sub AddHeaderColumn(ByVal columnName As String)

        If Not mHeaderColumnNames.Contains(columnName) Then
            mHeaderColumnNames.Add(columnName)
        End If

    End Sub

    Private Sub AddStrataColumn(ByVal columnName As String)

        If Not mStrataColumnNames.Contains(columnName) Then
            mStrataColumnNames.Add(columnName)
        End If

    End Sub

    Private Sub AddMiscColumn(ByVal columnName As String)

        If Not mMiscColumnNames.Contains(columnName) Then
            mMiscColumnNames.Add(columnName)
        End If

    End Sub

    Private Sub AddHDOSLColumn(ByVal columnName As String)

        If Not mHDOSLColumnNames.Contains(columnName) Then
            mHDOSLColumnNames.Add(columnName)
        End If

    End Sub

    Private Sub AddPatientAdminColumn(ByVal columnName As String)

        If Not mPatientAdminColumnNames.Contains(columnName) Then
            mPatientAdminColumnNames.Add(columnName)
        End If

    End Sub

    Private Sub AddPatientResponseColumn(ByVal columnName As String, ByVal isMarkAllThatApply As Boolean)

        If Not mPatientResponseColumnAliases.ContainsKey(columnName) Then
            mPatientResponseColumnAliases.Add(columnName, New PatientResponseColumn(isMarkAllThatApply))
        End If

    End Sub

    Private Sub AddPatientResponseOptionalColumn(ByVal columnName As String, ByVal isMarkAllThatApply As Boolean)

        If Not mPatientResponseOptionalColumnAliases.ContainsKey(columnName) Then
            mPatientResponseOptionalColumnAliases.Add(columnName, New PatientResponseColumn(isMarkAllThatApply))
        End If

    End Sub

#End Region

#Region " IDataReader Implementation "

    Public Sub Close() Implements System.Data.IDataReader.Close

        mReader.Close()

    End Sub

    Public ReadOnly Property Depth() As Integer Implements System.Data.IDataReader.Depth
        Get
            Return mReader.Depth
        End Get
    End Property

    Public Function GetSchemaTable() As System.Data.DataTable Implements System.Data.IDataReader.GetSchemaTable

        If mHasMultipleFacility = True Then
            Select Case mCurrentResultSet
                Case 0
                    Return mHDOSLSchema

                Case 1
                    Return mHeaderSchema

                Case 2
                    Return mResponseSchema

                Case 3
                    Return mMiscSchema

            End Select
        Else
            Select Case mCurrentResultSet
                Case 0
                    Return mHDOSLSchema

                Case 1
                    Return mHeaderSchema

                Case 2
                    Return mResponseSchema

                Case 3
                    Return mMiscSchema

            End Select
        End If

        Throw New ExportFileCreationException("Error Getting Schema Table.")

    End Function

    Public ReadOnly Property IsClosed() As Boolean Implements System.Data.IDataReader.IsClosed
        Get
            Return mReader.IsClosed
        End Get
    End Property

    Public Function NextResult() As Boolean Implements System.Data.IDataReader.NextResult

        If mReader.NextResult Then
            mCurrentResultSet += 1
            Return True
        Else
            Return False
        End If

    End Function

    Public Function Read() As Boolean Implements System.Data.IDataReader.Read

        mLanguageSpeakOldCoreUsedTPS = False

        Return mReader.Read

    End Function

    Public ReadOnly Property RecordsAffected() As Integer Implements System.Data.IDataReader.RecordsAffected
        Get
            Return mReader.RecordsAffected
        End Get
    End Property

    Public ReadOnly Property FieldCount() As Integer Implements System.Data.IDataRecord.FieldCount
        Get
            Return mReader.FieldCount
        End Get
    End Property

    Public Function GetBoolean(ByVal i As Integer) As Boolean Implements System.Data.IDataRecord.GetBoolean

        Throw New NotImplementedException

    End Function

    Public Function GetByte(ByVal i As Integer) As Byte Implements System.Data.IDataRecord.GetByte

        Throw New NotImplementedException

    End Function

    Public Function GetBytes(ByVal i As Integer, ByVal fieldOffset As Long, ByVal buffer() As Byte, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataRecord.GetBytes

        Throw New NotImplementedException

    End Function

    Public Function GetChar(ByVal i As Integer) As Char Implements System.Data.IDataRecord.GetChar

        Throw New NotImplementedException

    End Function

    Public Function GetChars(ByVal i As Integer, ByVal fieldoffset As Long, ByVal buffer() As Char, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataRecord.GetChars

        Throw New NotImplementedException

    End Function

    Public Function GetData(ByVal i As Integer) As System.Data.IDataReader Implements System.Data.IDataRecord.GetData

        Throw New NotImplementedException

    End Function

    Public Function GetDataTypeName(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetDataTypeName

        Throw New NotImplementedException

    End Function

    Public Function GetDateTime(ByVal i As Integer) As Date Implements System.Data.IDataRecord.GetDateTime

        Throw New NotImplementedException

    End Function

    Public Function GetDecimal(ByVal i As Integer) As Decimal Implements System.Data.IDataRecord.GetDecimal

        Throw New NotImplementedException

    End Function

    Public Function GetDouble(ByVal i As Integer) As Double Implements System.Data.IDataRecord.GetDouble

        Throw New NotImplementedException

    End Function

    Public Function GetFieldType(ByVal i As Integer) As System.Type Implements System.Data.IDataRecord.GetFieldType

        Throw New NotImplementedException

    End Function

    Public Function GetFloat(ByVal i As Integer) As Single Implements System.Data.IDataRecord.GetFloat

        Throw New NotImplementedException

    End Function

    Public Function GetGuid(ByVal i As Integer) As System.Guid Implements System.Data.IDataRecord.GetGuid

        Throw New NotImplementedException

    End Function

    Public Function GetInt16(ByVal i As Integer) As Short Implements System.Data.IDataRecord.GetInt16

        Throw New NotImplementedException

    End Function

    Public Function GetInt32(ByVal i As Integer) As Integer Implements System.Data.IDataRecord.GetInt32

        Throw New NotImplementedException

    End Function

    Public Function GetInt64(ByVal i As Integer) As Long Implements System.Data.IDataRecord.GetInt64

        Throw New NotImplementedException

    End Function

    Public Function GetName(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetName

        Return mReader.GetName(i)

    End Function

    Public Function GetOrdinal(ByVal name As String) As Integer Implements System.Data.IDataRecord.GetOrdinal

        Return mReader.GetOrdinal(name)

    End Function

    Public Function GetString(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetString

        Throw New NotImplementedException

    End Function

    Public Function GetValue(ByVal i As Integer) As Object Implements System.Data.IDataRecord.GetValue

        Throw New NotImplementedException

    End Function

    Public Function GetValues(ByVal values() As Object) As Integer Implements System.Data.IDataRecord.GetValues

        Throw New NotImplementedException

    End Function

    Public Function IsDBNull(ByVal i As Integer) As Boolean Implements System.Data.IDataRecord.IsDBNull

        Return mReader.IsDBNull(i)

    End Function

    Default Public Overloads ReadOnly Property Item(ByVal i As Integer) As Object Implements System.Data.IDataRecord.Item
        Get
            Return GetFieldValue(GetColumnName(i))
        End Get
    End Property

    Default Public Overloads ReadOnly Property Item(ByVal name As String) As Object Implements System.Data.IDataRecord.Item
        Get
            Return GetFieldValue(name)
        End Get
    End Property

#End Region

#Region " Column Type Methods "

    Private Function IsHeaderColumn(ByVal columnName As String) As Boolean

        Return mHeaderColumnNames.Contains(columnName)

    End Function

    Private Function IsStrataColumn(ByVal columnName As String) As Boolean

        Return mStrataColumnNames.Contains(columnName)

    End Function

    Private Function IsMiscColumn(ByVal columnName As String) As Boolean

        Return mMiscColumnNames.Contains(columnName)

    End Function

    Private Function IsHDOSLColumn(ByVal columnName As String) As Boolean

        Return mHDOSLColumnNames.Contains(columnName)

    End Function

    Private Function IsPatientAdminColumn(ByVal columnName As String) As Boolean

        Return mPatientAdminColumnNames.Contains(columnName)

    End Function

    Private Function IsPatientResponseColumn(ByVal columnName As String) As Boolean

        Return mPatientResponseColumnAliases.ContainsKey(columnName)

    End Function

    Private Function IsPatientResponseOptionalColumn(ByVal columnName As String) As Boolean

        Return mPatientResponseOptionalColumnAliases.ContainsKey(columnName)

    End Function

    Private Function GetColumnName(ByVal ordinal As Integer) As String

        If mHasMultipleFacility = True Then
            Select Case mCurrentResultSet
                Case 0
                    Return mHDOSLSchema.Rows(ordinal)(0).ToString

                Case 1
                    Return mHeaderSchema.Rows(ordinal)(0).ToString

                Case 2
                    Return mResponseSchema.Rows(ordinal)(0).ToString

                Case 3
                    Return mMiscSchema.Rows(ordinal)(0).ToString

            End Select
        Else
            Select Case mCurrentResultSet
                Case 0
                    Return mHDOSLSchema.Rows(ordinal)(0).ToString

                Case 1
                    Return mHeaderSchema.Rows(ordinal)(0).ToString

                Case 2
                    Return mResponseSchema.Rows(ordinal)(0).ToString

                Case 3
                    Return mMiscSchema.Rows(ordinal)(0).ToString

            End Select
        End If

        Throw New ExportFileCreationException(String.Format("Error Getting Column Name at ordinal {0}.", ordinal))

    End Function

#End Region

#Region " Get Field Methods "

    Private Function GetFieldValue(ByVal columnName As String) As Object

        If mHasMultipleFacility = True Then
            Select Case mCurrentResultSet
                Case 0
                    If IsHDOSLColumn(columnName) Then
                        Return GetHDOSLField(columnName)
                    End If

                Case 1
                    If IsHeaderColumn(columnName) Then
                        Return GetHeaderField(columnName)
                    End If

                Case 2
                    'If we are reading from patient result set then try to get a patient column
                    If IsPatientAdminColumn(columnName) Then
                        Return GetPatientAdminField(columnName)
                    End If

                    If IsPatientResponseColumn(columnName) Then
                        If mReader.Item("Rtrn_dt") Is DBNull.Value Then
                            Return DBNull.Value
                        Else
                            Return GetPatientResponseField(columnName)
                        End If
                    End If

                    If IsPatientResponseOptionalColumn(columnName) Then
                        If mReader.Item("Rtrn_dt") Is DBNull.Value Then
                            Return DBNull.Value
                        Else
                            Return GetPatientResponseOptionalField(columnName)
                        End If
                    End If

                Case 3
                    If IsMiscColumn(columnName) Then
                        Return GetMiscField(columnName)
                    End If

            End Select
        Else
            Select Case mCurrentResultSet
                Case 0
                    If IsHDOSLColumn(columnName) Then
                        Return GetHDOSLField(columnName)
                    End If

                Case 1
                    If IsHeaderColumn(columnName) Then
                        Return GetHeaderField(columnName)
                    End If

                Case 2
                    'If we are reading from patient result set then try to get a patient column
                    If IsPatientAdminColumn(columnName) Then
                        Return GetPatientAdminField(columnName)
                    End If

                    If IsPatientResponseColumn(columnName) Then
                        If mReader.Item("Rtrn_dt") Is DBNull.Value Then
                            Return DBNull.Value
                        Else
                            Return GetPatientResponseField(columnName)
                        End If
                    End If

                    If IsPatientResponseOptionalColumn(columnName) Then
                        If mReader.Item("Rtrn_dt") Is DBNull.Value Then
                            Return DBNull.Value
                        Else
                            Return GetPatientResponseOptionalField(columnName)
                        End If
                    End If

                Case 3
                    If IsMiscColumn(columnName) Then
                        Return GetMiscField(columnName)
                    End If

            End Select
        End If

        Throw New ExportFileCreationException(String.Format("The column '{0}' is not a known CMS column", columnName))

    End Function

    Protected Overridable Function GetHeaderField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "PROVIDER-NAME"
                If String.IsNullOrEmpty(mReader.Item("MedicareName").ToString) Then
                    Throw New ExportFileCreationException("The column 'MedicareName' (provider-name) cannot be empty")
                End If
                Return mReader.Item("MedicareName")

            Case "PROVIDER-ID"
                If String.IsNullOrEmpty(mReader.Item("MedicareNumber").ToString) Then
                    Throw New ExportFileCreationException("The column 'MedicareNumber' (provider-id) cannot be empty")
                End If
                Return RecodeProviderID(mReader.Item("MedicareNumber"))

            Case "NPI"
                '04-15-08 JJF - Added to the file but not yet used
                Return ""

            Case "DISCHARGE-YR"
                If String.IsNullOrEmpty(mReader.Item("DisYear").ToString) Then
                    Throw New ExportFileCreationException("The column 'DisYear' (discharge-yr) cannot be empty")
                End If
                Return mReader.Item("DisYear")

            Case "DISCHARGE-MONTH"
                If String.IsNullOrEmpty(mReader.Item("DisMonth").ToString) Then
                    Throw New ExportFileCreationException("The column 'DisMonth' (discharge-month) cannot be empty")
                End If
                Return SetLeadingZeros(mReader.Item("DisMonth").ToString, 2)

            Case "SURVEY-MODE"
                If mReader.Item("Method").ToString.ToUpper = "MIXED" Then
                    Throw New ExportFileCreationException("The column 'Method' (survey-mode) cannot have more than one value.  There are patients in the export that have different Mail Methodologies")
                End If
                Return RecodeSurveyMode(mReader.Item("Method"))

            Case "NUMBER-ELIGIBLE-DISCHARGE"
                Return mReader.Item("NumberEligible")

            Case "SAMPLE-SIZE"
                Return mReader.Item("SampleCount")

            Case "SAMPLE-TYPE"
                Return mReader.Item("SampleType")

            Case Else
                Throw New ExportFileCreationException(String.Format("Column '{0}' is not a known header column.", columnName))

        End Select

    End Function

    Private Function GetStrataField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "STRATA-NAME"
                If String.IsNullOrEmpty(mReader.Item("StrataName").ToString) Then
                    Throw New ExportFileCreationException("The column 'StrataName' (strata-name) cannot be empty")
                End If
                Return mReader.Item("StrataName")

            Case "DSRS-ELIGIBLE"
                If String.IsNullOrEmpty(mReader.Item("DsrsEligible").ToString) Then
                    Throw New ExportFileCreationException("The column 'DsrsEligible' (dsrs-eligible) cannot be empty")
                End If
                Return mReader.Item("DsrsEligible")

            Case "DSRS-SAMPLESIZE"
                If String.IsNullOrEmpty(mReader.Item("DsrsSampleSize").ToString) Then
                    Throw New ExportFileCreationException("The column 'DsrsSampleSize' (dsrs-samplesize) cannot be empty")
                End If
                Return mReader.Item("DsrsSampleSize")

            Case Else
                Throw New ExportFileCreationException(String.Format("Column '{0}' is not a known Strata column.", columnName))

        End Select

    End Function

    Private Function GetMiscField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "DELETEDCOUNT"
                Return mReader.Item("DeletedCount")

            Case Else
                Throw New ExportFileCreationException(String.Format("Column '{0}' is not a known Misc column.", columnName))

        End Select

    End Function

    Private Function GetHDOSLField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "DETERMINATION-OF-SERVICE-LINE"
                Return RecodeServiceLine()

            Case Else
                Throw New ExportFileCreationException(String.Format("Column '{0}' is not a known HDOSL column.", columnName))

        End Select

    End Function

    Protected Overridable Function GetPatientAdminField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "PROVIDER-ID"
                If String.IsNullOrEmpty(mReader.Item("Medicare").ToString) Then
                    Throw New ExportFileCreationException("The column 'Medicare' (provider-id) cannot be empty")
                End If
                Return RecodeProviderID(mReader.Item("Medicare"))

            Case "DISCHARGE-DATE"
                Return CType(mReader.Item("SmpEncDt"), Date).ToString

            Case "DISCHARGE-YR"
                Return CType(mReader.Item("SmpEncDt"), Date).Year

            Case "DISCHARGE-MONTH"
                Return SetLeadingZeros(CType(mReader.Item("SmpEncDt"), Date).Month.ToString, 2)

            Case "PATIENT-ID"
                Return mReader.Item("SampPop")

            Case "ADMISSION-SOURCE"
                Return RecodeHAdmissionSource(mReader.Item("HCAHPAdm"))

            Case "PRINCIPAL-REASON-ADMISSION"
                Return RecodeHServiceType(mReader.Item("HCAHPSER"))

            Case "DISCHARGE-STATUS"
                Return RecodeHDischargeStatus(mReader.Item("HCAHPDis"), CType(mReader.Item("SmpEncDt"), Date))

            Case "STRATA-NAME"
                If String.IsNullOrEmpty(mReader.Item("SampUnit").ToString) Then
                    Throw New ExportFileCreationException("The column 'Strata Name' (strata-name) cannot be empty")
                End If
                Return mReader.Item("SampUnit")

            Case "SURVEY-STATUS"
                Return RecodeHDisposition(mReader.Item("Dispostn"))

            Case "LANGUAGE"
                Dim recoLanguage As Integer
                Dim Method As String = CType(RecodeSurveyMode(mReader.Item("Method")), String)
                Try
                    'The HNQLDesc column may not alwasy exist.
                    'HCAHPS 2012 Audit Results. Requirement  2.
                    'There is not any condition that check Disposition.
                    'So, in case of a null or empty string will be return 1 (English)
                    recoLanguage = CType(RecodeLanguage(mReader.Item("LangID"), mReader.Item("HNQLDesc"), CType(mReader.Item("SmpEncDt"), Date)), Integer)
                Catch ex As Exception
                    recoLanguage = CType(RecodeLanguage(mReader.Item("LangID"), String.Empty, CType(mReader.Item("SmpEncDt"), Date)), Integer)
                End Try
                If Method = CType(Mode.Telephone, String) Then
                    If Not (recoLanguage = 1 Or recoLanguage = 2) Then
                        recoLanguage = 1
                    End If
                End If
                Return recoLanguage
            Case "LAG-TIME"
                Return ComputeLagTime()

            Case "SUPPLEMENTAL-QUESTION-COUNT"
                Return mReader.Item("numSuppl")

            Case "GENDER"
                Return RecodeGender(mReader.Item("Sex"))

            Case "PATIENT-AGE"
                Return RecodeHCatAge(mReader.Item("HCAHPSAG"))

            Case "SAMPSET"
                Return mReader.Item("SampSet")

            Case "COMPLETE"
                Return mReader.Item("Complete")

            Case "NUMBER-ATTEMPTS"
                Return mReader.Item("HNumAtts")

            Case Else
                Throw New ExportFileCreationException(String.Format("Column '{0}' is not a known Patient Administration column.", columnName))

        End Select

    End Function

    Private Function GetPatientResponseField(ByVal cmsName As String) As Object

        'Make sure the CMS field is defined in our alias list
        If Not mPatientResponseColumnAliases.ContainsKey(cmsName) Then
            Throw New ExportFileCreationException(String.Format("Unable to output column '{0}' because it is not a valid column alias.", cmsName))
        End If

        'Get the list of Question Core column names mapped to this CMS field
        Dim responseCol As PatientResponseColumn = mPatientResponseColumnAliases(cmsName)
        Dim coreList As List(Of String) = responseCol.CoreList

        'Mark all that apply questions can only have one core alias
        If responseCol.IsMarkAllThatApply Then
            If Not coreList.Count = 1 Then
                Throw New ExportFileCreationException("'Mark all that apply' responses must have exactly one question core alias")
            End If
            Dim core As String = coreList(0)
            Dim value As Object = Nothing

            Try
                value = mReader.Item(core)

            Catch ex As Exception
                value = DBNull.Value

            End Try

            Return GetRecodedCoreValue(core, value)
        Else
            Dim nonNullCount As Integer = 0
            Dim lastNonNull As String = ""

            'For each core column mapped to the CMS field, see if it has a result
            For Each core As String In coreList
                Try
                    If Not mReader.Item(core) Is DBNull.Value Then
                        nonNullCount += 1
                        lastNonNull = core
                        Exit For
                    End If

                Catch ex As Exception
                    'Do nothing

                End Try
            Next

            'If less than or more than one core column was found with results then throw an exception
            If nonNullCount <> 1 Then
                Throw New ExportFileCreationException(String.Format("Column '{0}' did not have one core column with a response.", cmsName))
            End If

            'If only one core column was found with results then return the recoded value for that particular core
            Return GetRecodedCoreValue(lastNonNull, mReader.Item(lastNonNull))
        End If

    End Function

    Private Function GetPatientResponseOptionalField(ByVal cmsName As String) As Object

        'Make sure the CMS field is defined in our alias list
        If Not mPatientResponseOptionalColumnAliases.ContainsKey(cmsName) Then
            Throw New ExportFileCreationException(String.Format("Unable to output column '{0}' because it is not a valid column alias.", cmsName))
        End If

        'Get the list of Question Core column names mapped to this CMS field
        Dim responseCol As PatientResponseColumn = mPatientResponseOptionalColumnAliases(cmsName)
        Dim coreList As List(Of String) = responseCol.CoreList
        Dim coreString As String = responseCol.CoreString
        Dim coreFound As Boolean
        Dim value As Object = Nothing

        'Determine the return value for the question
        If responseCol.IsMarkAllThatApply Then
            'This is a mark all that apply (multi-response question) so it can have only one core available
            If Not coreList.Count = 1 Then
                Throw New ExportFileCreationException(String.Format("Column {0} is a 'Mark all that apply' question and must have exactly one question core alias ({1})", cmsName, coreString))
            End If

            'Get the core to be used
            Dim core As String = coreList(0)

            'Determine if the core is in the schema
            If mReader.GetSchemaTable.Select(String.Format("ColumnName = '{0}'", core.ToUpper)).GetLength(0) > 0 Then
                'The core is in the schema
                coreFound = True
            End If

            'The core exists so determine the value
            If coreFound Then
                value = mReader.Item(core)
            Else
                value = DBNull.Value
            End If

            'Get the recoded response
            Return GetRecodedCoreOptionalValue(core, value, cmsName, coreFound, coreString)
        Else
            'This is a single resonse question
            Dim nonNullCount As Integer = 0
            Dim lastNonNull As String = ""

            'For each core column mapped to the CMS field, see if it has a result
            For Each core As String In coreList
                If mReader.GetSchemaTable.Select(String.Format("ColumnName = '{0}'", core.ToUpper)).GetLength(0) > 0 Then
                    coreFound = True
                    If Not mReader.Item(core) Is DBNull.Value Then
                        nonNullCount += 1
                        lastNonNull = core
                        Exit For
                    End If
                End If
            Next

            'The core exists so determine the value
            If coreFound Then
                'If less than or more than one core column was found with results then throw an exception
                If nonNullCount <> 1 Then
                    'Determine if we are inside the optional period for these questions
                    Dim dischargeDate As Date = CType(mReader.Item("SmpEncDt"), Date)
                    If dischargeDate >= AppConfig.Params("HCAHPSNewQuestionsOptionalStartDate").DateValue AndAlso dischargeDate < AppConfig.Params("HCAHPSNewQuestionsMandatoryStartDate").DateValue Then
                        'The discharge date is in the optional period so throw an exception indicating null value
                        Throw New ExportFileOptionalColumnNullException(String.Format("Column '{0}' did not have one core column ({1}) with a response.", cmsName, coreString))
                    Else
                        'The discharge date is outside of the range where the question is optional so throw an exception
                        Throw New ExportFileCreationException(String.Format("Column '{0}' did not have one core column ({1}) with a response.", cmsName, coreString))
                    End If
                End If

                'We made it to here so get the value
                value = mReader.Item(lastNonNull)
            Else
                value = DBNull.Value
            End If

            'If only one core column was found with results then return the recoded value for that particular core
            Return GetRecodedCoreOptionalValue(lastNonNull, value, cmsName, coreFound, coreString)
        End If

    End Function

    Protected Overridable Function GetRecodedCoreValue(ByVal columnName As String, ByVal value As Object) As Object

        Select Case columnName.ToUpper
            Case "Q018894", "Q018907", "Q018916"
                'Standard Two point scale
                Return RecodeStandard(value, 1, 2)

            Case "Q018929"
                'Standard Three point scale
                Return RecodeStandard(value, 1, 3)

            Case "Q018876", "Q018878", "Q018879", "Q018875", "Q018877", "Q018884", "Q018888", "Q018889", "Q018943"
                'Standard Four point scale
                Return RecodeStandard(value, 1, 4)

            Case "Q018945", "Q025541"
                'Standard Five point scale
                Return RecodeStandard(value, 1, 5)

            Case "Q018949"
                'Standard Six point scale
                Return RecodeStandard(value, 1, 6)

            Case "Q018941"
                '0-10 scale
                Return RecodeStandard(value, 0, 10)

            Case "Q018882"
                'Call button question
                Return RecodeCallButton(value)

            Case "Q023296A", "Q023296B", "Q023296C", "Q023296D", "Q023296E"
                'Race question
                Return RecodeRace(value, columnName.ToUpper)

            Case "Q018896"
                'Bathroom help question
                Return RecodeSkipable(value, "Q018894", 2, 1, 4)

            Case "Q018910"
                'pain control question
                Return RecodeSkipable(value, "Q018907", 2, 1, 4)

            Case "Q018911"
                'pain help
                Return RecodeSkipable(value, "Q018907", 2, 1, 4)

            Case "Q022560"
                'new medicine question
                Return RecodeSkipable(value, "Q018916", 2, 1, 4)

            Case "Q022547"
                'side effects question
                Return RecodeSkipable(value, "Q018916", 2, 1, 4)

            Case "Q018935"
                'help after discharge question
                Return RecodeSkipable(value, "Q018929", 3, 1, 2)

            Case "Q018937"
                'symptoms question
                Return RecodeSkipable(value, "Q018929", 3, 1, 2)

            Case "Q018952", "Q043350", "Q050860"
                'language-speak question
                Return RecodeLanguageSpeak(columnName, value)

            Case Else
                Return value

        End Select

    End Function

    Protected Overridable Function GetRecodedCoreOptionalValue(ByVal columnName As String, ByVal value As Object, ByVal cmsName As String, ByVal coreFound As Boolean, ByVal coreString As String) As Object

        'If the core was not found then determine what to do
        If Not coreFound Then
            'Get the discharge date
            Dim dischargeDate As Date = CType(mReader.Item("SmpEncDt"), Date)

            'The question does not exist
            If dischargeDate >= AppConfig.Params("HCAHPSNewQuestionsMandatoryStartDate").DateValue Then
                'The discharge date is after the date where this question is mandatory
                Throw New ExportFileOptionalColumnMissingException(String.Format("No QstnCores ({0}) exist in the study table for {1}!", coreString, cmsName))
            Else
                'The discharge date is in the range where the question is optional so return missing
                Return "M"
            End If
        End If

        'If we made it to here then do the recoding
        Select Case columnName.ToUpper
            Case "Q046866"
                'Standard Two point scale
                Return RecodeStandard(value, 1, 2)

            Case "Q046863", "Q046864"
                'Standard Four point scale
                Return RecodeStandard(value, 1, 4)

            Case "Q046867"
                'Standard Five point scale
                Return RecodeStandard(value, 1, 5)

            Case "Q046865"
                'Non-Standard Five point scale
                Return RecodeCtPurposeMed(value)

            Case Else
                Return value

        End Select

    End Function

#End Region

#Region " Recoding Methods "

    Public Shared Function RemoveAllLeadingZeros(ByVal fieldAsString As String) As String

        While fieldAsString.StartsWith("0")
            fieldAsString = fieldAsString.Substring(1, fieldAsString.Length - 1)
        End While

        Return fieldAsString

    End Function

    Public Shared Function SetLeadingZeros(ByVal fieldAsString As String, ByVal numberOfLeadingZeros As Integer) As String

        Dim i As Integer = 1
        For i = 1 To numberOfLeadingZeros - fieldAsString.Length
            fieldAsString = "0" & fieldAsString
        Next

        Return fieldAsString

    End Function

    Private Function RecodeProviderID(ByVal value As Object) As Object

        Return SetLeadingZeros(value.ToString, 6)

    End Function

    Private Function RecodeHAdmissionSource(ByVal value As Object) As Object

        'if a specific value comes in that needs to be recoded, enter it here
        If value Is DBNull.Value Then
            Return "9"
        ElseIf value.ToString.Trim = String.Empty Then
            Return "9"
        ElseIf value.ToString.ToUpper = "A" Then
            Return "9"
        ElseIf value.ToString.ToUpper = "D" Then
            Return "D"
        ElseIf value.ToString.ToUpper = "E" Then
            Return "E"
        ElseIf value.ToString.ToUpper = "F" Then
            Return "6"
        ElseIf value.ToString = "7" Then ''HCAHPS 2012 Audit Results. Requirement 3. Recode admissionsource. It should recode 1.
            Return "1"
        End If

        ' For invalid values, return 9
        Dim intVal As Integer
        Try
            intVal = CType(value, Integer)

        Catch ex As InvalidCastException
            Return "9"

        End Try

        ' Returns 9 if value isn't 1-9
        Select Case intVal
            Case 1 To 9
                If intVal = 3 Then
                    Return "9"
                Else
                    If intVal = 7 Then
                        intVal = 1
                    End If
                    Return RemoveAllLeadingZeros(intVal.ToString)
                End If

            Case Else
                Return "9"

        End Select

    End Function

    Private Function RecodeHServiceType(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Return "M"
        ElseIf value.ToString.Trim = String.Empty Then
            Return "M"
        ElseIf value.ToString.ToUpper = "X" Then
            Return "M"
        End If

        Dim intVal As Integer
        Try
            intVal = CType(value, Integer)

        Catch ex As InvalidCastException
            Return "M"

        End Try

        Select Case intVal
            Case 1, 2, 3
                Return RemoveAllLeadingZeros(intVal.ToString)

            Case 9
                Return "M"

            Case Else
                Return "M"

        End Select

    End Function

    Private Function RecodeHDischargeStatus(ByVal value As Object, ByVal sampleEncounterDate As Date) As Object

        If value Is DBNull.Value Then
            Return "M"
        ElseIf value.ToString.Trim = String.Empty Then
            Return "M"
        ElseIf value.ToString.ToUpper = "M" Then
            Return value
        End If

        Dim intVal As Integer
        Try
            intVal = CType(value, Integer)

        Catch ex As InvalidCastException
            Return "M"

        End Try

        If sampleEncounterDate >= AppConfig.Params("LanguageSpeakQstnCore50860StartDate").DateValue Then
            Select Case intVal
                Case 1 To 7, 20, 21, 40, 41, 42, 43, 50, 51, 61 To 66, 69, 70, 81 To 95
                    '"01","1","02","2","03","3","04","4","05","5","06","6","07","7","20","21","40","41","42","43","50","51","61","62","63","64","65","66","69","70","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"
                    Return RemoveAllLeadingZeros(value.ToString)

                Case Else
                    Return "M"

            End Select
        Else
            Select Case intVal
                Case 1 To 7, 20, 21, 41, 43, 50, 51, 61 To 66, 70
                    '"01","1","02","2","03","3","04","4","05","5","06","6","07","7","20","21","40","41","42","43","50","51","61","62","63","64","65","66","69","70","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"
                    Return RemoveAllLeadingZeros(value.ToString)

                Case 40, 42
                    Return "20" 'Expired
                Case 69
                    Return "70" 'Discharged/transfer
                Case 81
                    Return "1" 'Home care or self care
                Case 82
                    Return "2" 'Short-term general hospital
                Case 83
                    Return "3" 'Skilled nursing
                Case 84
                    Return "4" 'Intermediate
                Case 85
                    Return "5" 'Designated cancer
                Case 86
                    Return "6" 'Home with home health
                Case 87
                    Return "21" 'Discharged court/law
                Case 88
                    Return "43" 'Federal healthcare
                Case 89
                    Return "61" 'SNF swing bed
                Case 90
                    Return "62" 'Inpatient rehab
                Case 91
                    Return "63" 'Long-term care
                Case 92
                    Return "64" 'Certified Medicaid
                Case 93
                    Return "65" 'Psychiatric
                Case 94
                    Return "66" 'Critical Access
                Case 95
                    Return "70" 'Discharged/transfer to a heal care

                Case Else
                    Return "M"
            End Select
        End If
    End Function

    Protected Function RecodeSurveyMode(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Return ""
        End If

        Dim strValue As String = CType(value, String)
        Select Case strValue.ToUpper
            Case "MAIL ONLY"
                Return 1

            Case "TELEPHONE ONLY"
                Return 2

            Case "MIXED MODE"
                Return 3

            Case "IVR"
                Return 4

            Case "EXCEPTION"
                Return 5

            Case Else
                Return ""

        End Select

    End Function

    Private Function RecodeHDisposition(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Return "M"
        End If

        Select Case value.ToString
            Case "01", "02", "03", "04", "05", "06", "07", "08", "09"
                Return RemoveAllLeadingZeros(value.ToString)

            Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
                Return value.ToString

            Case Else
                Return "M"

        End Select

    End Function

    Private Function RecodeHCatAge(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Return "M"
        End If

        Select Case value.ToString
            Case "01", "02", "03", "04", "05", "06", "07", "08", "09"
                Return RemoveAllLeadingZeros(value.ToString)

            Case "00"
                Return "0"

            Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"
                Return value.ToString

            Case Else
                Return "M"

        End Select

    End Function

    Protected Function RecodeStandard(ByVal value As Object, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        If intVal >= minValue AndAlso intVal <= maxValue Then
            Return intVal
        Else
            Return "M"
        End If

    End Function

    Private Function RecodeCallButton(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        If intVal >= 1 AndAlso intVal <= 4 Then
            Return intVal
        ElseIf intVal = -89 Then
            Return 9
        Else
            Return "M"
        End If

    End Function

    Private Function RecodeRace(ByVal value As Object, ByVal columnName As String) As Object

        If value Is DBNull.Value Then
            Dim raceQuestions As String() = New String() {"Q023296A", "Q023296B", "Q023296C", "Q023296D", "Q023296E"}
            'Check each corresponding question, if any was not null then return 0
            For Each qstn As String In raceQuestions
                If qstn <> columnName Then
                    If mReader.Item(qstn) IsNot DBNull.Value Then
                        Return 0
                    End If
                End If
            Next

            'If all other questions were null then return "M"
            Return "M"
        Else
            'Return a 1 if the value was between 1-5
            Dim intVal As Integer = CType(value, Integer)
            If intVal >= 1 AndAlso intVal <= 5 Then
                Return 1
            Else
                Throw New ExportFileCreationException(String.Format("A value of {0} is not expected for question Q023296.", intVal))
            End If
        End If

    End Function

    Private Function RecodeSkipable(ByVal value As Object, ByVal screenQuestion As String, ByVal skipValue As Integer, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        'If question was skipped determine if it was correctly or incorrectly skipped
        If intVal = -9 Then
            'If screening question = skipValue recode to 8
            'otherwise return M (incorrectly skipped, blank, multi-marked)
            Dim screen As Object = mReader.Item(screenQuestion)
            If CType(screen, Integer) = skipValue Then
                Return 8
            Else
                Return "M"
            End If
        ElseIf intVal = -8 Then
            Return "M"
        Else
            'If the value is > 10000 then we need to subtract it off
            If intVal >= 10000 Then intVal -= 10000

            'Verify the value is in the correct range
            If intVal >= minValue AndAlso intVal <= maxValue Then
                Return intVal
            Else
                Throw New ExportFileCreationException("An out of range value was encountered.")
            End If
        End If

    End Function

    Private Function RecodeLanguage(ByVal value As Object, ByVal langdesc As Object, ByVal sampleEncounterDate As Date) As Object
        'HCAHPS 2012 Audit Results
        '
        If value Is DBNull.Value Then
            Return 1
        ElseIf value.ToString.Trim = String.Empty Then
            Return 1
        End If

        If langdesc IsNot DBNull.Value AndAlso langdesc.ToString.Trim <> String.Empty Then
            Select Case langdesc.ToString.ToUpper.Trim
                Case HCAHPSLanguages.Chinese.ToString.ToUpper
                    Return HCAHPSLanguages.Chinese
                Case HCAHPSLanguages.Russian.ToString.ToUpper
                    Return HCAHPSLanguages.Russian
                Case HCAHPSLanguages.Vietnamese.ToString.ToUpper
                    Return HCAHPSLanguages.Vietnamese
                Case HCAHPSLanguages.Portuguese.ToString.ToUpper 'Portuguese as of July, 2014
                    If sampleEncounterDate >= AppConfig.Params("LanguageSpeakQstnCore50860StartDate").DateValue Then
                        Return HCAHPSLanguages.Portuguese
                    End If
            End Select
        End If

        Dim intVal As Integer = CType(value, Integer)
        Select Case intVal
            Case 1          'English
                Return HCAHPSLanguages.English
            Case 2, 8, 18, 19  'Spanish
                Return HCAHPSLanguages.Spanish
            Case 27         'Chinese
                Return HCAHPSLanguages.Chinese
            Case 29         'Russian
                Return HCAHPSLanguages.Russian
            Case 30         'Vietnamese
                Return HCAHPSLanguages.Vietnamese
            Case 14         'Portuguese as of July, 2014
                Return IIf(sampleEncounterDate >= AppConfig.Params("LanguageSpeakQstnCore50860StartDate").DateValue, HCAHPSLanguages.Portuguese, 8)

            Case Else
                Return 8 '8 means missing

        End Select

    End Function

    Private Function ComputeLagTime() As Object

        Dim lagTime As Integer

        'Get the discharge date
        Dim dischargeDate As Date = CType(mReader.Item("SmpEncDt"), Date)

        'Determine method of calculation
        If dischargeDate >= AppConfig.Params("LagTimeColumnStartDate").DateValue Then
            'Use the LagTime column
            If mReader.GetSchemaTable.Select("ColumnName = 'LagTime'").GetLength(0) > 0 Then
                'LagTime column exists
                If Integer.TryParse(mReader.Item("LagTime").ToString, lagTime) Then
                    If lagTime >= 0 AndAlso lagTime <= 365 Then
                        Return lagTime
                    Else
                        Throw New ExportFileCreationException(String.Format("{0} is an invalid value for field lag-time.  lag-time must be between 0-365.", lagTime))
                    End If
                Else
                    Throw New ExportFileCreationException(String.Format("{0} is an invalid value for field lag-time.  lag-time must be between 0-365.", lagTime))
                End If
            Else
                'The LagTime column does not exist in the schema
                Throw New ExportFileCreationException("LagTime column does not exist in BigTable.")
            End If
        Else
            'Use the old method of calculation
            If mReader.Item("Rtrn_dt") Is DBNull.Value Then
                Return 888
            Else
                Dim returnDate As Date = CType(mReader.Item("Rtrn_dt"), Date)
                lagTime = returnDate.Subtract(dischargeDate).Days
                If lagTime >= 0 AndAlso lagTime <= 365 Then
                    Return lagTime
                Else
                    Throw New ExportFileCreationException(String.Format("{0} is an invalid value for field lag-time.  lag-time must be between 0-365.", lagTime))
                End If
            End If
        End If

    End Function

    Private Function RecodeGender(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Return "M"
        Else
            Dim str As String = value.ToString.ToUpper
            Select Case str
                Case "M"
                    Return 1

                Case "F"
                    Return 2

                Case Else
                    Return "M"

            End Select
        End If

    End Function

    Private Function RecodeServiceLine() As Object

        'Recoder Business Rules:
        'Any single value pulls through as itself (e.g. 1 = 1)
        'Any combination of 1, 2, and/or 3 recodes to 3 (e.g. 1 & 3 = 3, 1 & 2 = 3) 
        'Anything combined with -1 recodes to -1 (e.g. 2 & -1 = -1) --> -1 = field doesn't exist in dataset
        'Anything combined with NULL recodes to Null (e.g. 1 & NULL = NULL)
        'Anything combined with 4 recodes to 7 (e.g. 3 & 4 = 7)
        'Anything combined with 5 recodes to 7 (e.g. 4 & 5 = 7)
        'Anything combined with 6 recodes to 7 (e.g. 5 & 6 = 7)
        'Anything combined with 7 recodes to 7 (e.g. 6 & 7 = 7)
        'If we recode the DOSL to a 7, it should result in a TPS report with the message.
        'If we receive a value of 7, alone or in combination, there should be no TPS.

        Dim serviceLines As New Collection

        While mReader.Read
            serviceLines.Add(mReader.Item("HDOSL").ToString, mReader.Item("HDOSL").ToString.Trim)
        End While


        If serviceLines.Count = 1 Then
            Return serviceLines.Item(1).ToString.Trim

        ElseIf serviceLines.Contains("-1") Then
            Return "-1"

        ElseIf serviceLines.Contains(String.Empty) Then
            Return String.Empty

        ElseIf serviceLines.Contains("4") OrElse serviceLines.Contains("5") OrElse serviceLines.Contains("6") Then
            Return "R7"

        ElseIf serviceLines.Contains("7") Then
            Return "7"

        Else
            Return "3"

        End If

    End Function

    Protected Function RecodeLanguageSpeak(ByVal columnName As String, ByVal value As Object) As Object

        'Check for null value
        If value Is DBNull.Value Then
            Throw New ExportFileCreationException(String.Format("Unexpected NULL value encountered for language-speak ({0}).", columnName))
        End If

        'Get the integer value
        Dim intVal As Integer = CType(value, Integer)

        'Get the discharge date
        Dim dischargeDate As Date = CType(mReader.Item("SmpEncDt"), Date)

        'Determine how to recode based on date and core
        If dischargeDate < AppConfig.Params("LanguageSpeakQstnCore43350StartDate").DateValue Then
            'This is before the 43350 cutoff date
            If columnName = "Q018952" Then
                'This is the old question
                If intVal >= 1 AndAlso intVal <= 3 Then
                    Return intVal
                Else
                    Return "M"
                End If
            ElseIf columnName = "Q043350" Then
                'This is the newer question
                If intVal >= 1 AndAlso intVal <= 3 Then
                    Return intVal
                ElseIf intVal > 3 AndAlso intVal <= 6 Then
                    Return 3
                Else
                    Return "M"
                End If
            Else 'If columnName = "Q050860" Then
                'This is the newest question
                If intVal >= 1 AndAlso intVal <= 3 Then
                    Return intVal
                ElseIf intVal > 3 AndAlso intVal <= 7 Then
                    Return 3
                Else
                    Return "M"
                End If
            End If
        ElseIf dischargeDate < AppConfig.Params("LanguageSpeakQstnCore50860StartDate").DateValue Then
            'This is after the 43350 cutoff date and before the 50860 cutoff date
            If columnName = "Q018952" Then
                'This is the old question
                mLanguageSpeakOldCoreUsedTPS = True
                If intVal >= 1 AndAlso intVal <= 2 Then
                    Return intVal
                ElseIf intVal = 3 Then
                    Return 6
                Else
                    Return "M"
                End If
            ElseIf columnName = "Q043350" Then
                'This is the newer question
                If intVal >= 1 AndAlso intVal <= 6 Then
                    Return intVal
                Else
                    Return "M"
                End If
            Else 'If columnName = "Q050860" Then
                'This is the newest question
                If intVal >= 1 AndAlso intVal <= 6 Then
                    Return intVal
                ElseIf intVal = 7 Then
                    Return 6
                Else
                    Return "M"
                End If
            End If
        Else
            'This is after the 50860 cutoff date
            If columnName = "Q018952" Then
                'This is the old question
                mLanguageSpeakOldCoreUsedTPS = True
                If intVal >= 1 AndAlso intVal <= 2 Then
                    Return intVal
                ElseIf intVal = 3 Then
                    Return 9
                Else
                    Return "M"
                End If
            ElseIf columnName = "Q043350" Then
                'This is the newer question
                If intVal >= 1 AndAlso intVal <= 5 Then
                    Return intVal
                ElseIf intVal = 6 Then
                    Return 9
                Else
                    Return "M"
                End If
            Else 'If columnName = "Q050860" Then
                'This is the newest question
                If intVal >= 1 AndAlso intVal <= 6 Then
                    Return intVal
                ElseIf intVal = 7 Then
                    Return 9
                Else
                    Return "M"
                End If
            End If
        End If

    End Function

    Private Function RecodeCtPurposeMed(ByVal value As Object) As Object

        If value Is DBNull.Value Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        If intVal >= 1 AndAlso intVal <= 4 Then
            Return intVal
        ElseIf intVal = -89 Then
            Return 5
        Else
            Return "M"
        End If

    End Function

#End Region

#Region " IDisposable Support "

    Private disposedValue As Boolean        ' To detect redundant calls

    ' IDisposable
    Protected Sub Dispose(ByVal disposing As Boolean)

        If Not disposedValue Then
            If disposing Then
                ' TODO: free unmanaged resources when explicitly called
            End If

            ' TODO: free shared unmanaged resources
        End If
        disposedValue = True

    End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose

        ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)

    End Sub

#End Region

#Region " PatientResponseColumn Class "

    Private Class PatientResponseColumn

        Private mIsMarkAllThatApply As Boolean
        Private mCoreList As New List(Of String)

        Public Property IsMarkAllThatApply() As Boolean
            Get
                Return mIsMarkAllThatApply
            End Get
            Set(ByVal value As Boolean)
                mIsMarkAllThatApply = value
            End Set
        End Property

        Public ReadOnly Property CoreList() As List(Of String)
            Get
                Return mCoreList
            End Get
        End Property

        Public ReadOnly Property CoreString() As String
            Get
                Dim list As String = String.Empty

                For Each core As String In mCoreList
                    If list.Length = 0 Then
                        list = core
                    Else
                        list &= String.Format(",{0}", core)
                    End If
                Next

                Return list
            End Get
        End Property

        Public Sub New(ByVal isMarkAllThatApply As Boolean)

            mIsMarkAllThatApply = isMarkAllThatApply

        End Sub

    End Class

#End Region

End Class
