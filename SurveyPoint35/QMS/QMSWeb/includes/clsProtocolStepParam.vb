Public Enum tblProtocolStepParams
    ProtocolStepParamID = 0
    ProtocolStepID = 1
    ProtocolStepTypeParamID = 2
    ProtocolStepParamValue = 3
    ProtocolStepParamDesc = 4
    ProtocolID = 5
    ControlTypeID = 6
    ControlTypeName = 7

End Enum

<Obsolete("Use QMS.clsProtocolStepParameters")> _
Public Class clsProtocolStepParam
    Inherits clsDBEntity

    Public Const LU_CALLLIST_EVENT_CODES = "0;None;2006;Batched;3000;Not Batched;-3000;Data Entry Incomplete;3010;Verification Incomplete;3020;CATI Incomplete;3030;Reminder Call Incomplete;5009;Callback, No Appointment;-40001;1st Mailing, No Response;-40002;2nd Mailing, No Response"
    Private Const CLASS_LABEL_DESC = "label_desc"
    Private Const CLASS_LABEL_FORM = "label_form"
    Private Const CLASS_TEXT_DESC = "text_desc"

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Protected _iProtocolID As Integer

    Protected _iProtocolStepID As Integer

    Protected _iProtocolStepTypeParamID As Integer

    Default Public Overloads Property Details(ByVal eField As tblProtocolStepParams) As Object
        Get
            If eField = tblProtocolStepParams.ProtocolID Then
                Return Me._iProtocolID

            End If

            Return MyBase.Details(eField.ToString)

        End Get

        Set(ByVal Value As Object)
            If eField = tblProtocolStepParams.ProtocolStepParamID Then
                Me._iEntityID = Value

            ElseIf eField = tblProtocolStepParams.ProtocolID Then
                Me._iProtocolID = Value
                Return

            ElseIf eField = tblProtocolStepParams.ProtocolStepID Then
                Me._iProtocolStepID = Value

            ElseIf eField = tblProtocolStepParams.ProtocolStepTypeParamID Then
                Me._iProtocolStepTypeParamID = Value

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Public Overrides Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me.Details(tblProtocolStepParams.ProtocolStepParamID)
                    Me._iProtocolStepID = Me.Details(tblProtocolStepParams.ProtocolStepParamID)
                    Me._iProtocolStepTypeParamID = Me.Details(tblProtocolStepParams.ProtocolStepTypeParamID)
                    Me._iProtocolID = Me.Details(tblProtocolStepParams.ProtocolID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()

        'Define table
        Me._sTableName = "ProtocolStepParameters"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO ProtocolStepParameters (ProtocolStepID, ProtocolStepTypeParamID, ProtocolStepParamValue) "
        Me._sInsertSQL &= "VALUES ({1), {2}, {3}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE ProtocolStepParameters SET ProtocolStepParamValue = {3} "
        Me._sUpdateSQL &= "WHERE ProtocolStepID = {1} AND ProtocolStepTypeParamID = {2} "

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM ProtocolStepParameters WHERE ProtocolStepID = {1} AND ProtocolStepTypeParamID = {2} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT ProtocolStepParamID, ProtocolStepID, ProtocolStepTypeParamID, ProtocolStepParamValue, ProtocolStepParamDesc, ProtocolID, ControlTypeID, ControlTypeName "
        Me._sSelectSQL &= "FROM v_ProtocolStepParameters "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblProtocolStepParams.ProtocolStepParamID), _
                            Details(tblProtocolStepParams.ProtocolStepID), _
                            Details(tblProtocolStepParams.ProtocolStepTypeParamID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolStepParams.ProtocolStepParamValue)))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblProtocolStepParams.ProtocolStepParamID), _
                            Details(tblProtocolStepParams.ProtocolStepID), _
                            Details(tblProtocolStepParams.ProtocolStepTypeParamID), _
                            DMI.DataHandler.QuoteString(Details(tblProtocolStepParams.ProtocolStepParamValue)))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""


        If Not IsDBNull(Details(tblProtocolStepParams.ProtocolStepID)) Then
            sWHERESQL &= String.Format("ProtocolStepID = {0} AND ", Details(tblProtocolStepParams.ProtocolStepID))

        End If

        If Not IsDBNull(Details(tblProtocolStepParams.ProtocolStepTypeParamID)) Then
            sWHERESQL &= String.Format("ProtocolStepTypeParamID = {0} AND ", Details(tblProtocolStepParams.ProtocolStepTypeParamID))

        End If

        If Details(tblProtocolStepParams.ProtocolStepParamValue).ToString.Length > 0 Then
            sWHERESQL &= String.Format("ProtocolStepParamValue = {0} AND ", DMI.DataHandler.QuoteString(Details(tblProtocolStepParams.ProtocolStepParamValue)))

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    'Builds delete SQL from dataset
    Protected Overrides Function GetDeleteSQL() As String

        Return String.Format(Me._sDeleteSQL, Details(tblProtocolStepParams.ProtocolStepID), Details(tblProtocolStepParams.ProtocolStepTypeParamID))

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ProtocolStepParamID") = 0
        dr.Item("ProtocolStepID") = Me._iProtocolStepID
        dr.Item("ProtocolStepTypeParamID") = Me._iProtocolStepTypeParamID
        dr.Item("ProtocolStepParamValue") = ""

    End Sub

    Public Shared Function RenderHTMLDescription(ByRef ph As PlaceHolder, ByVal sControlType As String, ByVal sControlLabel As String, ByVal sControlValue As String, Optional ByVal sControlArg As String = "")

        Select Case sControlType
            Case "TextBox", "TextBoxNumeric"
                'do nothing

            Case "CheckBox"
                sControlValue = CStr(IIf(CInt(sControlValue) > 0, "Yes", "No"))

            Case "CallListFilterDropDownList"
                sControlValue = DMI.clsUtil.LookupString(sControlValue, LU_CALLLIST_EVENT_CODES)

            Case "EventCodeFilterDropDownList"
                sControlValue = clsQMSTools.GetEventName(CInt(sControlValue))

            Case "FileDefFilterDropDownList"
                sControlValue = clsQMSTools.GetFileDefFilterName(CInt(sControlValue))

            Case "LogEventCodeDropDownList"
                sControlValue = clsQMSTools.GetEventName(CInt(sControlValue))

        End Select

        ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{2}"">{0}:</span>&nbsp;<span class=""{3}"">{1}</span><br>", sControlLabel, sControlValue, CLASS_LABEL_DESC, CLASS_TEXT_DESC)))

    End Function

    Public Shared Function RenderHTMLControl(ByRef ph As PlaceHolder, ByVal sControlType As String, ByVal sControlLabel As String, ByVal sControlName As String, ByVal sControlValue As String, Optional ByVal sControlArg As String = "")
        Dim htmlc As HtmlControl

        Select Case sControlType
            Case "TextBox"
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span>&nbsp;", sControlLabel, CLASS_LABEL_FORM)))
                ph.Controls.Add(DMI.WebFormTools.GetTextBox(sControlName, sControlValue))

            Case "TextBoxNumeric"
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span>&nbsp;", sControlLabel, CLASS_LABEL_FORM)))
                htmlc = DMI.WebFormTools.GetTextBox(sControlName, sControlValue, "gridnumberfield")
                With CType(htmlc, HtmlInputText)
                    .MaxLength = 3
                End With
                ph.Controls.Add(htmlc)

            Case "CheckBox"
                'ph.Controls.Add(WebFormTools.GetCheckBox(sControlName, "1", Integer.Parse(sControlValue)))
                ph.Controls.Add(DMI.WebFormTools.GetCheckBoxHTML(sControlName, "1", Integer.Parse(sControlValue), "", "gridcheckbox"))
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("&nbsp;<span class=""{1}"">{0}</span>", sControlLabel, CLASS_LABEL_FORM)))

            Case "CallListFilterDropDownList"
                Dim i As Integer
                Dim ar As Array = Split(LU_CALLLIST_EVENT_CODES, ";")

                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span>&nbsp;", sControlLabel, CLASS_LABEL_FORM)))
                htmlc = DMI.WebFormTools.GetDropDownList(sControlName, "gridselect")
                With CType(htmlc, HtmlSelect)
                    For i = 0 To ar.Length - 1 Step 2
                        .Items.Add(New ListItem(ar(i + 1), ar(i)))

                    Next
                    .SelectedIndex = .Items.IndexOf(.Items.FindByValue(sControlValue))

                End With
                ph.Controls.Add(htmlc)

            Case "EventCodeFilterDropDownList"
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span><br>", sControlLabel, CLASS_LABEL_FORM)))
                htmlc = DMI.WebFormTools.GetDropDownList(sControlName, clsQMSTools.GetEventDataSource("2,3,4,5,7"), "EventID", "Name", sControlValue, "gridselect")
                CType(htmlc, HtmlSelect).Items.Insert(0, New ListItem("None", "0"))
                ph.Controls.Add(htmlc)

            Case "FileDefFilterDropDownList"
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span>&nbsp;", sControlLabel, CLASS_LABEL_FORM)))
                htmlc = DMI.WebFormTools.GetDropDownList(sControlName, clsQMSTools.GetFileDefFilterDataSource(), "FileDefFilterID", "FilterName", sControlValue, "gridselect")
                CType(htmlc, HtmlSelect).Items.Insert(0, New ListItem("None", "0"))
                ph.Controls.Add(htmlc)

            Case "LogEventCodeDropDownList"
                ph.Controls.Add(DMI.WebFormTools.GetLiteral(String.Format("<span class=""{1}"">{0}</span><br>", sControlLabel, CLASS_LABEL_FORM)))
                htmlc = DMI.WebFormTools.GetDropDownList(sControlName, clsQMSTools.GetEventDataSource("4,7"), "EventID", "Name", sControlValue, "gridselect")
                CType(htmlc, HtmlSelect).Items.Insert(0, New ListItem("None", "0"))
                ph.Controls.Add(htmlc)

        End Select
        ph.Controls.Add(DMI.WebFormTools.GetLiteral("<br>"))

    End Function

End Class
