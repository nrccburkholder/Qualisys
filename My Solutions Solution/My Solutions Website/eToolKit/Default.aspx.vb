Imports Nrc.Framework.Configuration.EnvironmentType
Imports Nrc.DataMart.MySolutions.Library.Legacy
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Default
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            'Set widths on login text boxes
            'Set default focus
            Dim ctrl As WebControl
            ctrl = Me.GetControl("txtUserName", Me.LoginView1)
            If ctrl IsNot Nothing Then
                ctrl.Focus()
                ctrl.Width = Unit.Pixel(150)
            End If

            ctrl = Me.GetControl("txtPassword", Me.LoginView1)
            If ctrl IsNot Nothing Then
                ctrl.Width = Unit.Pixel(150)
            End If

            'Show production or test images
            If Config.EnvironmentType = Production Then
                ltlVeriSign.Text = "<script src=https://seal.verisign.com/getseal?host_name=nrcpicker.com&size=M&use_flash=YES&use_transparent=YES&lang=en></script>"
                ltlScanAlert.Text = "<a target=""_blank"" href=""//www.scanalert.com/RatingVerify?ref=www.nrcpicker.com""><img width=""115"" height=""32"" border=""0"" src=""//images.scanalert.com/meter/www.nrcpicker.com/12.gif"" alt=""HACKER SAFE certified sites prevent over 99.9% of hacker crime."" oncontextmenu=""alert('Copying Prohibited by Law - HACKER SAFE is a Trademark of ScanAlert'); return false;"" /></a>"
            Else
                ltlVeriSign.Text = "<p align='center'><img alt='' src='../img/TempVerisign.gif' /></p>"
                ltlScanAlert.Text = "<p align='center'><img alt='' src='../img/TempHacker.gif' /></p>"
            End If

            '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
            '                                   Added new search parameter to GetRecentMemberResources
            '                                   function to allow filtering by groups.
            Dim tkServer As ToolkitServer = SessionInfo.EToolKitServer
            Dim serviceTypeId As Integer, selectedViewId As Integer
            Dim groupId As Integer
            If tkServer IsNot Nothing Then
                serviceTypeId = tkServer.MemberGroupPreference.ServiceTypeId
                selectedViewId = tkServer.MemberGroupPreference.SelectedViewId
                groupId = tkServer.MemberGroupPreference.GroupId
            End If

            Me.MemberResourcesList.DataSource = MemberResource.GetRecentMemberResources(serviceTypeId, selectedViewId, SessionInfo.SelectedDimensionId, SessionInfo.SelectedQuestionId, groupId)
            Me.MemberResourcesList.DataBind()
            Me.MemberResourceMoreLink.Enabled = CurrentUser.HasEToolkitAccess

        End If

        Dim login As NRCAuthLib.LoginControl = TryCast(Me.LoginView1.FindControl("LoginControl"), NRCAuthLib.LoginControl)
        If login IsNot Nothing Then
            If Request.QueryString("ReturnURL") IsNot Nothing Then
                login.DestinationPageUrl = Request.QueryString("ReturnURL")
            ElseIf Me.RequiresInitialize Then
                If MemberGroupPreference.IsChooseQuestionSelected Then
                    login.DestinationPageUrl = "~/eToolKit/QuestionSelection.aspx"
                Else
                    login.DestinationPageUrl = "~/eToolKit/ThemeSelection.aspx"
                End If
            End If
        End If
    End Sub

    Private Function GetControl(ByVal id As String) As WebControl
        Return GetControl(id, Me)
    End Function

    Private Function GetControl(ByVal id As String, ByVal container As Control) As WebControl
        Dim ctrl As Control = container.FindControl(id)

        If ctrl Is Nothing Then
            For Each childCtrl As Control In container.Controls
                ctrl = GetControl(id, childCtrl)
                If ctrl IsNot Nothing Then Exit For
            Next
        End If

        Return TryCast(ctrl, WebControl)
    End Function

    Protected Function NormalizeSpace(ByVal input As Object) As String
        Static pattern As New System.Text.RegularExpressions.Regex("\s+", RegexOptions.Compiled)
        Return pattern.Replace(DirectCast(input, String), " ").Trim()
    End Function

End Class