Imports Nrc.Framework.BusinessLogic.Configuration
'/* Created By Arman Mnatsakanyan Creation Date: 3/13/2009 11:33:41 AM */

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

    ''' <summary>QP_NormsConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property QP_NormsConnection() As String
        Get
            Return AppConfig.Params("NormsConnection").StringValue
        End Get
    End Property
    ''' <summary>QP_CommentsConnection value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property QP_CommentsConnection() As String
        Get
            Return AppConfig.DataMartConnection
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
    ''' <summary>SMTPServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property SMTPServer() As String
        Get
            Return Appconfig.SMTPServer
        End Get
    End Property
    ''' <summary>NRMReportServer value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property ReportServer() As String
        Get
            Return Appconfig.Params("NRMReportServer").StringValue
        End Get
    End Property

    ''' <summary>NRMCanadaNormGeneralSettingReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaNormGeneralSettingReport() As String
        Get
            Return Appconfig.Params("NRMCanadaNormGeneralSettingReport").StringValue
        End Get
    End Property
    ''' <summary>NRMCanadaNormSurveySelectionReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaNormSurveySelectionReport() As String
        Get
            Return Appconfig.Params("NRMCanadaNormSurveySelectionReport").StringValue
        End Get
    End Property
    ''' <summary>NRMCanadaNormRollupSelectionReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaNormRollupSelectionReport() As String
        Get
            Return Appconfig.Params("NRMCanadaNormRollupSelectionReport").StringValue
        End Get
    End Property
    ''' <summary>NRMCanadaNormQuestionScoreReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaNormQuestionScoreReport() As String
        Get
            Return Appconfig.Params("NRMCanadaNormQuestionScoreReport").StringValue
        End Get
    End Property
    ''' <summary>NRMCanadaQuestionBenchmarkPerformerReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaQuestionBenchmarkPerformerReport() As String
        Get
            Return Appconfig.Params("NRMCanadaQuestionBenchmarkPerformerReport").StringValue
        End Get
    End Property
    ''' <summary>NRMCanadaDimensionBenchmarkPerformerReport value from QualPro_Params table</summary>
    ''' <value></value>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property CanadaDimensionBenchmarkPerformerReport() As String
        Get
            Return Appconfig.Params("NRMCanadaDimensionBenchmarkPerformerReport").StringValue
        End Get
    End Property

    Public Shared ReadOnly Property SqlTimeOut() As Integer
        Get
            Return AppConfig.SqlTimeout
        End Get
    End Property
End Class

