Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsCriteria
    Inherits DMI.clsDBEntity2

    Private _SurveyID As Integer
    Private _CriteriaTypeID As Integer = 1
    Private _ParentCriteriaID As Integer = 0
    Private _CriteriaTypes As dsCriteria.CriteriaTypesDataTable = Nothing

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As System.Data.DataRow) As String
        Dim dr As dsCriteria.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsCriteria.SearchRow)

        'Primary key criteria

        If Not dr.IsCriteriaIDNull Then sbSQL.AppendFormat("CriteriaID = {0} AND ", dr.CriteriaID)
        If Not dr.IsAnswerCategoryIDNull Then sbSQL.AppendFormat("AnswerCategoryID = {0} AND ", dr.AnswerCategoryID)
        If Not dr.IsCriteriaTypeIDNull Then sbSQL.AppendFormat("CriteriaTypeID = {0} AND ", dr.CriteriaTypeID)
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        If Not dr.IsReferenceCriteriaIDNull Then sbSQL.AppendFormat("ReferenceCriteriaID = {0} AND ", dr.ReferenceCriteriaID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Criteria ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Criteria", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", SqlDbType.Int, 4, "CriteriaID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsCriteria
        _dtMainTable = _ds.Tables("Criteria")
        _sDeleteFilter = "CriteriaID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Criteria", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", SqlDbType.Int, 4, "CriteriaID"))
        oCmd.Parameters("@CriteriaID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaName", SqlDbType.VarChar, 100, "CriteriaName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaTypeID", SqlDbType.Int, 4, "CriteriaTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaDataTypeID", SqlDbType.SmallInt, 4, "CriteriaDataTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ParameterName", SqlDbType.VarChar, 100, "ParameterName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TextValue", SqlDbType.VarChar, 1000, "TextValue"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ReferenceCriteriaID", SqlDbType.Int, 4, "ReferenceCriteriaID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ReferenceCriteriaSequence", SqlDbType.Int, 4, "ReferenceCriteriaSequence"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Flag", SqlDbType.Int, 4, "Flag"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("CriteriaID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Criteria", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", SqlDbType.Int, 4, "CriteriaID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaName", SqlDbType.VarChar, 100, "CriteriaName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaTypeID", SqlDbType.Int, 4, "CriteriaTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaDataTypeID", SqlDbType.SmallInt, 4, "CriteriaDataTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ParameterName", SqlDbType.VarChar, 100, "ParameterName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TextValue", SqlDbType.VarChar, 1000, "TextValue"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ReferenceCriteriaID", SqlDbType.Int, 4, "ReferenceCriteriaID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ReferenceCriteriaSequence", SqlDbType.Int, 4, "ReferenceCriteriaSequence"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Flag", SqlDbType.Int, 4, "Flag"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("SurveyID") = _SurveyID
        dr.Item("CriteriaTypeID") = _CriteriaTypeID
        dr.Item("Flag") = 1

        'adding subcriteria
        If _ParentCriteriaID > 0 Then
            Dim ParentCriteria As DataRow
            dr.Item("ReferenceCriteriaID") = _ParentCriteriaID
            ParentCriteria = Me.GetParent(dr)
            If Not IsNothing(ParentCriteria) Then
                dr.Item("ReferenceCriteriaSequence") = GetChildern(ParentCriteria).Length + 1
                dr.Item("Lvl") = CInt(ParentCriteria.Item("Lvl")) + 1
                dr.Item("Hierarchy") = String.Format("{0}:{1:0000}", ParentCriteria.Item("Hierarchy"), dr.Item("ReferenceCriteriaSequence"))

                Exit Sub

            End If
        End If

        dr.Item("ReferenceCriteriaSequence") = 1
        dr.Item("Lvl") = 1
        dr.Item("Hierarchy") = String.Format("{0:0000}:{1:000000000}", dr.Item("ReferenceCriteriaSequence"), dr.Item("CriteriaID"))

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim CriteriaID As Integer
        Dim drs() As DataRow

        CriteriaID = dr.Item("CriteriaID", DataRowVersion.Original)
        'cannot delete criteria with sub-criteria
        drs = Me.MainDataTable.Select(String.Format("ReferenceCriteriaID = {0}", CriteriaID))
        If drs.Length > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete criteria id {0}. Criteria has sub-criteria that must be delete first.\n", dr.Item("CriteriaID", DataRowVersion.Original))
            Return False

        End If

        'check if sibling criteria reordering is needed
        If Not IsDBNull(dr.Item("ReferenceCriteriaID", DataRowVersion.Original)) Then
            Dim drParent As DataRow = Me.SelectRow(dr.Item("ReferenceCriteriaID", DataRowVersion.Original))
            Me.UpdateOrder(drParent)

        End If

        Return True

    End Function

#End Region

    Public Property SurveyID() As Integer
        Get
            Return _SurveyID
        End Get
        Set(ByVal Value As Integer)
            _SurveyID = Value
        End Set
    End Property

    Public Property CriteriaTypeID() As Integer
        Get
            Return _CriteriaTypeID
        End Get
        Set(ByVal Value As Integer)
            _CriteriaTypeID = Value
        End Set
    End Property

    Public Property ParentCriteriaID() As Integer
        Get
            Return _ParentCriteriaID
        End Get
        Set(ByVal Value As Integer)
            _ParentCriteriaID = Value
        End Set
    End Property

    Public Function ExpandCriteriaCmd(ByVal CriteriaID As Integer) As SqlClient.SqlCommand
        Dim Cmd As SqlClient.SqlCommand

        Cmd = New SqlClient.SqlCommand("get_Criteria", Me._oConn)
        Cmd.CommandType = CommandType.StoredProcedure
        Cmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", CriteriaID))

        Return Cmd

    End Function

    Public Sub ExpandCriteria(ByVal CriteriaID As Integer)
        Dim da As New SqlClient.SqlDataAdapter

        'check for read rights
        If Me.CanRead Then
            da.SelectCommand = ExpandCriteriaCmd(CriteriaID)
            _dtMainTable.Clear()
            da.Fill(_dtMainTable)

        Else
            Throw New DMI.dbEntitySecurityException("User does not have read rights")

        End If

        da = Nothing

    End Sub

    Public ReadOnly Property CriteriaTypes() As dsCriteria.CriteriaTypesDataTable
        Get
            If IsNothing(_CriteriaTypes) Then
                Dim sql As String = "SELECT * FROM CriteriaTypes ORDER BY Name"
                Dim ds As dsCriteria = New dsCriteria
                Dim tables As String() = New String() {"CriteriaTypes"}
                'TP Change
                SqlHelper.Db(_oConn.ConnectionString).LoadDataSet(CommandType.Text, sql, ds, tables)
                'SqlHelper.FillDataset(_oConn, CommandType.Text, sql, ds, tables)
                '_CriteriaTypes = ds.CriteriaTypes
            End If

            Return _CriteriaTypes

        End Get
    End Property

    Public Function GetCriteriaTypeName(ByVal CriteriaTypeID As Integer)
        Dim result As String = ""
        Dim row As dsCriteria.CriteriaTypesRow
        row = CriteriaTypes.FindByCriteriaTypeID(CriteriaTypeID)
        If Not IsNothing(row) Then result = row.Name
        Return result
    End Function

    Public Shared Sub FillCriteriaTypes(ByVal Connection As SqlClient.SqlConnection, ByVal CriteriaTypesTable As DataTable)
        Dim da As New SqlClient.SqlDataAdapter

        da.SelectCommand = New SqlClient.SqlCommand("SELECT * FROM CriteriaTypes", Connection)
        da.Fill(CriteriaTypesTable)

        da = Nothing
    End Sub

    Public Overloads Function AddMainRow(ByVal ParentCriteriaID As Integer, ByVal ChildCriteriaTypeID As Integer) As DataRow
        Dim drParent() As DataRow

        drParent = Me.MainDataTable.Select(String.Format("CriteriaID = {0}", ParentCriteriaID))
        If Not IsNothing(drParent) Then
            Dim CriteriaType As clsCriteriaTypes
            Dim drChild As DataRow
            Dim dr As DataRow = drParent(0)

            CriteriaType = clsCriteriaTypes.GetObject(Me._oConn, CInt(drParent(0).Item("CriteriaTypeID")))
            If CriteriaType.AllowChildern Then
                Me.ParentCriteriaID = ParentCriteriaID
                Me.CriteriaTypeID = ChildCriteriaTypeID
                drChild = Me.AddMainRow()

            Else
                Me._sErrorMsg = "Cannot add sub-criteria to selected criteria"

            End If
            drParent = Nothing
            Return drChild

        End If
    End Function

    Public Shared Function GetAnswerCategoryParameterList(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptID As Integer, ByVal TextCategoriesOnly As Boolean) As SqlClient.SqlDataReader
        If TextCategoriesOnly Then
            'TP Change
            Dim cmd As DbCommand = SqlHelper.Db(Connection.ConnectionString).GetStoredProcCommand("get_ScriptScreenTextCategoriesList", ScriptID)
            Return SqlHelper.Db(Connection.ConnectionString).ExecuteReader(cmd)
            'Return SqlHelper.ExecuteReader(Connection, CommandType.StoredProcedure, "get_ScriptScreenTextCategoriesList", _
            '   New SqlClient.SqlParameter("@ScriptID", ScriptID))

        Else
            Dim cmd As DbCommand = SqlHelper.Db(Connection.ConnectionString).GetStoredProcCommand("get_ScriptScreenCategoriesList", ScriptID)
            Return SqlHelper.Db(Connection.ConnectionString).ExecuteReader(cmd)
            'Return SqlHelper.ExecuteReader(Connection, CommandType.StoredProcedure, "get_ScriptScreenCategoriesList", _
            '    New SqlClient.SqlParameter("@ScriptID", ScriptID))

        End If

    End Function

    Public Shared Function GetSurveyAnswerCategoryParameterList(ByVal Connection As SqlClient.SqlConnection, ByVal SurveyID As Integer, ByVal TextCategoriesOnly As Boolean) As SqlClient.SqlDataReader
        If TextCategoriesOnly Then
            'TP CHange
            Dim cmd As DbCommand = SqlHelper.Db(Connection.ConnectionString).GetStoredProcCommand("get_SurveyTextCategoriesList", SurveyID)
            Return SqlHelper.Db(Connection.ConnectionString).ExecuteReader(cmd)
            'Return SqlHelper.ExecuteReader(Connection, CommandType.StoredProcedure, "get_SurveyTextCategoriesList", _
            '   New SqlClient.SqlParameter("@SurveyID", SurveyID))

        Else
            'TP Change
            Dim cmd As DbCommand = SqlHelper.Db(Connection.ConnectionString).GetStoredProcCommand("get_SurveyCategoriesList", SurveyID)
            Return SqlHelper.Db(Connection.ConnectionString).ExecuteReader(cmd)
            'Return SqlHelper.ExecuteReader(Connection, CommandType.StoredProcedure, "get_SurveyCategoriesList", _
            '   New SqlClient.SqlParameter("@SurveyID", SurveyID))

        End If

    End Function

    Public Shared Function GetQuestionParameterList(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer) As SqlClient.SqlDataReader

    End Function

    Public Shared Function GetCriteriaDataTypes(ByVal Connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return SqlHelper.Db(Connection.ConnectionString).ExecuteReader(CommandType.Text, "SELECT CriteriaDataTypeID, CriteriaDataType FROM CriteriaDataTypes ORDER BY CriteriaDataType")
        'Return SqlHelper.ExecuteReader(Connection, CommandType.Text, _
        '    "SELECT CriteriaDataTypeID, CriteriaDataType FROM CriteriaDataTypes ORDER BY CriteriaDataType")

    End Function

    Public Function GetChildern(ByRef CriteriaDataRow As DataRow) As DataRow()
        Dim CriteriaID As Integer = CriteriaDataRow.Item("CriteriaID")

        Return Me.MainDataTable.Select(String.Format("ReferenceCriteriaID = {0}", CriteriaID))

    End Function

    Public Function GetParent(ByRef CriteriaDataRow As DataRow) As DataRow
        If Not IsDBNull(CriteriaDataRow.Item("ReferenceCriteriaID")) Then
            Dim ParentDataRow As DataRow()

            ParentDataRow = Me.MainDataTable.Select(String.Format("CriteriaID = {0}", CriteriaDataRow.Item("ReferenceCriteriaID")))
            If ParentDataRow.Length > 0 Then
                Return ParentDataRow(0)
            End If
        End If

        Return Nothing

    End Function

    Public Shared Function ValidateCriteriaDataType(ByVal CriteriaDataTypeID As Integer, ByVal TextValue As String) As Boolean
        Select Case CriteriaDataTypeID
            Case 61 'date
                If Not IsDate(TextValue) Then Return False
            Case 62 'float
                If Not IsNumeric(TextValue) Then Return False
            Case 167 'text
                'any value is valid for text
        End Select

        Return True

    End Function

    Public Sub ChangeCriteriaOrder(ByVal CriteriaID As Integer, ByVal Move As Integer)
        Dim dr As DataRow = Me.SelectRow(CriteriaID)

        If Not IsNothing(dr) Then
            'cannot move root criteria
            If Not IsDBNull(dr.Item("ReferenceCriteriaID")) Then
                'cannot move criteria before seq 1
                If CInt(dr.Item("ReferenceCriteriaSequence")) + Move > 0 Then
                    'get parent criteria
                    Dim drParent As DataRow = Me.GetParent(dr)
                    'get sibling criteria
                    Dim drChildren() As DataRow = Me.GetChildern(drParent)
                    'cannot move critera past total number of sibling criteria
                    If CInt(dr.Item("ReferenceCriteriaSequence")) + Move <= drChildren.Length Then
                        Dim SortKeys(drChildren.Length - 1) As Double
                        Dim i As Integer

                        'build sort key array
                        For i = 0 To drChildren.Length - 1
                            SortKeys(i) = CDbl(drChildren(i).Item("ReferenceCriteriaSequence"))
                            If drChildren(i) Is dr Then
                                SortKeys(i) += Move
                                If Move > 0 Then
                                    SortKeys(i) += 0.5
                                Else
                                    SortKeys(i) -= 0.5
                                End If

                            End If
                        Next

                        Array.Sort(SortKeys, drChildren)
                        For i = 0 To drChildren.Length - 1
                            'update criteria order
                            drChildren(i).Item("ReferenceCriteriaSequence") = i + 1
                            'update hierarchy field
                            UpdateHierarchy(drChildren(i), drParent)

                        Next
                        Me.Save()

                    End If
                End If
            End If
        End If

    End Sub

    Public Sub UpdateOrder(ByVal drParent As DataRow)
        Dim drChildren() As DataRow = Me.GetChildern(drParent)
        Dim i As Integer

        For i = 0 To drChildren.Length - 1
            'update criteria order
            drChildren(i).Item("ReferenceCriteriaSequence") = i + 1
            UpdateHierarchy(drChildren(i), drParent)

        Next

    End Sub

    Private Sub UpdateHierarchy(ByVal drCriteria As DataRow, ByVal drParent As DataRow)
        Dim drChildren() As DataRow

        'update Criteria Hierarchy field
        drCriteria.Item("Hierarchy") = String.Format("{0}:{1:0000}:{2:000000000}", _
            drParent.Item("Hierarchy"), _
            drCriteria.Item("ReferenceCriteriaSequence"), _
            drCriteria.Item("CriteriaID"))

        'check for sub-criteria
        drChildren = Me.GetChildern(drCriteria)
        If drChildren.Length > 0 Then
            Dim dr As DataRow
            For Each dr In drChildren
                'update sub-criteria hierarchy
                UpdateHierarchy(dr, drCriteria)
            Next
        End If

        drChildren = Nothing

    End Sub

End Class

Public MustInherit Class clsCriteriaTypes
    Inherits DMI.clsProtoDataObject

    Protected _CriteriaDataRow As DataRow
    Protected _MatchText As Boolean = False

    Public Shared Function GetObject(ByVal Connection As SqlClient.SqlConnection, ByVal CriteriaTypeID As Integer) As clsCriteriaTypes
        Dim obj As clsCriteriaTypes

        Select Case CriteriaTypeID
            Case 1 ' simple answer category match
                obj = New clsCriteriaType_HAS_ANSWER_CATEGORY(Connection)

            Case 2 ' answer text equality match
                obj = New clsCriteriaType_COMPARE_OPEN_ANSWER_TEXT(Connection)
                obj.MatchTextCategory = True

            Case 3 ' answer text like match
                obj = New clsCriteriaType_COMPARE_OPEN_ANSWER_TEXT(Connection)

            Case 10 ' parameter equality match
                obj = New clsCriteriaType_COMPARE_PARAMETER(Connection)

            Case 11 ' parameter like match
                obj = New clsCriteriaType_COMPARE_PARAMETER(Connection)

            Case 12 ' parameter > match
                obj = New clsCriteriaType_COMPARE_PARAMETER(Connection)

            Case 13 ' paramter < match
                obj = New clsCriteriaType_COMPARE_PARAMETER(Connection)

            Case 21 ' and list
                obj = New clsCriteriaType_LIST(Connection)

            Case 22 ' or list
                obj = New clsCriteriaType_LIST(Connection)

            Case 99 'unanswered
                obj = New clsCriteriaType_LIST(Connection)

        End Select

        Return obj

    End Function

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    MustOverride ReadOnly Property AllowChildern() As Boolean
    MustOverride ReadOnly Property NeedAnswerCategoryID() As Boolean
    MustOverride ReadOnly Property NeedCriteriaDataTypeID() As Boolean
    MustOverride ReadOnly Property NeedAnswerTextValue() As Boolean
    MustOverride ReadOnly Property NeedParameterTextValue() As Boolean
    'Overridable ReadOnly Property NeedCriteriaName() As Boolean
    '    Get
    '        If IsDBNull(_CriteriaDataRow.Item("ReferenceCriteriaID")) Then
    '            Return True
    '        Else
    '            Return False
    '        End If
    '    End Get

    'End Property

    Overridable ReadOnly Property NeedQuestionID() As Boolean
        Get
            Return False
        End Get
    End Property


    Overridable Property MatchTextCategory() As Boolean
        Get
            Return _MatchText
        End Get
        Set(ByVal Value As Boolean)
            _MatchText = Value
        End Set
    End Property

    Protected Overridable Function Validate(ByVal CriteriaDataRow As DataRow) As Boolean
        If NeedAnswerCategoryID AndAlso IsDBNull(CriteriaDataRow.Item("AnswerCategoryID")) Then

        End If

        If NeedCriteriaDataTypeID AndAlso IsDBNull(CriteriaDataRow.Item("")) Then

        End If
    End Function

    MustOverride ReadOnly Property Text(ByVal drv As DataRowView) As String

End Class

'and, or operators
Public Class clsCriteriaType_LIST
    Inherits clsCriteriaTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides ReadOnly Property AllowChildern() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerCategoryID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedCriteriaDataTypeID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedParameterTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property Text(ByVal drv As DataRowView) As String
        Get
            Return ""

        End Get
    End Property
End Class

'simple answer category match
Public Class clsCriteriaType_HAS_ANSWER_CATEGORY
    Inherits clsCriteriaTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides ReadOnly Property AllowChildern() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerCategoryID() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedCriteriaDataTypeID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedParameterTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property Text(ByVal drv As DataRowView) As String
        Get
            If Not IsDBNull(drv.Item("AnswerCategoryID")) Then
                Dim sbSQL As New Text.StringBuilder

                sbSQL.Append("SELECT Questions.ShortDesc + ': ' + AnswerCategories.AnswerText ")
                sbSQL.Append("FROM AnswerCategories INNER JOIN Questions ON AnswerCategories.QuestionID = Questions.QuestionID ")
                sbSQL.AppendFormat("WHERE AnswerCategories.AnswerCategoryID = {0}", drv.Item("AnswerCategoryID"))
                'TP Change
                Return SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString())
                'Return SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sbSQL.ToString)

            Else
                Return "NONE"

            End If

        End Get
    End Property
End Class

'match open answer text
Public Class clsCriteriaType_COMPARE_OPEN_ANSWER_TEXT
    Inherits clsCriteriaTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides ReadOnly Property AllowChildern() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerCategoryID() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerTextValue() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedCriteriaDataTypeID() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedParameterTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property Text(ByVal drv As DataRowView) As String
        Get
            If Not IsDBNull(drv.Item("AnswerCategoryID")) Then
                Dim sbSQL As New Text.StringBuilder

                sbSQL.AppendFormat("SELECT Questions.ShortDesc + ': ' + AnswerCategories.AnswerText + ': ' + {0} ", DMI.DataHandler.QuoteString(drv.Item("TextValue")))
                sbSQL.Append("FROM AnswerCategories INNER JOIN Questions ON AnswerCategories.QuestionID = Questions.QuestionID ")
                sbSQL.AppendFormat("WHERE AnswerCategories.AnswerCategoryID = {0}", drv.Item("AnswerCategoryID"))
                'TP CHange
                Return SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString())
                'Return SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sbSQL.ToString)

            Else
                Return "NONE"

            End If

        End Get
    End Property
End Class

Public Class clsCriteriaType_COMPARE_PARAMETER
    Inherits clsCriteriaTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides ReadOnly Property AllowChildern() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerCategoryID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerTextValue() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedCriteriaDataTypeID() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property NeedParameterTextValue() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property Text(ByVal drv As DataRowView) As String
        Get
            Dim sbText As New Text.StringBuilder

            sbText.AppendFormat(drv.Item("ParameterName"))
            sbText.AppendFormat(": {0}", drv.Item("TextValue"))

            Return sbText.ToString

        End Get
    End Property

    Protected Overrides Function Validate(ByVal CriteriaDataRow As System.Data.DataRow) As Boolean


    End Function

    Public Shared Function GetPredefinedParameterDataTypeID(ByVal Connection As SqlClient.SqlConnection, ByVal ParameterName As String) As Integer
        Dim rtValue As Object
        'TP Change
        rtValue = SqlHelper.Db(Connection.ConnectionString).ExecuteScalar(CommandType.Text, String.Format("SELECT DefaultCriteriaDataTypeID FROM CriteriaPredefinedParameters WHERE ParameterName = '{0}'", ParameterName))
        'rtValue = SqlHelper.ExecuteScalar(Connection, CommandType.Text, _
        '   "SELECT DefaultCriteriaDataTypeID FROM CriteriaPredefinedParameters WHERE ParameterName = '{0}'", ParameterName)

        Return rtValue

    End Function

End Class

Public Class clsCriteriaType_UNANSWERED
    Inherits clsCriteriaTypes

    Public Sub New(ByVal connection As SqlClient.SqlConnection)
        MyBase.New(connection)

    End Sub

    Public Overrides ReadOnly Property AllowChildern() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerCategoryID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedAnswerTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedCriteriaDataTypeID() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedParameterTextValue() As Boolean
        Get
            Return False

        End Get
    End Property

    Public Overrides ReadOnly Property NeedQuestionID() As Boolean
        Get
            Return True

        End Get
    End Property

    Public Overrides ReadOnly Property Text(ByVal drv As System.Data.DataRowView) As String
        Get
            If Not IsDBNull(drv.Item("AnswerCategoryID")) Then
                Dim sbSQL As New Text.StringBuilder

                sbSQL.Append("SELECT Questions.ShortDesc + ': UNANSWERED' ")
                sbSQL.Append("FROM Questions ")
                sbSQL.AppendFormat("WHERE QuestionID = {0}", drv.Item("AnswerCategoryID"))
                'TP Change
                Return SqlHelper.Db(_Connection.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString())
                'Return SqlHelper.ExecuteScalar(_Connection, CommandType.Text, sbSQL.ToString)

            Else
                Return "NONE"

            End If

        End Get
    End Property


End Class


