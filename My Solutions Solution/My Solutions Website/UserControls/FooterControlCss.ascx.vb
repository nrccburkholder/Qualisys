Public Partial Class UserControls_FooterControlCss
    Inherits System.Web.UI.UserControl

    Private ReadOnly Property AppVersionNumber() As String
        Get
            Try
                Return My.Application.Info.Version.ToString()
            Catch ex As Exception
                Return "0.0.0.0"
            End Try
        End Get
    End Property

    ''' <summary>
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>2008.04.08 - Steve Kennedy - Changed privacy policy link URL per Ted 4/8</remarks>

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.PrivacyLink.NavigateUrl = Config.WWWNrcPickerUrl & "/Pages/PrivacyPolicy.aspx"
        Me.CopyrightLabel.Text = String.Format("© {0} NRC+Picker, a Division of National Research Corporation", Date.Today.Year)
        Me.VersionLabel.Text = Me.AppVersionNumber
        Me.DateTimeLabel.Text = Date.Now.ToString
    End Sub

End Class