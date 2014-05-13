Imports System.ServiceProcess
Imports Nrc.QualiSys.Scanning.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class MainForm

    Private Sub TransferResultsServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferResultsServiceButton.Click

        Dim transferForm As New QSITransferResultsServiceTest
        transferForm.Show(Me)

    End Sub

    Private Sub FileMoverServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileMoverServiceButton.Click

        Dim fileMoverForm As New QSIFileMoverServiceTest
        fileMoverForm.Show(Me)

    End Sub

    Private Sub VoviciServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VoviciServiceButton.Click

        Dim voviciForm As New QSIVoviciServiceTest
        voviciForm.Show(Me)

    End Sub

    Private Sub VendorFileServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VendorFileServiceButton.Click

        Dim vendorFileForm As New QSIVendorFileServiceTest
        vendorFileForm.Show(Me)

    End Sub

    Private Sub MainForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        CheckServices()

    End Sub

    Private Sub RefreshButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshButton.Click

        CheckServices()

    End Sub

    Private Sub CheckServices()

        Dim srvController As ServiceController

        Try
            srvController = New ServiceController(QSIServiceNames.QSIFileMoverService, AppConfig.Params("QSIServicesServerName").StringValue)
            QSIFileMoverServiceStatusLabel.Text = System.Enum.GetName(GetType(ServiceControllerStatus), srvController.Status)
        Catch
            QSIFileMoverServiceStatusLabel.Text = "Unknown"
        End Try

        Try
            srvController = New ServiceController(QSIServiceNames.QSIPhoneCancelFileMoverService, AppConfig.Params("QSIServicesServerName").StringValue)
            QSIPhoneCancelFileMoverServiceStatusLabel.Text = System.Enum.GetName(GetType(ServiceControllerStatus), srvController.Status)
        Catch
            QSIPhoneCancelFileMoverServiceStatusLabel.Text = "Unknown"
        End Try

        Try
            srvController = New ServiceController(QSIServiceNames.QSITransferResultsService, AppConfig.Params("QSIServicesServerName").StringValue)
            QSITransferResultsServiceStatusLabel.Text = System.Enum.GetName(GetType(ServiceControllerStatus), srvController.Status)
        Catch
            QSITransferResultsServiceStatusLabel.Text = "Unknown"
        End Try

        Try
            srvController = New ServiceController(QSIServiceNames.QSIVoviciService, AppConfig.Params("QSIServicesServerName").StringValue)
            QSIVoviciServiceLabel.Text = System.Enum.GetName(GetType(ServiceControllerStatus), srvController.Status)
        Catch
            QSIVoviciServiceLabel.Text = "Unknown"
        End Try

        Try
            srvController = New ServiceController(QSIServiceNames.QSIVendorFileService, AppConfig.Params("QSIServicesServerName").StringValue)
            QSIVendorFileServiceLabel.Text = System.Enum.GetName(GetType(ServiceControllerStatus), srvController.Status)
        Catch
            QSIVendorFileServiceLabel.Text = "Unknown"
        End Try

    End Sub

    Private Sub PhoneCancelFileMoverServiceButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles PhoneCancelFileMoverServiceButton.Click

        Dim phoneCancelFileMoverForm As New QSIPhoneCancelFileMoverServiceTest
        phoneCancelFileMoverForm.Show(Me)

    End Sub
End Class
