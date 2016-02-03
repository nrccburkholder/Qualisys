Imports System.Web
Imports System.Web.UI.WebControls
Imports DMI
Imports System.Data.Common
Public Enum qmsAnswerCategoryTypes As Integer
    SelectItem = 1
    SelectOpenAnswer = 2
    OpenAnswer = 3
    MultiMark = 4
    Year = 5
    TwoDigits = 6
    Missing = 7
    Numeric = 8

End Enum

Public Class clsScriptScreenCategories
    Inherits DMI.clsDBEntity2

    Private _iScriptScreenID As Integer
    Private _iAnswerCategoryID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        Me.FillAnswerCategoryTypes()
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsScriptScreenCategories.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsScriptScreenCategories.SearchRow)

        'Primary key criteria
        If Not dr.IsScriptScreenCategoryIDNull Then sbSQL.AppendFormat("ScriptScreenCategoryID = {0} AND ", dr.ScriptScreenCategoryID)
        If Not dr.IsScriptIDNull Then sbSQL.AppendFormat("(ScriptScreenID IN (SELECT ScriptScreenID FROM  ScriptScreens WHERE ScriptID = {0})) AND ", dr.ScriptID)
        If Not dr.IsScriptScreenIDNull Then sbSQL.AppendFormat("(ScriptScreenID = {0}) AND ", dr.ScriptScreenID)
        If Not dr.IsJumpToScriptScreenIDNull Then sbSQL.AppendFormat("(JumpToScriptScreenID = {0}) AND ", dr.JumpToScriptScreenID)
        If Not dr.IsAnswerCategoryIDNull Then sbSQL.AppendFormat("(AnswerCategoryID = {0}) AND ", dr.AnswerCategoryID)
        If Not dr.IsQuestionIDNull Then sbSQL.AppendFormat("(QuestionID = {0}) AND ", dr.QuestionID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, " WHERE ")
        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_ScriptScreenCategories")
        'sbSQL.Insert(0, "SELECT ScriptScreenCategories.ScriptScreenCategoryID, ScriptScreenCategories.ScriptScreenID, ScriptScreenCategories.AnswerCategoryID, ScriptScreenCategories.JumpToScriptScreenID, ScriptScreenCategories.Text, AnswerCategories.AnswerCategoryTypeID AS AnswerCategoryTypeID, AnswerCategories.AnswerText AS AnswerText, AnswerCategories.QuestionID AS AnswerQuestionID, AnswerCategories.AnswerValue AS AnswerValue, 1 AS Show FROM ScriptScreenCategories LEFT OUTER JOIN AnswerCategories ON ScriptScreenCategories.AnswerCategoryID = AnswerCategories.AnswerCategoryID")

        System.Diagnostics.Debug.WriteLine(sbSQL.ToString)

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_ScriptScreenCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenCategoryID", SqlDbType.Int, 4, "ScriptScreenCategoryID"))

        Return oCmd
    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsScriptScreenCategories()
        _dtMainTable = _ds.Tables("ScriptScreenCategories")
        _sDeleteFilter = "ScriptScreenCategoryID = {0}"
    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_ScriptScreenCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenCategoryID", SqlDbType.Int, 4, "ScriptScreenCategoryID"))
        oCmd.Parameters("@ScriptScreenCategoryID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenID", SqlDbType.Int, 4, "ScriptScreenID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@JumpToScriptScreenID", SqlDbType.Int, 4, "JumpToScriptScreenID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 1000, "Text"))

        Return oCmd
    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ScriptScreenCategoryID") = iEntityID
    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_ScriptScreenCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenCategoryID", SqlDbType.Int, 4, "ScriptScreenCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenID", SqlDbType.Int, 4, "ScriptScreenID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@JumpToScriptScreenID", SqlDbType.Int, 4, "JumpToScriptScreenID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 1000, "Text"))

        Return oCmd
    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("ScriptScreenID") = _iScriptScreenID
        dr.Item("AnswerCategoryID") = _iAnswerCategoryID
        dr.Item("Text") = ""
        dr.Item("JumpToScriptScreenID") = 0

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Return True
    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyUpdate(dr)
    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyAnswerText(dr)
    End Function

