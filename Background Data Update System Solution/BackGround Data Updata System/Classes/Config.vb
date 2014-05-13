Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config

#Region " Application Configuration Settings "

    Public Shared ReadOnly Property QP_ProdConnection() As String
        Get
            Return AppConfig.QualisysConnection
        End Get
    End Property

    Public Shared ReadOnly Property SMTPServer() As String
        Get
            Return AppConfig.SMTPServer
        End Get
    End Property
    ''' <summary>The current environment type you are in (dev, test, stage, etc)</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentTypes
        Get
            Return AppConfig.EnvironmentType
        End Get
    End Property

    ''' <summary>The current environment name you are in (dev, test, stage, etc)</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return AppConfig.EnvironmentName
        End Get
    End Property

#End Region


End Class
