Option Explicit On

Namespace Miscellaneous.TableWriters
    ''' <summary>
    ''' This class parses each Field that will be writen to the database
    ''' </summary>
    ''' <remarks>
    ''' This class parses each Field that will be writen to the database.
    ''' 
    ''' There is some basic validation done within this class to make sure the values passed to this class don't break the SQL statements that will be passed to SQL server.
    ''' 
    ''' If there is any modification to the data made by this class a warning will be available within the warnings property
    ''' </remarks>
    Public Class TableItem

        Private _sColumnName As String
        Private _sFormatType As String
        Private _tFieldType As Type
        'Private _sRawValue As String = String.Empty
        Private _sWarnings(0) As String
        Private _iLenght As Integer
        Private _bIsNull As Boolean = True
        Private _bShowAllExceptions As Boolean = False
        Private _colTranslation As New Collection
        Private _oValue As Object
        'Private _bStringValidations As Boolean

        'require column name, type, and the raw value as input to the constructer
        Public Sub New(ByVal ColumnName As String, ByVal Format As String, Optional ByVal Lenght As Integer = 0)
            Dim sFormatType As String
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If

            Me._sColumnName = ColumnName.ToUpper
            _sFormatType = Format.ToUpper
            sFormatType = _sFormatType

            Try
                If sFormatType.Contains("CHAR") _
                    OrElse sFormatType.Contains("TEXT") _
                    OrElse sFormatType.Contains("STRING") Then

                    _tFieldType = Type.GetType("System.String", False, False)
                ElseIf sFormatType.Contains("INT") Then
                    _tFieldType = Type.GetType("System.Int64", False, False)
                ElseIf sFormatType = "DOUBLE" _
                    OrElse sFormatType = "FLOAT" _
                    OrElse sFormatType = "SINGLE" Then

                    _tFieldType = Type.GetType("System.Double", False, False)
                ElseIf sFormatType.Contains("DATE") Then
                    _tFieldType = Type.GetType("System.DateTime", False, False)
                ElseIf sFormatType = "BIT" OrElse sFormatType = "BOOLEAN" Then
                    _tFieldType = Type.GetType("System.Boolean", False, False)
                ElseIf sFormatType = "UNIQUEIDENTIFIER" OrElse sFormatType = "GUID" Then
                    _tFieldType = Type.GetType("System.Guid", False, False)
                Else
                    _tFieldType = Type.GetType("System." & sFormatType, False, False)
                End If
            Catch ex As Exception

            End Try

            If _tFieldType Is Nothing Then
                Throw New Exception("The type " & sFormatType & " is not supported by the Table Item object. Please use a supported Format type")
            End If

            Me._iLenght = Lenght

            Array.Resize(_sWarnings, 0)

        End Sub

        Public Sub New(ByVal ColumnName As String, ByVal Format As Type, Optional ByVal Lenght As Integer = 0)
            If Not Security.ValidateKey Then
                Throw New System.Exception("Not valid Security Key, Please provide a valid Security Key using the security class")
            End If

            Me._sColumnName = ColumnName.ToUpper
            _tFieldType = Format

            Me._iLenght = Lenght

            Array.Resize(_sWarnings, 0)
        End Sub

        ''' <summary>
        ''' Name of the column to be inserted into the table
        ''' </summary>
        Public ReadOnly Property ColumnName() As String
            Get
                Return _sColumnName
            End Get
        End Property

        Public ReadOnly Property DBValue() As Object
            Get
                If _bIsNull OrElse _oValue Is Nothing Then
                    Return DBNull.Value
                Else
                    Return _oValue
                End If
            End Get
        End Property

        ''' <summary>
        ''' Column type in the table
        ''' </summary>
        Public ReadOnly Property FormatType() As String
            Get
                Return _sFormatType
            End Get
        End Property

        ''' <summary>
        ''' Gets any warning generated when parsing a value
        ''' </summary>
        Public ReadOnly Property Warnings() As String
            Get
                Dim sResult As String = String.Empty
                Dim Warning As String

                For Each Warning In _sWarnings
                    sResult = sResult & Warning & vbCrLf
                Next

                Return sResult
            End Get
        End Property

        ''' <summary>
        ''' Value formated for table insertion
        ''' </summary>
        Public ReadOnly Property Value() As String
            Get
                'insert null into the database when we have no value
                If Me.IsNull Then
                    Return "NULL"
                End If

                'strings and dates require single qoutes in T-Sql
                Select Case Me.FormatType
                    Case "STRING", "DATE", "DATETIME", "VARCHAR", "CHAR", "TEXT", "NVARCHAR"
                        Return "'" & _oValue.ToString.Replace("'"c, "''") & "'"
                    Case "INTEGER", "INT", "SMALLINT", "DOUBLE", "FLOAT", "BIT", "BOOLEAN"
                        Return _oValue.ToString
                    Case Else
                        Return _oValue.ToString
                        '    Throw New System.Exception("Invalid type specified for the interpreter's SLWritable item")
                End Select
            End Get
        End Property


        ''' <summary>
        ''' Value without any formatting
        ''' </summary>
        Public ReadOnly Property RawValue() As String
            Get
                If Not _bIsNull Then
                    Return _oValue.ToString
                Else
                    Return ""
                End If
            End Get
        End Property

        Private Sub SetDBValue(ByVal NewValue As Object)
            _oValue = NewValue
            _bIsNull = False
        End Sub

        ''' <summary>
        ''' Sets the value that will be writen to the database
        ''' </summary>
        Public Sub SetValue(ByVal NewValue As Object)
            'Dim Value As String

            If NewValue.GetType() IsNot _tFieldType Then
                Try
                    SetDBValue(System.Convert.ChangeType(NewValue, _tFieldType))
                Catch ex As Exception
                    If _bShowAllExceptions Then
                        Throw
                    Else
                        Array.Resize(_sWarnings, _sWarnings.Length + 1)
                        _sWarnings(_sWarnings.Length - 1) = "Value '" & CStr(NewValue) & "' for " & _sColumnName & " is not a valid " & _tFieldType.Name & ". Value has been ignored"
                    End If
                End Try

                Exit Sub
            ElseIf _tFieldType IsNot Nothing Then
                If _tFieldType.Name.ToUpper = "STRING" Then
                    Dim ParsedValue As String
                    ParsedValue = CStr(NewValue).Trim

                    If _colTranslation.Count > 0 Then
                        If _colTranslation.Contains(ParsedValue.ToUpper) Then
                            SetDBValue(_colTranslation.Item(ParsedValue.ToUpper).ToString)
                        End If
                    ElseIf ParsedValue.Length > _iLenght AndAlso _iLenght >= 0 Then
                        If _bShowAllExceptions Then
                            Throw New Exception("Value '" & ParsedValue & "' for " & _sColumnName & " is " & _iLenght - ParsedValue.Length & " characters longer than the field in the database.")
                        Else
                            SetDBValue(ParsedValue.Substring(0, _iLenght))
                            Array.Resize(_sWarnings, _sWarnings.Length + 1)
                            _sWarnings(_sWarnings.Length - 1) = "Value '" & ParsedValue & "' for " & _sColumnName & " is " & _iLenght - ParsedValue.Length & " characters longer than the field in the database. The last characters have been dropped"
                        End If
                    Else
                        SetDBValue(ParsedValue)
                    End If

                    Exit Sub
                End If
            End If

            'Assumes that the value passed to this method is fine to be used as Query parameter
            'If there is an exception when writing to the database
            'add code above to handle the new exception
            SetDBValue(NewValue)
        End Sub

        ''' <summary>
        ''' Defines if the class should throw exceptions or just store the warnings in the warnings property
        ''' </summary>
        Public Property ShowAllExceptions() As Boolean
            Get
                Return _bShowAllExceptions
            End Get
            Set(ByVal value As Boolean)
                _bShowAllExceptions = value
            End Set
        End Property

        ''' <summary>
        ''' Clears the value, warnings, and filled flag for this item
        ''' </summary>
        Public Sub Clear()
            Array.Resize(_sWarnings, 0)
            '_sRawValue = String.Empty
            _bIsNull = True
        End Sub

        ''' <summary>
        ''' Shows if a value has been filled in this item
        ''' </summary>
        ''' <remarks>This flag will be cleared when the clear method is called</remarks>
        ''' <returns>Boolean</returns>
        Public Function IsNull() As Boolean
            Return _bIsNull
        End Function

        Public Property Lenght() As Integer
            Get
                Return _iLenght
            End Get
            Set(ByVal value As Integer)
                _iLenght = value
            End Set
        End Property

        ''' <summary>
        ''' Adds a translation mapping for value translations
        ''' </summary>
        ''' <remarks>
        ''' If there are no translations provided for an specific field, all the values will be allowed.
        ''' 
        ''' If there are translations, only the translated values will be allowed.
        ''' </remarks>
        Public Sub AddValueTranslation(ByVal ValueToUse As String, ByVal ValueAlias As String)
            ValueToUse = ValueToUse
            ValueAlias = ValueAlias.ToUpper
            If Not _colTranslation.Contains(ValueAlias) Then
                _colTranslation.Add(ValueToUse, ValueAlias)
            Else
                Throw New System.Exception("Alias name '" & ValueAlias & "' already exists in the translation list for Field " & Me.ColumnName & ". Please use a different Alias")
            End If
        End Sub

    End Class
End Namespace
