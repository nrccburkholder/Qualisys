Imports SurveyPointClasses
Imports SurveyPointDAL

Partial Class triggerdetail
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private _TriggerID As Integer = -1
    Private _ParentTriggerID As Integer = -1
    Private _ChildTriggerID As Integer = -1
    Private _RootCriteriaID As Integer = -1
    Private _TriggerHelper As clsTriggers = Nothing
    Private _CriteriaHelper As QMS.clsCriteria = Nothing
    Private _bFilledCriteria As Boolean = False
    Private _iSurveyID As Integer = -1

    Private _DBConn As SqlClient.SqlConnection = Nothing

    Public Const TRIGGER_ID_KEY As String = "id"
    Public Const PARENT_TRIGGER_ID_KEY As String = "pid"
    Public Const CHILD_TRIGGER_ID_KEY As String = "cid"
    Public Const ROOT_CRITERIA_ID_KEY As String = "criteria_id"
    Public Const PARENT_TRIGGER_SORT_KEY As String = "psort"
    Public Const CHILD_TRIGGER_SORT_KEY As String = "csort"
    Public Const ADD_TO_PARENT_ID_KEY As String = "parent"
    Public Const CHILD_CRITERIA_TYPE_ID_KEY As String = "type"
    Public Const DUMMY_SCRIPT_ID As Integer = -1
    Public Const SURVEY_ID_KEY As String = "survey_id"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then InitPage()

    End Sub

    Protected Sub InitPage()
        clsWebTools.fillTriggerTypeDDL(CType(ddlTriggerType, ListControl), "")
        clsWebTools.fillSurveyDDL(CType(ddlSurvey, ListControl), "")
        clsWebTools.fillInvocationPointDDL(CType(ddlInvocation, ListControl), "")
        clsWebTools.fillCriteriaTypeDDL(CType(ddlCriteriaTypeID, ListControl), "")

        ParentSort = "TriggerID"
        ChildSort = "TriggerID"
        RootCriteriaID = -1
        ViewState(ADD_TO_PARENT_ID_KEY) = ""
        ViewState(CHILD_CRITERIA_TYPE_ID_KEY) = ""

        QMS.clsQMSTools.FormatQMSDataGrid(dgParentTriggers)
        QMS.clsQMSTools.FormatQMSDataGrid(dgChildTriggers)
        QMS.clsQMSTools.FormatQMSDataGrid(dgCriteria)

        Dim trigger As dsSurveyPoint.TriggersRow
        Dim triggerName As String = "NONE"
        If (TriggerID > 0) Then
            LoadTriggerDetails()
        ElseIf (ParentTriggerID > 0) Then
            trigger = TriggerHelper.GetTriggerRow(ParentTriggerID)
            If Not trigger.IsTriggerNameNull() Then triggerName = trigger.TriggerName
            ltTriggerID.Text = String.Format("New Trigger Dependent on {0} - {1}", trigger.TriggerID, triggerName)
        ElseIf (ChildTriggerID > 0) Then
            trigger = TriggerHelper.GetTriggerRow(ChildTriggerID)
            If Not trigger.IsTriggerNameNull() Then triggerName = trigger.TriggerName
            ltTriggerID.Text = String.Format("New Parent Trigger for {0} - {1}", trigger.TriggerID, triggerName)
        Else
            ltTriggerID.Text = "New"
        End If

    End Sub

    Protected Sub LoadTriggerDetails()
        Dim trigger As dsSurveyPoint.TriggersRow = TriggerHelper.GetTriggerRow(TriggerID)
        ltTriggerID.Text = trigger.TriggerID
        ddlTriggerType.SelectedValue = trigger.TriggerTypeID
        ddlSurvey.Visible = False
        If Not trigger.IsSurveyIDNull() Then
            ltSurveyName.Text = trigger.SurveyName
            SurveyID = trigger.SurveyID
        Else
            ltSurveyName.Text = "NONE"
        End If

        If Not trigger.IsInvocationPointIDNull() Then ddlInvocation.SelectedValue = trigger.InvocationPointID
        If Not trigger.IsTriggerNameNull() Then tbTriggerName.Text = trigger.TriggerName
        If Not trigger.IsPerodicyDateNull() Then tbPerodicyDate.Text = trigger.PerodicyDate.ToShortDateString()
        If Not trigger.IsPerodicyNextDateNull() Then tbPerodicyDateNext.Text = trigger.PerodicyNextDate.ToShortDateString()
        If Not trigger.IsTheCodeNull() Then tbTriggerCode.Text = trigger.TheCode
        If Not trigger.IsCriteriaIDNull() Then RootCriteriaID = trigger.CriteriaID

        pnlSubInfo.Visible = True
        If Not trigger.IsSurveyIDNull() Then pnlCriteria.Visible = True
        LoadTriggerCriteria()
        LoadParentTriggers()
        LoadChildTriggers()

        'fill add trigger ddls here
        FillAddTriggerDDLs()
    End Sub

    Protected Sub FillAddTriggerDDLs()
        Dim iTriggerID As Integer = TriggerID
        Dim iSurveyID As Integer

        If (SurveyID > 0) Then
            iSurveyID = SurveyID
        Else
            iSurveyID = 0
        End If

        clsWebTools.fillTriggerDDL(CType(ddlAddParentTriggerID, ListControl), "New Trigger", iTriggerID, iSurveyID, -1, -1)
        clsWebTools.fillTriggerDDL(CType(ddlAddChildTriggerID, ListControl), "New Trigger", iTriggerID, iSurveyID, -1, -1)

    End Sub

    Protected Sub LoadTriggerCriteria()
        Dim c As QMS.clsCriteria = CriteriaHelper
        dgCriteria.DataKeyField = "CriteriaID"
        FillCriteria()
        c.DataGridBind(dgCriteria, "Hierarchy")

        If (c.MainDataTable.Rows.Count > 0) Then
            ltCriteriaResults.Text = String.Format("{0} criteria(s)", c.MainDataTable.Rows.Count)
        Else
            ltCriteriaResults.Text = "No criteria"
        End If

    End Sub

    Protected Sub LoadParentTriggers()
        Dim dt As dsSurveyPoint.TriggersDataTable = TriggerHelper.GetParentTriggers(TriggerID)
        Dim dv As DataView = dt.DefaultView
        dv.Sort = ParentSort

        dgParentTriggers.DataSource = dv
        dgParentTriggers.DataKeyField = "TriggerID"
        dgParentTriggers.DataBind()

        If (dt.Rows.Count > 0) Then
            ltParentsResults.Text = String.Format("Depending on {0} trigger(s)", dt.Rows.Count)
        Else
            ltParentsResults.Text = "Depending on no triggers"
        End If

    End Sub

    Protected Sub LoadChildTriggers()
        Dim dt As dsSurveyPoint.TriggersDataTable = TriggerHelper.GetChildTriggers(TriggerID)
        Dim dv As DataView = dt.DefaultView
        dv.Sort = ChildSort

        dgChildTriggers.DataSource = dv
        dgChildTriggers.DataKeyField = "TriggerID"
        dgChildTriggers.DataBind()

        If (dt.Rows.Count > 0) Then
            ltChildResults.Text = String.Format("{0} depending trigger(s)", dt.Rows.Count)
        Else
            ltChildResults.Text = "No depending triggers"
        End If

    End Sub

    Private Sub ibSave_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        If Page.IsValid Then
            SaveTrigger()
        End If
    End Sub

    Private Sub SaveTrigger()
        Dim trigger As dsSurveyPoint.TriggersRow = CopyFormToRow()
        If trigger.TriggerID = 0 Then
            Dim iTriggerID As Integer = TriggerHelper.InsertTrigger(trigger)
            _TriggerID = iTriggerID
            If ParentTriggerID > 0 Then
                TriggerHelper.MakeTriggerDependent(iTriggerID, ParentTriggerID)
            ElseIf ChildTriggerID > 0 Then
                TriggerHelper.MakeTriggerDependent(ChildTriggerID, iTriggerID)
            End If
            Dim url As String = String.Format("triggerdetail.aspx?{0}={1}", TRIGGER_ID_KEY, iTriggerID)
            Response.Redirect(url)
        Else
            TriggerHelper.UpdateTrigger(trigger)
            FillCriteria()
            If Not trigger.IsSurveyIDNull() Then
                pnlCriteria.Visible = True
                Dim SurveyID As Integer = trigger.SurveyID
                Dim criteria As QMS.dsCriteria.CriteriaRow
                For Each criteria In CriteriaHelper.MainDataTable.Rows
                    If (criteria.SurveyID <> SurveyID) Then criteria.SurveyID = SurveyID
                Next
                CriteriaHelper.Save()
            Else
                pnlCriteria.Visible = False
                Dim criteria As QMS.dsCriteria.CriteriaRow
                For Each criteria In CriteriaHelper.MainDataTable.Rows
                    criteria.Delete()
                Next
                CriteriaHelper.Save()
            End If

        End If
    End Sub

    Protected Sub FillCriteria()
        If Not _bFilledCriteria Then
            CriteriaHelper.ExpandCriteria(RootCriteriaID)
            _bFilledCriteria = True
        End If
    End Sub

    Protected ReadOnly Property TriggerID() As Integer
        Get
            If _TriggerID < 0 Then
                If Not IsNothing(ViewState(TRIGGER_ID_KEY)) Then
                    _TriggerID = CInt(ViewState(TRIGGER_ID_KEY))
                ElseIf IsNumeric(Request.QueryString(TRIGGER_ID_KEY)) Then
                    _TriggerID = CInt(Request.QueryString(TRIGGER_ID_KEY))
                    ViewState(TRIGGER_ID_KEY) = _TriggerID
                End If
            End If
            Return _TriggerID
        End Get
    End Property

    Protected ReadOnly Property ParentTriggerID() As Integer
        Get
            If _ParentTriggerID < 0 Then
                If Not IsNothing(ViewState(PARENT_TRIGGER_ID_KEY)) Then
                    _ParentTriggerID = CInt(ViewState(PARENT_TRIGGER_ID_KEY))
                ElseIf IsNumeric(Request.QueryString(PARENT_TRIGGER_ID_KEY)) Then
                    _ParentTriggerID = CInt(Request.QueryString(PARENT_TRIGGER_ID_KEY))
                    ViewState(PARENT_TRIGGER_ID_KEY) = _ParentTriggerID
                End If
            End If
            Return _ParentTriggerID

        End Get
    End Property

    Protected ReadOnly Property ChildTriggerID() As Integer
        Get
            If _ChildTriggerID < 0 Then
                If Not IsNothing(ViewState(CHILD_TRIGGER_ID_KEY)) Then
                    _ChildTriggerID = CInt(ViewState(CHILD_TRIGGER_ID_KEY))
                ElseIf IsNumeric(Request.QueryString(CHILD_TRIGGER_ID_KEY)) Then
                    _ChildTriggerID = CInt(Request.QueryString(CHILD_TRIGGER_ID_KEY))
                    ViewState(CHILD_TRIGGER_ID_KEY) = _ChildTriggerID
                End If
            End If
            Return _ChildTriggerID

        End Get
    End Property

    Protected ReadOnly Property TriggerHelper() As clsTriggers
        Get
            If IsNothing(_TriggerHelper) Then
                _TriggerHelper = New clsTriggers
                _TriggerHelper.DBConnection = DBConnection
            End If
            Return _TriggerHelper
        End Get
    End Property

    Protected ReadOnly Property CriteriaHelper() As QMS.clsCriteria
        Get
            If IsNothing(_CriteriaHelper) Then
                _CriteriaHelper = New QMS.clsCriteria(DBConnection)
            End If
            Return _CriteriaHelper
        End Get
    End Property

    Protected ReadOnly Property DBConnection() As SqlClient.SqlConnection
        Get
            If IsNothing(_DBConn) Then _DBConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            Return _DBConn
        End Get
    End Property

    Protected Property ParentSort() As String
        Get
            If IsNothing(ViewState(PARENT_TRIGGER_SORT_KEY)) Then ViewState(PARENT_TRIGGER_SORT_KEY) = "TriggerID"
            Return ViewState(PARENT_TRIGGER_SORT_KEY)
        End Get
        Set(ByVal Value As String)
            If Value = ViewState(PARENT_TRIGGER_SORT_KEY) Then
                ViewState(PARENT_TRIGGER_SORT_KEY) = String.Format("{0} DESC", Value)
            Else
                ViewState(PARENT_TRIGGER_SORT_KEY) = Value
            End If
        End Set
    End Property

    Protected Property ChildSort() As String
        Get
            If IsNothing(ViewState(CHILD_TRIGGER_SORT_KEY)) Then ViewState(CHILD_TRIGGER_SORT_KEY) = "TriggerID"
            Return ViewState(CHILD_TRIGGER_SORT_KEY)
        End Get
        Set(ByVal Value As String)
            If Value = ViewState(CHILD_TRIGGER_SORT_KEY) Then
                ViewState(CHILD_TRIGGER_SORT_KEY) = String.Format("{0} DESC", Value)
            Else
                ViewState(CHILD_TRIGGER_SORT_KEY) = Value
            End If
        End Set
    End Property

    Protected Property RootCriteriaID() As Integer
        Get
            If _RootCriteriaID < 0 Then
                If Not IsNothing(ViewState(ROOT_CRITERIA_ID_KEY)) Then
                    _RootCriteriaID = CInt(ViewState(ROOT_CRITERIA_ID_KEY))
                Else
                    ViewState(ROOT_CRITERIA_ID_KEY) = -1
                End If
            End If
            Return _RootCriteriaID
        End Get
        Set(ByVal Value As Integer)
            _RootCriteriaID = Value
            ViewState(ROOT_CRITERIA_ID_KEY) = _RootCriteriaID
        End Set
    End Property

    Private Sub Page_Unload(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Unload
        If Not IsNothing(_DBConn) Then
            If _DBConn.State = ConnectionState.Open Then _DBConn.Close()
            _DBConn.Dispose()
        End If
    End Sub

    Private Sub dgChildTriggers_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgChildTriggers.SortCommand
        ChildSort = e.SortExpression
    End Sub

    Private Sub dgParentTriggers_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgParentTriggers.SortCommand
        ParentSort = e.SortExpression
    End Sub

    Private Sub dgChildTriggers_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgChildTriggers.PageIndexChanged
        dgChildTriggers.CurrentPageIndex = e.NewPageIndex
        LoadChildTriggers()
    End Sub

    Private Sub dgParentTriggers_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgParentTriggers.PageIndexChanged
        dgParentTriggers.CurrentPageIndex = e.NewPageIndex
        LoadParentTriggers()
    End Sub

    Private Sub ibAddCriteria_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs)

        If (ddlCriteriaTypeID.SelectedIndex > 0) Then
            FillCriteria()
            ViewState(CHILD_CRITERIA_TYPE_ID_KEY) = CInt(ddlCriteriaTypeID.SelectedValue)
            With CriteriaHelper
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
                    LoadTriggerCriteria()

                End If
                If .ErrMsg.Length > 0 Then DMI.WebFormTools.Msgbox(Page, .ErrMsg)
            End With
        Else
            DMI.WebFormTools.Msgbox(Page, "Please select a criteria type to add")
        End If

    End Sub

    Private Sub ibDeleteCriteria_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDeleteCriteria.Click
        'cannot delete while in edit mode
        If dgCriteria.EditItemIndex = -1 Then
            Dim Criteria As QMS.clsCriteria = CriteriaHelper
            Dim drParent As DataRow

            'check for root criteria
            If Criteria.MainDataTable.Rows.Count = 1 Then
                'last criteria, remove reference to criteria in trigger
                Dim trigger As dsSurveyPoint.TriggersRow = TriggerHelper.GetTriggerRow(TriggerID)
                trigger.SetCriteriaIDNull()
                TriggerHelper.UpdateTrigger(trigger)

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

    End Sub

    Private Sub ibDeleteParent_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDeleteParent.Click
        TriggerDataGridDelete(dgParentTriggers, "cbSelectParent")
        dgParentTriggers.CurrentPageIndex = 0
        LoadParentTriggers()
    End Sub

    Private Sub ibDeleteChild_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDeleteChild.Click
        TriggerDataGridDelete(dgChildTriggers, "cbSelectChild")
        dgChildTriggers.CurrentPageIndex = 0
        LoadChildTriggers()
    End Sub

    Private Sub TriggerDataGridDelete(ByVal dg As DataGrid, ByVal cbName As String)
        Dim dgi As DataGridItem
        Dim iDeleteCount As Integer = 0

        For Each dgi In dg.Items
            If CType(dgi.FindControl(cbName), CheckBox).Checked Then
                Dim iTriggerID = CInt(dg.DataKeys(dgi.ItemIndex))
                TriggerHelper.DeleteTrigger(iTriggerID)
                iDeleteCount += 1
            End If
        Next

        If iDeleteCount > 0 Then
            'successful deletes
            DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

        Else
            'no deletes
            DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

        End If
    End Sub

    Private Sub dgCriteria_DeleteCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.DeleteCommand
        FillCriteria()
        CriteriaHelper.DataGridDelete(dgCriteria, "Hierarchy")
    End Sub

    Private Sub dgCriteria_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.UpdateCommand
        If Page.IsValid Then
            FillCriteria()
            Dim dr As QMS.dsCriteria.CriteriaRow
            Dim CriteriaID As Integer = CInt(dgCriteria.DataKeys(e.Item.ItemIndex))
            Dim Criteria As QMS.clsCriteria = CriteriaHelper
            Dim CriteriaType As QMS.clsCriteriaTypes

            'get existing datarow 
            dr = CType(Criteria.MainDataTable, QMS.dsCriteria.CriteriaDataTable).FindByCriteriaID(CriteriaID)
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

            dr.SurveyID = CInt(ddlSurvey.SelectedValue)

            'copy value into datarow
            CriteriaType = QMS.clsCriteriaTypes.GetObject(DBConnection, dr.CriteriaTypeID)
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
                Dim trigger As dsSurveyPoint.TriggersRow
                trigger = TriggerHelper.GetTriggerRow(TriggerID)
                trigger.CriteriaID = CInt(dr.Item("CriteriaID"))
                TriggerHelper.UpdateTrigger(trigger)
            End If

            'check for save errors
            If Criteria.ErrMsg.Length = 0 Then
                'exit edit mode and rebind datagrid
                dgCriteria.EditItemIndex = -1
                LoadTriggerCriteria()

            Else
                'display save errors
                DMI.WebFormTools.Msgbox(Page, Criteria.ErrMsg)

            End If

        End If

    End Sub

    Private Sub dgCriteria_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.EditCommand
        FillCriteria()
        CriteriaHelper.DataGridEditItem(dgCriteria, e, "Hierarchy")
    End Sub

    Private Sub dgCriteria_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.ItemCommand
        Select Case e.CommandName
            Case "Up"
                MoveCriteriaOrder(dgCriteria.DataKeys(e.Item.ItemIndex), -1)
            Case "Down"
                MoveCriteriaOrder(dgCriteria.DataKeys(e.Item.ItemIndex), 1)
        End Select

    End Sub

    Private Sub dgCriteria_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgCriteria.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim drv As DataRowView = CType(e.Item.DataItem, DataRowView)
            Dim CriteriaTypeID As Integer = CInt(drv.Item("CriteriaTypeID"))
            Dim CriteriaType As QMS.clsCriteriaTypes = QMS.clsCriteriaTypes.GetObject(DBConnection, CriteriaTypeID)

            CType(e.Item.FindControl("ltLvl"), Literal).Text = drv.Item("Lvl")
            CType(e.Item.FindControl("ltCriteriaTypeName"), Literal).Text = CriteriaHelper.GetCriteriaTypeName(CriteriaTypeID)
            If drv.Item("Flag") = 0 Then CType(e.Item.FindControl("ltCriteriaNot"), Literal).Text = "NOT"
            CType(e.Item.FindControl("ltSettingText"), Literal).Text = CriteriaType.Text(drv)

        ElseIf e.Item.ItemType = ListItemType.EditItem Then
            EditRow(e)

        End If

    End Sub

    Private Sub dgCriteria_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgCriteria.CancelCommand
        FillCriteria()
        CriteriaHelper.DataGridCancel(dgCriteria, "Hierarchy")

    End Sub

    Private Sub EditRow(ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs)
        Dim drv As DataRowView = e.Item.DataItem
        Dim CriteriaTypeID As Integer = CInt(drv.Item("CriteriaTypeID"))
        Dim CriteriaType As QMS.clsCriteriaTypes = QMS.clsCriteriaTypes.GetObject(DBConnection, CriteriaTypeID)

        With CType(e.Item.FindControl("ltCriteriaTypeName2"), Literal)
            .Visible = True
            .Text = CriteriaHelper.GetCriteriaTypeName(CriteriaTypeID)
        End With

        If drv.Item("Flag") = 0 Then
            CType(e.Item.FindControl("cbCriteriaNot"), CheckBox).Checked = True
        End If

        If CriteriaType.NeedAnswerCategoryID AndAlso Not CriteriaType.NeedQuestionID Then
            Dim ddl As DropDownList = CType(e.Item.FindControl("ddlAnswerCategoryID"), DropDownList)
            ddl.Visible = True
            ddl.Items.Clear()
            If ddlSurvey.SelectedIndex > 0 Then
                Dim SurveyID As Integer = CInt(ddlSurvey.SelectedValue)
                FillAnswerCategoryDDL(DBConnection, CType(ddl, ListControl), SurveyID, CriteriaType.MatchTextCategory)
            Else
                ddl.Items.Add(New ListItem("NO ANSWER CATEGORIES", ""))
            End If
            If Not IsDBNull(drv.Item("AnswerCategoryID")) Then ddl.SelectedValue = drv.Item("AnswerCategoryID")
            CType(e.Item.FindControl("cvAnswerCategoryID"), CompareValidator).Enabled = True
        End If

        If CriteriaType.NeedQuestionID Then
            Dim ddl As DropDownList = CType(e.Item.FindControl("ddlAnswerCategoryID"), DropDownList)
            ddl.Visible = True
            ddl.Items.Clear()
            If ddlSurvey.SelectedIndex > 0 Then
                Dim SurveyID As Integer = CInt(ddlSurvey.SelectedValue)
                FillAnswerCategoryDDL(DBConnection, CType(ddl, ListControl), SurveyID, CriteriaType.MatchTextCategory)
            Else
                ddl.Items.Add(New ListItem("NO ANSWER CATEGORIES", ""))
            End If
            If Not IsDBNull(drv.Item("AnswerCategoryID")) Then ddl.SelectedValue = drv.Item("AnswerCategoryID")
            CType(e.Item.FindControl("cvAnswerCategoryID"), CompareValidator).Enabled = True

        End If

        If CriteriaType.NeedCriteriaDataTypeID Then
            Dim ddl As DropDownList = CType(e.Item.FindControl("ddlCriteriaDataTypeID"), DropDownList)
            ddl.Visible = True
            FillCriteriaDataTypeDDL(DBConnection, CType(ddl, ListControl))
            If Not IsDBNull(drv.Item("CriteriaDataTypeID")) Then ddl.SelectedValue = drv.Item("CriteriaDataTypeID")
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

    Private Sub FillCriteriaDataTypeDDL(ByVal conn As SqlClient.SqlConnection, ByVal list As ListControl)
        Dim sqlDR As SqlClient.SqlDataReader
        Try
            sqlDR = QMS.clsCriteria.GetCriteriaDataTypes(conn)
            list.DataTextField = "CriteriaDataType"
            list.DataValueField = "CriteriaDataTypeID"
            list.DataSource = sqlDR
            list.DataBind()

        Catch ex As Exception
            Throw ex
        Finally
            If Not IsNothing(sqlDR) AndAlso Not sqlDR.IsClosed Then sqlDR.Close()
            sqlDR = Nothing

        End Try

    End Sub

    Private Sub FillAnswerCategoryDDL(ByVal conn As SqlClient.SqlConnection, ByVal list As ListControl, ByVal SurveyID As Integer, ByVal bTextCategoriesOnly As Boolean)
        Dim sqlDR As SqlClient.SqlDataReader
        Try
            sqlDR = QMS.clsCriteria.GetSurveyAnswerCategoryParameterList(DBConnection, SurveyID, bTextCategoriesOnly)
            list.DataValueField = "AnswerCategoryID"
            list.DataTextField = "AnswerText"
            list.DataSource = sqlDR
            list.DataBind()
        Catch ex As Exception
            Throw ex
        Finally
            If Not IsNothing(sqlDR) AndAlso Not sqlDR.IsClosed Then sqlDR.Close()
            sqlDR = Nothing

        End Try

    End Sub

    Private Sub MoveCriteriaOrder(ByVal CriteriaID As Integer, ByVal Move As Integer)
        FillCriteria()
        CriteriaHelper.ChangeCriteriaOrder(CriteriaID, Move)
        LoadTriggerCriteria()

    End Sub

    Public Sub ValidateTriggerCode(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim triggers As New QMS.clsTriggers(DBConnection)
        If triggers.VerifyTriggerCode(tbTriggerCode.Text) Then
            args.IsValid = True

        Else
            cuvTriggerCode.ErrorMessage = triggers.ErrMsg
            args.IsValid = False

        End If
    End Sub

    Public Function CopyFormToRow() As dsSurveyPoint.TriggersRow
        Dim ds As New dsSurveyPoint
        Dim row As dsSurveyPoint.TriggersRow = ds.Triggers.NewTriggersRow()

        If IsNumeric(ltTriggerID.Text) Then
            row.TriggerID = CInt(ltTriggerID.Text)
            If (SurveyID > 0) Then
                row.SurveyID = SurveyID
            Else
                row.SetSurveyIDNull()
            End If
        Else
            row.TriggerID = 0
            If (ddlSurvey.SelectedIndex > 0) Then
                row.SurveyID = CInt(ddlSurvey.SelectedValue)
            Else
                row.SetSurveyIDNull()
            End If
        End If
        row.TriggerName = tbTriggerName.Text
        row.TriggerTypeID = CInt(ddlTriggerType.SelectedValue)
        If (ddlInvocation.SelectedIndex > 0) Then
            row.InvocationPointID = CInt(ddlInvocation.SelectedValue)
        Else
            row.SetInvocationPointIDNull()
        End If
        If (tbPerodicyDate.Text.Length > 0) Then
            row.PerodicyDate = CDate(tbPerodicyDate.Text)
        Else
            row.SetPerodicyDateNull()
        End If
        If (tbPerodicyDateNext.Text.Length > 0) Then
            row.PerodicyNextDate = CDate(tbPerodicyDateNext.Text)
        Else
            row.SetPerodicyNextDateNull()
        End If
        row.TheCode = tbTriggerCode.Text

        Return row

    End Function

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

    Public Property SurveyID() As Integer
        Get
            If (_iSurveyID < 0) Then
                If Not IsNothing(ViewState(SURVEY_ID_KEY)) Then
                    _iSurveyID = CInt(ViewState(SURVEY_ID_KEY))
                ElseIf ddlSurvey.SelectedIndex > 0 Then
                    _iSurveyID = CInt(ddlSurvey.SelectedValue)
                End If
            End If
            Return _iSurveyID
        End Get
        Set(ByVal Value As Integer)
            _iSurveyID = Value
            ViewState(SURVEY_ID_KEY) = _iSurveyID
        End Set
    End Property

    Private Sub ibAddParent_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        If ddlAddParentTriggerID.SelectedIndex > 0 Then
            Dim ParentTriggerID As Integer = CInt(ddlAddParentTriggerID.SelectedValue)
            TriggerHelper.MakeTriggerDependent(TriggerID, ParentTriggerID)
            LoadParentTriggers()
            FillAddTriggerDDLs()
        Else
            Dim url As String = String.Format("triggerdetail.aspx?{0}={1}", CHILD_TRIGGER_ID_KEY, TriggerID)
            Response.Redirect(url)

        End If
    End Sub

    Private Sub ibAddChild_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        If ddlAddChildTriggerID.SelectedIndex > 0 Then
            Dim ChildTriggerID As Integer = CInt(ddlAddChildTriggerID.SelectedValue)
            TriggerHelper.MakeTriggerDependent(ChildTriggerID, TriggerID)
            LoadChildTriggers()
            FillAddTriggerDDLs()
        Else
            Dim url As String = String.Format("triggerdetail.aspx?{0}={1}", PARENT_TRIGGER_ID_KEY, TriggerID)
            Response.Redirect(url)
        End If

    End Sub

    Private Sub cuvTriggerNameUnique_ServerValidate(ByVal source As System.Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cuvTriggerNameUnique.ServerValidate

        args.IsValid = TriggerHelper.IsTriggerNameUnique(TriggerID, SurveyID, tbTriggerName.Text)

    End Sub

End Class
