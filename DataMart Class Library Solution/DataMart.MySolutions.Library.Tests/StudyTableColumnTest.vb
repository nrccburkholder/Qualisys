﻿'The following code was generated by Microsoft Visual Studio 2005.
'The test owner should check each test for validity.
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.DataMart.MySolutions.Library





'''<summary>
'''This is a test class for Nrc.DataMart.MySolutions.Library.StudyTableColumn and is intended
'''to contain all Nrc.DataMart.MySolutions.Library.StudyTableColumn Unit Tests
'''</summary>
<TestClass()> _
Public Class StudyTableColumnTest


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
#Region "Additional test attributes"
    '
    'You can use the following additional attributes as you write your tests:
    '
    'Use ClassInitialize to run code before running the first test in the class
    '
    '<ClassInitialize()>  _
    'Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
    'End Sub
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


    '''<summary>
    '''A test for GetStudyTableColumns(ByVal Integer, ByVal Integer)
    '''</summary>
    <TestMethod()> _
    Public Sub GetStudyTableColumnsTest()
        Dim studyId As Integer = 1446

        Dim tableId As Integer = 2664

        Dim expected As Integer = 46
        Dim actual As Integer
        Dim columnCollection As System.Collections.ObjectModel.Collection(Of Nrc.DataMart.MySolutions.Library.StudyTableColumn)

        columnCollection = Nrc.DataMart.MySolutions.Library.StudyTableColumn.GetStudyTableColumns(studyId, tableId)
        actual = columnCollection.Count

        If Not StringAssert.Equals(expected, actual) Then Assert.Fail("Expected column count was " & expected & " but actual was " & actual)
    End Sub


    '''<summary>
    '''A test for InsertCalculatedStudyTableColumn(ByVal Integer, ByVal String, ByVal String, ByVal String, ByVal Boolean)
    '''</summary>
    <TestMethod()> _
    Public Sub InsertCalculatedStudyTableColumnTest()
        Dim studyId As Integer = 593 'TODO: Initialize to an appropriate value

        Dim name As String = "Test" 'TODO: Initialize to an appropriate value

        Dim description As String = "Test" 'TODO: Initialize to an appropriate value

        Dim displayName As String = "Test" 'TODO: Initialize to an appropriate value

        Dim formula As String = "case when age >0 then 'One' else 'Zero' end" 'TODO: Initialize to an appropriate value

        Dim override As Boolean = True 'TODO: Initialize to an appropriate value

        Dim expected As String = formula
        Dim actualColumn As StudyTableColumn
        Dim warningMessages As String = ""

        actualColumn = Nrc.DataMart.MySolutions.Library.StudyTableColumn.InsertCalculatedStudyTableColumn(studyId, name, description, displayName, formula, warningMessages)

        Dim actual As String = actualColumn.Formula
        Assert.AreEqual(expected, actual, "Nrc.DataMart.MySolutions.Library.StudyTableColumn.InsertCalculatedStudyTableColum" & _
                "n did not return the expected value.")
        'Assert.Inconclusive("Verify the correctness of this test method.")
    End Sub
End Class
