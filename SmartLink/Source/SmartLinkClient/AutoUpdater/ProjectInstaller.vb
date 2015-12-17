Imports System.ComponentModel
Imports System.Configuration.Install

Public Class ProjectInstaller

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add initialization code after the call to InitializeComponent

    End Sub

    Protected Overrides Sub OnAfterInstall(ByVal savedState As System.Collections.IDictionary)
        MyBase.OnAfterInstall(savedState)

        Try
            ' Try to register the event source ("NRC SmartLink Auto Updater") with
            ' the system's Application event log.
            If Not EventLog.SourceExists(Me.ServiceInstaller1.ServiceName) Then
                EventLog.CreateEventSource(Me.ServiceInstaller1.ServiceName, "Application")
            End If
        Catch ex As Exception

        End Try
    End Sub
End Class
