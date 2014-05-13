Imports NRC.NRCAuthLib
Partial Public Class SignIn
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Config.EnvironmentType = Framework.BusinessLogic.Configuration.EnvironmentTypes.Production Then
            ltlVerisign.Text = "<script src=https://seal.verisign.com/getseal?host_name=nrcpicker.com&size=M&use_flash=YES&use_transparent=YES&lang=en></script>"
            ltlScanAlert.Text = "<a target=""_blank"" href=""//www.scanalert.com/RatingVerify?ref=www.nrcpicker.com""><img width=""115"" height=""32"" border=""0"" src=""//images.scanalert.com/meter/www.nrcpicker.com/12.gif"" alt=""HACKER SAFE certified sites prevent over 99.9% of hacker crime."" oncontextmenu=""alert('Copying Prohibited by Law - HACKER SAFE is a Trademark of ScanAlert'); return false;""></a>"
        Else
            ltlVerisign.Text = "<P align='center'><IMG alt='' src='Img/NRCPicker/TempVerisign.gif'></P>"
            ltlScanAlert.Text = "<P align='center'><IMG alt='' src='Img/NRCPicker/TempHacker.gif'></P>"
        End If
    End Sub
End Class