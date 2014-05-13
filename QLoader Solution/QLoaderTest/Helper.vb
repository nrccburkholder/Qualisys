Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports System
Imports System.Text
Imports System.Collections.Generic
Imports Nrc.Qualisys.QLoader.Library
Imports TypeMock

Public Class Helper
#Region "Constants"
    Public Const DummyRecordGroupID As Integer = 16752
    Public Const DummyRecordFileSize As Integer = 1200
    Public Const DummyRecordOriginalFilename As String = "C:\My Documents\Data.txt"
    Public Const DummyRecorFileName As String = "C:\Temp\UploadedFile.txt"
    Public Const DummyRecordJanuaryData As String = "January Data"
    Public Const DummyMemberLogin As String = "DummyMemberLogin"
    Public Const FAKEMEMBERFULLNAME As String = "Under Cover FakeMember"
    Public Const FakeMemberId As Integer = 164111
    Public Const TestPackageName As String = "Test Package Name"
    Public Const TestPackageFriendlyName As String = "Test PackageFriendlyName"
    Public Const FakeProjectManagerFirstName As String = "FakeProjectManagerFirstName"
    Public Const FakeProjectManagerLastname As String = "FakeProjectManagerLastname"
    Public Const FakeMemberEmailAddress As String = "fakeMember@nationalresearch.com"
#End Region

#Region "Helper Shared Functions"
    Private Shared Function CreateDummyDTSPackage() As DTSPackage
        Dim md As Date = Now()
        Using rex As New RecordExpectations()
            Dim FakeDTSPackage As DTSPackage = RecorderManager.CreateMockedObject(Of DTSPackage)()
            Dim FakeSource As DTSDataSet = RecorderManager.CreateMockedObject(Of DTSDataSet)()
            rex.ExpectAndReturn(FakeSource.ConcatSettings, "fakeConcatSetting")
            rex.ExpectAndReturn(FakeSource.DataSetType, DataSetType.Text)
            rex.ExpectAndReturn(FakeDTSPackage.BitActive, True)
            rex.ExpectAndReturn(FakeDTSPackage.CreatorID, 0)
            rex.ExpectAndReturn(FakeDTSPackage.DateLastModified, md)
            rex.ExpectAndReturn(FakeDTSPackage.Modified, False)
            rex.ExpectAndReturn(FakeDTSPackage.PackageFriendlyName, TestPackageFriendlyName)
            rex.ExpectAndReturn(FakeDTSPackage.PackageName, TestPackageName)
            rex.ExpectAndReturn(FakeDTSPackage.OwnerMemberID, 0)
            rex.ExpectAndReturn(FakeDTSPackage.Version, 0)
            rex.ExpectAndReturn(FakeDTSPackage.Source, FakeSource)
            rex.ExpectAndReturn(DTSPackage.GetPackageByID(-1), FakeDTSPackage).WhenArgumentsMatch(-1)
        End Using

        Return DTSPackage.GetPackageByID(-1)
    End Function
    ''' <summary>Caution! This will actually create a record in UploadFile table if not 
    ''' called from a test that runs in a transaction.</summary>
    ''' <returns></returns>
    Private Shared Function GetDummyDTSPackage() As DTSPackage
        'Do our saving and verifying in a new transaction scope to avoid data dependency
        'Note: in your connection string enlist attribute should be set to true to be 
        'included in the Transaction. Transactions can have only one connection so if you need to 
        'leave NrcAuth connection out then set enlist to false in NrcAuthConnectionString in App.Config
        '***************************************************************************************
        'Using scope As New System.Transactions.TransactionScope(System.Transactions.TransactionScopeOption.RequiresNew, System.TimeSpan.FromSeconds(10))
        '  We(don) 't need an actual PM member from the database to save with the uploadfile so
        'let's mock the PM
        Using rex As New RecordExpectations()
            Dim fakeMember As Nrc.NRCAuthLib.Member = RecorderManager.CreateMockedObject(Of Nrc.NRCAuthLib.Member)()
            rex.ExpectAndReturn(fakeMember.MemberId, FakeMemberId)
            rex.ExpectAndReturn(fakeMember.FirstName, FakeProjectManagerFirstName)
            rex.ExpectAndReturn(fakeMember.LastName, FakeProjectManagerLastname)
            rex.ExpectAndReturn(fakeMember.EmailAddress, FakeMemberEmailAddress)
            rex.ExpectAndReturn(fakeMember.FullName, FakeProjectManagerFirstName & " " & FakeProjectManagerLastname)
            rex.ExpectAndReturn(Nrc.NRCAuthLib.Member.GetMember("amnatsakanyan"), fakeMember).RepeatAlways.WhenArgumentsMatch(DummyMemberLogin)
        End Using


        Dim FakeDTSPackage As DTSPackage = CreateDummyDTSPackage()

        Return FakeDTSPackage
    End Function
#End Region
End Class