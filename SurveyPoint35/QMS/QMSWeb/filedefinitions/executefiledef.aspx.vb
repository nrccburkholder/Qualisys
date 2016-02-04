Option Strict On
Imports System.Collections.Generic
Imports System.Xml

Partial Class frmExecuteFileDef
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


    Private m_oConn As SqlClient.SqlConnection
    Private m_oFileDef As QMS.clsFileDefs



    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
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
            clsLog.LogError(GetType(frmExecuteFileDef), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try
    End Sub

	Private Sub PageLoad()
		'security check
		If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Or _
		  QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Then
			PageSetup()
			SecuritySetup()
			PageCleanUp()

		Else
			'FileDef does not have FileDef viewing privledges, reflect
			Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

		End If

	End Sub

	Private Sub PageSetup()
		'set up search row
		If IsNumeric(Request.QueryString("id")) Then
			'save entity id on page
			viewstate("id") = Request.QueryString("id")

		End If

		'get file def data
		LoadDataSet()

		LoadDetailsForm()

	End Sub

	Private Sub LoadDataSet()
		Dim dr As DataRow

		m_oFileDef = New QMS.clsFileDefs(m_oConn)

		If IsNumeric(viewstate("id")) Then
			dr = m_oFileDef.NewSearchRow
			dr.Item("FileDefID") = CInt(viewstate("id"))
			m_oFileDef.FillFileDefTypes()
			m_oFileDef.FillFileTypes()
			m_oFileDef.FillSurveys(dr)
			m_oFileDef.FillClients(dr)
			m_oFileDef.FillMain(dr)

		End If

	End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oFileDef) Then
            m_oFileDef.Close()
            m_oFileDef = Nothing
        End If

    End Sub

    Private Sub SecuritySetup()
        Dim dr As DataRow = m_oFileDef.MainDataTable.Rows(0)

        If CType(dr.Item("FileDefTypeID"), FileDefType) = FileDefType.EXPORT Then
            If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EXPORT_ACCESS) Then
                ibExecute.Enabled = False
            End If

        ElseIf Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.IMPORT_ACCESS) Then
            ibExecute.Enabled = False

        End If

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsFileDefs.FileDefsRow = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)
        Dim iSurveyID As Integer
        Dim iClientID As Integer
        Dim sqlDR As SqlClient.SqlDataReader

        'fill in form fields
        lblFileDefName.Text = dr.Item("FileDefName").ToString
        lblFileDefDescription.Text = dr.Item("FileDefDescription").ToString
        lblFileDefTypeName.Text = dr.GetParentRow("FileDefTypesFileDefs").Item("FileDefTypeName").ToString
        lblFileTypeName.Text = dr.GetParentRow("FileTypesFileDefs").Item("FileTypeName").ToString
        If dr.IsSurveyIDNull Then
            lblSurveyName.Text = "NONE"
            iSurveyID = 0
        Else
            lblSurveyName.Text = dr.GetParentRow("SurveysFileDefs").Item("Name").ToString
            iSurveyID = dr.SurveyID
        End If
        If dr.IsClientIDNull Then
            lblClientName.Text = "NONE"
            iClientID = 0
        Else
            lblClientName.Text = dr.GetParentRow("ClientsFileDefs").Item("Name").ToString
            iClientID = dr.ClientID
        End If

        'fill in event log dropdown
        sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "4,7")
        ddlEventID.DataSource = sqlDR
        ddlEventID.DataValueField = "EventID"
        ddlEventID.DataTextField = "Name"
        ddlEventID.DataBind()
        ddlEventID.Items.Insert(0, New ListItem("No Event", "0"))
        sqlDR.Close()

        If CType(dr.FileDefTypeID, FileDefType) = FileDefType.EXPORT OrElse CType(dr.FileDefTypeID, FileDefType) = FileDefType.IMPORTUPDATE Then
            'EXPORTS SETUP

            'display export file title
            ltFormTitle.Text = "Execute Export File Definition"

            'display export fields and hide import field
            ExportHeaderRow.Visible = True
            ImportFileRow.Visible = False
            SurveyInstanceRow.Visible = False
            'tblExecuteForm.Rows(EXPORTHEADER_ROWINDEX).Visible = True
            'tblExecuteForm.Rows(IMPORTFILE_ROWINDEX).Visible = False
            'tblExecuteForm.Rows(SURVEYINSTANCE_ROWINDEX).Visible = False
            pnlExportFilters.Visible = True
            cuvFileImport.Enabled = False

            'setup survey instance export filter
            sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn, iSurveyID, iClientID)
            ddlSurveyInstanceIDExport.DataSource = sqlDR
            ddlSurveyInstanceIDExport.DataValueField = "SurveyInstanceID"
            ddlSurveyInstanceIDExport.DataTextField = "Name"
            ddlSurveyInstanceIDExport.DataBind()
            ddlSurveyInstanceIDExport.Items.Insert(0, New ListItem("None", "0"))
            ddlSurveyInstanceIDExport.Visible = False
            sqlDR.Close()
            'TP20091104
            'Setup for multiple survey instances
            sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn, iSurveyID, iClientID)
            ddlSurveyInstanceIDsExport.DataSource = sqlDR
            ddlSurveyInstanceIDsExport.DataValueField = "SurveyInstanceID"
            ddlSurveyInstanceIDsExport.DataTextField = "Name"
            ddlSurveyInstanceIDsExport.DataBind()
            'ddlSurveyInstanceIDsExport.Items.Insert(0, New ListItem("None", "0"))
            sqlDR.Close()
            'TP20091104
            'setup survey export filter
            If Not dr.IsSurveyIDNull Then
                ddlSurveyID.Items.Insert(0, New ListItem(dr.GetParentRow("SurveysFileDefs").Item("Name").ToString, dr.SurveyID.ToString))

            Else
                sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
                ddlSurveyID.DataSource = sqlDR
                ddlSurveyID.DataValueField = "SurveyID"
                ddlSurveyID.DataTextField = "Name"
                ddlSurveyID.DataBind()
                ddlSurveyID.Items.Insert(0, New ListItem("None", "0"))
                sqlDR.Close()

            End If

            'setup client export filter
            If Not dr.IsClientIDNull Then
                ddlClientID.Items.Insert(0, New ListItem(dr.GetParentRow("ClientsFileDefs").Item("Name").ToString, dr.ClientID.ToString))

            Else
                sqlDR = QMS.clsClients.GetClientList(m_oConn)
                ddlClientID.DataSource = sqlDR
                ddlClientID.DataValueField = "ClientID"
                ddlClientID.DataTextField = "Name"
                ddlClientID.DataBind()
                ddlClientID.Items.Insert(0, New ListItem("None", "0"))
                sqlDR.Close()

            End If

            'setup event filter
            sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "2,3,4,5,7")
            ddlEventIDFilter.DataSource = sqlDR
            ddlEventIDFilter.DataValueField = "EventID"
            ddlEventIDFilter.DataTextField = "Name"
            ddlEventIDFilter.DataBind()
            ddlEventIDFilter.Items.Insert(0, New ListItem("None", "0"))
            sqlDR.Close()

            'setup file def filter
            sqlDR = QMS.clsFileDefs.GetFileDefFilterDataSource(m_oConn)
            ddlFileDefFilterID.DataSource = sqlDR
            ddlFileDefFilterID.DataTextField = "FilterName"
            ddlFileDefFilterID.DataValueField = "FileDefFilterID"
            ddlFileDefFilterID.DataBind()
            ddlFileDefFilterID.Items.Insert(0, New ListItem("None", "0"))
            sqlDR.Close()

        Else
            '*** FOR IMPORTS ONLY

            'display export file title
            ltFormTitle.Text = "Execute Import File Definition"

            'hide export fields and display import field
            ExportHeaderRow.Visible = False
            ImportFileRow.Visible = True
            SurveyInstanceRow.Visible = True
            'tblExecuteForm.Rows(EXPORTHEADER_ROWINDEX).Visible = False
            'tblExecuteForm.Rows(IMPORTFILE_ROWINDEX).Visible = True
            'tblExecuteForm.Rows(SURVEYINSTANCE_ROWINDEX).Visible = True
            pnlExportFilters.Visible = False
            cuvFileImport.Enabled = True

            'setup import survey instance 
            sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn, iSurveyID, iClientID)
            ddlSurveyInstanceIDImport.DataSource = sqlDR
            ddlSurveyInstanceIDImport.DataValueField = "SurveyInstanceID"
            ddlSurveyInstanceIDImport.DataTextField = "Name"
            ddlSurveyInstanceIDImport.DataBind()
            ddlSurveyInstanceIDImport.Items.Insert(0, New ListItem("None", "0"))
            sqlDR.Close()

        End If

        'Set cancel link url
        DMI.WebFormTools.SetReferingURL(Request, hlCancel)

    End Sub

    Private Sub ExecuteAndRedirect()
        Dim dr As QMS.dsFileDefs.FileDefsRow = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)
        Dim iEventCode As Integer = CInt(ddlEventID.SelectedItem.Value)
        Dim oIE As New QMS.clsImportExport(m_oConn, True)
        Dim sJobID As String = oIE.JobID
        Dim sWorkingFile As String = String.Format("{0}\{1}.TXT", Server.MapPath("../tmp"), sJobID)
        Diagnostics.Debug.Assert((Not (sJobID Is Nothing)) And (sJobID.Length > 0), "Invalid job id!")

        Dim ht As Hashtable

        'Import specific tasks
        If CType(dr.FileDefTypeID, FileDefType) = FileDefType.IMPORT Then
            'save uploaded import file
            Try
                fileImport.PostedFile.SaveAs(sWorkingFile)

            Catch ex As Exception
                ex.ToString()

            End Try

            'check for update columns
            '*** code goes here

            'save import job settings for step 2 of import
            Session.Add("jobsettings", oIE.MakeDBImportSettings(dr.FileDefID, _
              CInt(ddlSurveyInstanceIDImport.SelectedItem.Value), _
              iEventCode, sJobID))

            'kick off import process
            oIE.WorkingFile = sWorkingFile
            oIE.FileDefID = dr.FileDefID
            oIE.UserID = CInt(HttpContext.Current.User.Identity.Name)
            oIE.Execute()

        Else
            'export

            'kick off export process
            oIE.InsertExportHeaderRow = cbExportHeader.Checked
            oIE.WorkingFile = sWorkingFile
            oIE.FileDefID = dr.FileDefID
            oIE.UserID = CInt(HttpContext.Current.User.Identity.Name)
            oIE.LogEventID = iEventCode
            oIE.ExportFilters = SaveExportJobSettings()
            oIE.Execute()

        End If

        If oIE.ErrorMsg.Length > 0 Then
            DMI.WebFormTools.Msgbox(Page, oIE.ErrorMsg)
            oIE.Close()
            PageCleanUp()

        Else
            'Go to progress page and wait for job to finish
            Response.Redirect(String.Format("progress.aspx?jobid={0}&fdid={1}", sJobID, dr.FileDefID))

        End If

    End Sub

    Private Function SaveExportJobSettings() As Hashtable
        Dim ht As New Hashtable

        'survey instance id
        If ddlSurveyInstanceIDExport.SelectedIndex > 0 Then ht.Add("SurveyInstanceID", ddlSurveyInstanceIDExport.SelectedItem.Value)
        Dim siString As String = ""
        For Each item As ListItem In ddlSurveyInstanceIDsExport.Items
            If CInt(item.Value) > 0 AndAlso item.Selected Then
                siString &= item.Value & ","
            End If
        Next
        If siString.Length > 0 Then
            siString = siString.Substring(0, siString.Length - 1)
            ht.Add("SurveyInstanceIDs", siString)
        End If
        'survey instance date range
        'If tbSurveyInstanceDateAfter.Text.Length > 0 Then ht.Add("SurveyInstanceDateAfter", tbSurveyInstanceDateAfter.Text)
        'If tbSurveyInstanceDateBefore.Text.Length > 0 Then ht.Add("SurveyInstanceDateBefore", tbSurveyInstanceDateBefore.Text)
        'mailing seeds filter
        ht.Add("IncludeMailSeeds", False)
        'survey filter
        If CInt(ddlSurveyID.SelectedItem.Value) > 0 Then ht.Add("SurveyID", ddlSurveyID.SelectedItem.Value)
        'client filter
        If CInt(ddlClientID.SelectedItem.Value) > 0 Then ht.Add("ClientID", ddlClientID.SelectedItem.Value)
        'event code filter
        If ddlEventIDFilter.SelectedIndex > 0 Then ht.Add("EventID", ddlEventIDFilter.SelectedItem.Value)
        'event code date range
        If tbEventDateAfter.Text.Length > 0 Then ht.Add("EventDateAfter", tbEventDateAfter.Text)
        If tbEventDateBefore.Text.Length > 0 Then ht.Add("EventDateBefore", tbEventDateBefore.Text)
        'Batch numbers
        'If tbBatchIDs.Text.Length > 0 Then ht.Add("BatchIDs", tbBatchIDs.Text)
        'Other filters
        If ddlFileDefFilterID.SelectedIndex > 0 Then ht.Add("FileDefFilterID", ddlFileDefFilterID.SelectedItem.Value)
        'final codes
        If ddlFinal.SelectedIndex > 0 Then ht.Add("Final", ddlFinal.SelectedValue)
        'If cbExcludeFinalCodes.Checked Then ht.Add("ExcludeFinalCodes", True)
        'active respondents
        If cbActive.Checked Then ht.Add("Active", 1)
        If txtRespID.Text <> String.Empty Then ht.Add("RespondentID", txtRespID.Text)


        Return ht

    End Function

    Private Sub ibExecute_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExecute.Click
        Try
            If Page.IsValid Then
                'excute code here
                ExecuteAndRedirect()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmExecuteFileDef), "ibExecute_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured executing.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Public Sub ValidateFileImport(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        'check if file was uploaded
        If Request.Files(0).ContentLength = 0 Then
            args.IsValid = False

        Else
            args.IsValid = True

        End If

    End Sub

    Private Sub btnGetCount_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGetCount.Click
        Try
            If Page.IsValid Then
                Dim oIE As New QMS.clsImportExport(m_oConn, True)
                Dim drCriteria As DataRow = oIE.Respondents.NewSearchRow
                Dim RespondentCount As Integer

                oIE.ExportFilters = SaveExportJobSettings()
                oIE.SetSearchCriteria(drCriteria)
                Dim dxv As New QMS.clsDataExtractView(m_oConn)
                dxv.SurveyID = CInt(ddlSurveyID.SelectedValue)
                RespondentCount = dxv.RespondentCount(drCriteria)

                DMI.WebFormTools.Msgbox(Page, String.Format("{0} Respondents", RespondentCount))

            End If
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmExecuteFileDef), "btnGetCount_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured getting count.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Protected Sub ClearInstanceSelection_Click(ByVal sender As Object, ByVal e As EventArgs) Handles ClearInstanceSelection.Click
        For Each x As ListItem In ddlSurveyInstanceIDsExport.Items
            x.Selected = False
        Next
    End Sub
End Class
