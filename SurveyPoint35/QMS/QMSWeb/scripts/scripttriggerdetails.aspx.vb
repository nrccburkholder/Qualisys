Partial Class frmScriptTriggerDetails
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents ddlPrePostFlag As System.Web.UI.WebControls.DropDownList

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Const LAST_SORT_KEY As String = "LastSort"
    Public Const SCRIPT_TRIGGER_ID_KEY As String = "id"
    Public Const SCRIPT_SCREEN_ID_KEY As String = "ssid"
    Public Const SCRIPT_ID_KEY As String = "sid"
    Public Const ADD_TO_PARENT_ID_KEY As String = "parent"
    Public Const CHILD_CRITERIA_TYPE_ID_KEY As String = "type"

    Private m_ScriptTriggerDetails As QMS.clsScriptTriggerDetails
    Private m_Conn As SqlClient.SqlConnection
    Private m_DSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_Conn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_ScriptTriggerDetails = New QMS.clsScriptTriggerDetails(m_Conn)
        m_ScriptTriggerDetails.Triggers.UserID = CInt(HttpContext.Current.User.Identity.Name)
        m_DSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then
            PageLoad()
        Else
            'retrieve search row
            LoadDataSet()
        End If

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_VIEWER) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()
        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))
        End If

    End Sub

    Private Sub PageSetup()
        Dim ScriptTriggerID As Integer = CInt(String.Format("0{0}", Request.QueryString(SCRIPT_TRIGGER_ID_KEY)))
        Dim ScriptID As Integer = CInt(String.Format("0{0}", Request.QueryString(SCRIPT_ID_KEY)))
        Dim ScriptScreenID As Integer = CInt(String.Format("0{0}", Request.QueryString(SCRIPT_SCREEN_ID_KEY)))

        'setup view state vars
        ViewState(SCRIPT_TRIGGER_ID_KEY) = ScriptTriggerID
        ViewState(SCRIPT_ID_KEY) = ScriptID
        ViewState(SCRIPT_SCREEN_ID_KEY) = ScriptScreenID
        ViewState(LAST_SORT_KEY) = "Hierarchy"
        ViewState(ADD_TO_PARENT_ID_KEY) = ""
        ViewState(CHILD_CRITERIA_TYPE_ID_KEY) = ""

        'get datset
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrid
        dgCriteria.DataKeyField = "CriteriaID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgCriteria)
        CriteriaGridBind()

    End Sub

    Private Sub LoadDataSet()
        If CInt(ViewState(SCRIPT_TRIGGER_ID_KEY)) > 0 Then
            '*** existing row
            Dim SearchRow As QMS.dsScriptTriggers.SearchRow = m_ScriptTriggerDetails.ScriptTriggers.NewSearchRow
            SetSearchRow(SearchRow)
            m_ScriptTriggerDetails.Fill(SearchRow)

        Else
            '*** new row
            Dim ScriptTrigger As QMS.clsScriptTriggers = m_ScriptTriggerDetails.ScriptTriggers
            Dim Trigger As QMS.clsTriggers = m_ScriptTriggerDetails.Triggers
            Dim drScriptTrigger As DataRow
            Dim drTrigger As DataRow

            'add trigger row
            Trigger.ScriptID = CInt(ViewState(SCRIPT_ID_KEY))
            drTrigger = Trigger.AddMainRow

            'add script trigger row
            ScriptTrigger.ScriptID = CInt(ViewState(SCRIPT_TRIGGER_ID_KEY))
            ScriptTrigger.ScriptScreenID = CInt(ViewState(SCRIPT_SCREEN_ID_KEY))
            drScriptTrigger = ScriptTrigger.NewMainRow()
            drScriptTrigger.Item("TriggerID") = drTrigger.Item("TriggerID")
            ScriptTrigger.AddMainRow(drScriptTrigger)

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_Conn) Then
            m_Conn.Close()
            m_Conn.Dispose()
            m_Conn = Nothing
        End If
        If Not IsNothing(m_ScriptTriggerDetails) Then
            m_ScriptTriggerDetails.Close()
            m_ScriptTriggerDetails = Nothing
        End If

    End Sub


    Private Sub LoadDetailsForm()
        Dim ScriptTriggerRow As QMS.dsScriptTriggerDetails.ScriptedTriggersRow
        Dim TriggerRow As QMS.dsScriptTriggerDetails.TriggersRow
        Dim ScriptScreenDataReader As SqlClient.SqlDataReader
        ScriptTriggerRow = CType(Me.m_ScriptTriggerDetails.ScriptTriggers.MainDataTable.Rows(0), QMS.dsScriptTriggerDetails.ScriptedTriggersRow)
        TriggerRow = CType(Me.m_ScriptTriggerDetails.Triggers.MainDataTable.Rows(0), QMS.dsScriptTriggerDetails.TriggersRow)

        'update page variables
        If Not ScriptTriggerRow.IsTriggerIDValue1Null Then ViewState(SCRIPT_ID_KEY) = ScriptTriggerRow.TriggerIDValue1
        If Not ScriptTriggerRow.IsTriggerIDValue2Null Then ViewState(SCRIPT_SCREEN_ID_KEY) = ScriptTriggerRow.TriggerIDValue2

        'setup trigger type dropdownlist
        ScriptScreenDataReader = m_ScriptTriggerDetails.ScriptScreens.GetScriptScreensDataReader(Me.m_Conn, CInt(ViewState(SCRIPT_ID_KEY)))
        ddlScriptTriggerType.DataSource = ScriptScreenDataReader
        ddlScriptTriggerType.DataTextField = "ScreenTitle"
        ddlScriptTriggerType.DataValueField = "ScriptScreenID"
        ddlScriptTriggerType.DataBind()
        ScriptScreenDataReader.Close()
        ScriptScreenDataReader = Nothing
        ddlScriptTriggerType.Items.Insert(0, New ListItem(QMS.clsScripts.GetScriptName(Me.m_Conn, CInt(ViewState(SCRIPT_ID_KEY))), "0"))
        ddlScriptTriggerType.SelectedValue = ViewState(SCRIPT_SCREEN_ID_KEY).ToString

        If ScriptTriggerRow.RowState = DataRowState.Added Then
            ltScriptTriggerID.Text = "NEW"
            pnlCriteria.Visible = False

        Else
            ltScriptTriggerID.Text = ScriptTriggerRow.ScriptedTriggerID
            If Not ScriptTriggerRow.IsTriggerIDValue2Null Then
                ddlScriptTriggerType.SelectedValue = ViewState(SCRIPT_SCREEN_ID_KEY)

            End If
            'TP 20090710
            ddlSurvey.SelectedValue = ScriptTriggerRow.TriggerIDValue4
            'ddlPrePostFlag.SelectedValue = ScriptTriggerRow.TriggerIDValue4

            If Not TriggerRow.IsTriggerNameNull() Then tbTriggerName.Text = TriggerRow.TriggerName
            tbTriggerCode.Text = TriggerRow.TheCode

        End If

        SetCriteriaTypeDDL(ddlCriteriaTypeID)

        'set done link
        DMI.WebFormTools.SetReferingURL(Request, hlDone, "/scripts/scripttriggerdetails\.aspx", Session)

        'set critieria datagrid
        dgCriteria.DataKeyField = "CriteriaID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgCriteria)

    End Sub

    Sub CriteriaGridBind()
        Dim Criteria As QMS.clsCriteria = m_ScriptTriggerDetails.Criteria
        Dim iRowCount As Integer = Criteria.DataGridBind(dgCriteria, ViewState(LAST_SORT_KEY).ToString)

        ltSearchResults.Text = String.Format("{0} Criteria", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_DESIGNER) Then
            'must be script designer to add or delete scripts
            ibSave.Visible = False

        End If
    End Sub

    Private Sub SetSearchRow(ByRef dr As DataRow)
        If CInt(ViewState(SCRIPT_TRIGGER_ID_KEY)) > 0 Then dr.Item("ScriptedTriggerID") = ViewState(SCRIPT_TRIGGER_ID_KEY)
        If CInt(ViewState(SCRIPT_ID_KEY)) > 0 Then dr.Item("ScriptID") = ViewState(SCRIPT_ID_KEY)
        If CInt(ViewState(SCRIPT_SCREEN_ID_KEY)) > 0 Then dr.Item("ScriptScreenID") = ViewState(SCRIPT_SCREEN_ID_KEY)

    End Sub

    Private Sub ibSave_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        If Page.IsValid Then
            Dim ScriptTriggerRow As QMS.dsScriptTriggerDetails.ScriptedTriggersRow
            Dim TriggerRow As QMS.dsScriptTriggerDetails.TriggersRow
            Dim bNew As Boolean = False

            TriggerRow = CType(Me.m_ScriptTriggerDetails.Triggers.MainDataTable.Rows(0), QMS.dsScriptTriggerDetails.TriggersRow)
            TriggerRow.TriggerName = tbTriggerName.Text
            TriggerRow.TriggerTypeID = 1
            TriggerRow.TheCode = tbTriggerCode.Text
            m_ScriptTriggerDetails.Triggers.Save()

            ScriptTriggerRow = CType(Me.m_ScriptTriggerDetails.ScriptTriggers.MainDataTable.Rows(0), QMS.dsScriptTriggerDetails.ScriptedTriggersRow)
            If ScriptTriggerRow.RowState = DataRowState.Added Then bNew = True
            ScriptTriggerRow.TriggerIDValue1 = CInt(ViewState(SCRIPT_ID_KEY))
            If ddlScriptTriggerType.SelectedIndex > 0 Then
                ScriptTriggerRow.TriggerIDValue2 = ddlScriptTriggerType.SelectedValue
            Else
                ScriptTriggerRow.SetTriggerIDValue2Null()
            End If
            'TP 20090710
            ScriptTriggerRow.TriggerIDValue4 = CInt(ddlSurvey.SelectedValue)
            'ScriptTriggerRow.TriggerIDValue4 = CInt(ddlPrePostFlag.SelectedValue)
            m_ScriptTriggerDetails.ScriptTriggers.Save()

            If bNew Then Response.Redirect(String.Format("scripttriggerdetails.aspx?{1}={0}", ScriptTriggerRow.ScriptedTriggerID, Me.SCRIPT_TRIGGER_ID_KEY), True)

        End If

        PageCleanUp()

    End Sub

    Private Sub dgCriteria_DeleteCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.DeleteCommand
        m_ScriptTriggerDetails.Criteria.DataGridDelete(dgCriteria, "Hierarchy")
        PageCleanUp()

    End Sub

    Private Sub dgCriteria_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.EditCommand
        m_ScriptTriggerDetails.Criteria.DataGridEditItem(dgCriteria, e, "Hierarchy")
        PageCleanUp()

    End Sub

    Private Sub dgCriteria_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.UpdateCommand
        If Page.IsValid Then
            Dim dr As QMS.dsScriptTriggerDetails.CriteriaRow
            Dim Criteria As QMS.clsCriteria = Me.m_ScriptTriggerDetails.Criteria
            Dim CriteriaType As QMS.clsCriteriaTypes

            'get existing datarow 
            dr = CType(Criteria.SelectRow(String.Format("CriteriaID = {0}", dgCriteria.DataKeys(e.Item.ItemIndex))), QMS.dsScriptTriggerDetails.CriteriaRow)
            'or create new datarow
            If IsNothing(dr) Then
                If IsNumeric(ViewState(ADD_TO_PARENT_ID_KEY)) Then
                    'add subcriteria
                    dr = Criteria.AddMainRow(ViewState(ADD_TO_PARENT_ID_KEY), ViewState(CHILD_CRITERIA_TYPE_ID_KEY))
                Else
                    'add root criteria
                    Criteria.CriteriaTypeID = CInt(ViewState(CHILD_CRITERIA_TYPE_ID_KEY))
                    dr = Criteria.AddMainRow()
                End If

            End If

            'copy value into datarow
            CriteriaType = QMS.clsCriteriaTypes.GetObject(m_Conn, dr.CriteriaTypeID)
            With e.Item
                If CriteriaType.NeedAnswerCategoryID Then dr.AnswerCategoryID = CInt(CType(.FindControl("ddlAnswerCategoryID"), DropDownList).SelectedValue) Else dr.SetAnswerCategoryIDNull()
                If CriteriaType.NeedAnswerTextValue Then dr.TextValue = CType(.FindControl("tbAnswerTextValue"), TextBox).Text Else dr.SetTextValueNull()
                If CriteriaType.NeedCriteriaDataTypeID Then dr.CriteriaDataTypeID = CInt(CType(.FindControl("ddlCriteriaDataTypeID"), DropDownList).SelectedValue) Else dr.SetCriteriaDataTypeIDNull()
                If CriteriaType.NeedParameterTextValue Then dr.ParameterName = CType(.FindControl("tbParameterTextValue"), TextBox).Text Else dr.SetParameterNameNull()
                If CType(.FindControl("cbCriteriaNot"), CheckBox).Checked Then dr.Flag = 0 Else dr.Flag = 1

            End With
            CriteriaType = Nothing

            'commit changes to database
            Criteria.Save()

            'todo: set hierarch field

            'check if this is root criteria for trigger
            If Not IsNumeric(ViewState(ADD_TO_PARENT_ID_KEY)) Then
                Dim trigger As QMS.clsTriggers
                trigger = Me.m_ScriptTriggerDetails.Triggers
                trigger.MainDataTable.Rows(0).Item("CriteriaID") = dr.Item("CriteriaID")
                trigger.Save()
            End If

            'check for save errors
            If Criteria.ErrMsg.Length = 0 Then
                'exit edit mode and rebind datagrid
                dgCriteria.EditItemIndex = -1
                CriteriaGridBind()

            Else
                'display save errors
                DMI.WebFormTools.Msgbox(Page, Criteria.ErrMsg)

            End If

        End If
        PageCleanUp()

    End Sub

    Private Sub dgCriteria_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.CancelCommand
        m_ScriptTriggerDetails.Criteria.DataGridCancel(dgCriteria, "Hierarchy")
        PageCleanUp()

    End Sub

    Private Sub dgCriteria_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgCriteria.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim drv As DataRowView
            Dim CriteriaType As QMS.clsCriteriaTypes

            drv = CType(e.Item.DataItem, DataRowView)
            CriteriaType = QMS.clsCriteriaTypes.GetObject(m_Conn, CInt(drv.Item("CriteriaTypeID")))

            CType(e.Item.FindControl("ltLvl"), Literal).Text = drv.Item("Lvl")
            CType(e.Item.FindControl("ltCriteriaTypeName"), Literal).Text = drv.Row.GetParentRow("CriteriaTypesCriteria").Item("Name").ToString
            If drv.Item("Flag") = 0 Then CType(e.Item.FindControl("ltCriteriaNot"), Literal).Text = "NOT"
            CType(e.Item.FindControl("ltSettingText"), Literal).Text = CriteriaType.Text(drv)

        ElseIf e.Item.ItemType = ListItemType.EditItem Then
            EditRow(e)

        End If

    End Sub

    Private Sub EditRow(ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim drv As DataRowView
        Dim CriteriaType As QMS.clsCriteriaTypes

        drv = e.Item.DataItem
        CriteriaType = QMS.clsCriteriaTypes.GetObject(Me.m_Conn, CInt(drv.Item("CriteriaTypeID")))

        With CType(e.Item.FindControl("ltCriteriaTypeName2"), Literal)
            .Visible = True
            .Text = drv.Row.GetParentRow("CriteriaTypesCriteria").Item("Name").ToString
        End With

        If drv.Item("Flag") = 0 Then
            CType(e.Item.FindControl("cbCriteriaNot"), CheckBox).Checked = True
        End If

        If CriteriaType.NeedAnswerCategoryID AndAlso Not CriteriaType.NeedQuestionID Then
            With CType(e.Item.FindControl("ddlAnswerCategoryID"), DropDownList)
                .Visible = True
                Dim sqlDR As SqlClient.SqlDataReader
                sqlDR = QMS.clsCriteria.GetAnswerCategoryParameterList(Me.m_Conn, CInt(ViewState(SCRIPT_ID_KEY)), CriteriaType.MatchTextCategory)
                .DataValueField = "AnswerCategoryID"
                .DataTextField = "AnswerText"
                .DataSource = sqlDR
                .DataBind()
                sqlDR.Close()
                sqlDR = Nothing
                If Not IsDBNull(drv.Item("AnswerCategoryID")) Then .SelectedValue = drv.Item("AnswerCategoryID")
            End With
            CType(e.Item.FindControl("cvAnswerCategoryID"), CompareValidator).Enabled = True

        End If

        If CriteriaType.NeedQuestionID Then
            With CType(e.Item.FindControl("ddlAnswerCategoryID"), DropDownList)
                .Visible = True
                Dim sqlDR As SqlClient.SqlDataReader
                sqlDR = QMS.clsCriteria.GetAnswerCategoryParameterList(Me.m_Conn, CInt(ViewState(SCRIPT_ID_KEY)), CriteriaType.MatchTextCategory)
                .DataValueField = "AnswerCategoryID"
                .DataTextField = "AnswerText"
                .DataSource = sqlDR
                .DataBind()
                sqlDR.Close()
                sqlDR = Nothing
                If Not IsDBNull(drv.Item("AnswerCategoryID")) Then .SelectedValue = drv.Item("AnswerCategoryID")
            End With
            CType(e.Item.FindControl("cvAnswerCategoryID"), CompareValidator).Enabled = True

        End If

        If CriteriaType.NeedCriteriaDataTypeID Then
            With CType(e.Item.FindControl("ddlCriteriaDataTypeID"), DropDownList)
                .Visible = True
                Dim sqlDR As SqlClient.SqlDataReader
                sqldr = QMS.clsCriteria.GetCriteriaDataTypes(Me.m_Conn)
                .DataTextField = "CriteriaDataType"
                .DataValueField = "CriteriaDataTypeID"
                .DataSource = sqldr
                .DataBind()
                sqldr.Close()
                sqldr = Nothing
                If Not IsDBNull(drv.Item("CriteriaDataTypeID")) Then .SelectedValue = drv.Item("CriteriaDataTypeID")
            End With
            CType(e.Item.FindControl("cuvAnswerTextValue"), CustomValidator).Enabled = True
        End If

        If CriteriaType.NeedParameterTextValue Then
            With CType(e.Item.FindControl("tbParameterTextValue"), TextBox)
                .Visible = True
                If Not IsDBNull(drv.Item("ParameterName")) Then .Text = drv.Item("ParameterName")
            End With
            CType(e.Item.FindControl("rfvParameterTextValue"), RequiredFieldValidator).Enabled = True

        End If

        If CriteriaType.NeedAnswerTextValue Then
            With CType(e.Item.FindControl("tbAnswerTextValue"), TextBox)
                .Visible = True
                If Not IsDBNull(drv.Item("TextValue")) Then .Text = drv.Item("TextValue")

            End With

        End If

    End Sub

    Private Sub ibAdd_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        ViewState(CHILD_CRITERIA_TYPE_ID_KEY) = CInt(ddlCriteriaTypeID.SelectedValue)
        With m_ScriptTriggerDetails.Criteria
            If .MainDataTable.Rows.Count = 0 Then
                'add root criteria
                .CriteriaTypeID = CInt(ddlCriteriaTypeID.SelectedValue)
                .DataGridNewItem(dgCriteria, "Hierarchy")
            Else
                'check add child
                Dim dgi As DataGridItem
                Dim AddCriteria As Boolean = False
                For Each dgi In dgCriteria.Items
                    If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                        Dim dr As DataRow
                        AddCriteria = True
                        ViewState(ADD_TO_PARENT_ID_KEY) = CInt(dgCriteria.DataKeys(dgi.ItemIndex))
                        dr = .AddMainRow(ViewState(ADD_TO_PARENT_ID_KEY), CInt(ViewState(CHILD_CRITERIA_TYPE_ID_KEY)))
                        If Not IsNothing(dr) Then dgCriteria.EditItemIndex = dgi.ItemIndex + CInt(dr.Item("ReferenceCriteriaSequence"))
                        Exit For

                    End If

                Next
                If AddCriteria = False Then DMI.WebFormTools.Msgbox(Page, "Please select a criteria to add to")
                CriteriaGridBind()

            End If
            If .ErrMsg.Length > 0 Then DMI.WebFormTools.Msgbox(Page, .ErrMsg)
        End With
        PageCleanUp()

    End Sub

    Private Sub SetCriteriaTypeDDL(ByRef ddl As DropDownList)
        ddl.DataTextField = "Name"
        ddl.DataValueField = "CriteriaTypeID"
        ddl.DataSource = Me.m_ScriptTriggerDetails.DataSet.Tables("CriteriaTypes")
        ddl.DataBind()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        'cannot delete while in edit mode
        If dgCriteria.EditItemIndex = -1 Then
            Dim Criteria As QMS.clsCriteria = m_ScriptTriggerDetails.Criteria
            Dim drParent As DataRow

            'check for root criteria
            If Criteria.MainDataTable.Rows.Count = 1 Then
                'last criteria, remove reference to criteria in trigger
                Dim Triggers As QMS.clsTriggers = m_ScriptTriggerDetails.Triggers
                Triggers.MainDataTable.Rows(0).Item("CriteriaID") = DBNull.Value
                Triggers.Save()

            Else
                'get parent criteria for reordering of sibling criteria

            End If

            'delete selected criteria
            Criteria.DataGridDelete(dgCriteria, "Hierarchy")

            'reorder sibling criteria to remove sequence gaps after a delete
            If Not IsNothing(drParent) Then
                Criteria.UpdateOrder(drParent)
                Criteria.Save()
            End If

        End If
        PageCleanUp()

    End Sub

    Public Sub ValidateTriggerCode(source As object, args As ServerValidateEventArgs)
        If m_ScriptTriggerDetails.Triggers.VerifyTriggerCode(tbTriggerCode.Text) Then
            args.IsValid = True

        Else
            cuvTriggerCode.ErrorMessage = m_ScriptTriggerDetails.Triggers.ErrMsg
            args.IsValid = False

        End If
    End Sub

    Public Sub ValidateCriteriaDataType(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        If dgCriteria.EditItemIndex > -1 Then
            Dim dgi As DataGridItem = dgCriteria.Items(dgCriteria.EditItemIndex)
            Dim TextValue As String
            Dim CriteriaDataTypeID As Integer

            TextValue = CType(dgi.FindControl("tbAnswerTextValue"), TextBox).Text
            CriteriaDataTypeID = CInt(CType(dgi.FindControl("ddlCriteriaDataTypeID"), DropDownList).SelectedValue)
            args.IsValid = QMS.clsCriteria.ValidateCriteriaDataType(CriteriaDataTypeID, TextValue)

        Else
            args.IsValid = True

        End If

    End Sub

    Private Sub dgCriteria_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.ItemCommand
        Select Case e.CommandName
            Case "Up"
                MoveCriteriaOrder(dgCriteria.DataKeys(e.Item.ItemIndex), -1)

            Case "Down"
                MoveCriteriaOrder(dgCriteria.DataKeys(e.Item.ItemIndex), 1)

        End Select

    End Sub

    Private Sub MoveCriteriaOrder(ByVal CriteriaID As Integer, ByVal Move As Integer)
        m_ScriptTriggerDetails.Criteria.ChangeCriteriaOrder(CriteriaID, Move)
        CriteriaGridBind()
        PageCleanUp()

    End Sub

End Class
