
Imports Nrc.Framework.BusinessLogic.Configuration
'/* Created By Arman Mnatsakanyan Creation Date: 3/19/2009 9:43:23 AM */

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

    ''' <summary>NRCAuthConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NRCAuthConnection() As String
        Get
            Return Appconfig.NRCAuthConnection
        End Get
    End Property
    ''' <summary>DataMartConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property DataMartConnection() As String
        Get
            Return AppConfig.Params("NAADataMartConnection").StringValue
        End Get
    End Property
    ''' <summary>SmtpServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return Appconfig.SmtpServer
        End Get
    End Property
    ''' <summary>NAAReportServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ReportServer() As String
        Get
            Return Appconfig.Params("NAAReportServer").StringValue
        End Get
    End Property
    ''' <summary>NAAReportFolder value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ReportFolder() As String
        Get
            Return Appconfig.Params("NAAReportFolder").StringValue
        End Get
    End Property
    ''' <summary>NAASiteUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SiteUrl() As String
        Get
            Return Appconfig.Params("NAASiteUrl").StringValue
        End Get
    End Property
    ''' <summary>NAANRCPickerUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NRCPickerUrl() As String
        Get
            Return Appconfig.Params("NRCPickerUrl").StringValue
        End Get
    End Property

    ''' <summary>NAAMailFromAccount value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property MailFromAccount() As String
        Get
            Return Appconfig.Params("NAAMailFromAccount").StringValue
        End Get
    End Property
    ''' <summary>SQLTimeOut value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CommandTimeout() As Integer
        Get
            Return Appconfig.SQLTimeOut
        End Get
    End Property

    Public Shared ReadOnly Property MassEmailCCMembers() As NRCAuthLib.MemberCollection
        Get
            Dim result As New NRCAuthLib.MemberCollection()
            Dim names As String() = AppConfig.Params("NAAMassEmailCCMembers").StringValue.Split(",".ToCharArray)
            Dim m As NRCAuthLib.Member
            For Each n As String In names
                m = NRCAuthLib.Member.GetMember(n.Trim())
                If Not m Is Nothing Then
                    result.Add(m)
                End If
            Next
            Return result
        End Get
    End Property
    Public Shared ReadOnly Property MassEmailDefaultFromAddress() As String
        Get
            Return AppConfig.Params("NAAMassEmailFrom").StringValue
        End Get
    End Property
    Public Shared ReadOnly Property MassEmailDefaultTemplatePath() As String
        Get
            Return AppConfig.Params("NAAMassEmailTemplateRepository").StringValue
        End Get
    End Property
    Public Shared ReadOnly Property MassEmailImageRepository() As String
        Get
            Return AppConfig.Params("NAAMassEmailImageRepository").StringValue
        End Get
    End Property
End Class
