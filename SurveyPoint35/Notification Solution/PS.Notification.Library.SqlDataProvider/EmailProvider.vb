Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports PS.Framework.Data
Imports PS.Notification.Library
Public Class EmailProvider
    Inherits PS.Notification.Library.EmailProvider
    Private ReadOnly Property Db(ByVal connString As String) As Database
        Get
            Return DatabaseHelper.Db(connString)
        End Get
    End Property
    Private Function PopulateEmail(ByVal rdr As SafeDataReader) As Email
        Dim obj As Email = Email.NewEmail
        Dim privateInterface As IEmail = obj
        obj.BeginPopulate()
        privateInterface.EmailID = rdr.GetInteger("EmailID")
        StringToList(obj.ToEmailAddresses, rdr.GetString("ToEmailAddress"))
        StringToList(obj.CCEmailAddresses, rdr.GetString("CCEmailAddress"))
        StringToList(obj.BCCEmailAddresses, rdr.GetString("BCCEmailAddress"))
        StringToList(obj.Attachements, rdr.GetString("Attachments"))
        obj.FromEmailAddress = rdr.GetString("FromEmailAddress")
        If rdr.GetInteger("ContinueWithAttachmentError") = 1 Then
            obj.ContinueWithAttachmentError = True
        Else
            obj.ContinueWithAttachmentError = False
        End If
        obj.StatusMsg = rdr.GetString("StatusMsg")
        obj.Subject = rdr.GetString("Subject")
        obj.Body = rdr.GetString("Body")
        obj.EmailStatus = NumToEmailStatus(rdr.GetInteger("EmailStatus"))
        obj.EmailType = NumToEmailType(rdr.GetInteger("EmailType"))
        obj.InsertDate = rdr.GetDate("InsertDate")
        obj.UpdateDate = rdr.GetDate("UpdateDate")
        obj.InsertUser = rdr.GetString("InsertUser")
        obj.UpdateUser = rdr.GetString("UpdateUser")
        obj.EndPopulate()
        Return obj
    End Function

#Region " Overrides "
    Public Overrides Sub RecordSent(ByVal emailID As Integer)
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.RecordSent, emailID)
        ExecuteNonQuery(cmd)
    End Sub
    Public Overrides Function PingSurveyAdminDB() As Boolean
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.PingSurveyAdminDB)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Return True
            End While
        End Using
    End Function
    Public Overrides Function GetTop50EmailsToSend() As Emails
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.GetTop50EmailsToSend)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Emails, Email)(rdr, AddressOf PopulateEmail)
        End Using
    End Function
    Public Overrides Function InsertEmail(ByVal ToAddresses As String, ByVal ccAddresses As String, ByVal bccAddresses As String, _
                                          ByVal fromAddress As String, ByVal subject As String, ByVal body As String, _
                                          ByVal emailType As EmailType, ByVal attachments As String, ByVal applicationName As String, _
                                          ByVal insertUser As String, ByVal continueWAttachmentError As Boolean) As Integer
        Dim retVal As Integer = 0
        Dim cmd As DbCommand = Db(Config.SurveyAdminConnection).GetStoredProcCommand(SP.InsertEmailQueue, ToAddresses, _
                                        ccAddresses, bccAddresses, fromAddress, subject, body, CInt(emailType), _
                                        attachments, applicationName, insertUser, Math.Abs(CInt(continueWAttachmentError)))
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                retVal = CInt(rdr("ID"))
            End While
        End Using
        Return retVal
    End Function
#End Region
#Region " Helper Methods "
    Private Sub StringToList(ByRef lst As List(Of String), ByVal str As String)
        If str.Length > 0 Then
            str = Replace(str, ";DELIMIT;", Chr(223))
            Dim strArray() As String = str.Split(Chr(223))
            For Each item As String In strArray
                lst.Add(item)
            Next
        End If
    End Sub
    Private Function NumToEmailType(ByVal number As Integer) As EmailType
        Dim temp As EmailType = EmailType.Text
        Return [Enum].ToObject(temp.GetType(), number)
    End Function
    Private Function NumToEmailStatus(ByVal number As Integer) As EmailStatus
        Dim temp As EmailStatus = EmailStatus.NotSent
        Return [Enum].ToObject(temp.GetType(), number)
    End Function
#End Region
End Class
