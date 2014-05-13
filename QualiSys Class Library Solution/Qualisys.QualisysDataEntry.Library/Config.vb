Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config
#Region " EnvironmentSettings Properties "
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

    ''' <summary>QualisysConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property QualisysConnection() As String
        Get
            Return AppConfig.QualisysConnection
        End Get
    End Property
    ''' <summary>NrcAuthConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return AppConfig.NrcAuthConnection
        End Get
    End Property
    ''' <summary>SmtpServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return AppConfig.SMTPServer
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
#End Region
    Public Shared ReadOnly Property IsLoggingOn() As Boolean
        Get
            Return CType(AppConfig.Params("QDELogging").IntegerValue, Boolean)
        End Get
    End Property

End Class
