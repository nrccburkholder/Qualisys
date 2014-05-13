Imports Nrc.Framework.BusinessLogic.Configuration
'/* Created By Arman Mnatsakanyan Creation Date: 2/23/2009 10:02:29 AM */

''' <summary>Wrapper arround settings from QualPro_Params table.</summary>
''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class Config

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
            Return Appconfig.SMTPServer
        End Get
    End Property
    ''' <summary>NRCAuthConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NRCAuthConnection() As String
        Get
            Return Appconfig.NRCAuthConnection
        End Get
    End Property
    ''' <summary>QP_CommentsConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property QP_CommentsConnection() As String
        Get
            Return Appconfig.DataMartConnection
        End Get
    End Property
    ''' <summary>WebDocumentPosterUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property WebDocumentPosterUrl() As String
        Get
            Return Appconfig.Params("WebDocumentPosterUrl").StringValue
        End Get
    End Property

    ''' <summary>FileSizeLimitkB value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property FileSizeLimitkB() As Integer
        Get
            Return Appconfig.Params("FileSizeLimitkB").IntegerValue
        End Get
    End Property
    ''' <summary>SqlTimeout value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SqlTimeout() As Integer
        Get
            Return Appconfig.SqlTimeout
        End Get
    End Property

End Class
