Partial Class frmPreviewImport
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
	Private m_ds As DataSet
	Private m_dt As DataTable
	Private m_sJobID As String
	Private m_sWorkingFolder As String
	Private m_oConn As SqlClient.SqlConnection
	Private m_iImportRecordCount As Integer

	Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            'init variables
            m_ds = New DataSet
            m_sJobID = Request.QueryString("jobid")
            m_sWorkingFolder = Server.MapPath("../tmp")
            m_iImportRecordCount = DMI.clsPersistedJobStorage.GetJobStorageValue(m_sJobID, QMS.clsImportExport.JOB_PROPERTY_KEY_IMPORT_RECORD_COUNT)
            DMI.clsPersistedJobStorage.RemoveJobStorageValue(m_sJobID, QMS.clsImportExport.JOB_PROPERTY_KEY_IMPORT_RECORD_COUNT)

            Try
                'load dataset
                Dim sFirstXMLFile As String = QMS.clsImportExport.MakeImportXMLDatasetFilenameFromJobID(m_sWorkingFolder, m_sJobID, 0)
                m_ds.ReadXml(sFirstXMLFile)
                m_dt = m_ds.Tables(0)

                'load datagrid for non-postback
                If Not Page.IsPostBack Then PageSetup()

            Catch ex As Exception
                lblImportStatus.Text = String.Format("Import Error<br>{0}", ex.Message)
                lbImport.Visible = False

            End Try

        Catch ex As Exception
            clsLog.LogError(GetType(frmPreviewImport), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try


	End Sub

	Private Sub PageSetup()
		Viewstate("LastSort") = ""
		DataGridBind()
		CleanUp()

	End Sub

	Private Sub CleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If

	End Sub

    Private Sub DataGridBind()
        QMS.clsQMSTools.FormatQMSDataGrid(dgPreview)
        DMI.clsDataGridTools.DataGridBind(dgPreview, m_dt, ViewState("LastSort").ToString)
        lblImportStatus.Text = String.Format("{0} Rows Imported, {1} Rows Displayed", m_iImportRecordCount, m_dt.Rows.Count)
    End Sub

	Private Sub dgPreview_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgPreview.SortCommand
		ViewState("LastSort") = DMI.clsDataGridTools.DataGridSort(dgPreview, m_dt, e, ViewState("LastSort").ToString)
		CleanUp()

	End Sub

	Private Sub dgPreview_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgPreview.PageIndexChanged
        Try
            DMI.clsDataGridTools.DataGridPageChange(dgPreview, m_dt, e, ViewState("LastSort").ToString)
            CleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmPreviewImport), "dgPreview_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

	End Sub

	Private Sub lbImport_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbImport.Click
        Try
            Dim htJobSettings As Hashtable
            Dim oIE As New QMS.clsImportExport(m_oConn)
            Dim sWorkingFile As String = String.Format("{0}\{1}.TXT", Server.MapPath("../tmp"), m_sJobID)
            Dim sUpdateOnCols As String

            'check job settings stored in session variable
            If Not Session.Item("jobsettings") Is Nothing Then
                'get job settings, clean up session var
                oIE.ReadDBImportSettings(CType(Session.Item("jobsettings"), Hashtable))
                Session.Remove("jobsettings")
                htJobSettings = Nothing

                'Kick off import/export process
                oIE.WorkingFile = sWorkingFile
                oIE.UserID = CInt(HttpContext.Current.User.Identity.Name)
                Dim sJobID As String = oIE.Execute()

                If oIE.ErrorMsg.Length = 0 Then
                    'Go to progress page and wait for job to finish
                    Response.Redirect(String.Format("progress.aspx?jobid={0}&fdid={1}", sJobID, oIE.FileDefID))

                Else
                    DMI.WebFormTools.Msgbox(Page, oIE.ErrorMsg)

                End If

            Else
                DMI.WebFormTools.Msgbox(Page, "Cannot continue import, unable to access job settings.")

            End If

            CleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmPreviewImport), "lbImport_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

	End Sub

End Class
