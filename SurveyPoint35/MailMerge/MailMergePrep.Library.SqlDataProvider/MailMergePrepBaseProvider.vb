Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports MailMergePrep.Library
Public Class MailMergePrepBaseProvider
    Inherits MailMergePrep.Library.MailMergePrepBaseProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateMailMergePrepBase(ByVal rdr As SafeDataReader) As MailMergePrepBase
        'Not Implemented
        Return Nothing
    End Function

#Region " Overrides "
    Public Overrides Function QueueSurveyMerge(ByVal mergeName As String, ByVal templateID As Integer, ByVal projectID As Integer, ByVal faqssID As String, _
                                               ByVal mailStep As Integer, ByVal paperConfigID As Integer, ByVal surveyDataDirectory As String, _
                                               ByVal mergeDirectory As String, ByVal totalRecordNum As Integer, ByVal saveMergedWordDocs As Boolean, _
                                               ByVal instructions As String, ByVal specialInstructions As String, ByVal currentUser As String) As Integer
        Dim cmd As DbCommand = Db(Config.QMSConnection).GetStoredProcCommand(SP.InsertMergeQueue, mergeName, templateID, _
                                                                             projectID, faqssID, mailStep, paperConfigID, surveyDataDirectory, _
                                                                             mergeDirectory, totalRecordNum, Math.Abs(CInt(saveMergedWordDocs)), instructions, specialInstructions, _
                                                                             currentUser)
        Dim id As Integer = 0
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                id = CInt(rdr("ID"))
            End While
        End Using
        Return id
    End Function
#End Region
End Class
