﻿'The following code was generated by Microsoft Visual Studio 2005.
'Edited by Arman Mnatsakanyan
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.SurveyPoint.Library
Imports TestExportGroup

'''<summary>
'''This is a test class for Nrc.SurveyPoint.Library.ExportGroup and is intended
'''to contain all Nrc.SurveyPoint.Library.ExportGroup Unit Tests
'''</summary>
<TestClass()> _
Public Class ExportGroupTest
    Private Shared mNewExportGroup As ExportGroup
    Private testContextInstance As TestContext
    Private Const TestSurveyID As Integer = 24
    Private Const TestExportGroupID As Integer = 1
    Private Const NewTestName As String = "NewTestName"

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
    <ClassInitialize()> _
    Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
        mNewExportGroup = CrateDummyExportGroup()
    End Sub
    '
    'Use ClassCleanup to run code after all tests in a class have run
    '
    <ClassCleanup()> _
    Public Shared Sub MyClassCleanup()
        mNewExportGroup.Delete()
        mNewExportGroup.Save()
    End Sub
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


    Public Shared Function CrateDummyExportGroup() As ExportGroup
        Dim newGroup As ExportGroup
        newGroup = ExportGroup.NewExportGroup()
        newGroup.MiscChar1 = ""
        newGroup.MiscChar1Name = ""
        newGroup.MiscChar2 = ""
        newGroup.MiscChar2Name = ""
        newGroup.MiscChar3 = ""
        newGroup.MiscChar3Name = ""
        newGroup.MiscChar4 = ""
        newGroup.MiscChar4Name = ""
        newGroup.MiscChar5 = ""
        newGroup.MiscChar5Name = ""
        newGroup.MiscChar6 = ""
        newGroup.MiscDate1 = Now()
        newGroup.MiscDate1Name = ""
        newGroup.MiscDate2 = Now()
        newGroup.MiscDate2Name = ""
        newGroup.MiscDate3 = Now()
        newGroup.MiscDate3Name = ""
        newGroup.MiscNum1 = 1
        newGroup.MiscNum1Name = ""
        newGroup.MiscNum2 = 2
        newGroup.MiscNum2Name = ""
        newGroup.MiscNum3 = 3
        newGroup.MiscNum3Name = ""
        newGroup.Name = NewTestName
        newGroup.QuestionFileName = "C:\test.txt"
        newGroup.ResultFileName = "C:\ResultTest.txt"
        newGroup.ExportSelectedSurvey = ExportSurvey.GetSurveyBySurveyID(TestSurveyID)
        newGroup.ExportSelectedSurvey.ExportClientSelectedCollection = ExportClientSelected.GetSelectedClients(TestExportGroupID, TestSurveyID)
        newGroup.ExportSelectedSurvey.ExportScriptSelectedCollection = ExportScriptSelected.GetScriptsByExportGroupAndSurvey(TestExportGroupID, TestSurveyID)
        newGroup.Save()
        Return newGroup
    End Function
    '''<summary>
    '''A test for Get(ByVal Integer)
    '''</summary>
    <TestMethod()> _
    Public Sub GetExportGroupTest()
        Dim exportGroupID As Integer = mNewExportGroup.ExportGroupID  'TODO: Initialize to an appropriate value

        Dim actual As ExportGroup

        actual = Nrc.SurveyPoint.Library.ExportGroup.[Get](exportGroupID)

        Assert.AreEqual(mNewExportGroup.ExportGroupID, actual.ExportGroupID, "Nrc.SurveyPoint.Library.ExportGroup.Get did not return the expected value.")
        'Assert.Inconclusive("Verify the correctness of this test method.")
    End Sub

    ''' <summary> A test for GetAll(). This test will also test deleting all business
    ''' objects from a given business object collection.</summary>
    <TestMethod()> _
    Public Sub GetAllExportGroupsTest()
        Dim actual As ExportGroupCollection
        Dim newrecords As ExportGroupCollection

        actual = Nrc.SurveyPoint.Library.ExportGroup.GetAll
        Assert.IsNotNull(actual, "ExportGroup.GetAll failed")

        'Save the current Export Group count
        Dim CurrentCount As Integer = actual.Count

        'Add Five records to Export Group 
        Dim NewCount As Integer = CurrentCount + 5
        newrecords = AddExportGroupRecord(5)

        'Get the count again and make sure there are 5 more there
        actual = Nrc.SurveyPoint.Library.ExportGroup.GetAll
        Assert.AreEqual(actual.Count, NewCount)

        'cleanup
        deletenewrecords(newrecords)
        'check to see if the newly added records got deleted
        actual = Nrc.SurveyPoint.Library.ExportGroup.GetAll
        Assert.AreEqual(CurrentCount, actual.Count, "Could not delete new records.")
    End Sub
    Public Shared Function AddExportGroupRecord(ByVal rCount As Integer) As ExportGroupCollection
        Dim newrecords As New ExportGroupCollection

        For i As Integer = 1 To rCount
            Dim ExportGroupRecord As ExportGroup = CrateDummyExportGroup()
            newrecords.Add(ExportGroupRecord)
        Next
        newrecords.Save()
        Return newrecords
    End Function
    Public Shared Sub deletenewrecords(ByVal newrecords As ExportGroupCollection)
        For i As Integer = 0 To newrecords.Count - 1
            newrecords.RemoveAt(0)
        Next
        newrecords.Save()
    End Sub
    '''<summary>
    '''A test for NewExportGroup()
    '''</summary>
    <TestMethod()> _
    Public Sub NewExportGroupTest()
        Dim expected As ExportGroup = Nothing
        Dim actual As ExportGroup = Nrc.SurveyPoint.Library.ExportGroup.NewExportGroup
        Assert.IsNotNull(actual, "New ExportGroup object creation failed")
    End Sub

    ''' <summary>A test for Update()</summary>
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
    <DeploymentItem("Nrc.SurveyPoint.Library.dll"), _
     TestMethod()> _
    Public Sub UpdateExportGroupTest()
        Const ModifiedTestName As String = "Modified Test Name"
        Assert.AreEqual(NewTestName, mNewExportGroup.Name)
        mNewExportGroup.Name = ModifiedTestName
        mNewExportGroup.Save()
        Assert.AreEqual(ModifiedTestName, ExportGroup.Get(mNewExportGroup.ExportGroupID()).Name, "Update on ExportGroup Failed")
    End Sub

End Class
