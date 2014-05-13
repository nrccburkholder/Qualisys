Public MustInherit Class Column
    Implements ICloneable

#Region " Public Constants "

    Public Shared COLUMN_NAME_MAX_CHARS As Integer = 128
    Public Shared MAX_VARCHAR_LENGTH As Integer = 8000
    Public Shared DEFAULT_COLUMN_NAME As String = "COL"

#End Region

#Region " Private Members "

    Protected mColumnName As String
    Protected mDataType As DataTypes
    Protected mLength As Integer
    Protected mOrdinal As Integer
    Protected mParent As DTSDataSet

    Private Shared mSqlServerKeywords() As String = {"ADD", "EXCEPT", "PERCENT", "ALL", "EXEC", "PLAN", "ALTER", "EXECUTE", "PRECISION", "AND", "EXISTS", "PRIMARY", _
                                                     "ANY", "EXIT", "PRINT", "AS", "FETCH", "PROC", "ASC", "FILE", "PROCEDURE", "AUTHORIZATION", "FILLFACTOR", "PUBLIC", _
                                                     "BACKUP", "FOR", "RAISERROR", "BEGIN", "FOREIGN", "READ", "BETWEEN", "FREETEXT", "READTEXT", "BREAK", "FREETEXTTABLE", _
                                                     "RECONFIGURE", "BROWSE", "FROM", "REFERENCES", "BULK", "FULL", "REPLICATION", "BY", "FUNCTION", "RESTORE", "CASCADE", _
                                                     "GOTO", "RESTRICT", "CASE", "GRANT", "RETURN", "CHECK", "GROUP", "REVOKE", "CHECKPOINT", "HAVING", "RIGHT", "CLOSE", _
                                                     "HOLDLOCK", "ROLLBACK", "CLUSTERED", "IDENTITY", "ROWCOUNT", "COALESCE", "IDENTITY_INSERT", "ROWGUIDCOL", "COLLATE", _
                                                     "IDENTITYCOL", "RULE", "COLUMN", "IF", "SAVE", "COMMIT", "IN", "SCHEMA", "COMPUTE", "INDEX", "SELECT", "CONSTRAINT", _
                                                     "INNER", "SESSION_USER", "CONTAINS", "INSERT", "SET", "CONTAINSTABLE", "INTERSECT", "SETUSER", "CONTINUE", "INTO", _
                                                     "SHUTDOWN", "CONVERT", "IS", "SOME", "CREATE", "JOIN", "STATISTICS", "CROSS", "KEY", "SYSTEM_USER", "CURRENT", "KILL", _
                                                     "TABLE", "CURRENT_DATE", "LEFT", "TEXTSIZE", "CURRENT_TIME", "LIKE", "THEN", "CURRENT_TIMESTAMP", "LINENO", "TO", _
                                                     "CURRENT_USER", "LOAD", "TOP", "CURSOR", "NATIONAL", "TRAN", "DATABASE", "NOCHECK", "TRANSACTION", "DBCC", _
                                                     "NONCLUSTERED", "TRIGGER", "DEALLOCATE", "NOT", "TRUNCATE", "DECLARE", "NULL", "TSEQUAL", "DEFAULT", "NULLIF", _
                                                     "UNION", "DELETE", "OF", "UNIQUE", "DENY", "OFF", "UPDATE", "DESC", "OFFSETS", "UPDATETEXT", "DISK", "ON", "USE", _
                                                     "DISTINCT", "OPEN", "USER", "DISTRIBUTED", "OPENDATASOURCE", "VALUES", "DOUBLE", "OPENQUERY", "VARYING", "DROP", _
                                                     "OPENROWSET", "VIEW", "DUMMY", "OPENXML", "WAITFOR", "DUMP", "OPTION", "WHEN", "ELSE", "OR", "WHERE", "END", "ORDER", _
                                                     "WHILE", "ERRLVL", "OUTER", "WITH", "ESCAPE", "OVER", "WRITETEXT"}

    Private Shared mOdbcKeywords() As String = {"ABSOLUTE", "EXEC", "OVERLAPS", "ACTION", "EXECUTE", "PAD", "ADA", "EXISTS", "PARTIAL", "ADD", "EXTERNAL", "PASCAL", "ALL", _
                                                "EXTRACT", "POSITION", "ALLOCATE", "FALSE", "PRECISION", "ALTER", "FETCH", "PREPARE", "AND", "FIRST", "PRESERVE", "ANY", _
                                                "FLOAT", "PRIMARY", "ARE", "FOR", "PRIOR", "AS", "FOREIGN", "PRIVILEGES", "ASC", "FORTRAN", "PROCEDURE", "ASSERTION", _
                                                "FOUND", "PUBLIC", "AT", "FROM", "READ", "AUTHORIZATION", "FULL", "REAL", "AVG", "GET", "REFERENCES", "BEGIN", "GLOBAL", _
                                                "RELATIVE", "BETWEEN", "GO", "RESTRICT", "BIT", "GOTO", "REVOKE", "BIT_LENGTH", "GRANT", "RIGHT", "BOTH", "GROUP", _
                                                "ROLLBACK", "BY", "HAVING", "ROWS", "CASCADE", "HOUR", "SCHEMA", "CASCADED", "IDENTITY", "SCROLL", "CASE", "IMMEDIATE", _
                                                "SECOND", "CAST", "IN", "SECTION", "CATALOG", "INCLUDE", "SELECT", "CHAR", "INDEX", "SESSION", "CHAR_LENGTH", "INDICATOR", _
                                                "SESSION_USER", "CHARACTER", "INITIALLY", "SET", "CHARACTER_LENGTH", "INNER", "SIZE", "CHECK", "INPUT", "SMALLINT", "CLOSE", _
                                                "INSENSITIVE", "SOME", "COALESCE", "INSERT", "SPACE", "COLLATE", "INT", "SQL", "COLLATION", "INTEGER", "SQLCA", "COLUMN", _
                                                "INTERSECT", "SQLCODE", "COMMIT", "INTERVAL", "SQLERROR", "CONNECT", "INTO", "SQLSTATE", "CONNECTION", "IS", "SQLWARNING", _
                                                "CONSTRAINT", "ISOLATION", "SUBSTRING", "CONSTRAINTS", "JOIN", "SUM", "CONTINUE", "KEY", "SYSTEM_USER", "CONVERT", _
                                                "LANGUAGE", "TABLE", "CORRESPONDING", "LAST", "TEMPORARY", "COUNT", "LEADING", "THEN", "CREATE", "LEFT", "TIME", "CROSS", _
                                                "LEVEL", "TIMESTAMP", "CURRENT", "LIKE", "TIMEZONE_HOUR", "CURRENT_DATE", "LOCAL", "TIMEZONE_MINUTE", "CURRENT_TIME", _
                                                "LOWER", "TO", "CURRENT_TIMESTAMP", "MATCH", "TRAILING", "CURRENT_USER", "MAX", "TRANSACTION", "CURSOR", "MIN", "TRANSLATE", _
                                                "DATE", "MINUTE", "TRANSLATION", "DAY", "MODULE", "TRIM", "DEALLOCATE", "MONTH", "TRUE", "DEC", "NAMES", "UNION", "DECIMAL", _
                                                "NATIONAL", "UNIQUE", "DECLARE", "NATURAL", "UNKNOWN", "DEFAULT", "NCHAR", "UPDATE", "DEFERRABLE", "NEXT", "UPPER", _
                                                "DEFERRED", "NO", "USAGE", "DELETE", "NONE", "USER", "DESC", "NOT", "USING", "DESCRIBE", "NULL", "VALUE", "DESCRIPTOR", _
                                                "NULLIF", "VALUES", "DIAGNOSTICS", "NUMERIC", "VARCHAR", "DISCONNECT", "OCTET_LENGTH", "VARYING", "DISTINCT", "OF", "VIEW", _
                                                "DOMAIN", "ON", "WHEN", "DOUBLE", "ONLY", "WHENEVER", "DROP", "OPEN", "WHERE", "ELSE", "OPTION", "WITH", "END", "OR", _
                                                "WORK", "END-EXEC", "ORDER", "WRITE", "ESCAPE", "OUTER", "YEAR", "EXCEPT", "OUTPUT", "ZONE", "EXCEPTION"}

    Private Shared mFutureKeywords() As String = {"ABSOLUTE", "FOUND", "PRESERVE", "ACTION", "FREE", "PRIOR", "ADMIN", "GENERAL", "PRIVILEGES", "AFTER", "GET", "READS", _
                                                  "AGGREGATE", "GLOBAL", "REAL", "ALIAS", "GO", "RECURSIVE", "ALLOCATE", "GROUPING", "REF", "ARE", "HOST", "REFERENCING", _
                                                  "ARRAY", "HOUR", "RELATIVE", "ASSERTION", "IGNORE", "RESULT", "AT", "IMMEDIATE", "RETURNS", "BEFORE", "INDICATOR", "ROLE", _
                                                  "BINARY", "INITIALIZE", "ROLLUP", "BIT", "INITIALLY", "ROUTINE", "BLOB", "INOUT", "ROW", "BOOLEAN", "INPUT", "ROWS", _
                                                  "BOTH", "INT", "SAVEPOINT", "BREADTH", "INTEGER", "SCROLL", "CALL", "INTERVAL", "SCOPE", "CASCADED", "ISOLATION", _
                                                  "SEARCH", "CAST", "ITERATE", "SECOND", "CATALOG", "LANGUAGE", "SECTION", "CHAR", "LARGE", "SEQUENCE", "CHARACTER", "LAST", _
                                                  "SESSION", "CLASS", "LATERAL", "SETS", "CLOB", "LEADING", "SIZE", "COLLATION", "LESS", "SMALLINT", "COMPLETION", "LEVEL", _
                                                  "SPACE", "CONNECT", "LIMIT", "SPECIFIC", "CONNECTION", "LOCAL", "SPECIFICTYPE", "CONSTRAINTS", "LOCALTIME", "SQL", _
                                                  "CONSTRUCTOR", "LOCALTIMESTAMP", "SQLEXCEPTION", "CORRESPONDING", "LOCATOR", "SQLSTATE", "CUBE", "MAP", "SQLWARNING", _
                                                  "CURRENT_PATH", "MATCH", "START", "CURRENT_ROLE", "MINUTE", "--STATE--", "CYCLE", "MODIFIES", "STATEMENT", "DATA", _
                                                  "MODIFY", "STATIC", "DATE", "MODULE", "STRUCTURE", "DAY", "MONTH", "TEMPORARY", "DEC", "NAMES", "TERMINATE", "DECIMAL", _
                                                  "NATURAL", "THAN", "DEFERRABLE", "NCHAR", "TIME", "DEFERRED", "NCLOB", "TIMESTAMP", "DEPTH", "NEW", "TIMEZONE_HOUR", _
                                                  "DEREF", "NEXT", "TIMEZONE_MINUTE", "DESCRIBE", "NO", "TRAILING", "DESCRIPTOR", "NONE", "TRANSLATION", "DESTROY", _
                                                  "NUMERIC", "TREAT", "DESTRUCTOR", "OBJECT", "TRUE", "DETERMINISTIC", "OLD", "UNDER", "DICTIONARY", "ONLY", "UNKNOWN", _
                                                  "DIAGNOSTICS", "OPERATION", "UNNEST", "DISCONNECT", "ORDINALITY", "USAGE", "DOMAIN", "OUT", "USING", "DYNAMIC", "OUTPUT", _
                                                  "VALUE", "EACH", "PAD", "VARCHAR", "END-EXEC", "PARAMETER", "VARIABLE", "EQUALS", "PARAMETERS", "WHENEVER", "EVERY", _
                                                  "PARTIAL", "WITHOUT", "EXCEPTION", "PATH", "WORK", "EXTERNAL", "POSTFIX", "WRITE", "FALSE", "PREFIX", "YEAR", "FIRST", _
                                                  "PREORDER", "ZONE", "FLOAT", "PREPARE"}

