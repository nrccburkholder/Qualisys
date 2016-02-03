Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.SurveyPoint.Library
Imports Nrc.SurveyPointUtilities
Imports TestExportGroup

<TestClass()> _
Public Class ExportLogSectionControllerTest
#Region "Additional test attributes"
    '
    'You can use the following additional attributes as you write your tests:
    '
    'Use ClassInitialize to run code before running the first test in the class
    '
    <ClassInitialize()> _
    Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
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
    Dim mStartDate As Date
    Dim mEndDate As Date
    Dim mLogs As ExportFileLogCollection
    Dim Controller As ExportLogSectionController
    <TestMethod()> _
    Public Sub GetAllLogsTest()
        Controller = New ExportLogSectionController(ExportFileLogTest.StartDate, ExportFileLogTest.EndDate)
        Controller.SelectedExportGroupID = ExportFileLogTest.TestExportGroupID
        Dim BeforeTestCount As Integer = Controller.ExportFileLogs.Count()

        Dim NewTestLogs As ExportFileLogCollection = ExportFileLogTest.CreateDummyLogAndSave(2, ExportFileLogTest.TestExportGroupID)
        Controller.GetAllLogs()


        'Dim AllLogsCountInGivenDateRange As Integer = ExportFileLog.GetAll(ExportFileLogTest.StartDate, ExportFileLogTest.EndDate).Count
        Assert.AreEqual(BeforeTestCount + 2, Controller.ExportFileLogs.Count)


        ExportFileLogTest.DeleteLogs(NewTestLogs)
        Controller.GetAllLogs()
        Assert.AreEqual(BeforeTestCount, Controller.ExportFileLogs.Count)

    End Sub

End Class
