Option Explicit On 

Imports DMI

Public Enum FileDefType
    IMPORT = 2
    EXPORT = 1
    IMPORTUPDATE = 3

End Enum

Partial Class frmFileDefinitionDetails
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Protected WithEvents uctTemplates As ucTemplates

    Private Const DATASET_NAME As String = "FILEDEFINITIONS/FILEDEFINITIONDETAILS"
    Private Const DELETE_CELLINDEX As Integer = 0
    Private Const DISPLAYORDER_CELLINDEX As Integer = 1
    Private Const POSITION_CELLINDEX As Integer = 2
    Private Const WIDTH_CELLINDEX As Integer = 3
    Private Const COLUMNNAME_CELLINDEX As Integer = 4
    Private Const EDIT_CELLINDEX As Integer = 5
    Private Const DELIMITER_TABLEROWINDEX As Integer = 2

    Private m_oFileDef As QMS.clsFileDefs
    Private m_oFileDefColumns As QMS.clsFileDefColumns
    Private m_oConn As SqlClient.SqlConnection
    Private m_iPosition As Integer = 1

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            'Determine whether page setup is required:
            'FileDef has posted back to same page
            If Not Page.IsPostBack Then
                PageLoad()

            Else
                'retrieve search row
                LoadDataSet()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Or _
            QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Then
            CopyScript()
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'FileDef does not have FileDef viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        ViewState("LastSort") = "DisplayOrder"

        'set up search row
        If IsNumeric(Request.QueryString("id")) Then
            'save entity id on page
            viewstate("id") = Request.QueryString("id")

        ElseIf IsNumeric(Request.QueryString("copyid")) Then
            'viewstate("id") = m_oFileDef.Copy(Integer.Parse(Request.QueryString("copyid")))

        Else
            'save viewstate for future id
            viewstate("id") = ""

            'setup new file def controls
            sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
            ddlSurveyID.DataSource = sqlDR
            ddlSurveyID.DataValueField = "SurveyID"
            ddlSurveyID.DataTextField = "Name"
            ddlSurveyID.DataBind()
            ddlSurveyID.Items.Insert(0, New ListItem("None", ""))
            sqlDR.Close()

            sqlDR = QMS.clsFileDefs.GetFileDefTypeList(m_oConn)
            ddlFileDefTypeID.DataSource = sqlDR
            ddlFileDefTypeID.DataValueField = "FileDefTypeID"
            ddlFileDefTypeID.DataTextField = "FileDefTypeName"
            ddlFileDefTypeID.DataBind()
            ddlFileDefTypeID.Items.Insert(0, New ListItem("Select Type", ""))
            sqlDR.Close()

            sqlDR = QMS.clsFileDefs.GetFileTypeList(m_oConn)
            ddlFileTypeID.DataSource = sqlDR
            ddlFileTypeID.DataValueField = "FileTypeID"
            ddlFileTypeID.DataTextField = "FileTypeName"
            ddlFileTypeID.DataBind()
            ddlFileTypeID.Items.Insert(0, New ListItem("Select Format", ""))
            sqlDR.Close()

        End If

        sqlDR = QMS.clsClients.GetClientList(m_oConn)
        ddlClientID.DataSource = sqlDR
        ddlClientID.DataValueField = "ClientID"
        ddlClientID.DataTextField = "Name"
        ddlClientID.DataBind()
        ddlClientID.Items.Insert(0, New ListItem("None", ""))
        sqlDR.Close()

        QMS.clsQMSTools.FormatQMSDataGrid(dgFileDefColumns)
        dgFileDefColumns.DataKeyField = "FileDefColumnID"

        'get file def data
        LoadDataSet()

        LoadDetailsForm()

    End Sub

    Private Sub LoadDataSet()
        Dim dr As DataRow

        m_oFileDef = New QMS.clsFileDefs(m_oConn)
        m_oFileDefColumns = m_oFileDef.FileDefColumns

        If IsNumeric(viewstate("id")) Then
            m_oFileDef.FillAll(CInt(viewstate("id")), True)

        Else
            dr = m_oFileDef.NewSearchRow

            m_oFileDef.FillFileDefTypes()
            m_oFileDef.FillFileTypes()
            m_oFileDef.FillSurveys(dr)
            m_oFileDef.FillClients(dr)
            m_oFileDef.AddMainRow()

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        m_oFileDefColumns = Nothing
        If Not IsNothing(m_oFileDef) Then
            m_oFileDef.Close()
            m_oFileDef = Nothing
        End If

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.FILEDEF_DESIGNER) Then
            'must have designer rights to modify definition
            ibSave.Enabled = False
            ibAdd.Enabled = False
            ibDelete.Enabled = False
            ibUpdateOrder.Enabled = False

        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsFileDefs.FileDefsRow
        dr = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)

        'set FileDef id
        If dr.RowState = DataRowState.Added Then
            'new FileDef, no FileDef id
            ltFileDefID.Text = "NEW"
            SetupDetailsForm(True)
            uctTemplates.Visible = False

        Else
            'existing FileDef, display FileDef id
            ltFileDefID.Text = dr.FileDefID.ToString

            ltTypeName.Text = dr.GetParentRow("FileDefTypesFileDefs").Item("FileDefTypeName")
            ltFileFormatName.Text = dr.GetParentRow("FileTypesFileDefs").Item("FileTypeName")
            If Not dr.IsSurveyIDNull Then
                ltSurveyName.Text = dr.GetParentRow("SurveysFileDefs").Item("Name")
            Else
                ltSurveyName.Text = "NONE"
            End If
            If Not dr.IsClientIDNull Then DMI.clsUtil.SetDropDownSelection(ddlClientID, dr.ClientID.ToString)

            hlExecute.NavigateUrl = String.Format("ExecuteFileDef.aspx?id={0}", dr.FileDefID)

            SetupDetailsForm(False)
            SetupColumnDDL(dr.FileDefID)

            SetupFileDefType(dr.FileDefTypeID)
            SetupFileType(dr.FileTypeID)

            FileDefColumnsGridBind()

            uctTemplates.FileDefID = dr.FileDefID
            uctTemplates.fillGrid()

        End If

        tbFileDefName.Text = dr.FileDefName
        tbFileDefDescription.Text = dr.FileDefDescription
        If Not dr.IsFileDefDelimiterNull Then tbFileDefDelimiter.Text = dr.FileDefDelimiter

    End Sub

    Private Sub FileDefColumnsGridBind()
        m_oFileDefColumns.DataGridBind(dgFileDefColumns, ViewState("LastSort").ToString)

    End Sub

    Private Sub SetupColumnDDL(ByVal iFileDefID As Integer)
        Dim sqlDR As SqlClient.SqlDataReader

        Try
            sqlDR = QMS.clsFileDefColumns.GetColumnNames(m_oConn, iFileDefID)
            ddlColumnName.DataSource = sqlDR
            ddlColumnName.DataTextField = "Name"
            ddlColumnName.DataBind()

        Finally
            sqlDR.Close()
            sqlDR = Nothing

        End Try

    End Sub
    Private Sub SetupDetailsForm(ByVal bNew As Boolean)
        'display dropdowns for new
        ddlSurveyID.Visible = bNew
        ddlFileDefTypeID.Visible = bNew
        ddlFileTypeID.Visible = bNew
        'enable validators for new
        rfvFileDefTypeID.Enabled = bNew
        rfvFileTypeID.Enabled = bNew
        rfvSurveyId.Enabled = bNew
        If bNew Then rfvFileDefDelimiter.Enabled = False
        'display labels for existing
        ltSurveyName.Visible = Not bNew
        ltTypeName.Visible = Not bNew
        ltFileFormatName.Visible = Not bNew
        'display column controls for existing
        pnlFileDefColumns.Visible = Not bNew
        'allow execute for existing
        hlExecute.Visible = Not bNew

    End Sub

    'Form setup for import export type
    Private Sub SetupFileDefType(ByVal iFileDefType As FileDefType)
        Dim sqlDR As SqlClient.SqlDataReader

        Select Case iFileDefType
            Case FileDefType.IMPORT, FileDefType.IMPORTUPDATE
                ddlColumnName.Items.Add(New ListItem("New Property", "New Property"))
                ddlColumnName.Items.Add(New ListItem("Skip Field", "Skip Field"))
                If (iFileDefType = FileDefType.IMPORT AndAlso Not IsNothing(ddlColumnName.Items.FindByText("Respondent: RESPONDENTID"))) Then ddlColumnName.Items.Remove(ddlColumnName.Items.FindByText("Respondent: RESPONDENTID"))
                If Not IsNothing(ddlColumnName.Items.FindByText("Respondent: SURVEYINSTANCEID")) Then ddlColumnName.Items.Remove(ddlColumnName.Items.FindByText("Respondent: SURVEYINSTANCEID"))
                If Not IsNothing(ddlColumnName.Items.FindByText("Respondent: CALLSMADE")) Then ddlColumnName.Items.Remove(ddlColumnName.Items.FindByText("Respondent: CALLSMADE"))
                If Not IsNothing(ddlColumnName.Items.FindByText("Respondent: FINAL")) Then ddlColumnName.Items.Remove(ddlColumnName.Items.FindByText("Respondent: FINAL"))
                If Not IsNothing(ddlColumnName.Items.FindByText("Respondent: NEXTCONTACT")) Then ddlColumnName.Items.Remove(ddlColumnName.Items.FindByText("Respondent: NEXTCONTACT"))
                tblColumnControls.Rows(0).Cells(1).Visible = True
                tblColumnControls.Rows(1).Cells(1).Visible = True

            Case FileDefType.EXPORT
                tblColumnControls.Rows(0).Cells(1).Visible = False
                tblColumnControls.Rows(1).Cells(1).Visible = False

        End Select

    End Sub

    'Form setup for file type
    Private Sub SetupFileType(ByVal iFileType As FileTypes)

        Select Case iFileType
            Case FileTypes.COMMA_DELIMITED_TEXT, FileTypes.TAB_DELIMITED_TEXT
                'hide edit, position and width columns for delimited file types
                dgFileDefColumns.Columns(EDIT_CELLINDEX).Visible = False
                dgFileDefColumns.Columns(POSITION_CELLINDEX).Visible = False
                dgFileDefColumns.Columns(WIDTH_CELLINDEX).Visible = False

                'hide other delimiter parameter
                tbFileDefDelimiter.Visible = False
                rfvFileDefDelimiter.Enabled = False

            Case FileTypes.OTHER_DELIMITED_TEXT
                'hide edit, position and width columns for delimited file types
                dgFileDefColumns.Columns(EDIT_CELLINDEX).Visible = False
                dgFileDefColumns.Columns(POSITION_CELLINDEX).Visible = False
                dgFileDefColumns.Columns(WIDTH_CELLINDEX).Visible = False

                tbFileDefDelimiter.Enabled = True
                rfvFileDefDelimiter.Enabled = True

            Case FileTypes.FIXED_WIDTH_TEXT
                'hide other delimiter parameter
                tbFileDefDelimiter.Visible = False
                rfvFileDefDelimiter.Enabled = False

        End Select

    End Sub

    Private Sub ibSave_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSave.Click
        Try
            Dim dr As QMS.dsFileDefs.FileDefsRow
            Dim bNew As Boolean = False
            Dim iFileDefID As Integer

            If Page.IsValid Then
                dr = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)

                'set other fields
                dr.FileDefName = tbFileDefName.Text
                dr.FileDefDescription = tbFileDefDescription.Text

                If dr.RowState = DataRowState.Added Then
                    bNew = True
                    dr.FileDefTypeID = CInt(ddlFileDefTypeID.SelectedItem.Value)
                    dr.FileTypeID = CInt(ddlFileTypeID.SelectedItem.Value)
                    If ddlSurveyID.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)

                End If

                If ddlClientID.SelectedIndex > 0 Then
                    dr.ClientID = CInt(ddlClientID.SelectedItem.Value)
                Else
                    dr.SetClientIDNull()
                End If

                'get delimiter for other delimited file type
                If dr.FileTypeID = 3 Then dr.FileDefDelimiter = tbFileDefDelimiter.Text

                'commit changes to database
                m_oFileDef.Save()

                If m_oFileDef.ErrMsg.Length = 0 Then
                    iFileDefID = dr.FileDefID
                    SetupColumnDDL(iFileDefID)
                Else
                    'display error
                    DMI.WebFormTools.Msgbox(Page, m_oFileDef.ErrMsg)
                    bNew = False

                End If

            End If

            PageCleanUp()

            If bNew Then Response.Redirect(String.Format("filedefinitiondetails.aspx?id={0}", iFileDefID))

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "ibSave_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try
 
    End Sub

    Private Sub dgFileDefColumns_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgFileDefColumns.EditCommand
        Try
            m_oFileDefColumns.DataGridEditItem(dgFileDefColumns, e, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "dgFileDefColumns_EditCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgFileDefColumns_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgFileDefColumns.CancelCommand
        Try
            m_oFileDefColumns.DataGridCancel(dgFileDefColumns, ViewState("LastSort").ToString)
            tblColumnControls.Visible = True
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "dgFileDefColumns_CancelCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub


    Private Sub dgFileDefColumns_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgFileDefColumns.UpdateCommand
        Try
            Dim dr As QMS.dsFileDefs.FileDefColumnsRow
            Dim drFileDef As QMS.dsFileDefs.FileDefsRow

            If Page.IsValid Then
                'get reference to file def
                drFileDef = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)

                'get existing datarow or create new datarow
                dr = CType(m_oFileDefColumns.SelectRow(String.Format("FileDefColumnID = {0}", dgFileDefColumns.DataKeys(e.Item.ItemIndex))), QMS.dsFileDefs.FileDefColumnsRow)
                If IsNothing(dr) Then
                    m_oFileDefColumns.FileDefID = CInt(ViewState("id"))
                    m_oFileDefColumns.ColumnName = ViewState("NewColumnName").ToString
                    dr = CType(m_oFileDefColumns.AddMainRow, QMS.dsFileDefs.FileDefColumnsRow)

                End If

                'copy form values into datarow
                dr.ColumnName = CType(e.Item.FindControl("ltColumnName"), Literal).Text
                'get width for fixed width file types
                If drFileDef.FileTypeID = 4 Then dr.Width = CInt(CType(e.Item.FindControl("tbWidth"), TextBox).Text)

                'commit changes to database
                m_oFileDefColumns.Save()

                'check for save errors
                If m_oFileDefColumns.ErrMsg.Length = 0 Then
                    tblColumnControls.Visible = True
                    dgFileDefColumns.EditItemIndex = -1
                    FileDefColumnsGridBind()

                Else
                    'display save errors
                    DMI.WebFormTools.Msgbox(Page, m_oFileDefColumns.ErrMsg)

                End If

            End If

            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "dgFileDefColumns_UpdateCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub ibAdd_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdd.Click
        Try
            If ValidateColumnAdd() Then
                m_oFileDefColumns.FileDefID = CInt(ViewState("id"))
                If ddlColumnName.SelectedItem.Text = "New Property" Then
                    m_oFileDefColumns.ColumnName = String.Format("Property:{0}", tbPropertyName.Text.ToUpper.Trim)
                Else
                    m_oFileDefColumns.ColumnName = m_oFileDefColumns.AllowMultiSkipFields(ddlColumnName.SelectedItem.Text)
                End If

                'For fixed width file formats
                If CInt(m_oFileDef.MainDataTable.Rows(0).Item("FileTypeID")) = 4 Then
                    ViewState("NewColumnName") = ddlColumnName.SelectedItem.Text
                    m_oFileDefColumns.DataGridNewItem(dgFileDefColumns, ViewState("LastSort").ToString)
                    tblColumnControls.Visible = False

                Else
                    'for other formats, add row and commit to database
                    m_oFileDefColumns.AddMainRow()
                    m_oFileDefColumns.Save()

                    If m_oFileDefColumns.ErrMsg.Length > 0 Then
                        DMI.WebFormTools.Msgbox(Page, m_oFileDefColumns.ErrMsg)

                    End If

                    FileDefColumnsGridBind()

                End If

                'reset add controls
                ddlColumnName.SelectedIndex = 0
                tbPropertyName.Text = ""

            End If

            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "ibAdd_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            m_oFileDefColumns.DataGridDelete(dgFileDefColumns, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgFileDefColumns_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgFileDefColumns.ItemDataBound
        Dim drv As DataRowView
        Dim ddl As DropDownList
        Dim ddlValue As Integer

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            ddl = CType(e.Item.FindControl("ddlSortIndex"), DropDownList)
            ddlValue = drv("DisplayOrder")
            DMI.WebFormTools.GetSortOrderList(ddl, ddlValue, m_oFileDefColumns.MainDataTable.Rows.Count)

            'fixed width
            If m_oFileDef.MainDataTable.Rows(0).Item("FileTypeID") = 4 Then
                CType(e.Item.FindControl("ltPosition"), Literal).Text = m_iPosition
                Dim iWidth As Integer = 0
                If Not IsDBNull(drv.Item("Width")) Then iWidth = CInt(drv.Item("Width"))
                CType(e.Item.FindControl("ltWidth"), Literal).Text = iWidth.ToString()
                m_iPosition += iWidth

            End If
        End If

    End Sub

    Private Sub ibUpdateOrder_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateOrder.Click
        Try
            m_oFileDefColumns.DataGridUpdateOrder(dgFileDefColumns, ViewState("LastSort").ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "ibUpdateOrder_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub CopyScript()
        Dim iFileDefID As Integer

        If IsNumeric(Request.QueryString("copy")) Then
            iFileDefID = CInt(Request.QueryString("copy"))
            iFileDefID = CInt(QMS.clsFileDefs.Copy(m_oConn, iFileDefID))

            m_oConn.Close()
            m_oConn = Nothing

            Response.Redirect(String.Format("filedefinitiondetails.aspx?id={0}", iFileDefID))

        End If

    End Sub

    Private Function ValidateColumnAdd() As Boolean

        If ddlColumnName.SelectedItem.Text = "New Property" AndAlso _
            tbPropertyName.Text.Trim.Length = 0 Then
            'new property must be named
            DMI.WebFormTools.Msgbox(Page, "Please provide property name.")
            Return False

        ElseIf ddlColumnName.SelectedItem.Text <> "New Property" AndAlso tbPropertyName.Text.Length > 0 Then
            'cannot name non-property
            DMI.WebFormTools.Msgbox(Page, "Please clear property name. Cannot add column with name.")
            Return False

        ElseIf m_oFileDefColumns.ContainsColumnName(ddlColumnName.SelectedItem.Text) Then
            'cannot have more than one column with the same name
            DMI.WebFormTools.Msgbox(Page, m_oFileDefColumns.ErrMsg)
            Return False

        End If

        Return True

    End Function

    Private Sub ddlFileDefTypeID_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlFileDefTypeID.SelectedIndexChanged
        Try
            'disable survey required validator for IMPORT and EXPORT types

            If ddlFileDefTypeID.SelectedIndex > 0 Then
                Dim iFileDefType As FileDefType = CType(ddlFileDefTypeID.SelectedValue, FileDefType)
                rfvSurveyId.Enabled = (iFileDefType = FileDefType.IMPORTUPDATE)
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmFileDefinitionDetails), "ddlFileDefTypeID_SelectedIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub
End Class
