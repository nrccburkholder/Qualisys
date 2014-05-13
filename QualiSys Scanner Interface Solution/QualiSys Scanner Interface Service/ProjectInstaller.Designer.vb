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
        Me.QSITransferResultsServiceProcessInstaller = New System.ServiceProcess.ServiceProcessInstaller
        Me.QSITransferResultsServiceInstaller = New System.ServiceProcess.ServiceInstaller
        Me.QSIFileMoverServiceInstaller = New System.ServiceProcess.ServiceInstaller
        Me.QSIVoviciServiceInstaller = New System.ServiceProcess.ServiceInstaller
        Me.QSIVendorFileServiceInstaller = New System.ServiceProcess.ServiceInstaller
        Me.QSIPhoneCancelFileMoverServiceInstaller = New System.ServiceProcess.ServiceInstaller
        '
        'QSITransferResultsServiceProcessInstaller
        '
        Me.QSITransferResultsServiceProcessInstaller.Password = Nothing
        Me.QSITransferResultsServiceProcessInstaller.Username = Nothing
        '
        'QSITransferResultsServiceInstaller
        '
        Me.QSITransferResultsServiceInstaller.Description = "This service monitors the InBound folders specified in the DL_TranslationModules " & _
            "table for new files and transfers the data contained into QualiSys."
        Me.QSITransferResultsServiceInstaller.DisplayName = "QSI Transfer Results Service"
        Me.QSITransferResultsServiceInstaller.ServiceName = "QSI Transfer Results Service"
        Me.QSITransferResultsServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'QSIFileMoverServiceInstaller
        '
        Me.QSIFileMoverServiceInstaller.Description = "This service monitors the vendor FTP folder and moves new files to the InBoundFil" & _
            "es vendor folder."
        Me.QSIFileMoverServiceInstaller.DisplayName = "QSI File Mover Service"
        Me.QSIFileMoverServiceInstaller.ServiceName = "QSI File Mover Service"
        Me.QSIFileMoverServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'QSIVoviciServiceInstaller
        '
        Me.QSIVoviciServiceInstaller.Description = "This service interfaces with Vovici web surveys"
        Me.QSIVoviciServiceInstaller.DisplayName = "QSI Vovici Service"
        Me.QSIVoviciServiceInstaller.ServiceName = "QSI Vovici Service"
        Me.QSIVoviciServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'QSIVendorFileServiceInstaller
        '
        Me.QSIVendorFileServiceInstaller.Description = "This service submits and recieves files from Telematch and sends them to the Vend" & _
            "or"
        Me.QSIVendorFileServiceInstaller.DisplayName = "QSI Vendor File Service"
        Me.QSIVendorFileServiceInstaller.ServiceName = "QSI Vendor File Service"
        Me.QSIVendorFileServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'QSIPhoneCancelFileMoverServiceInstaller
        '
        Me.QSIPhoneCancelFileMoverServiceInstaller.Description = "This service monitors the vendor FTP folder and moves new files to the InBoundFil" & _
            "es vendor folder."
        Me.QSIPhoneCancelFileMoverServiceInstaller.DisplayName = "QSI Phone Cancel File Mover Service"
        Me.QSIPhoneCancelFileMoverServiceInstaller.ServiceName = "QSI Phone Cancel File Mover Service"
        Me.QSIPhoneCancelFileMoverServiceInstaller.StartType = System.ServiceProcess.ServiceStartMode.Automatic
        '
        'ProjectInstaller
        '
        Me.Installers.AddRange(New System.Configuration.Install.Installer() {Me.QSITransferResultsServiceProcessInstaller, Me.QSITransferResultsServiceInstaller, Me.QSIFileMoverServiceInstaller, Me.QSIVoviciServiceInstaller, Me.QSIVendorFileServiceInstaller, Me.QSIPhoneCancelFileMoverServiceInstaller})

    End Sub
    Friend WithEvents QSITransferResultsServiceProcessInstaller As System.ServiceProcess.ServiceProcessInstaller
    Friend WithEvents QSITransferResultsServiceInstaller As System.ServiceProcess.ServiceInstaller
    Friend WithEvents QSIFileMoverServiceInstaller As System.ServiceProcess.ServiceInstaller
    Friend WithEvents QSIVoviciServiceInstaller As System.ServiceProcess.ServiceInstaller
    Friend WithEvents QSIVendorFileServiceInstaller As System.ServiceProcess.ServiceInstaller
    Friend WithEvents QSIPhoneCancelFileMoverServiceInstaller As System.ServiceProcess.ServiceInstaller

End Class
