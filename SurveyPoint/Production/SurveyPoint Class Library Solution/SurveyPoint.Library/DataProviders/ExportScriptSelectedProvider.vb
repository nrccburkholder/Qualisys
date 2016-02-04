Namespace DataProviders
    ''' <summary>Abstract class that holds stubs for DAL Calls.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class ExportScriptSelectedProvider

#Region " Singleton Implementation "
        Private Shared mInstance As ExportScriptSelectedProvider
        Private Const mProviderName As String = "ExportScriptSelectedProvider"
        ''' <summary>Retrieves the instance of the Data provider class that will implement the astract methods.</summary>
        ''' <value></value>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Shared ReadOnly Property Instance() As ExportScriptSelectedProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ExportScriptSelectedProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        ''' <summary>Get Scripts by survey and export</summary>
        ''' <param name="exportGroup"></param>
        ''' <param name="survey"></param>
        ''' <RevisionList><list type="table">
        ''' <listheader>
        ''' <term>Date Modified - Modified By</term>
        ''' <description>Description</description></listheader>
        ''' <item>
        ''' <term>03/11/08 -- Arman Mnatsakanyan</term>
        ''' <description>changed parameters to object types</description></item>
        ''' <item>
        ''' <term>	</term>
        ''' <description>
        ''' <para></para></description></item></list></RevisionList>
        Public MustOverride Function SelectSelectedExportScripts(ByVal exportGroup As ExportGroup, ByVal survey As ExportSurvey) As ExportScriptSelectedCollection
        ''' <summary>Get the script by its id</summary>
        ''' <param name="scriptID"></param>
        ''' <returns></returns>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Function GetScriptByScriptID(ByVal scriptID As Integer) As ExportScriptSelected
        ''' <summary>Insert a new script into the data store.</summary>
        ''' <param name="script"></param>
        ''' <param name="surveyID"></param>
        ''' <param name="exportGroupID"></param>
        ''' <CreatedBy>Tony Piccoli</CreatedBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public MustOverride Sub InsertScript(ByVal script As ExportScriptSelected, ByVal surveyID As Integer, ByVal exportGroupID As Integer)
    End Class
End Namespace
