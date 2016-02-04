Imports Nrc.Framework.Configuration
'TODO:  Do not forget to reset your references to the following:
'Nrc.Framework
'Nrc.Framework.BusinessLogic
'NRC.NRCAuthLib
''' <summary>Holds the environment settings and db connectin string info for the application.</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public Class Config

#Region " EnvironmentSettings Properties "
#If Config = "Production" Then
    Private Const mConfiguration As String="Production"
#ElseIf Config = "Staging" Then
    Private Const mConfiguration As String = "Staging"
#ElseIf Config = "Testing" Then
    Private Const mConfiguration As String = "Testing"
#ElseIf Config = "Development" Then
    Private Const mConfiguration As String = "Development"
#Else
    Private Const mConfiguration As String = "Unknown"
#End If

    Protected Shared mSettings As EnvironmentSettings
    
    ''' <summary>Loads and returns an EnvironementSettings object based on config file and when environment you are running in.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Shared ReadOnly Property Settings() As EnvironmentSettings
        Get
            If mSettings Is Nothing Then
                mSettings = EnvironmentSettings.LoadFromConfig
                If String.IsNullOrEmpty(mSettings.CurrentEnvironmentName) Then
                    mSettings.CurrentEnvironmentName = mConfiguration
                End If
            End If
            Return mSettings
        End Get
    End Property
    ''' <summary></summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentType
        Get
            Return Settings.CurrentEnvironment.EnvironmentType
        End Get
    End Property

    ''' <summary></summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return Settings.CurrentEnvironment.Name
        End Get
    End Property
#End Region

#Region " Custom Configuration Properties "
    ''' <summary>SMTP Server based on which enironement your in (DEV, Stage, Prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return Settings("SmtpServer")
        End Get
    End Property
    ''' <summary>Conn string for NRC Auth connection based on which environment your in (Dev, stage, prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Settings("NrcAuthConnection")
        End Get
    End Property
    Public Shared ReadOnly Property QMSConnection() As String
        Get
            Return Settings("QMSConnection")
        End Get
    End Property

#Region " Coventry Split Files "
    Public Shared ReadOnly Property CoventryFiles() As String
        Get
            Return Settings("CoventryFiles")
        End Get
    End Property
    Public Shared ReadOnly Property AltiusAdvantraMedicare() As String
        Get
            Return Settings("AltiusAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property GeorgiaAdvantraMedicare() As String
        Get
            Return Settings("GeorgiaAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property IowaAdvantraMedicare() As String
        Get
            Return Settings("IowaAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property KansasCityAdvantraMedicare() As String
        Get
            Return Settings("KansasCityAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property NebraskaAdvantraMedicare() As String
        Get
            Return Settings("NebraskaAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property PersnalCareAdvantraMedicare() As String
        Get
            Return Settings("PersnalCareAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property AdvantraFreedomPFFSMedicare() As String
        Get
            Return Settings("AdvantraFreedomPFFSMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property AdvantraSavingsMedicare() As String
        Get
            Return Settings("AdvantraSavingsMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property GHPAdvantraMedicare() As String
        Get
            Return Settings("GHPAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property CarelinkAdvantraMedicare() As String
        Get
            Return Settings("CarelinkAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property HAPAAdvantraMedicare() As String
        Get
            Return Settings("HAPAAdvantraMedicare")
        End Get
    End Property
    Public Shared ReadOnly Property CoventryColumnNames() As String
        Get
            Return Settings("CoventryColNames")
        End Get
    End Property
#End Region
#Region " Wellpoint Split Files "
    Public Shared ReadOnly Property WellpointSchema() As String
        Get
            Return Settings("WellpointSchema")
        End Get
    End Property
    Public Shared ReadOnly Property WellpointClients() As String
        Get
            Return Settings("WellpointClients")
        End Get
    End Property
    Public Shared ReadOnly Property WP_AICI_PFFS() As String
        Get
            Return Settings("WP_AICI_PFFS")
        End Get
    End Property
    Public Shared ReadOnly Property WP_AICI_HMO() As String
        Get
            Return Settings("WP_AICI_HMO")
        End Get
    End Property
    Public Shared ReadOnly Property WP_BC_California() As String
        Get
            Return Settings("WP_BC_California")
        End Get
    End Property
    Public Shared ReadOnly Property WP_BCBS_Georgia() As String
        Get
            Return Settings("WP_BCBS_Georgia")
        End Get
    End Property
    Public Shared ReadOnly Property WP_BCBS_Missouri() As String
        Get
            Return Settings("WP_BCBS_Missouri")
        End Get
    End Property
    Public Shared ReadOnly Property WP_BCBS_Wisconsin() As String
        Get
            Return Settings("WP_BCBS_Wisconsin")
        End Get
    End Property
    Public Shared ReadOnly Property WP_Unicare_PFFS() As String
        Get
            Return Settings("WP_Unicare_PFFS")
        End Get
    End Property
    Public Shared ReadOnly Property WP_Unicare_MSA() As String
        Get
            Return Settings("WP_Unicare_MSA")
        End Get
    End Property
#End Region
#End Region
    Public Shared Function GetConfigValue(ByVal propName As String) As String
        Select Case propName
            Case "AltiusAdvantraMedicare"
                Return Config.AltiusAdvantraMedicare
            Case "GeorgiaAdvantraMedicare"
                Return Config.GeorgiaAdvantraMedicare
            Case "IowaAdvantraMedicare"
                Return Config.IowaAdvantraMedicare
            Case "KansasCityAdvantraMedicare"
                Return Config.KansasCityAdvantraMedicare
            Case "NebraskaAdvantraMedicare"
                Return Config.NebraskaAdvantraMedicare
            Case "PersnalCareAdvantraMedicare"
                Return Config.PersnalCareAdvantraMedicare
            Case "AdvantraFreedomPFFSMedicare"
                Return Config.AdvantraFreedomPFFSMedicare
            Case "AdvantraSavingsMedicare"
                Return Config.AdvantraSavingsMedicare
            Case "GHPAdvantraMedicare"
                Return Config.GHPAdvantraMedicare
            Case "CarelinkAdvantraMedicare"
                Return Config.CarelinkAdvantraMedicare
            Case "HAPAAdvantraMedicare"
                Return Config.HAPAAdvantraMedicare
            Case "WP_AICI_PFFS"
                Return Config.WP_AICI_PFFS
            Case "WP_AICI_HMO"
                Return Config.WP_AICI_HMO
            Case "WP_BC_California"
                Return Config.WP_BC_California
            Case "WP_BCBS_Georgia"
                Return Config.WP_BCBS_Georgia
            Case "WP_BCBS_Missouri"
                Return Config.WP_BCBS_Missouri
            Case "WP_BCBS_Wisconsin"
                Return Config.WP_BCBS_Wisconsin
            Case "WP_Unicare_PFFS"
                Return Config.WP_Unicare_PFFS
            Case "WP_Unicare_MSA"
                Return Config.WP_Unicare_MSA
            Case Else
                Return ""
        End Select
    End Function


End Class
