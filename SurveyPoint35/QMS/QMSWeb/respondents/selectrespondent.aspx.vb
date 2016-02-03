Partial Class frmSelectRespondent
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

    Public Const REQUEST_INPUTMODE_ID_KEY As String = "input"
    Public Const REQUEST_RESPONDENT_ID_KEY As String = "rid"

    Private m_oRespondent As QMS.clsRespondents
    Private m_oConn As SqlClient.SqlConnection
    Private m_iInputMode As QMS.qmsInputMode = QMS.qmsInputMode.VIEW
    Private m_iRespondentID As Integer

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oRespondent = New QMS.clsRespondents(m_oConn)
        Session.Remove("ds")

        If ValidateSelection() Then
            'valid selection, go to respondent details
            PageCleanUp()
            Response.Redirect(String.Format("respondentdetails.aspx?rid={0}&input={1}", m_iRespondentID, CInt(m_iInputMode)))

        End If

        'invalid selection, return user back to starting point
        If m_oRespondent.ErrMsg.Length > 0 Then
            'display error msg
            DMI.WebFormTools.Msgbox(Page, m_oRespondent.ErrMsg)
            'add redirect javascript
            PageCleanUp()
            'Page.RegisterStartupScript("rd", String.Format("<SCRIPT language=JavaScript>this.document.location.href = ""{0}"";</script>", Request.UrlReferrer.PathAndQuery))
            Page.RegisterStartupScript("rd", "<SCRIPT language=JavaScript>history.go(-1)</script>")

        Else
            PageCleanUp()
            Response.Redirect(DMI.WebFormTools.ReflectURL(Request))

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oRespondent) Then
            m_oRespondent.Close()
            m_oRespondent = Nothing
        End If
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If

    End Sub

    Private Function ValidateSelection() As Boolean
        'verify input mode key
        If IsNumeric(Request.QueryString(REQUEST_INPUTMODE_ID_KEY)) Then m_iInputMode = CInt(Request.QueryString(REQUEST_INPUTMODE_ID_KEY))

        'verify respondent key
        If IsNumeric(Request.QueryString(REQUEST_RESPONDENT_ID_KEY)) Then
            m_iRespondentID = CInt(Request.QueryString("rid"))

            'verify selection
            If m_oRespondent.SelectForInput(m_iInputMode, m_iRespondentID, CInt(HttpContext.Current.User.Identity.Name)) Then
                Return True

            End If

        End If

        Return False

    End Function

End Class
