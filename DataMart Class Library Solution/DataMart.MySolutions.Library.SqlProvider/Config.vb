Imports Nrc.Framework.BusinessLogic.Configuration
Public notinheritable Class Config

    Private Sub New()
    End Sub

#Region " Properties"
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentTypes
        Get
            Return AppConfig.EnvironmentType
        End Get
    End Property

    ''' <summary>The current environment you are in (dev, test, stage, etc)</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return AppConfig.EnvironmentName
        End Get
    End Property

    ''' <summary>SMTPServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SMTPServer() As String
        Get
            Return AppConfig.SMTPServer
        End Get
    End Property
    ''' <summary>NRCAuthConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NRCAuthConnection() As String
        Get
            Return AppConfig.NrcAuthConnection
        End Get
    End Property

    Public Shared ReadOnly Property DataMartConnection() As String
        Get
            Return AppConfig.DataMartConnection
        End Get
    End Property
    ''' <summary>
    ''' Not used anywhere?
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property RscmConnection() As String
        Get
            Return AppConfig.Params("RscmConnection").StringValue
        End Get
    End Property
    ''' <summary>SqlTimeout value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SqlTimeout() As Integer
        Get
            Return AppConfig.SqlTimeout
        End Get
    End Property
    ''' <summary>
    ''' Not Used anywhere?
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared ReadOnly Property IndexConnection() As String
        Get
            'not used?
            Return AppConfig.Params("IndexConnection").StringValue
        End Get
    End Property
#End Region


End Class
