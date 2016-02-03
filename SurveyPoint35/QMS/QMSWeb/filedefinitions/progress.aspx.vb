Option Strict On

Partial Class frmProgress

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


	Private m_oFileDef As QMS.clsFileDefs
	Private m_oConn As SqlClient.SqlConnection
	Private m_sJobID As String
	Private m_iFileDefID As Integer
    Private m_sDSName As String

	Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim oJobs As DMI.clsJobStatus
            m_sJobID = Request.QueryString("jobid").ToString
            m_iFileDefID = CInt(Request.QueryString("fdid"))
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_sDSName = Request.Url.AbsolutePath

            'Page setup
            If Not Page.IsPostBack Then PageSetup()

            'check job status and update screen
            If oJobs.CheckStatus(m_sJobID) = oJobs.JOB_NOT_FOUND Then
                JobCompleted()

            Else
                'Job in progress
                JobInProgress(oJobs.CheckStatus(m_sJobID))

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmProgress), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

	End Sub

	Private Sub LoadDataSet()
		Dim dr As DataRow

		'init dataset
		m_oFileDef = New QMS.clsFileDefs(m_oConn)
		m_oFileDef.DSName = m_sDSName

		If Not IsNothing(Session("ds")) AndAlso m_oFileDef.DSVerify(CType(Session("ds"), DataSet)) Then
			'verified dataset
			Exit Sub

		End If

		dr = m_oFileDef.NewSearchRow
		dr.Item("FileDefID") = m_iFileDefID
		m_oFileDef.FillFileDefTypes()
		m_oFileDef.FillFileTypes()
		m_oFileDef.FillSurveys(dr)
		m_oFileDef.FillClients(dr)
		m_oFileDef.FillMain(dr)
		Session("ds") = m_oFileDef.DataSet

	End Sub

	Private Sub PageSetup()
		Dim dr As QMS.dsFileDefs.FileDefsRow

		LoadDataSet()
		dr = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)

		'save file def properties
		ViewState("FileDefName") = dr.FileDefName
		ViewState("FileDefTypeName") = dr.GetParentRow("FileDefTypesFileDefs").Item("FileDefTypeName").ToString
		ViewState("FileDefTypeID") = CInt(dr.GetParentRow("FileDefTypesFileDefs").Item("FileDefTypeID"))

		'set progress title
		lblFileDefName.Text = String.Format("Running {0} {1}", ViewState("FileDefName"), ViewState("FileDefTypeName"))

		'display progress bar
		imgProgress.Visible = True

		'set cancel link
		hlExit.NavigateUrl = "filedefinitions.aspx"
		hlExit.Text = String.Format("Cancel {0} And Exit to File Definitions", ViewState("FileDefTypeName"))

		'set meta tag to refresh screen
        'ltRefreshMetaTag.Text = String.Format("<META HTTP-EQUIV=""Refresh"" CONTENT=""4; URL=progress.aspx?jobid={0}&fdid={1}"">", m_sJobID, 0)
        'ltRefreshMetaTag.Visible = True

        'this only works on iis 7
        'For i As Integer = 0 To Response.Headers.Keys.Count - 1
        '    If Response.Headers.Keys(i) = "Refresh" Then
        '        Response.Headers(Response.Headers.Keys(i)) = String.Format("4; URL=progress.aspx?jobid={0}&fdid={1}", m_sJobID, 0)
        '        Exit For
        '    End If
        '    If i = Response.Headers.Keys.Count - 1 Then
        '        Response.Headers.Add("Refresh", String.Format("4; URL=progress.aspx?jobid={0}&fdid={1}", m_sJobID, 0))
        '    End If
        'Next

        Response.ClearHeaders()
        Response.AddHeader("Refresh", String.Format("4; URL=progress.aspx?jobid={0}&fdid={1}", m_sJobID, 0))

    End Sub

	Private Sub CleanUp()
		If Not IsNothing(m_oFileDef) Then
			m_oFileDef.Close()
			m_oFileDef = Nothing

		End If
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If

	End Sub

	Private Sub ExportCompleted(ByVal sFileName As String)
		Dim iCountLines As Integer
		Dim fa As System.IO.FileInfo
		Dim sFilePath As String

		iCountLines = DMI.clsUtil.CountOfFileLines(String.Format("{0}\{1}.TXT", Server.MapPath("../tmp"), sFileName))
		If iCountLines > 0 Then
			sFilePath = String.Format("../tmp/{0}.TXT", sFileName)
			fa = New System.IO.FileInfo(Server.MapPath(sFilePath))
			lblJobStatus.Text = String.Format("<b>Export Completed!</b><br>Exported {0} rows, {1:#,0.0} KB<br>Right-click download button and select ""Save As"" to download File.", iCountLines, fa.Length() / 1024)
			hlDownload.NavigateUrl = sFilePath
            hlDownload.Visible = True
            ltOpenInExcel.Text = String.Format("Click <a href=""{0}"">here</a> To Open File In Excel.", ExcelExport.GetURL(sFilePath))
			fa = Nothing

		Else
			hlDownload.Text = "No rows exported. Please check export filter settings."
			hlDownload.NavigateUrl = "filedefinitions.aspx"
			hlDownload.Visible = True

		End If

    End Sub

    Private Function GetLogFilePathLink(ByVal sJobID As String) As String
        Dim sFileLink As String = String.Format("../tmp/{0}_log.TXT", sJobID)
        Dim sFilePath As String = Server.MapPath(sFileLink)
        Dim sLinkHTML As String = ""
        Dim fi As System.IO.FileInfo = New System.IO.FileInfo(sFilePath)

        If fi.Exists Then sLinkHTML = String.Format("<a href=""{0}"" target=""_log"">View Log</a>", sFileLink)

        Return sLinkHTML
    End Function


    Private Function UpdateExportStatus(ByVal sFileName As String) As Boolean
        Dim fa As System.IO.FileInfo
        Dim sfpath As String

        sfpath = String.Format("{0}\{1}.TXT", Server.MapPath("../tmp"), sFileName)
        If Dir(sfpath) <> "" Then
            fa = New System.IO.FileInfo(sfpath)
            lblJobStatus.Text = String.Format("{0:#,0.0} KB Exported. Please Wait... ", fa.Length() / 1024)
            fa = Nothing
            Return True

        End If

        Return False

    End Function

    Private Sub JobInProgress(ByVal iStatus As Integer)
        'Update file export message
        'If CType(ViewState("FileDefTypeID"), FileDefType) = FileDefType.EXPORT Then
        '	If UpdateExportStatus(m_sJobID) Then Exit Sub
        'End If

        'Update status message
        lblJobStatus.Text = String.Format("{0}% Complete. Please Wait... ", iStatus)

        CleanUp()

    End Sub

    Private Sub JobCompleted()
        Dim dr As QMS.dsFileDefs.FileDefsRow

        LoadDataSet()
        dr = CType(m_oFileDef.MainDataTable.Rows(0), QMS.dsFileDefs.FileDefsRow)

        'clean directory
        DMI.clsUtil.CleanDir(Server.MapPath("../tmp"), 12)

        'hide progress bar
        imgProgress.Visible = False

        'set exit link
        hlExit.NavigateUrl = "filedefinitions.aspx"
        hlExit.Text = "Exit to File Definitions"
        hlExit.ImageUrl = "../images/qms_done_btn.gif"

        'turn off page refresh
        'ltRefreshMetaTag.Text = ""
        'ltRefreshMetaTag.Visible = False

        'only works in iis 7
        'Dim HasRefreshTag As Boolean = False
        'For i As Integer = 0 To Response.Headers.Keys.Count - 1
        '    If Response.Headers.Keys(i) = "Refresh" Then
        '        HasRefreshTag = True
        '        Exit For
        '    End If
        'Next
        'If HasRefreshTag Then
        '    Response.Headers.Remove("Refresh")
        'End If

        Response.ClearHeaders()


        'set status message to complete
        lblJobStatus.Text = String.Format("{0} Finished. {1}", ViewState("FileDefTypeName"), GetLogFilePathLink(m_sJobID))

        'Job info
        If CType(dr.FileDefTypeID, FileDefType) = FileDefType.EXPORT OrElse CType(dr.FileDefTypeID, FileDefType) = FileDefType.IMPORTUPDATE Then
            'finished export, set download link
            ExportCompleted(m_sJobID)

        ElseIf Not Session.Item("jobsettings") Is Nothing Then
            'finished import to dataset, go to preview page
            Response.Redirect(String.Format("previewimport.aspx?jobid={0}", m_sJobID))

        End If
        LogCheck(m_sJobID, CInt(HttpContext.Current.User.Identity.Name))
        Session.Remove("ds")

        CleanUp()

    End Sub

    Private Sub LogCheck(ByVal sJobID As String, ByVal iUserID As Integer)
        Dim e As New QMS.clsEventLog(m_oConn)
        Dim dr As QMS.dsEventLog.SearchRow

        dr = CType(e.NewSearchRow, QMS.dsEventLog.SearchRow)
        dr.EventParameters = String.Format("{0}%", sJobID)
        dr.UserID = iUserID
        dr.EventStartRange = Date.Today()
        dr.EventIDList = String.Format("{0}, {1}, {2}, {3}", CInt(QMS.qmsEvents.EXPORT_COMPLETED), CInt(QMS.qmsEvents.EXPORT_ERROR), CInt(QMS.qmsEvents.IMPORT_COMPLETED), CInt(QMS.qmsEvents.IMPORT_ERROR))

        e.EnforceConstraints = False
        e.FillMain(CType(dr, DataRow))

        If e.MainDataTable.Rows.Count > 0 Then
            If CInt(e.MainDataTable.Rows(0).Item("EventID")) = QMS.qmsEvents.IMPORT_ERROR Then
                lblJobStatus.Text = "Import Error."
            ElseIf CInt(e.MainDataTable.Rows(0).Item("EventID")) = QMS.qmsEvents.EXPORT_ERROR Then
                lblJobStatus.Text = "Export Error."
            End If
            lblJobStatus.Text &= String.Format("<br>Job ID {0}", e.MainDataTable.Rows(0).Item("EventParameters"))
        End If

    End Sub

End Class
