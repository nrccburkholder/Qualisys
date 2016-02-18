'The following code was generated by Microsoft Visual Studio 2005.
'Edited by Arman Mnatsakanyan
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.SurveyPoint.Library
'Imports TestSurvey

'''<summary>
'''This is a test class for Nrc.SurveyPoint.Library.Survey and is intended
'''to contain all Nrc.SurveyPoint.Library.Client Unit Tests
'''</summary>
<TestClass()> _
Public Class ClientTest
    Private testContextInstance As TestContext
    Private Const TestSurveyID As Integer = 24
    Private Const TestExportGroupID As Integer = 1

    '''<summary>
    '''Gets or sets the test context which provides
    '''information about and functionality for the current test run.
    '''</summary>
    Public Property TestContext() As TestContext
        Get
            Return testContextInstance
        End Get
        Set(ByVal value As TestContext)
            testContextInstance = value
        End Set
    End Property
#Region "Additional test attributes"
    '
    'You can use the following additional attributes as you write your tests:
    '
    'Use ClassInitialize to run code before running the first test in the class
    '
    '<ClassInitialize()> _
    'Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
    'End Sub
    '
    'Use ClassCleanup to run code after all tests in a class have run
    '
    '<ClassCleanup()> _
    'Public Shared Sub MyClassCleanup()
    'End Sub
    '
    'Use TestInitialize to run code before running each test
    '
    '<TestInitialize()>  _
    'Public Sub MyTestInitialize()
    'End Sub
    '
    'Use TestCleanup to run code after each test has run
    '
    '<TestCleanup()>  _
    'Public Sub MyTestCleanup()
    'End Sub
    '
#End Region


    ''' <summary>Tests Client.GetBySurveyID function with a hard coded SurveyID as a
    ''' parameter. The function should return ClientCollection object with at least one
    ''' Client object in it. Otherwise test is considered failed.</summary>
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
    <TestMethod()> _
    Public Sub GetBySurveyIDTest()
        Dim actual As ExportClientCollection = Nrc.SurveyPoint.Library.ExportClient.GetBySurveyID(TestSurveyID)
        Assert.IsNotNull(actual, "Client.GetBySurveyID failed")
        Assert.IsTrue(actual.Count > 0)
    End Sub
    ''' <summary>Selected Clients must have associated ExportGroup and Survey. We supply
    ''' Client.GetSelectedClients with test ExportGroupID and SurveyID that we know
    ''' exist in the test database and expect to get business object collection
    ''' populated with test Client records.</summary>
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
    <TestMethod()> _
    Public Sub GetSelectedClientsTest()
        Dim actual As ExportClientCollection = Nrc.SurveyPoint.Library.ExportClient.GetSelectedClients(TestExportGroupID, TestSurveyID)
        Assert.IsNotNull(actual, "Client.GetSelectedClients failed")
        Assert.IsTrue(actual.Count > 0, "Failed to get Selected Clients")
    End Sub

    ''' <summary>If we don't get a NotImplementedException then the test has
    ''' failed. This is to ensure that someone doesn't accidently call Save on the business object.</summary>
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
    <TestMethod(), ExpectedException(GetType(NotImplementedException))> _
    Public Sub TestSaveClient()
        Dim newClient As ExportClient = ExportClient.NewClient()
        newClient.Save()
    End Sub
End Class