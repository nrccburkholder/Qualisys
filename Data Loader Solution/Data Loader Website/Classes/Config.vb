Imports Nrc.Framework.BusinessLogic.Configuration
'/* Created By Arman Mnatsakanyan Creation Date: 2/27/2009 2:52:10 PM */

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

    ''' <summary>NotificationConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NotificationConnection() As String
        Get
            Return Appconfig.NotificationConnection
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
    ''' <summary>DLWHomeUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property HomeUrl() As String
        Get
            Return AppConfig.Params("DLWHomeUrl").StringValue
        End Get
    End Property
    ''' <summary>DLWNrcPickerUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NrcPickerUrl() As String
        Get
            Return AppConfig.Params("DLWNrcPickerUrl").StringValue
        End Get
    End Property
    ''' <summary>DLWUseSsl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property UseSsl() As Boolean
        Get
            Dim Result As Boolean
            System.Boolean.TryParse(AppConfig.Params("DLWUseSsl").StringValue, Result)
            Return Result
        End Get
    End Property
    ''' <summary>NrcAuthConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Appconfig.NrcAuthConnection
        End Get
    End Property
    ''' <summary>DataMartConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property DataMartConnection() As String
        Get
            Return Appconfig.DataMartConnection
        End Get
    End Property
    ''' <summary>QP_LoadConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property QP_LoadConnection() As String
        Get
            Return AppConfig.QLoaderConnection
        End Get
    End Property
    ''' <summary>DLWSaveFolder value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property DataLoaderSaveFolder() As String
        Get
            Dim path As String = AppConfig.Params("DLWSaveFolder").StringValue
            If Not path.EndsWith("\") Then
                path = path & "\"
            End If
            Return path
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
    ''' <summary>DLWeReportsUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property eReportsUrl() As String
        Get
            Return Appconfig.Params("DLWeReportsUrl").StringValue
        End Get
    End Property
    ''' <summary>DLWMySolutionsUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property MySolutionsUrl() As String
        Get
            Return AppConfig.Params("DLWMySolutionsUrl").StringValue  '"/MySolutions.aspx"
        End Get
    End Property
    ''' <summary>DLWSiteMapURL value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SiteMapUrl() As String
        Get
            Return AppConfig.Params("DLWSiteMapURL").StringValue '/Pages/SiteMap.aspx
        End Get
    End Property
    ''' <summary>DLWeCommentsUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property eCommentsUrl() As String
        Get
            Return Appconfig.Params("DLWeCommentsUrl").StringValue
        End Get
    End Property
    ''' <summary>DLWPCCInstituteUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property PCCInstituteUrl() As String
        Get
            Return AppConfig.Params("DLWPCCInstituteUrl").StringValue '/PCC%20Institute/Pages/default.aspx
        End Get
    End Property
    ''' <summary>DLWeToolKitUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property eToolKitUrl() As String
        Get
            Return Appconfig.Params("DLWeToolKitUrl").StringValue
        End Get
    End Property
    ''' <summary>DLWMyAccountUrl value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property MyAccountUrl() As String
        Get
            Return Appconfig.Params("DLWMyAccountUrl").StringValue
        End Get
    End Property

    ''' <summary>DLWExceptionFromAddress value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ExceptionFromAddress() As String
        Get
            Return Appconfig.Params("DLWExceptionFromAddress").StringValue
        End Get
    End Property
    ''' <summary>DLWExceptionToAddress value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ExceptionToAddress() As String
        Get
            Return Appconfig.Params("DLWExceptionToAddress").StringValue
        End Get
    End Property

    Public Shared ReadOnly Property GroupSelectorUrl(ByVal currentPage As Page) As String
        Get
            Return String.Format("{0}/GroupSelector.aspx?App=Data%20Loader&ReturnURL={1}", MyAccountUrl, HttpUtility.UrlEncode(currentPage.Request.Url.PathAndQuery))
        End Get
    End Property

    ''' <summary>ClientSupportEmailAddress value from QualPro_Params table</summary>
    ''' <value>Current value is ClientSupport@NationalResearch.com</value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ClientSupportEmailAddress() As String
        Get
            Return AppConfig.Params("ClientSupportEmailAddress").StringValue
        End Get
    End Property
    ''' <summary>LoadingTeamTestEmailAddress value from QualPro_Params table</summary>
    ''' <value>Current value is LoadingTeamTest@NationalResearch.com </value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property LoadingTeamTestEmailAddress() As String
        Get
            Return AppConfig.Params("LoadingTeamTestEmailAddress").StringValue
        End Get
    End Property
    ''' <summary>MySolutionsEmailAddress value from QualPro_Params table</summary>
    ''' <value>Current value is LoadingTeamTest@NationalResearch.com </value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property MySolutionsEmailAddress() As String
        Get
            Return AppConfig.Params("MySolutionsEmailAddress").StringValue
        End Get
    End Property

End Class


