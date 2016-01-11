Imports System.ComponentModel
Imports System.Configuration.Install

Public Class ProjectInstaller

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add initialization code after the call to InitializeComponent

    End Sub

    Public Overrides Sub Commit(ByVal savedState As System.Collections.IDictionary)
        MyBase.Commit(savedState)
        'Dim sc As New ServiceProcess.ServiceController(ServiceInstaller1.ServiceName)
        'Try
        '    sc.Start()
        '    sc.WaitForStatus(ServiceProcess.ServiceControllerStatus.Running)
        'Catch ex As Exception
        '    ' The service failed to start.  This may happen on Windows 7 and Vista 
        '    ' due to a security change that prevents services from starting themselves.
        '    ' We should probably alert the user.
        'End Try
        'sc.Close()
    End Sub

    Public Overrides Sub Uninstall(ByVal savedState As System.Collections.IDictionary)
        'Dim sc As New ServiceProcess.ServiceController(ServiceInstaller1.ServiceName)
        'If sc.Status <> ServiceProcess.ServiceControllerStatus.Stopped Then
        '    sc.Stop()
        '    sc.WaitForStatus(ServiceProcess.ServiceControllerStatus.Stopped)
        'End If
        'sc.Close()
        MyBase.Uninstall(savedState)
    End Sub
End Class
