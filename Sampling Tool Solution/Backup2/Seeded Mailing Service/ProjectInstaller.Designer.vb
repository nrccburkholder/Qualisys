<System.ComponentModel.RunInstaller(True)> Partial Class ProjectInstaller
    Inherits System.Configuration.Install.Installer

    'Installer overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Component Designer
    'It can be modified using the Component Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.SeededMailingServiceProcessInstaller = New System.ServiceProcess.ServiceProcessInstaller
        Me.SeededMailingServiceInstaller = New System.ServiceProcess.ServiceInstaller
        '
        'SeededMailingServiceProcessInstaller
        '
        Me.SeededMailingServiceProcessInstaller.Password = Nothing
        Me.SeededMailingServiceProcessInstaller.Username = Nothing
        '
        'SeededMailingServiceInstaller
        '
        Me.SeededMailingServiceInstaller.Description = "This service sets up the ToBeSeeded table with all of the surveys that are to be " & _
            "seeded each quarter."
        Me.SeededMailingServiceInstaller.DisplayName = "Seeded Mailing Service"
        Me.SeededMailingServiceInstaller.ServiceName = "Seeded Mailing Service"
        Me.SeededMailingServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'ProjectInstaller
        '
        Me.Installers.AddRange(New System.Configuration.Install.Installer() {Me.SeededMailingServiceProcessInstaller, Me.SeededMailingServiceInstaller})

    End Sub
    Friend WithEvents SeededMailingServiceProcessInstaller As System.ServiceProcess.ServiceProcessInstaller
    Friend WithEvents SeededMailingServiceInstaller As System.ServiceProcess.ServiceInstaller

End Class
