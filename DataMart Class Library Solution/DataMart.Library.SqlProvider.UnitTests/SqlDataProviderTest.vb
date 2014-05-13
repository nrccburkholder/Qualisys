Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.DataMart.Library.SqlProvider.UnitTests
Imports Nrc.DataMart.Library
Imports System.Collections.ObjectModel
Imports Nrc.DataMart.Library.SqlProvider


<TestClass()> _
Public Class SqlDataProviderTest

    Private Shared mDataProvider As Nrc.DataMart.Library.SqlProvider.SqlDataProvider

#Region " TestContext "
    Private testContextInstance As TestContext

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
#End Region

#Region " Additional Test Methods "
    '
    'You can use the following additional attributes as you write your tests:
    '
    'Use ClassInitialize to run code before running the first test in the class
    '
    <ClassInitialize()> _
    Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
        mDataProvider = New Nrc.DataMart.Library.SqlProvider.SqlDataProvider
    End Sub
    '
    'Use ClassCleanup to run code after all tests in a class have run
    '
    '<ClassCleanup()>  _
    'Public Shared Sub MyClassCleanup()
    'End Sub
    '
    'Use TestInitialize to run code before running each test
    '
    '<TestInitialize()> _
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

#Region " Client Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectClient_Success()
        Dim clnt As Client = mDataProvider.SelectClient(767)
        Assert.IsNotNull(clnt)
        Assert.AreEqual(Of Integer)(767, clnt.Id)
        Assert.AreEqual(Of String)("Adventist Health System", clnt.Name)
        Assert.IsFalse(clnt.IsDirty)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectClient_NonExistant()
        Dim clnt As Client = mDataProvider.SelectClient(4)
        Assert.IsNull(clnt)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectClientsStudiesAndSurveyByUser()
        Dim clientList As Collection(Of Client) = mDataProvider.SelectClientsStudiesAndSurveysByUser("DChristensen")
        Assert.IsNotNull(clientList)
        Assert.IsTrue(clientList.Count > 0)
        Dim clnt As Client = clientList(0)
        Assert.AreEqual(Of String)("Adventist Health System", clnt.Name)
        Assert.IsTrue(clnt.Studies.Count > 0)
        Dim stdy As Study = clnt.Studies(0)
        Assert.AreEqual(Of String)("IP/OP/ER", stdy.Name)
        Assert.IsTrue(stdy.Surveys.Count > 0)
        Dim srvy As Survey = stdy.Surveys(0)
        Assert.AreEqual(Of String)("7305SCMC", srvy.Name)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectClientsAndStudiesByUser()
        Dim clientList As Collection(Of Client) = mDataProvider.SelectClientsAndStudiesByUser("DChristensen")
        Assert.IsNotNull(clientList)
        Assert.IsTrue(clientList.Count > 0)
        Dim clnt As Client = clientList(0)
        Assert.AreEqual(Of String)("Adventist Health System", clnt.Name)
        Assert.IsTrue(clnt.Studies.Count > 0)
        Dim stdy As Study = clnt.Studies(0)
        Assert.AreEqual(Of String)("IP/OP/ER", stdy.Name)
        Assert.AreEqual(Of Integer)(0, stdy.Surveys.Count)
    End Sub

#End Region

#Region " Study Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectStudy_Success()
        Dim stdy As Study = mDataProvider.SelectStudy(554)

        Assert.IsNotNull(stdy)
        Assert.AreEqual(Of Integer)(554, stdy.Id)
        Assert.AreEqual(Of String)("IP/OP/ER", stdy.Name)
        Assert.AreEqual(Of Integer)(767, stdy.ClientId)
        Assert.IsFalse(stdy.IsDirty)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectStudy_NonExistant()
        Dim stdy As Study = mDataProvider.SelectStudy(-1)
        Assert.IsNull(stdy)
    End Sub
#End Region

#Region " Survey Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
       Public Sub SelectSurvey_Success()
        Dim srvy As Survey = Survey.GetSurvey(2603)
        Assert.IsNotNull(srvy)
        Assert.AreEqual(Of Integer)(2603, srvy.Id)
        Assert.AreEqual(Of String)("7305SCMC", srvy.Name)
        Assert.AreEqual(Of Integer)(554, srvy.StudyId)
        Assert.IsFalse(srvy.IsDirty)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectSurvey_NonExistant()
        Dim srvy As Survey = Survey.GetSurvey(-1)
        Assert.IsNull(srvy)
    End Sub
#End Region

