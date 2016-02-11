Imports Microsoft.ApplicationBlocks.Data

Public MustInherit Class clsDBEntity

    Public ConnectionString As String

    Protected _iEntityID As Integer = -1

    Protected _dsEntity As DataSet

    Protected _sErrorMsg As String = ""

    Protected _sSelectSQL As String

    Protected _sDeleteSQL As String

    Protected _sInsertSQL As String

    Protected _sUpdateSQL As String

    Protected _sTableName As String

    Sub New(ByVal ConnStr As String, Optional ByVal iEntityID As Integer = 0)
        ConnectionString = ConnStr
        Me.InitClass()

        If iEntityID > 0 Then
            Me._iEntityID = iEntityID
            Me.Fetch()

        Else
            Me.Clear()

        End If

    End Sub

    'Function to provide all class parameters, like _sTableName
    Protected MustOverride Sub InitClass()

    'Builds insert SQL from dataset
    Protected MustOverride Function GetInsertSQL() As String

    'Builds update SQL from dataset
    Protected MustOverride Function GetUpdateSQL() As String

    'Builds select SQL from dataset for search
    Protected MustOverride Function GetSearchSQL() As String

    'Builds delete SQL from dataset
    Protected MustOverride Function GetDeleteSQL() As String

    'Called by Create method to fill datarow with default values for new record
    Protected MustOverride Sub SetRecordDefaults(ByRef dr As DataRow)

    'Returns column values of dataset
    Default Public Overridable Property Details(ByVal sFieldName As String) As Object
        Get
            Try
                Return Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(sFieldName)

            Catch
                Return ""

            End Try

        End Get

        Set(ByVal Value As Object)
            Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(sFieldName) = Value

        End Set

    End Property

    'Return Entity Dataset
    Public Overridable Property DataSet() As DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me._dsEntity.Tables(Me._sTableName).Rows(0).Item(0)

                End If
            End If
        End Set

    End Property

    Public ReadOnly Property NamedDataSet(ByVal sName As String) As DataSet
        Get

            If sName.Length > 0 Then Me._dsEntity.DataSetName = sName

            Return Me._dsEntity

        End Get

    End Property


    Public Function VerifyNamedDataSet(ByVal ds As DataSet, ByVal sName As String) As Boolean

        If ds.DataSetName.ToUpper = sName.ToUpper Then
            'signed dataset matches signature
            Me.DataSet = ds
            Return True

        End If

        Return False

    End Function

    Public ReadOnly Property ErrorMsgs() As String
        Get
            Return Me._sErrorMsg
        End Get
    End Property

    'SELECT method
    Public Overridable Function GetDetails(Optional ByVal iEntityID As Integer = -1) As DataSet

        If iEntityID >= 0 Then Me._iEntityID = iEntityID

        If Me._iEntityID <> 0 Then
            'Use search criteria to select from entity table
            Return Fetch()

        Else
            'New entity, get new row data from entity table
            Return Create()

        End If

    End Function

    'INSERT/UPDATE method
    Public Overridable Function Submit() As Integer
        Dim sSQL As String
        Dim sMsg As String = ""

        sMsg = VerifyInsert()

        If sMsg.Length = 0 Then
            If Me._iEntityID = 0 Then

                'insert new entity
                sSQL = GetInsertSQL()
                sSQL &= "; SELECT ISNULL(@@IDENTITY,0) "

            Else
                'update entity
                sSQL = GetUpdateSQL()
                sSQL &= "; SELECT {0}"
                sSQL = String.Format(sSQL, Me._iEntityID)

            End If

            Try
                Me._iEntityID = CInt(SqlHelper.ExecuteScalar(Me.ConnectionString, CommandType.Text, sSQL))

                Return Me._iEntityID

            Catch
                Throw

            End Try

        Else
            Me._sErrorMsg &= sMsg
            Return 0

        End If

    End Function

    'DELETE method
    Public Overridable Function Delete(Optional ByVal iEntityID As Integer = 0) As Boolean
        Dim sSQL As String
        Dim sMsg As String = ""

        sSQL = Me._sDeleteSQL

        If iEntityID > 0 Then Me._iEntityID = iEntityID

        If Me._iEntityID > 0 Then
            sMsg = VerifyDelete()

            If sMsg = "" Then

                sSQL = String.Format(sSQL, Me._iEntityID)

                If SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL) Then
                    Me._iEntityID = 0
                    Return True

                End If

            End If

            Me._sErrorMsg &= sMsg

        End If

        Return False

    End Function

    'New record method
    Protected Overridable Function Create() As DataSet
        Dim dc As DataColumn
        Dim dr As DataRow

        If Not Me._dsEntity Is Nothing Then
            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                Me._dsEntity.Tables.Remove(Me._sTableName)

            End If

        End If

        Me._iEntityID = 0

        If DMI.DataHandler.GetSchema(Me._dsEntity, Me._sTableName, Me.ConnectionString) Then
            For Each dc In Me._dsEntity.Tables(Me._sTableName).Columns
                dc.AllowDBNull = True
                dc.ReadOnly = False

            Next

            dr = Me._dsEntity.Tables(Me._sTableName).NewRow

            'set default values
            SetRecordDefaults(dr)

            Me._dsEntity.Tables(Me._sTableName).Rows.Add(dr)

            Return Me._dsEntity

        End If

    End Function

    'Start a search by clearing dataset and filling with empty row
    Public Overridable Sub Clear()
        Dim dc As DataColumn
        Dim dr As DataRow

        If Not Me._dsEntity Is Nothing Then
            Me._dsEntity = Nothing
        End If

        If DMI.DataHandler.GetSchema(Me._dsEntity, Me._sTableName, Me.ConnectionString) Then
            For Each dc In Me._dsEntity.Tables(Me._sTableName).Columns
                dc.AllowDBNull = True
                dc.ReadOnly = False

            Next

            dr = Me._dsEntity.Tables(Me._sTableName).NewRow
            dr.Item(0) = -1

            Me._dsEntity.Tables(Me._sTableName).Rows.Add(dr)

        End If

        Me._iEntityID = -1

    End Sub

    'SELECT method with search
    Private Function Fetch() As DataSet
        Dim sSQL As String

        sSQL = Me.GetSearchSQL()

        If Not Me._dsEntity Is Nothing Then
            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                Me._dsEntity.Tables.Remove(Me._sTableName)

            End If

        End If

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
            Return Me._dsEntity

        End If

    End Function

    'Determine if delete is allowed
    Protected Overridable Function VerifyDelete() As String
        Return ""

    End Function

    'Determine if insert is allowed
    Protected Overridable Function VerifyInsert() As String
        Return ""

    End Function

End Class
