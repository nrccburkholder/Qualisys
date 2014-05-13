Imports System.IO

Public NotInheritable Class SharedMethods
    Private Sub New()
    End Sub

    Public Shared Sub SetupNrcAuthSettings()
        Nrc.NRCAuthLib.StaticConfig.NRCAuthConnection = Config.NrcAuthConnection
        Select Case Config.EnvironmentType
            Case Framework.Configuration.EnvironmentType.Development
                Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Development
            Case Framework.Configuration.EnvironmentType.Testing
                Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
            Case Framework.Configuration.EnvironmentType.Production
                Nrc.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
        End Select
    End Sub

    ''' <summary>I believe this is used to allow the passing of connections to the NRCAuth (1.1) library dll.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Sub SetupDataMartSettings()
        NRC.NRCAuthLib.StaticConfig.DataMartConnection = Config.DataMartConnection
        Select Case Config.EnvironmentType
            Case Framework.Configuration.EnvironmentType.Development
                NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Development
            Case Framework.Configuration.EnvironmentType.Testing
                NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Testing
            Case Framework.Configuration.EnvironmentType.Production
                NRC.NRCAuthLib.StaticConfig.EnvironmentType = NRCAuthLib.StaticConfig.Environment.Production
        End Select
    End Sub

    Public Shared Sub TempFolderCleanUp(ByVal folderName As String, ByVal searchPattern As String)
        TempFolderCleanUp(folderName, searchPattern, 20)
    End Sub

    Public Shared Sub TempFolderCleanUp(ByVal folderName As String, ByVal searchPattern As String, ByVal expirationMinutes As Integer)
        Try
            Dim appPath As String
            If HttpContext.Current Is Nothing Then
                appPath = AppDomain.CurrentDomain.BaseDirectory
            Else
                appPath = HttpContext.Current.Request.PhysicalApplicationPath.ToString
            End If
            Dim dir As DirectoryInfo = New DirectoryInfo(Path.Combine(appPath, folderName))

            For Each file As FileInfo In dir.GetFiles(searchPattern)
                Dim datDiff As Long = DateDiff(DateInterval.Minute, file.CreationTime, DateTime.Now())

                If datDiff > expirationMinutes Then
                    file.Delete()
                End If
            Next
        Catch ex As Exception
        End Try
    End Sub

End Class