#End Region

    'checks that answer categories do not have same text
    Private Function VerifyAnswerText(ByRef dr As System.Data.DataRow) As Boolean
        Dim sSQL As String
        Dim drResult As DataRow

        sSQL = String.Format("ScriptScreenCategoryID <> {0} AND Text = {1}", dr.Item("ScriptScreenCategoryID"), DMI.DataHandler.QuoteString(dr.Item("Text")))
        drResult = Me.SelectRow(sSQL)

        If IsNothing(drResult) Then
            Return True
        End If

        Me._sErrorMsg &= String.Format("Answer text ""{0}"" already exists. Please change text.\n", dr.Item("Text"))
        Return False
    End Function


#Region "Answer category type lookups"
    Private m_CategoryTypeMap As Hashtable = Nothing

    Public Function GetCategoryName(ByVal iCategoryID As Integer) As String
        If m_CategoryTypeMap Is Nothing Then
            FillAnswerCategoryTypes()
        End If

        Return m_CategoryTypeMap(iCategoryID)
    End Function

    Public Sub FillAnswerCategoryTypes()
        DMI.DataHandler.GetDataTable(Me._oConn, Me.AnswerCategoryTypesTable, "SELECT * FROM AnswerCategoryTypes")

        m_CategoryTypeMap = New Hashtable(Me.AnswerCategoryTypesTable.Rows.Count)
        Dim dr As dsScriptScreenCategories.AnswerCategoryTypesRow
        For Each dr In Me.AnswerCategoryTypesTable
            m_CategoryTypeMap.Add(dr.AnswerCategoryTypeID, dr.Name)
        Next
    End Sub

    Public ReadOnly Property AnswerCategoryTypesTable() As dsScriptScreenCategories.AnswerCategoryTypesDataTable
        Get
            Return _ds.Tables("AnswerCategoryTypes")
        End Get
    End Property


#End Region

#Region "Properties"
    Public ReadOnly Property ScriptScreenCategoriesTable() As dsScriptScreenCategories.ScriptScreenCategoriesDataTable
        Get
            Return _ds.Tables("ScriptScreenCategories")
        End Get
    End Property

    Public Property ScriptScreenID() As Integer
        Get
            Return _iScriptScreenID

        End Get
        Set(ByVal Value As Integer)
            _iScriptScreenID = Value

        End Set
    End Property

    Public Property AnswerCategoryID() As Integer
        Get
            Return _iAnswerCategoryID

        End Get
        Set(ByVal Value As Integer)
            _iAnswerCategoryID = Value

        End Set
    End Property

#End Region

#Region "Render Category HTML"
    Public Shared Function GetCategoryHTML(ByVal dr As dsScriptScreenCategories.ScriptScreenCategoriesRow) As String
        'Dim sbDisplay As New Text.StringBuilder()

        'Select Case dr.AnswerCategoryTypeID
        '    Case 1, 4 'Textbox, Numeric Textbox
        '        sbDisplay.Append(dr.Item("ProtocolStepParamValue").ToString)

        '    Case 2 'Checkbox
        '        sbDisplay.Append(IIf(CInt(dr.Item("ProtocolStepParamValue")) = 1, "Yes", "No").ToString)

        '    Case 3 'Call Filter DropDownList
        '        sbDisplay.Append(DMI.clsUtil.LookupString(dr.Item("ProtocolStepParamValue").ToString, LU_CALLLIST_EVENT_CODES))

        '    Case 5 'EventCodeFilterDropDownList
        '        sbDisplay.Append(clsQMSTools.GetEventName(CInt(dr.Item("ProtocolStepParamValue"))))

        '    Case 6 'FileDefFilterDropDownList
        '        sbDisplay.Append(clsQMSTools.GetFileDefFilterName(CInt(dr.Item("ProtocolStepParamValue"))))

        '    Case 7 'LogEventCodeDropDownList
        '        sbDisplay.Append(clsQMSTools.GetEventName(CInt(dr.Item("ProtocolStepParamValue"))))

        '    Case 8 'YesNoDropDownList
        '        sbDisplay.Append(clsQMSTools.GetYesNoText(dr.Item("ProtocolStepParamValue")))

        'End Select
        'sbDisplay.Append("</span><br/>")

        'Return sbDisplay.ToString

    End Function

#End Region

#Region "ICompare"
    Public Class SortByAnswerValue
        Implements IComparer

        Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements System.Collections.IComparer.Compare
            Dim xValue As Integer
            Dim yValue As Integer

            xValue = CInt(CType(x, DataRow).Item("AnswerValue"))
            yValue = CInt(CType(y, DataRow).Item("AnswerValue"))

            If xValue < yValue Then
                Return -1
            ElseIf xValue > yValue Then
                Return 1
            Else
                Return 0
            End If

        End Function

    End Class
#End Region
End Class