#Region " ExportSet Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSet()
        Dim export As ExportSet = mDataProvider.SelectExportSet(1)
        Assert.IsNotNull(export)
        Assert.AreEqual(Of String)("Q1 2005 Cutoff", export.Name)
        Assert.AreEqual(Of Integer)(2603, export.SurveyId)
        Assert.AreEqual(Of Integer)(164, export.ExportCount)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetByClientId()
        Dim exports As Collection(Of ExportSet) = mDataProvider.SelectExportSetsByClientId(767, Nothing, Nothing)
        Assert.AreEqual(Of Integer)(9, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetByClientIdAndDate()
        Dim clientId As Integer = 767
        Dim startDate As Date = Date.Parse("1/7/2006")
        Dim endDate As Date = Date.Parse("1/11/2006")
        Dim exports As Collection(Of ExportSet)
        exports = mDataProvider.SelectExportSetsByClientId(clientId, startDate, endDate)
        Assert.AreEqual(Of Integer)(5, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetsByStudyId()
        Dim exports As Collection(Of ExportSet) = mDataProvider.SelectExportSetsByStudyId(554, Nothing, Nothing)
        Assert.AreEqual(Of Integer)(7, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetsByStudyIdAndDate()
        Dim studyId As Integer = 554
        Dim startDate As Date = Date.Parse("1/7/2006")
        Dim endDate As Date = Date.Parse("1/10/2006")
        Dim exports As Collection(Of ExportSet)
        exports = mDataProvider.SelectExportSetsByStudyId(studyId, startDate, endDate)
        Assert.AreEqual(4, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetsBySurveyId()
        Dim exports As Collection(Of ExportSet) = mDataProvider.SelectExportSetsBySurveyId(2603, Nothing, Nothing)
        Assert.AreEqual(Of Integer)(4, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetsBySurveyIdAndDate()
        Dim surveyId As Integer = 2603
        Dim startDate As Date = Date.Parse("1/6/2006")
        Dim endDate As Date = Date.Parse("1/7/2006")
        Dim exports As Collection(Of ExportSet)
        exports = mDataProvider.SelectExportSetsBySurveyId(surveyId, startDate, endDate)
        Assert.AreEqual(Of Integer)(2, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub InsertExportSet()
        Dim exportName As String = "New Export"
        Dim surveyId As Integer = 2603
        Dim startDate As Date = Date.Now.AddMonths(-3)
        Dim enddate As Date = Date.Now
        Dim creator As String = "JCamp"

        Dim newId As Integer = mDataProvider.InsertExportSet(exportName, surveyId, startDate, enddate, creator)
        Dim export As ExportSet = mDataProvider.SelectExportSet(newId)
        Assert.IsNotNull(export)
        Assert.AreEqual(Of String)(exportName, export.Name)
        Assert.AreEqual(Of Integer)(surveyId, export.SurveyId)
        'Assert.AreEqual(Of Date)(export.EncounterStartDate, startDate)
        'Assert.AreEqual(Of Date)(export.EncounterEndDate, enddate)
        Assert.AreEqual(Of String)(creator, export.CreatedEmployeeName)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub DeleteExportSet()
        Assert.IsNotNull(mDataProvider.SelectExportSet(8))
        mDataProvider.DeleteExportSet(8, "JCamp")
        Assert.IsNull(mDataProvider.SelectExportSet(8))
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportSetsByExportFileId()
        Dim exports As Collection(Of ExportSet) = mDataProvider.SelectExportSetsByExportFileId(4)
        Assert.IsNotNull(exports)
        Assert.AreEqual(Of Integer)(3, exports.Count)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub RebuildExportSet()
        mDataProvider.RebuildExportSet(4)
    End Sub

#End Region

#Region " ExportFile Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportFilesByExportSet()
        Dim files As Collection(Of ExportFile) = mDataProvider.SelectExportFilesByExportSetId(1)
        Assert.IsTrue(files.Count > 0)
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectExportFileData()
        Dim exportIds As New List(Of Integer)
        exportIds.Add(1)
        exportIds.Add(2)
        Using rdr As System.Data.IDataReader = mDataProvider.SelectExportFileData(exportIds.ToArray, True, True)
            Assert.IsTrue(rdr.Read)
        End Using
    End Sub

    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub InsertExportFile()
        'Dim file As ExportFile
        Dim recordCount As Integer = 1234
        Dim userName As String = "JCamp"
        Dim path As String = "E:\Export.dbf"
        Dim filePartsCount As Integer = 2
        Dim fileType As ExportFileType = ExportFileType.DBase
        Dim newId As Integer = mDataProvider.InsertExportFile(recordCount, userName, path, filePartsCount, fileType)
        Assert.IsTrue(newId > 0)
        'file = mdataprovider.SelectExportFile

        mDataProvider.InsertExportFileExportSet(1, newId)
    End Sub



#End Region

#Region " Question Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectQuestionsBySurveyId()
        Dim Questions As Collection(Of Question) = mDataProvider.SelectQuestionsBySurveyId(2603)
        Assert.AreEqual(Questions.Count, 212)
    End Sub
#End Region

#Region " Scale Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectScaleBySurveyIdAndScaleId()
        Dim TestScale As Scale = mDataProvider.SelectScaleBySurveyIdAndScaleId(2603, 1323)
        Assert.AreEqual(TestScale.MaxScaleOrder, 6)
    End Sub
#End Region

#Region " Response Tests "
    <TestMethod(), DeploymentItem("Nrc.DataMart.Library.SqlProvider.dll")> _
    Public Sub SelectResponsesBySurveyIdAndScaleid()
        Dim Responses As Collection(Of Response) = mDataProvider.SelectResponsesBySurveyIdAndScaleId(2603, 1323)
        Assert.AreEqual(Responses.Count, 6)
    End Sub
#End Region


End Class
