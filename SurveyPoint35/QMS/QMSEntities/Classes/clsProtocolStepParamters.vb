Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsProtocolStepParameters
    Inherits DMI.clsDBEntity2

    Public Const LU_CALLLIST_EVENT_CODES = "0;None;2006;Batched;-2006;Not Batched;3000;Data Entry Incomplete;3010;Verification Incomplete;3020;CATI Incomplete;3030;Reminder Call Incomplete;5009;Callback, No Appointment;-40001;1st Mailing, No Response;-40002;2nd Mailing, No Response"
    Private _iProtocolStepID As Integer = 0
    Private _iProtocolStepParamTypeID As Integer = 0
    Private _sDefaultParamValue As String = ""

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

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsProtocolStepParameters.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsProtocolStepParameters.SearchRow)

        'Primary key criteria
        If Not dr.IsProtocolStepTypeParamIDNull Then sbSQL.AppendFormat("ProtocolStepParamID = {0} AND ", dr.ProtocolStepParamID)
        'protocol step id criteria
        If Not dr.IsProtocolStepIDNull Then sbSQL.AppendFormat("ProtocolStepID = {0} AND ", dr.ProtocolStepID)
        'protocol id criteria
        If Not dr.IsProtocolIDNull Then sbSQL.AppendFormat("ProtocolStepID IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolID = {0}) AND ", dr.ProtocolID)
        'protocol step parameter type
        If Not dr.IsProtocolStepTypeParamIDNull Then sbSQL.AppendFormat("ProtocolStepTypeParamID = {0} AND ", dr.ProtocolStepTypeParamID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM ProtocolStepParameters ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_ProtocolStepParameters", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepParamID", SqlDbType.Int, 4, "ProtocolStepParamID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsProtocolStepParameters
        _dtMainTable = _ds.Tables("ProtocolStepParameters")
        _sDeleteFilter = "ProtocolStepParameterID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_ProtocolStepParameters", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepParamID", SqlDbType.Int, 4, "ProtocolStepParamID"))
        oCmd.Parameters("@ProtocolStepParamID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepTypeParamID", SqlDbType.Int, 4, "ProtocolStepTypeParamID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepParamValue", SqlDbType.VarChar, 100, "ProtocolStepParamValue"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ProtocolStepParameterID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_ProtocolStepParameters", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepParamID", SqlDbType.Int, 4, "ProtocolStepParamID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepID", SqlDbType.Int, 4, "ProtocolStepID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepTypeParamID", SqlDbType.Int, 4, "ProtocolStepTypeParamID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolStepParamValue", SqlDbType.VarChar, 100, "ProtocolStepParamValue"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("ProtocolStepID") = _iProtocolStepID
        dr.Item("ProtocolStepTypeParamID") = _iProtocolStepParamTypeID
        dr.Item("ProtocolStepParamValue") = _sDefaultParamValue

    End Sub

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Dim pt As ParameterTypes = ParameterTypes.GetObject(CInt(dr.Item("ProtocolStepTypeParamID")), Me._oConn)
        If Not pt.VerifyInsert(dr) Then
            Me._sErrorMsg = pt.ErrMsg
            Return False

        End If
        Return True

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Dim pt As ParameterTypes = ParameterTypes.GetObject(CInt(dr.Item("ProtocolStepTypeParamID")), Me._oConn)
        If Not pt.VerifyUpdate(dr) Then
            Me._sErrorMsg = pt.ErrMsg
            Return False

        End If
        Return True

    End Function

#End Region

    Public Property ProtocolStepID() As Integer
        Get
            Return _iProtocolStepID

        End Get
        Set(ByVal Value As Integer)
            _iProtocolStepID = Value

        End Set
    End Property

    'call this to initialize protocol step parameters for a new protocol step
    'inserts params for a given protocol step
    Public Sub NewProtocolStepParameters(ByRef drProtocolStep As DataRow)
        Dim drParamTypes As DataRow()
        Dim drParamType As DataRow
        Dim pt As ParameterTypes
        Dim dr As DataRow

        'set protocol step id
        Me.ProtocolStepID = CInt(drProtocolStep.Item("ProtocolStepID"))

        'get protocol step parameters types
        drParamTypes = drProtocolStep.GetParentRow("ProtocolStepTypesProtocolSteps").GetChildRows("ProtocolStepTypesProtocolStepTypeParameters")
        For Each drParamType In drParamTypes
            _iProtocolStepParamTypeID = drParamType.Item("ProtocolStepTypeParamID")
            _sDefaultParamValue = drParamType.Item("Defaults")
            dr = AddMainRow()
            'override default values for parameter types
            pt = ParameterTypes.GetObject(_iProtocolStepParamTypeID, Me._oConn)
            pt.SetDefaultValue(dr)
            pt = Nothing

        Next

    End Sub

    'verifies valid values for a parameter type
    'Private Function VerifyDataType(ByRef dr As DataRow) As Boolean
    '    Select Case CInt(dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ControlTypeID"))
    '        Case 2 'Checkbox
    '            If dr.Item("ProtocolStepParamValue") <> "1" And dr.Item("ProtocolStepParamValue") <> "0" Then
    '                _sErrorMsg &= String.Format("Problem with {0} checkbox value.\n", dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ProtocolStepParamDesc"))
    '                dr.RejectChanges()

    '            End If

    '        Case 4 'Numeric
    '            If dr.Item("ProtocolStepParamValue") = "" Then
    '                _sErrorMsg &= String.Format("{0} can not be blank.\n", dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ProtocolStepParamDesc"))
    '                dr.RejectChanges()

    '            ElseIf Not IsNumeric(dr.Item("ProtocolStepParamValue")) Then
    '                _sErrorMsg &= String.Format("{0} must be numeric.\n", dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ProtocolStepParamDesc"))
    '                dr.RejectChanges()

    '            End If

    '        Case 8 'Numeric Optional
    '                If Not IsNumeric(dr.Item("ProtocolStepParamValue")) AndAlso _
    '                    dr.Item("ProtocolStepParamValue") <> "" Then
    '                    _sErrorMsg &= String.Format("{0} must be numeric or blank.\n", dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ProtocolStepParamDesc"))
    '                    dr.RejectChanges()

    '                End If

    '    End Select

    '    Return True

    'End Function

#Region "Default Value functions"
    'Private Function GetParamDefaultValue(ByRef drProtocolStep As DataRow, ByVal drParamType As DataRow) As String
    '    Select Case CInt(drParamType.Item("ProtocolStepTypeParamID"))
    '        Case 8, 10 'Call attempts
    '            Return NextCallAttempt(CInt(drProtocolStep.Item("ProtocolID"))).ToString

    '        Case 33, 43 'Day Ago
    '            'return days from start of protocol
    '            Return drProtocolStep.Item("StartDay").ToString

    '        Case Else
    '            'return default value for other types
    '            Return drParamType.Item("Defaults").ToString

    '    End Select

    'End Function

    'Private Function NextCallAttempt(ByVal iProtocolID As Integer) As Integer
    '    Dim sSQL As String

    '    'count number of cati and reminder call steps current in protocol, add 1 for next call attempt
    '    sSQL = String.Format("SELECT ISNULL(COUNT(ProtocolStepID),0) FROM ProtocolSteps WHERE ProtocolID = {0} AND ProtocolStepTypeID IN (5, 6)", iProtocolID)
    '    Return CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL))

    'End Function

#End Region

#Region "Protocol Step Type Lookup"
    Public Shared Sub FillProtocolStepParameterType(ByVal oConn As SqlClient.SqlConnection, ByVal dt As DataTable)
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM ProtocolStepTypeParameters", oConn)

        da.Fill(dt)
        da.Dispose()
        da = Nothing

    End Sub

#End Region

#Region "Protocol Step Type Display functions"
    Public Function DisplayHTMLParameters(ByVal drs As DataRow()) As String
        Dim dr As DataRow
        Dim sbDisplay As New Text.StringBuilder
        Dim pt As ParameterTypes

        For Each dr In drs
            pt = ParameterTypes.GetObject(dr.Item("ProtocolStepTypeParamID"), Me._oConn)
            pt.DataRow = dr
            sbDisplay.AppendFormat("{0}<br>", pt.ToHTMLStatic())
            pt.Close()
            pt = Nothing

        Next

        Return sbDisplay.ToString

    End Function

    Public Function DisplayHTMLParameterInputs(ByVal drs As DataRow()) As String
        Dim dr As DataRow
        Dim sqlDR As SqlClient.SqlDataReader
        Dim sbDisplay As New Text.StringBuilder
        Dim pt As ParameterTypes

        For Each dr In drs
            pt = ParameterTypes.GetObject(dr.Item("ProtocolStepTypeParamID"), Me._oConn)
            pt.DataRow = dr
            sbDisplay.AppendFormat("{0}<br>", pt.ToHTMLForm())
            pt.Close()
            pt = Nothing

        Next

        Return sbDisplay.ToString

    End Function

    Public Sub ReadHTMLParameterInputs(ByVal drs As DataRow(), ByVal r As System.Web.HttpRequest)
        Dim dr As DataRow
        Dim pt As ParameterTypes

        For Each dr In drs
            pt = ParameterTypes.GetObject(dr.Item("ProtocolStepTypeParamID"), Me._oConn)
            pt.DataRow = dr
            If Not pt.ReadHTMLSubmit(r) Then Me._sErrorMsg &= String.Format("{0}\n", pt.ErrMsg)
            pt.Close()
            pt = Nothing

        Next

    End Sub

#End Region

#Region "ParameterTypes Class"
    Protected MustInherit Class ParameterTypes
        Protected _Conn As SqlClient.SqlConnection
        Protected _ParameterControl As ParameterControlTypes
        Protected _ErrMsg As String
        Protected _dr As DataRow

        Public Sub New(ByVal Connection As SqlClient.SqlConnection)
            _Conn = Connection

        End Sub

        Public Sub Close()
            _ParameterControl = Nothing

        End Sub

        Public Function ToHTMLStatic() As String
            Dim pc As ParameterControlTypes = ParameterControl()

            pc.Name = Me.ControlName
            pc.Label = Me.ParameterName
            pc.Value = Me.ParameterValue

            Return pc.ToHTMLStatic()

        End Function

        Public Function ToHTMLForm() As String
            Dim pc As ParameterControlTypes = ParameterControl()

            pc.Name = Me.ControlName
            pc.Label = Me.ParameterName
            pc.Value = Me.ParameterValue

            Return pc.ToHTMLForm()

        End Function

        Public Function ReadHTMLSubmit(ByRef r As System.Web.HttpRequest) As Boolean
            Dim pc As ParameterControlTypes = ParameterControl()

            pc.Name = Me.ControlName
            pc.Label = Me.ParameterName

            If pc.ReadHTMLSubmit(r) Then
                Me.ParameterValue = pc.Value
                Return True
            Else
                Me._ErrMsg = pc.ErrMsg
                Return False
            End If

        End Function

        Public Overridable Sub SetDefaultValue(ByVal dr As DataRow)
            'usually do nothing

        End Sub

        Public Overridable Function VerifyInsert(ByVal dr As DataRow) As Boolean
            Return True

        End Function

        Public Overridable Function VerifyUpdate(ByVal dr As DataRow) As Boolean
            Return True

        End Function

        Public Overridable Function VerifyDelete(ByVal dr As DataRow) As Boolean
            Return True

        End Function

        Public ReadOnly Property ErrMsg() As String
            Get
                Return Me._ErrMsg

            End Get
        End Property

        Public WriteOnly Property DataRow() As DataRow
            Set(ByVal Value As DataRow)
                _dr = Value

            End Set
        End Property

        Public ReadOnly Property ControlTypeID() As Integer
            Get
                Return CInt(_dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ControlTypeID"))

            End Get
        End Property

        Public ReadOnly Property ParameterID() As Integer
            Get
                Return CInt(_dr.Item("ProtocolStepTypeParamID"))

            End Get
        End Property

        Public ReadOnly Property ParameterName() As String
            Get
                Return _dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ProtocolStepParamDesc").ToString

            End Get
        End Property

        Public Property ParameterValue() As String
            Get
                Return _dr.Item("ProtocolStepParamValue").ToString

            End Get
            Set(ByVal Value As String)
                _dr.Item("ProtocolStepParamValue") = Value

            End Set
        End Property

        Public ReadOnly Property ControlName() As String
            Get
                Return String.Format("PSPID{0}", ParameterID())

            End Get
        End Property

        Private ReadOnly Property ParameterControl() As ParameterControlTypes
            Get
                If IsNothing(_ParameterControl) Then
                    Dim ControlTypeID As Integer

                    ControlTypeID = CInt(_dr.GetParentRow("ProtocolStepTypeParametersProtocolStepParameters").Item("ControlTypeID"))
                    _ParameterControl = ParameterControlTypes.GetObject(ControlTypeID, Me._Conn)

                End If

                Return _ParameterControl

            End Get
        End Property

        Public Shared Function GetObject(ByVal ParameterTypeID As Integer, ByVal Connection As SqlClient.SqlConnection) As ParameterTypes
            Select Case ParameterTypeID
                Case 8, 10 'Call attempts
                    Return New ptFilterOnCallAttempt(Connection)

                Case 33, 43 'Day Ago
                    'return days from start of protocol
                    Return New ptDaysAgo(Connection)

                Case Else
                    'return default value for other types
                    Return New ptGeneric(Connection)

            End Select
        End Function

    End Class

    Protected Class ptGeneric
        Inherits ParameterTypes

        Public Sub New(ByVal Connection As SqlClient.SqlConnection)
            MyBase.New(Connection)

        End Sub

    End Class

    Protected Class ptFilterOnCallAttempt
        Inherits ParameterTypes

        Public Sub New(ByVal Connection As SqlClient.SqlConnection)
            MyBase.New(Connection)

        End Sub

        Public Overrides Sub SetDefaultValue(ByVal dr As DataRow)
            dr.Item("ProtocolStepParamValue") = Me.MaxCallAttempt(CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID"))) + 1

        End Sub

        Private Function MaxCallAttempt(ByVal iProtocolID As Integer) As Integer
            Dim sSQL As String

            'count number of cati and reminder call steps current in protocol, add 1 for next call attempt
            sSQL = String.Format("SELECT ISNULL(MAX(ProtocolStepParamValue),-1) FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID IN (8, 10) AND ProtocolStepID IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolID = {0}) ", iProtocolID)
            Return CInt(SqlHelper.ExecuteScalar(Me._Conn, CommandType.Text, sSQL))

        End Function

        Private Function CountCallAttempt(ByVal ProtocolID As Integer, ByVal ProtocolStepParamID As Integer) As Integer
            Dim sqlCount As New Text.StringBuilder

            sqlCount.Append("SELECT COUNT(ProtocolStepParamID) FROM ProtocolStepParameters ")
            sqlCount.Append("WHERE ProtocolStepTypeParamID IN (8, 10) AND ")
            sqlCount.AppendFormat("ProtocolStepID IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolID = {0}) ", ProtocolID)
            sqlCount.AppendFormat("AND ProtocolStepParamValue IN (SELECT x.ProtocolStepParamValue FROM ProtocolStepParameters x WHERE ProtocolStepParamID = {0})", ProtocolStepParamID)

            Return CInt(SqlHelper.ExecuteScalar(Me._Conn, CommandType.Text, sqlCount.ToString))

        End Function

        Private Function ValidateCallsAttemptsGapFromRemoval(ByVal protocolID As Integer, ByVal protocolStepParamID As Integer)
            Dim sql As New Text.StringBuilder
            Dim result As Object

            sql.Append("SELECT COUNT(*) FROM ProtocolStepParameters ")
            sql.Append("WHERE ProtocolStepTypeParamID IN (8, 10) ")
            sql.AppendFormat("AND (ProtocolStepID IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolID = {0})) ", protocolID)
            sql.AppendFormat("AND (ProtocolStepParamValue IN (SELECT x.ProtocolStepParamValue FROM ProtocolStepParameters x WHERE ProtocolStepParamID = {0})) ", protocolStepParamID)
            sql.AppendFormat("AND (ProtocolStepParamID <> {0}) ", protocolStepParamID)

            result = SqlHelper.ExecuteScalar(Me._Conn, CommandType.Text, sql.ToString)

            If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
                If CInt(result) = 0 Then Return False
            End If

            Return True

        End Function

        Public Overrides Function VerifyDelete(ByVal dr As DataRow) As Boolean
            Dim MaxCalls As Integer
            Dim CallCount As Integer

            MaxCalls = Me.MaxCallAttempt(CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID")))

            If MaxCalls < CInt(dr.Item("ProtocolStepParamValue")) Then
                CallCount = Me.CountCallAttempt(CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID")), _
                    CInt(dr.Item("ProtocolStepParamID")))
                If CallCount = 1 Then
                    Me._ErrMsg = "Cannot delete. Deleting will result in a gap in the call attempts order."
                    Return False
                End If

            End If

            Return True

        End Function

        Public Overrides Function VerifyInsert(ByVal dr As DataRow) As Boolean
            Dim MaxCalls As Integer

            MaxCalls = Me.MaxCallAttempt(CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID"))) + 1
            If CInt(dr.Item("ProtocolStepParamValue")) > MaxCalls Then
                Me._ErrMsg = String.Format("Call attempt filter cannot be greater than {0}", MaxCalls)
                Return False

            End If

            Return True

        End Function

        Public Overrides Function VerifyUpdate(ByVal dr As DataRow) As Boolean
            Dim OldCallValue As Integer
            Dim NewCallValue As Integer

            OldCallValue = CInt(SqlHelper.ExecuteScalar(Me._Conn, CommandType.Text, _
                String.Format("SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepParamID = {0}", dr.Item("ProtocolStepParamID"))))
            NewCallValue = CInt(dr.Item("ProtocolStepParamValue"))

            'calls made value was changed, check for gap
            If OldCallValue <> NewCallValue Then
                Dim MaxCalls As Integer
                Dim CallCount As Integer
                Dim protocolID As Integer = CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID"))
                Dim protocolStepParamID As Integer = CInt(dr.Item("ProtocolStepParamID"))

                MaxCalls = Me.MaxCallAttempt(CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("ProtocolID")))

                'check if changed value exceeds current max call attempt
                If MaxCalls + 1 < NewCallValue Then
                    'new call attempts cannot be larger than max call attempts
                    Me._ErrMsg = String.Format("Call attempts cannot be larger than {0} calls", MaxCalls)
                    Return False

                End If

                'does removal of old calls made value leave a gap?
                If ((OldCallValue <> MaxCalls) Or (NewCallValue > MaxCalls)) AndAlso (Not ValidateCallsAttemptsGapFromRemoval(protocolID, protocolStepParamID)) Then
                    Me._ErrMsg = "Changing call attempts value will result in a call attempts gap"
                    Return False

                End If


            End If
            Return True

        End Function

    End Class

    Protected Class ptDaysAgo
        Inherits ParameterTypes

        Public Sub New(ByVal Connection As SqlClient.SqlConnection)
            MyBase.New(Connection)

        End Sub

        Public Overrides Sub SetDefaultValue(ByVal dr As DataRow)
            Dim StartDay As Integer
            StartDay = CInt(dr.GetParentRow("ProtocolStepsProtocolStepParameters").Item("StartDay"))
            dr.Item("ProtocolStepParamValue") = StartDay.ToString

        End Sub

    End Class

#End Region

End Class


#Region "ParameterControlTypes Class"
Public MustInherit Class ParameterControlTypes
    Protected _ErrMsg As String
    Protected _ControlValue As String
    Protected _ControlName As String
    Protected _ControlLabel As String
    Protected _Conn As SqlClient.SqlConnection

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        _Conn = Connection

    End Sub

    Public MustOverride Function ToHTMLStatic() As String
    Public MustOverride Function ToHTMLForm() As String

    Public Overridable Function ReadHTMLSubmit(ByRef r As System.Web.HttpRequest) As Boolean
        Dim ControlValue As String

        ControlValue = r.Item(Me._ControlName)
        If VerifySubmit(ControlValue) Then
            Me._ControlValue = ControlValue
            Return True

        Else
            Return False

        End If

    End Function

    Protected Overridable Function VerifySubmit(ByVal ControlValue As String) As Boolean
        Return True

    End Function

    Public ReadOnly Property ErrMsg() As String
        Get
            Return _ErrMsg

        End Get
    End Property

    Public Property Value() As String
        Get
            Return _ControlValue

        End Get
        Set(ByVal Value As String)
            _ControlValue = Value

        End Set
    End Property

    Public Property Name() As String
        Get
            Return _ControlName

        End Get
        Set(ByVal Value As String)
            _ControlName = Value

        End Set
    End Property

    Public Property Label() As String
        Get
            Return _ControlLabel

        End Get
        Set(ByVal Value As String)
            _ControlLabel = Value

        End Set
    End Property

    Public Shared Function GetObject(ByVal ControlTypeID As Integer, ByVal Connection As SqlClient.SqlConnection) As ParameterControlTypes
        Select Case ControlTypeID
            Case 1 'Textbox
                Return New pctTextBox(Connection)

            Case 2 'Checkbox
                Return New pctCheckbox(Connection)

            Case 4 'Numeric Textbox
                Return New pctNumericTextBox(Connection)

            Case 5 'Filter Event Code DDL
                Return New pctFilterEventCodeDropDown(Connection)

            Case 6 'File Def Filter DDL
                Return New pctFileDefFilterDropDown(Connection)

            Case 7 'Log Event Code DDL
                Return New pctLogEventCodeDropDown(Connection)

            Case 8 'Yes/No DDL
                Return New pctYesNoDropDown(Connection)

            Case 10 ' Generic DLL
                Return New pctDropDownList(Connection)

        End Select

    End Function

End Class

Public Class pctTextBox
    Inherits ParameterControlTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As New Text.StringBuilder

        html.AppendFormat("<span class=""gridlabel"">{0}</span>&nbsp;", Me._ControlLabel)
        html.AppendFormat(DMI.WebFormTools.TextBoxHTML(Me._ControlName, "", Me._ControlValue, 100, "gridtextfield"))

        Return html.ToString

    End Function

    Public Overrides Function ToHTMLStatic() As String
        Dim html As String

        html = String.Format("<span class=""label_desc"">{0}:</span>&nbsp;<span class=""text_desc"">{1}</span>", Me._ControlLabel, Me._ControlValue)

        Return html

    End Function

End Class

Public Class pctNumericTextBox
    Inherits pctTextBox

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As New Text.StringBuilder

        html.AppendFormat("<span class=""gridlabel"">{0}</span>&nbsp;", Me._ControlLabel)
        html.AppendFormat(DMI.WebFormTools.TextBoxHTML(Me._ControlName, "", Me._ControlValue, 10, "gridnumberfield"))

        Return html.ToString

    End Function

    Protected Overrides Function VerifySubmit(ByVal ControlValue As String) As Boolean
        If IsNumeric(ControlValue) Then
            Return True
        Else
            Me._ErrMsg = String.Format("{0} must be a numeric value.", Me._ControlLabel)
            Return False
        End If
    End Function

End Class

Public Class pctNumericOptionalTextBox
    Inherits pctTextBox

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As New Text.StringBuilder

        html.AppendFormat("<span class=""gridlabel"">{0}</span>&nbsp;", Me._ControlLabel)
        html.AppendFormat(DMI.WebFormTools.TextBoxHTML(Me._ControlName, "", Me._ControlValue, 10, "gridnumberfield"))

        Return html.ToString

    End Function

    Protected Overrides Function VerifySubmit(ByVal ControlValue As String) As Boolean
        If ControlValue = "" Then
            Return True
        ElseIf IsNumeric(ControlValue) Then
            Return True
        Else
            Me._ErrMsg = String.Format("{0} must be a numeric value.", Me._ControlLabel)
            Return False
        End If
    End Function

End Class

Public Class pctCheckbox
    Inherits ParameterControlTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As New Text.StringBuilder

        html.Append(DMI.WebFormTools.CheckBoxHTML(Me._ControlName, "", "1", Me.Checked, "gridcheckbox"))
        html.AppendFormat("<span class=""gridlabel"">{0}</span>", Me._ControlLabel)
        Return html.ToString

    End Function

    Public Overrides Function ToHTMLStatic() As String
        Dim html As String

        html = String.Format("<span class=""label_desc"">{0}:</span>&nbsp;<span class=""text_desc"">{1}</span>", Me._ControlLabel, IIf(Me.Checked, "Yes", "No").ToString)
        Return html

    End Function

    Public Overrides Function ReadHTMLSubmit(ByRef r As System.Web.HttpRequest) As Boolean
        If r.Item(Me._ControlName) = "1" Then
            Me.Checked = True
        Else
            Me.Checked = False
        End If

        Return True

    End Function

    Public Overridable Property Checked() As Boolean
        Get
            If Me._ControlValue = "1" Then
                Return True
            Else
                Return False
            End If

        End Get
        Set(ByVal Value As Boolean)
            If Value Then
                Me._ControlValue = "1"
            Else
                Me._ControlValue = "0"
            End If

        End Set
    End Property

End Class

Public Class pctDropDown
    Inherits ParameterControlTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As String

        html = String.Format("<span class=""gridlabel"">{0}</span>&nbsp;{1}", Me._ControlLabel, Me.DropDownHTML)
        Return html

    End Function

    Public Overrides Function ToHTMLStatic() As String
        Dim html As String

        html = String.Format("<span class=""label_desc"">{0}:</span>&nbsp;<span class=""text_desc"">{1}</span>", Me._ControlLabel, Me.ListItemText(Me._ControlValue))
        Return html

    End Function

    Protected Overridable Function DropDownHTML() As String
        Return ""

    End Function

    Protected Overridable Function ListItemText(ByVal ListItemValue) As String
        Return ""

    End Function
End Class

Public Class pctFilterEventCodeDropDown
    Inherits pctDropDown

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Protected Overrides Function DropDownHTML() As String
        Dim html As String
        Dim sqlDR As SqlClient.SqlDataReader

        sqlDR = QMS.clsEvents.GetEventDataSource(Me._Conn, "2,3,4,5,7")
        html = (DMI.WebFormTools.DropDownListHTML(Me._ControlName, "", _
            Me._ControlValue, sqlDR, "EventID", "Name", "gridselect", "0", "None"))
        sqlDR.Close()
        sqlDR = Nothing

        Return html

    End Function

    Protected Overrides Function ListItemText(ByVal ListItemValue As Object) As String
        Return clsQMSTools.GetEventName(CInt(Me._ControlValue))

    End Function

End Class

Public Class pctFileDefFilterDropDown
    Inherits pctDropDown

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Protected Overrides Function DropDownHTML() As String
        Dim html As String
        Dim sqlDR As SqlClient.SqlDataReader

        sqlDR = QMS.clsFileDefs.GetFileDefFilterDataSource(Me._Conn)
        html = (DMI.WebFormTools.DropDownListHTML(Me._ControlName, "", _
            Me._ControlValue, sqlDR, "FileDefFilterID", "FilterName", "gridselect", "0", "None"))
        sqlDR.Close()
        sqlDR = Nothing

        Return html

    End Function

    Protected Overrides Function ListItemText(ByVal ListItemValue As Object) As String
        Return clsQMSTools.GetFileDefFilterName(CInt(Me._ControlValue))

    End Function

End Class

Public Class pctLogEventCodeDropDown
    Inherits pctDropDown

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Protected Overrides Function DropDownHTML() As String
        Dim html As String
        Dim sqlDR As SqlClient.SqlDataReader

        sqlDR = QMS.clsEvents.GetEventDataSource(Me._Conn, "4,7")
        html = (DMI.WebFormTools.DropDownListHTML(Me._ControlName, "", _
            Me._ControlValue, sqlDR, "EventID", "Name", "gridselect", "0", "None"))
        sqlDR.Close()
        sqlDR = Nothing

        Return html

    End Function

    Protected Overrides Function ListItemText(ByVal ListItemValue As Object) As String
        Return clsQMSTools.GetEventName(CInt(Me._ControlValue))

    End Function

End Class

Public Class pctYesNoDropDown
    Inherits pctDropDown

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Protected Overrides Function DropDownHTML() As String
        Dim html As String

        html = DMI.WebFormTools.DropDownListHTML(Me._ControlName, "", Me._ControlValue, _
                    Split(";All;1;Yes;0;No", ";"), "gridselect", "", "")

        Return html

    End Function

    Protected Overrides Function ListItemText(ByVal ListItemValue As Object) As String
        Return clsQMSTools.GetYesNoText(ListItemValue)

    End Function

End Class

Public Class pctDropDownList
    Inherits ParameterControlTypes

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        MyBase.New(Connection)

    End Sub

    Public Overrides Function ToHTMLForm() As String
        Dim html As String

        html = String.Format("<span class=""gridlabel"">{0}</span>&nbsp;{1}", Me.GetDDLLabel, Me.GetDDLHtml)
        Return html

    End Function

    Public Overrides Function ToHTMLStatic() As String
        Dim html As String

        html = String.Format("<span class=""label_desc"">{0}:</span>&nbsp;<span class=""text_desc"">{1}</span>", Me.GetDDLLabel, Me.GetSelectedItemText)
        Return html

    End Function

    Private Function GetDDLLabel() As String
        Dim rx As Text.RegularExpressions.Regex
        Dim match As Text.RegularExpressions.Match

        match = rx.Match(Me._ControlLabel, "^([^\{]*)\s*\{{0,1}")
        If match.Success Then
            Return match.Groups(1).ToString
        End If

    End Function

    Private Function GetDDLListItems() As String
        Dim rx As Text.RegularExpressions.Regex
        Dim match As Text.RegularExpressions.Match

        match = rx.Match(Me._ControlLabel, "\{([^\}]*)\}")
        If match.Success Then
            Return match.Groups(1).ToString
        End If

    End Function

    Private Function GetDDLHtml() As String
        Return DMI.WebFormTools.DropDownListHTML(Me._ControlName, "", Me._ControlValue, _
            Split(Me.GetDDLListItems, ";"), "gridselect", "", "")

    End Function

    Private Function GetSelectedItemText() As String
        Return DMI.clsUtil.LookupString(Me._ControlValue, Me.GetDDLListItems)

    End Function

End Class

#End Region
