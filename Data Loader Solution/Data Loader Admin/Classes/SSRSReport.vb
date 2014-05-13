''' <summary>This class is used to keep an SSRS Report information. Currently used 
''' to keep the selected report and to pass that info from ReportsNavigator to ReportSection</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class SSRSReport
    Public Const UploadedFileReport As String = "UploadedFileReport"
    Private mReportName As String
    Private mReportNameKey As String
    Private mReportDisplayName As String

    ''' <summary>The only constructor that needs a name to Identify where to read the 
    ''' SSRS report settings from (through public shared properties of the Config class</summary>
    ''' <param name="pNameKey">This is a hard coded constant value for each report.</param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal pNameKey As String)
        mReportNameKey = pNameKey
        Select Case mReportNameKey
            Case UploadedFileReport
                mReportName = Config.UploadedFileReport
                mReportDisplayName = "Uploaded File Report"
            Case Else
                Throw New Exception(mReportName & " must be in config.vb as a property.")
        End Select

    End Sub
    ''' <summary>This is the report name that the SSRS will identify the report with (not the full URL).</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ReportName() As String
        Get
            Return mReportName
        End Get
    End Property
    ''' <summary>The name that will show up in the ListBox on the Navigator</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ReportDisplayName() As String
        Get
            Return mReportDisplayName
        End Get
    End Property
    ''' <summary>SSRS Server Url</summary>
    ''' <remarks>The full URL will be the concatenation of the ReportServer &amp;
    ''' ReportName</remarks>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property ReportServer() As String
        Get
            Return Config.ReportServer
        End Get
    End Property

End Class