#End Region

#Region " Public Properties "

    Public Property ColumnName() As String
        Get
            Return mColumnName
        End Get
        Set(ByVal Value As String)
            mColumnName = Value
        End Set
    End Property

    Public Property DataType() As DataTypes
        Get
            Return mDataType
        End Get
        Set(ByVal Value As DataTypes)
            mDataType = Value
        End Set
    End Property

    Public Property Length() As Integer
        Get
            Return mLength
        End Get
        Set(ByVal Value As Integer)
            mLength = Value
        End Set
    End Property

    Public Property Ordinal() As Integer
        Get
            Return mOrdinal
        End Get
        Set(ByVal Value As Integer)
            mOrdinal = Value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public Overridable ReadOnly Property Parent() As DTSDataSet
        Get
            Return mParent
        End Get
    End Property

#End Region

#Region " Constructors "

    Sub New()

        Me.New(Nothing)

    End Sub

    Sub New(ByVal Parent As DTSDataSet)

        mParent = Parent

    End Sub

#End Region

#Region " Public Methods "

    Public Function DataTypeString() As String

        Return System.Enum.GetName(DataType.GetType, DataType)

    End Function

    Public Overridable Function DataTypeStringFull() As String

        Return String.Format("{0}({1})", DataTypeString, Length)

    End Function

    Public Function IsValidColumnName(ByRef errMsg As String) As Boolean

        'Check if name is blank
        If mColumnName Is Nothing OrElse mColumnName.Trim = "" Then
            errMsg = "Column name can not be blank."
            Return False
        End If

        'Check the length
        If mColumnName.Length > COLUMN_NAME_MAX_CHARS Then
            errMsg = String.Format("Column name must contain from 1 through {0} characters", COLUMN_NAME_MAX_CHARS)
            Return False
        End If

        'Check if first character is valid
        If Not Char.IsLetter(mColumnName, 0) AndAlso mColumnName.Substring(0, 1) <> "_" AndAlso mColumnName.Substring(0, 1) <> "#" Then
            errMsg = String.Format("The first character of the column name must be one of the following:{0}alphabetic letter, {0}the underscore (_), or number sign (#)", vbCrLf)
            Return False
        End If

        'Check if subsequent characters are valid
        For cnt As Integer = 1 To mColumnName.Length - 1
            Dim character As Char = CChar(mColumnName.Substring(cnt, 1))
            If Not Char.IsLetterOrDigit(character) AndAlso character <> "_" AndAlso character <> "#" AndAlso character <> "$" AndAlso character <> "@" AndAlso character <> " " Then
                errMsg = String.Format("The subsequent characters of the column name must be one of the following:{0}{0}    alphabetic letter, {0}    decimal digit, {0}    the ""at"" sign (@), {0}    dollar sign ($), {0}    number sign (#), {0}    underscore (_), or{0}    space ( )", vbCrLf)
                Return False
            End If
        Next

        Dim colNameUpperCase As String = mColumnName.ToUpper

        'Check if it is a SQL Server reserved keyword
        If Array.IndexOf(mSqlServerKeywords, colNameUpperCase) >= 0 Then
            errMsg = "The column name must not be a Transact-SQL reserved word."
            Return False
        End If

        'Check if it is an ODBC reserved keyword
        If Array.IndexOf(mOdbcKeywords, colNameUpperCase) >= 0 Then
            errMsg = "The column name must not be an ODBC reserved keywords."
            Return False
        End If

        'Check if it is a future SQL Server reserved keywords
        If Array.IndexOf(mFutureKeywords, colNameUpperCase) >= 0 Then
            errMsg = "The column name must not be a future Transact-SQL reserved word."
            Return False
        End If

        Return True

    End Function

    Public Shared Function GetDefaultColumnName(ByVal colIndex As Integer) As String

        If colIndex < 1 OrElse colIndex > 999 Then
            Throw New ArgumentOutOfRangeException("colIndex", "Unable to generate default column name.  Column index must be between 1-999.")
        End If

        Return String.Format("{0}{1}", DEFAULT_COLUMN_NAME, colIndex.ToString.PadLeft(3, Char.Parse("0")))

    End Function

    Public MustOverride Function Clone() As Object Implements System.ICloneable.Clone

#End Region

End Class
