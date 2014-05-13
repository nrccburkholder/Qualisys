Imports Nrc.Framework.BusinessLogic.Configuration
'/* Created By Arman Mnatsakanyan Creation Date: 2/24/2009 4:20:32 PM */

''' <summary>Wrapper arround settings from QualPro_Params table.</summary>
''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class Config
    ''' <summary>DataMartConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property DataMartConnection() As String
        Get
            Return AppConfig.DataMartConnection
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
End Class
