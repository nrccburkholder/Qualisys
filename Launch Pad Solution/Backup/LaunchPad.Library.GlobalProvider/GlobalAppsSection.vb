Imports System.Configuration
Imports Nrc.Framework.BusinessLogic.Configuration
''' <summary>This class used to read settings from app.config. The revised version
''' reads the settings from QualPro_Params table.</summary>
''' <revision>March-12-2009 by Arman Mnatsakanyan</revision>
Public Class GlobalAppsSection
    Inherits ConfigurationSection

    ''' <summary>Retrieves relative path to the xml file that contains Global
    ''' application settings then replaces the relative path with the absolute path of
    ''' the application directory + the file name. Relative path is stored in
    ''' QualPro_Params table.</summary>
    ''' <author>Arman Mnatsakanyan</author>
    ''' <revision>March-12-2009</revision>
    Public Shared ReadOnly Property DataStorePath() As String
        Get
            Dim DataStorePathParamValue As String = AppConfig.Params("LPGlobalApplicationsXMLPath").StringValue
            Return DataStorePathParamValue.Replace("(AppDirectory)", My.Application.Info.DirectoryPath)
        End Get
    End Property


    ''' <summary>Returns comma separated list of admin groups from QualPro_Params
    ''' table.</summary>
    ''' <author>Arman Mnatsakanyan</author>
    ''' <revision>March-12-2009</revision>
    Public Shared ReadOnly Property AdminGroupList() As String
        Get
            Return AppConfig.Params("LPAdminGroups").StringValue
        End Get
    End Property

    Public Shared ReadOnly Property AdminGroups() As String()
        Get
            Dim groups As String()
            groups = AdminGroupList.Split(New String() {",", ";"}, StringSplitOptions.RemoveEmptyEntries)

            For i As Integer = 0 To groups.Length - 1
                groups(i) = groups(i).Trim
            Next

            Return groups
        End Get
    End Property

End Class
