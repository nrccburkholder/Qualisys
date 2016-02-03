Imports PS.Notification.Library
Imports PS.Framework.BusinessLogic.Validation
Imports PS.Notification.ServiceLibrary

Public Class ServiceTesterSection
    Private mSubSection As Section
    Private myVal As ObjectValidations
    Private mserivce As New ServiceLibrary.ServiceLibrary
    Friend WithEvents mNavigator As ServiceTesterNavigator
#Region "Baseclass Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavigator = DirectCast(navCtrl, ServiceTesterNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

#End Region

    Private Sub cmdStart_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStart.Click
        Me.mserivce.Start()
    End Sub

    Private Sub cmdStop_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdStop.Click

    End Sub

    Private Sub cmdPause_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdPause.Click

    End Sub

    Private Sub cmdResume_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdResume.Click

    End Sub

    Private Sub cmdValidEmails_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdValidEmails.Click
        Dim em As Email = Email.NewEmail(CurrentUser.UserName, False)
        em.AddTo("tpiccoli@nationalresearch.com")
        em.AddCC("jcintani@nationalresearch.com")
        em.AddBCC("jkubick@nationalresearch.com")
        em.FromEmailAddress = "tpiccoli@nationalresearch.com"
        em.Subject = "This is a test2."
        em.Body = "<h1><b>This is another test.</b></h1>"
        em.EmailType = EmailType.HTML
        'em.AddAttachment("C:\Documents and Settings\tpiccoli\Desktop\Internesdfrer.jpg")
        myVal = em.ValidateAndSendToQueue
        DataGridView1.DataSource = myVal.MyValidations
        Stop
    End Sub

    Private Sub cmdInvalidEmails_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdInvalidEmails.Click
        Dim em As Email = Email.NewEmail(CurrentUser.UserName, True)
        em.AddTo("tpiccoli@nationalResearch.com")
        em.AddCC("jcintani@nationalresearch.com")
        em.AddBCC("jkubick@nationalresearch.com")
        em.FromEmailAddress = "tpiccoli@nationalresearch.com"
        em.Subject = "This is a test2."
        em.Body = "<h1><b>This is another test.</b></h1>"
        em.EmailType = EmailType.HTML
        em.AddAttachment("C:\Documents and Settings\tpiccoli\Desktop\Internesdfrer.jpg")
        myVal = em.ValidateAndSendToQueue
        DataGridView1.DataSource = myVal.MyValidations
    End Sub
End Class
