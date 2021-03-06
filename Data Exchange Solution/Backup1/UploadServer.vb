Imports System.Text
Imports System.Web.Mail
Imports System.IO
Imports System.Xml.Serialization
Imports System.Data.SqlClient
Public Class UploadServer

#Region " Application Variables/Constants "
    Private mstrClientSupportEmail As String
    Private mstrAppPath As String

    Private mobjLastException As Exception

    Private DataUser As DataUser
    Private DownloadFile As PostedFile
    Private UploadFile As UploadFile

    Public Enum Role
        DownloadUser = 1
        PostUser = 2
        UploadUser = 3
        AdminUser = 4
    End Enum


#End Region

#Region " Application Properties "
    Public ReadOnly Property User() As DataUser
        Get
            Return DataUser
        End Get
    End Property
    Public ReadOnly Property FileToDownload() As PostedFile
        Get
            Return DownloadFile
        End Get
    End Property
    Public ReadOnly Property FileToUpload() As UploadFile
        Get
            Return UploadFile
        End Get
    End Property
    Public Property LastException() As Exception
        Get
            Return mobjLastException
        End Get
        Set(ByVal Value As Exception)
            mobjLastException = Value
        End Set
    End Property
    Public ReadOnly Property ClientSupportEmail() As String
        Get
            Return mstrClientSupportEmail
        End Get
    End Property
#End Region

#Region " Database Functions "

#Region " GetDBConnection "
    Private Shared Function GetDBConnection() As SqlConnection
        Dim strConn As String
        strConn = AppConfig.Instance.DataExchangeConnection
        Dim objConn As New SqlConnection(strConn)
        Return objConn
    End Function

#End Region

#Region " Authenticate "
    Public Function Authenticate(ByVal strUserName As String, ByVal strPassword As String) As Boolean
        Dim objCommand As New SqlCommand("DBO.SP_Authenticate", GetDBConnection)
        Dim objAdapter As SqlDataAdapter
        Dim objDS As New DataSet("DataUser")
        Dim bolAuthenticated As Boolean = False
        Dim objDataUser As DataUser

        With objCommand
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@strUserName", SqlDbType.VarChar).Value = strUserName
            .Parameters.Add("@strPassword", SqlDbType.VarChar).Value = strPassword
        End With

        objAdapter = New SqlDataAdapter(objCommand)
        objAdapter.Fill(objDS)

        If objDS.Tables(0).Rows.Count = 0 Then
            bolAuthenticated = False
            objDataUser = Nothing
        Else
            bolAuthenticated = True

            Dim objRec As DataRow = objDS.Tables(0).Rows(0)
            objDataUser = New DataUser(objRec.Item("DataUser_id"))
            With objDataUser
                .FirstName = objRec.Item("strFName")
                .LastName = objRec.Item("strLName")
                .UserName = objRec.Item("strUserName")
                .Password = objRec.Item("strPassword")
                .Email = objRec.Item("strEmail")
                .HasPostAccess = objRec.Item("bitPostAccess")
                .Roles = objRec.Item("strRoles")
                .Browser = HttpContext.Current.Request.Browser.Browser & HttpContext.Current.Request.Browser.Version
            End With
            UploadFile = New UploadFile
        End If

        If Not bolAuthenticated _
            And strUserName.ToLower = "anonymous" _
            And Not strPassword = "" _
            And Not strPassword.IndexOf("@") = -1 _
            And Not strPassword.IndexOf(".") = -1 Then

            bolAuthenticated = True
            objDataUser = New DataUser
            objDataUser.UserName = strUserName
            objDataUser.Email = strPassword
            objDataUser.Roles = "UploadUser"
            objDataUser.Browser = HttpContext.Current.Request.Browser.Browser & HttpContext.Current.Request.Browser.Version
            UploadFile = New UploadFile
        End If

        If bolAuthenticated Then
            GetDownloadFile(objDataUser.DataUserID)
        End If

        DataUser = objDataUser
        Return bolAuthenticated
    End Function

#End Region

#Region " GetDownloadFile "
    Private Function GetDownloadFile(ByVal DownloadUser_id As Integer)
        Dim objCommand As New SqlCommand("DBO.SP_GetUserDownload", GetDBConnection)
        Dim objAdapter As SqlDataAdapter
        Dim objDS As New DataSet("DownloadFile")
        Dim objFile As PostedFile

        With objCommand
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@DataUser_id", SqlDbType.VarChar).Value = DownloadUser_id
        End With

        objAdapter = New SqlDataAdapter(objCommand)
        objAdapter.Fill(objDS)

        If objDS.Tables(0).Rows.Count = 0 Then
            objFile = Nothing
        Else
            Dim objRec As DataRow = objDS.Tables(0).Rows(0)
            objFile = New PostedFile(objRec.Item("PostedFile_id"))
            With objFile
                .PostUser = objRec.Item("strPostUser")
                .FileNameOld = objRec.Item("strOldFileName")
                .FileNameNew = objRec.Item("strNewFileName")
                .FilePath = objRec.Item("strFilePath")
                .Description = objRec.Item("strDescription")
                .DatePosted = objRec.Item("datPosted")
                If Not IsDBNull(objRec.Item("datLastDownload")) Then
                    .DateLastDownload = objRec.Item("datLastDownload")
                End If
                .DateExpires = objRec.Item("datExpires")
                .MaxDownloads = objRec.Item("intMaxDownloads")
                .DownloadCount = objRec.Item("intDownloadCount")
                .isDeleted = objRec.Item("bitDeleted")
            End With
        End If

        DownloadFile = objFile
    End Function

#End Region

#Region " RecordUserDownload "
    Public Sub RecordUserDownload(ByVal PostedFile_id As Integer)
        Dim objCommand As New SqlCommand("DBO.SP_RecordUserDownload", GetDBConnection)

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@PostedFile_id", SqlDbType.VarChar).Value = PostedFile_id
            .ExecuteNonQuery()
        End With
    End Sub

#End Region

#Region " ChangeUserPassword "
    Public Function changeUserPassword(ByVal userID As String, ByVal newPassword As String)
        Dim updateUser As Integer = userID
        Dim userPassword As String = newPassword

        Dim objCommand As New SqlCommand("DBO.SP_ChangeUserPassword", GetDBConnection)

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@userID", SqlDbType.Int).Value = updateUser
            .Parameters.Add("@pWord", SqlDbType.VarChar, 50).Value = userPassword
            .ExecuteNonQuery()
        End With
        Return ""
    End Function
#End Region

#Region " CreateNewUser "
    Public Function CreateNewDownloadUser(ByVal strFName As String, ByVal strLName As String, ByVal strEmail As String) As Integer
        Dim strUserName As String
        Dim strPassword As String
        Dim intNewUserID As Integer

        strUserName = GenerateNewUserName()
        strPassword = GenerateNewPassword()

        intNewUserID = CreateNewUser(strFName, strLName, strUserName, strPassword, strEmail, Role.DownloadUser)
        Return intNewUserID
    End Function
    Public Function CreateNewPostUser(ByVal strFName As String, ByVal strLName As String, ByVal strEmail As String, ByVal strPassword As String) As Integer
        Dim strUserName As String
        Dim intNewUserID As Integer

        strUserName = Left(strFName, 1) & strLName

        intNewUserID = CreateNewUser(strFName, strLName, strUserName, strPassword, strEmail, Role.PostUser)
        Return intNewUserID
    End Function
    Public Function CreateNewAdminUser(ByVal strFName As String, ByVal strLName As String, ByVal strEmail As String, ByVal strPassword As String) As Integer
        Dim strUserName As String
        Dim intNewUserID As Integer

        strUserName = Left(strFName, 1) & strLName

        intNewUserID = CreateNewUser(strFName, strLName, strUserName, strPassword, strEmail, Role.AdminUser)
        Return intNewUserID
    End Function
    Private Function CreateNewUser(ByVal strFName As String, ByVal strLName As String, ByVal strUserName As String, ByVal strPassword As String, ByVal strEmail As String, ByVal enumUserRole As Role) As Integer
        Dim intNewUserID As Integer

        Dim bolHasPostAccess As Boolean = False
        If enumUserRole = Role.AdminUser Or enumUserRole = Role.PostUser Then
            bolHasPostAccess = True
        End If

        Dim objCommand As New SqlCommand("DBO.SP_CreateNewUser", GetDBConnection)

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@strFName", SqlDbType.VarChar).Value = strFName
            .Parameters.Add("@strLName", SqlDbType.VarChar).Value = strLName
            .Parameters.Add("@strUserName", SqlDbType.VarChar).Value = strUserName
            .Parameters.Add("@strPassword", SqlDbType.VarChar).Value = strPassword
            .Parameters.Add("@strEmail", SqlDbType.VarChar).Value = strEmail
            .Parameters.Add("@bitPostAccess", SqlDbType.Bit).Value = bolHasPostAccess
            .Parameters.Add("@Role_id", SqlDbType.Int).Value = enumUserRole
            .Parameters.Add("@intNewID", SqlDbType.Int).Direction = ParameterDirection.Output
            .ExecuteNonQuery()
            intNewUserID = .Parameters("@intNewID").Value
        End With

        Return intNewUserID
    End Function

#End Region

#Region " PostNewFile "
    Public Sub PostNewFile(ByVal DownloadUser_id As Integer, ByVal strOldFileName As String, ByVal strNewFilePath As String, ByVal strNewFileName As String, ByVal strDescription As String, ByVal strNotes As String)
        Dim intNewPostedFile_id As Integer
        Dim objCommand As New SqlCommand("DBO.SP_PostNewFile", GetDBConnection)

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@PostUser_id", SqlDbType.Int).Value = User.DataUserID
            .Parameters.Add("@DownloadUser_id", SqlDbType.Int).Value = DownloadUser_id
            .Parameters.Add("@strOldFileName", SqlDbType.VarChar).Value = strOldFileName
            .Parameters.Add("@strNewFileName", SqlDbType.VarChar).Value = strNewFileName
            .Parameters.Add("@strFilePath", SqlDbType.VarChar).Value = strNewFilePath
            .Parameters.Add("@strDescription", SqlDbType.VarChar).Value = strDescription
            .Parameters.Add("@strNotes", SqlDbType.Text).Value = strNotes
            .Parameters.Add("@intNewPostedFile_id", SqlDbType.Int).Direction = ParameterDirection.Output
            .ExecuteNonQuery()
            intNewPostedFile_id = .Parameters("@intNewPostedFile_id").Value
        End With

        EmailDownloadRecipient(DownloadUser_id)
    End Sub

#End Region

#Region " DeleteFile "
    Public Sub DeleteFile(ByVal intPostedFile_id As Integer)
        Dim objCommand As New SqlCommand("DBO.SP_DeleteFile", GetDBConnection)

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@PostedFile_id", SqlDbType.VarChar).Value = intPostedFile_id
            .ExecuteNonQuery()
        End With
    End Sub
#End Region

#Region " DeleteExpiredFiles "
    Public Shared Function DeleteExpiredFiles()
        Dim objCommand As New SqlCommand("DBO.SP_GetExpiredFiles", GetDBConnection())
        Dim objReader As SqlDataReader

        With objCommand
            .Connection.Open()
            .CommandType = CommandType.StoredProcedure
            objReader = .ExecuteReader()
        End With

        While objReader.Read()
            Try
                IO.File.Delete(objReader("strFilePath"))
            Catch
            End Try
        End While
    End Function

#End Region

#Region " LogUpload "
    Public Sub LogUpload()
        Dim objCommand As New SqlCommand("DBO.SP_LogUpload", GetDBConnection)

        With objCommand
            .CommandType = CommandType.StoredProcedure
            .Connection.Open()
            .Parameters.Add("@strIPAddr", SqlDbType.VarChar).Value = HttpContext.Current.Request.ServerVariables("REMOTE_ADDR")
            .Parameters.Add("@strUserFName", SqlDbType.VarChar).Value = User.FirstName
            .Parameters.Add("@strUserLName", SqlDbType.VarChar).Value = User.LastName
            .Parameters.Add("@strUserEmail", SqlDbType.VarChar).Value = User.Email
            .Parameters.Add("@strFacilityName", SqlDbType.VarChar).Value = FileToUpload.FacilityName
            .Parameters.Add("@strStudy_id", SqlDbType.VarChar).Value = FileToUpload.StudyID
            .Parameters.Add("@strFileDescription", SqlDbType.VarChar).Value = FileToUpload.Description
            .Parameters.Add("@strBeginDate", SqlDbType.VarChar).Value = FileToUpload.BeginDate
            .Parameters.Add("@strEndDate", SqlDbType.VarChar).Value = FileToUpload.EndDate
            .Parameters.Add("@strFileType", SqlDbType.VarChar).Value = FileToUpload.FileType
            .Parameters.Add("@strFileSize", SqlDbType.VarChar).Value = FileToUpload.FileSize
            .Parameters.Add("@strFileNameOld", SqlDbType.VarChar).Value = FileToUpload.FileNameOld
            .Parameters.Add("@strFileNameNew", SqlDbType.VarChar).Value = FileToUpload.FileNameNew
            .ExecuteReader()
        End With

    End Sub

    Public Function GetUploadLog(ByVal startDate As Date, ByVal endDate As Date) As DataSet
        Dim objCommand As New SqlCommand("DBO.SP_GetUploadLog", GetDBConnection)
        objCommand.Parameters.Add("@StartDate", SqlDbType.DateTime).Value = startDate
        objCommand.Parameters.Add("@EndDate", SqlDbType.DateTime).Value = endDate
        Dim objAdapter As SqlDataAdapter
        Dim objDS As New DataSet("UploadLog")

        With objCommand
            .CommandType = CommandType.StoredProcedure
        End With

        objAdapter = New SqlDataAdapter(objCommand)
        objAdapter.Fill(objDS)

        Return objDS
    End Function

    Public Function GetPostedFileLog(ByVal startDate As Date, ByVal endDate As Date) As DataSet
        Dim strSQL As String
        Dim objComm As SqlCommand
        Dim objAdapter As SqlDataAdapter
        Dim objDS As New DataSet("PostedFileLog")

        objComm = New SqlCommand("sp_GetPostedFileLog", GetDBConnection)
        objComm.CommandType = CommandType.StoredProcedure
        objComm.Parameters.Add("@StartDate", SqlDbType.DateTime).Value = startDate
        objComm.Parameters.Add("@EndDate", SqlDbType.DateTime).Value = endDate

        objAdapter = New SqlDataAdapter(objComm)
        objAdapter.Fill(objDS)

        Return objDS
    End Function

#End Region


#End Region

    Private ReadOnly Property LogoImage() As String
        Get
            Select Case AppConfig.Instance.Locale
                Case AppConfig.LocaleEnum.USA
                    Return AppConfig.Instance.SiteUrl & "img/NRCPicker/HeaderLeftUS.gif"
                Case AppConfig.LocaleEnum.Canada
                    Return AppConfig.Instance.SiteUrl & "img/NRCPicker/HeaderLeftCA.gif"
            End Select
        End Get
    End Property

    Public Sub New()
        mstrAppPath = HttpContext.Current.Request.PhysicalApplicationPath
        mstrClientSupportEmail = AppConfig.Instance.ClientSupportEmail
    End Sub

#Region " Email Methods "

#Region " Download Recipient "
    Public Sub EmailDownloadRecipient(ByVal intDataUser_id As Integer)
        Dim objCommand As New SqlCommand("DBO.SP_GetUserDownload", GetDBConnection)
        Dim objAdapter As SqlDataAdapter
        Dim objDS As New DataSet("DataUser")
        Dim objMail As New Mail.MailMessage
        Dim strBody As New StringBuilder
        Dim strSiteURL As String = AppConfig.Instance.SiteUrl

        Dim strPostUser As String
        Dim strPostUserEmail As String
        Dim strDownloadUser As String
        Dim strDownloadUserEmail As String
        Dim strUserName As String
        Dim strPassword As String
        Dim strFileDescription As String
        Dim strDatPosted As String
        Dim strFileExpiration As String
        Dim strMaxDownloads As String
        Dim strNotes As String

        With objCommand
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@DataUser_ID", SqlDbType.VarChar).Value = intDataUser_id
        End With

        objAdapter = New SqlDataAdapter(objCommand)
        objAdapter.Fill(objDS)

        If Not objDS.Tables(0).Rows.Count = 0 Then
            Dim objRec As DataRow = objDS.Tables(0).Rows(0)

            strPostUser = objRec.Item("strPostUser")
            strPostUserEmail = objRec.Item("strPostUserEmail")
            strDownloadUser = objRec.Item("strDownloadUser")
            strDownloadUserEmail = objRec.Item("strDownloadUserEmail")
            strUserName = objRec.Item("strUserName")
            strPassword = objRec.Item("strPassword")
            strFileDescription = objRec.Item("strDescription")
            strDatPosted = objRec.Item("datPosted").ToString
            strFileExpiration = objRec.Item("datExpires").ToString
            strMaxDownloads = objRec.Item("intMaxDownloads").ToString
            strNotes = objRec.Item("txtNotes")

            strBody.Append("<table border=""0"" cellspacing=""1"" cellpadding=""4"" width=""100%"" bgcolor=""#7C7C7C"">" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""FFFFFF"" colspan=""2"">" & vbCrLf)
            strBody.Append("			<table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%"">" & vbCrLf)
            strBody.Append("				<tr><td align=""left""><img src=""" & LogoImage & """></td>" & vbCrLf)
            strBody.Append("				    <td width=""100%"" style=""BACKGROUND-IMAGE: url(" & strSiteURL & "/img/NRCPicker/HeaderMiddle.gif); BACKGROUND-REPEAT: repeat-x"">&nbsp;</td>" & vbCrLf)
            strBody.Append("				    <td><img src=""" & strSiteURL & "img/NRCPicker/HeaderRight.gif""></td></tr>" & vbCrLf)
            strBody.Append("			</table>" & vbCrLf)
            strBody.Append("		</td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" align=""center"" colspan=""2""><font face=""Arial"" size=""4"" color=""#990000""><STRONG>New File Ready To Download</STRONG></font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Posted By:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strPostUser & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Post Time:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strDatPosted & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Description:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strFileDescription & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Notes</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strNotes & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Expiration Date:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strFileExpiration & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Maximum Downloads:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strMaxDownloads & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Secure Site:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2""><a target=""_blank"" href=""" & strSiteURL & """>" & strSiteURL & "</a></font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Name:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strUserName & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("	<tr>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Password:</STRONG></font></td>" & vbCrLf)
            strBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strPassword & "</font></td>" & vbCrLf)
            strBody.Append("	</tr>" & vbCrLf)
            strBody.Append("</table>" & vbCrLf)

            With objMail
                .To = strDownloadUserEmail
                .Bcc = strPostUserEmail
                .From = strPostUserEmail
                '.From = AppConfig.Instance.DataExchangeFromAddress
                .Subject = "New file ready to download"
                .Body = strBody.ToString
                .BodyFormat = MailFormat.Html
            End With
            Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
            Mail.SmtpMail.Send(objMail)
        End If
    End Sub

#End Region

#Region " Upload Notification "

    Public Sub EmailUploadNotification()
        Dim objMail As New MailMessage
        Dim sbBody As New StringBuilder

        sbBody.Append("<table border=""0"" cellspacing=""1"" cellpadding=""4"" width=""100%"" bgcolor=""#7C7C7C"">" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" align=""center"" colspan=""2""><font face=""Arial"" size=""4"" color=""#990000""><STRONG>New File Uploaded</STRONG></font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Uploaded By:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.FirstName & " " & User.LastName & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Email:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Email & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Facility Name:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FacilityName & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Study ID:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.StudyID & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Description:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.Description & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Begin Date:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.BeginDate & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>End Date:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.EndDate & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Type:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileType & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Old File Name:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileNameOld & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>New File Name:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileNameNew & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Size:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileSize.ToString("N") & " Bytes" & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Browser:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Browser & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("</table>" & vbCrLf)

        With objMail
            .To = ClientSupportEmail
            .From = AppConfig.Instance.DataExchangeFromAddress
            .Subject = "New File Uploaded"
            .Body = sbBody.ToString
            .BodyFormat = MailFormat.Html
            .Priority = MailPriority.High
        End With

        Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
        SmtpMail.Send(objMail)
    End Sub

#End Region

#Region " Upload Receipt "

    Public Sub EmailUploadReceipt()
        Dim objMail As New MailMessage
        Dim sbBody As New StringBuilder
        Dim strSiteURL As String = AppConfig.Instance.SiteUrl

        sbBody.Append("<table border=""0"" cellspacing=""1"" cellpadding=""4"" width=""100%"" bgcolor=""#7C7C7C"">" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""FFFFFF"" colspan=""2"">" & vbCrLf)
        sbBody.Append("			<table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%"">" & vbCrLf)
        sbBody.Append("				<tr><td align=""left""><img src=""" & LogoImage & """></td>" & vbCrLf)
        sbBody.Append("				    <td width=""100%"" style=""BACKGROUND-IMAGE: url(" & strSiteURL & "/img/NRCPicker/HeaderMiddle.gif); BACKGROUND-REPEAT: repeat-x"">&nbsp;</td>" & vbCrLf)
        sbBody.Append("				    <td><img src=""" & strSiteURL & "img/NRCPicker/HeaderRight.gif""></td></tr>" & vbCrLf)
        sbBody.Append("			</table>" & vbCrLf)
        sbBody.Append("		</td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" align=""center"" colspan=""2""><font face=""Arial"" size=""4"" color=""#990000""><STRONG>File Upload Successful</STRONG></font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Uploaded By:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.FirstName & " " & User.LastName & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Facility Name:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FacilityName & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Study ID:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.StudyID & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Description:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.Description & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Begin Date:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.BeginDate & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>End Date:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.EndDate & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Type:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileType & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Name:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileNameOld & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("	<tr>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>File Size:</STRONG></font></td>" & vbCrLf)
        sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & FileToUpload.FileSize.ToString("N") & " Bytes" & "</font></td>" & vbCrLf)
        sbBody.Append("	</tr>" & vbCrLf)
        sbBody.Append("</table>" & vbCrLf)

        With objMail
            .To = User.Email
            .From = AppConfig.Instance.DataExchangeFromAddress
            .Subject = "File Received"
            .Body = sbBody.ToString
            .BodyFormat = MailFormat.Html
            .Priority = MailPriority.Normal
        End With

        Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
        SmtpMail.Send(objMail)
    End Sub

#End Region

#Region " Error Message "

    Public Sub EmailErrorMessage()
        Try
            Dim objMail As New MailMessage
            Dim sbBody As New System.Text.StringBuilder

            sbBody.Append("<table border=""0"" cellspacing=""1"" cellpadding=""4"" width=""100%"" bgcolor=""#7C7C7C"">" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" align=""center"" colspan=""2""><font face=""Arial"" size=""4"" color=""#990000""><STRONG>Application Error</STRONG></font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.FirstName & " " & User.LastName & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Name:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.UserName & " " & User.LastName & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Email:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Email & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Browser:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Browser & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Stack Trace:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & LastException.ToString().Replace(" ---> ", "<BR>").Replace(" at ", "<BR>&nbsp;&nbsp;&nbsp;at ").Replace(" --- ", "<BR><BR>") & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("</table>" & vbCrLf)

            With objMail
                .To = AppConfig.Instance.WebAdminEmail
                .From = AppConfig.Instance.DataExchangeFromAddress
                .Subject = "Data Transfer Application Error"
                .Body = sbBody.ToString
                .BodyFormat = MailFormat.Html
                .Priority = MailPriority.High
            End With

            Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
            SmtpMail.Send(objMail)
        Catch
        End Try
    End Sub

#End Region

#Region " Feedback Message "

    Public Sub EmailFeedBack(ByVal strFeedBack As String)
        Try
            Dim objMail As New MailMessage
            Dim sbBody As New System.Text.StringBuilder

            sbBody.Append("<table border=""0"" cellspacing=""1"" cellpadding=""4"" width=""100%"" bgcolor=""#7C7C7C"">" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" align=""center"" colspan=""2""><font face=""Arial"" size=""4"" color=""#990000""><STRONG>Feedback</STRONG></font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.FirstName & " " & User.LastName & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Name:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.UserName & " " & User.LastName & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Email:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Email & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>User Browser:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & User.Browser & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("	<tr>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" nowrap><font face=""Verdana"" size=""2""><STRONG>Message:</STRONG></font></td>" & vbCrLf)
            sbBody.Append("		<td bgcolor=""#FFFFCC"" width=""100%""><font face=""Verdana"" size=""2"">" & strFeedBack & "</font></td>" & vbCrLf)
            sbBody.Append("	</tr>" & vbCrLf)
            sbBody.Append("</table>" & vbCrLf)

            With objMail
                .To = ClientSupportEmail
                .From = AppConfig.Instance.DataExchangeFromAddress
                .Subject = "Feedback"
                .Body = sbBody.ToString
                .BodyFormat = MailFormat.Html
                .Priority = MailPriority.High
            End With

            Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
            SmtpMail.Send(objMail)
        Catch
        End Try
    End Sub

#End Region


#End Region

#Region " New Username/Password "
    Public Function GenerateNewPassword() As String
        Return GenRandomString(8)
    End Function

    Public Shared Function GenRandomString(ByVal intLength As Integer) As String
        Dim strRand As String = ""
        Dim strRandChar As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
        Dim ranBuff(50) As Byte
        Dim objRng As System.Security.Cryptography.RandomNumberGenerator = System.Security.Cryptography.RandomNumberGenerator.Create()

        objRng.GetBytes(ranBuff)

        Dim intRandLen As Integer = intLength
        'Dim intlength As Integer = ranBuff(0) Mod 4 + 8
        Dim i As Integer

        For i = 1 To intRandLen
            Dim intbNum As Integer = CInt(ranBuff((i + 1)))
            intbNum = intbNum Mod strRandChar.Length
            strRand += strRandChar.Substring(intbNum, 1)
        Next i

        Return strRand
    End Function

    Public Function GenerateNewUserName() As String
        Return GenRandomString(8)
    End Function
#End Region

#Region " GetNewFileName "
    Public Function GetNewFileName(ByVal enumUserRole As Role, ByRef strOldFileName As String, ByRef strNewFilePath As String, ByRef strNewFileName As String)
        Dim strTemp() As String
        Dim strExtension As String
        strTemp = strOldFileName.Split("\")
        strOldFileName = strTemp(strTemp.Length - 1)

        If strOldFileName.IndexOf(".") = -1 Then
            strExtension = ""
        Else
            strTemp = strOldFileName.Split(".")
            strExtension = "." & strTemp(strTemp.Length - 1)
        End If

        strNewFileName = Date.Now.ToString.Replace(" ", "_").Replace("/", "_").Replace(":", "_")
        strNewFileName &= HttpContext.Current.Session.SessionID.Substring(20)
        strNewFileName &= strExtension

        Select Case enumUserRole
            Case Role.PostUser
                strNewFilePath = AppConfig.Instance.PostedFilePath
            Case Role.UploadUser
                strNewFilePath = AppConfig.Instance.UploadedFilePath
        End Select

        If Not strNewFilePath.EndsWith("\") Then
            strNewFilePath &= "\"
        End If
    End Function

#End Region


End Class

#Region " DataUploadConfig Class "
Public Class DataUploadConfig
    Public SavePath As String
    Public BkupPath As String
    Public ClientSupportEmail As String
    Public LogFile As String
End Class

#End Region

#Region " DataUser Class "
Public Class DataUser
    Private DataUser_id As Integer
    Private strFName As String
    Private strLName As String
    Private strUserName As String
    Private strPassword As String
    Private strEmail As String
    Private bolPostAccess As Boolean
    Private strBrowser As String
    Private strRoles As String

#Region " Properties "
    Public ReadOnly Property DataUserID() As Integer
        Get
            Return DataUser_id
        End Get
    End Property
    Public Property FirstName() As String
        Get
            Return strFName
        End Get
        Set(ByVal Value As String)
            strFName = Value
        End Set
    End Property
    Public Property LastName() As String
        Get
            Return strLName
        End Get
        Set(ByVal Value As String)
            strLName = Value
        End Set
    End Property
    Public Property UserName() As String
        Get
            Return strUserName
        End Get
        Set(ByVal Value As String)
            strUserName = Value
        End Set
    End Property
    Public Property Password() As String
        Get
            Return strPassword
        End Get
        Set(ByVal Value As String)
            strPassword = Value
        End Set
    End Property
    Public Property Email() As String
        Get
            Return strEmail
        End Get
        Set(ByVal Value As String)
            strEmail = Value
        End Set
    End Property
    Public Property HasPostAccess() As Boolean
        Get
            Return bolPostAccess
        End Get
        Set(ByVal Value As Boolean)
            bolPostAccess = Value
        End Set
    End Property
    Public Property Browser() As String
        Get
            Return strBrowser
        End Get
        Set(ByVal Value As String)
            strBrowser = Value
        End Set
    End Property
    Public Property Roles() As String
        Get
            Return strRoles
        End Get
        Set(ByVal Value As String)
            strRoles = Value
        End Set
    End Property
#End Region

    Public Sub New(ByVal DataUser_id As Integer)
        Me.DataUser_id = DataUser_id
    End Sub
    Public Sub New()
        Me.New(-1)
    End Sub

End Class

#End Region

#Region " PostedFile Class "

Public Class PostedFile
    Private intPostedFile_id As Integer
    Private strPostUser As String
    Private strOldFileName As String
    Private strNewFileName As String
    Private strFilePath As String
    Private strDescription As String
    Private datPosted As DateTime
    Private datLastDownload As DateTime
    Private datExpires As DateTime
    Private intMaxDownloads As Integer
    Private intDownloadCount As Integer
    Private bolDeleted As Boolean

#Region " Properties "
    Public ReadOnly Property PostedFileID() As Integer
        Get
            Return intPostedFile_id
        End Get
    End Property
    Public Property PostUser() As String
        Get
            Return strPostUser
        End Get
        Set(ByVal Value As String)
            strPostUser = Value
        End Set
    End Property
    Public Property FileNameOld() As String
        Get
            Return strOldFileName
        End Get
        Set(ByVal Value As String)
            strOldFileName = Value
        End Set
    End Property
    Public Property FileNameNew() As String
        Get
            Return strNewFileName
        End Get
        Set(ByVal Value As String)
            strNewFileName = Value
        End Set
    End Property
    Public Property FilePath() As String
        Get
            Return strFilePath
        End Get
        Set(ByVal Value As String)
            strFilePath = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return strDescription
        End Get
        Set(ByVal Value As String)
            strDescription = Value
        End Set
    End Property
    Public Property DatePosted() As DateTime
        Get
            Return datPosted
        End Get
        Set(ByVal Value As DateTime)
            datPosted = Value
        End Set
    End Property
    Public Property DateLastDownload() As DateTime
        Get
            Return datLastDownload
        End Get
        Set(ByVal Value As DateTime)
            datLastDownload = Value
        End Set
    End Property
    Public Property DateExpires() As DateTime
        Get
            Return datExpires
        End Get
        Set(ByVal Value As DateTime)
            datExpires = Value
        End Set
    End Property
    Public Property MaxDownloads() As Integer
        Get
            Return intMaxDownloads
        End Get
        Set(ByVal Value As Integer)
            intMaxDownloads = Value
        End Set
    End Property
    Public Property DownloadCount() As Integer
        Get
            Return intDownloadCount
        End Get
        Set(ByVal Value As Integer)
            intDownloadCount = Value
        End Set
    End Property
    Public Property isDeleted() As Boolean
        Get
            Return bolDeleted
        End Get
        Set(ByVal Value As Boolean)
            bolDeleted = Value
        End Set
    End Property
#End Region

    Public Sub New()

    End Sub
    Public Sub New(ByVal PostedFile_id As Integer)
        Me.intPostedFile_id = PostedFile_id
    End Sub
End Class

#End Region

#Region " UploadFile Class"
Public Class UploadFile
    Private strOldFileName As String
    Private strNewFileName As String
    Private intFileSize
    Private strFacilityName As String
    Private strStudyID As String
    Private strDescription As String
    Private strBeginDate As String
    Private strEndDate As String
    Private strFileType As String

#Region " Properties "
    Public Property FileNameOld() As String
        Get
            Return strOldFileName
        End Get
        Set(ByVal Value As String)
            strOldFileName = Value
        End Set
    End Property
    Public Property FileNameNew() As String
        Get
            Return strNewFileName
        End Get
        Set(ByVal Value As String)
            strNewFileName = Value
        End Set
    End Property
    Public Property FileSize() As Integer
        Get
            Return intFileSize
        End Get
        Set(ByVal Value As Integer)
            intFileSize = Value
        End Set
    End Property
    Public Property FacilityName() As String
        Get
            Return strFacilityName
        End Get
        Set(ByVal Value As String)
            strFacilityName = Value
        End Set
    End Property
    Public Property StudyID() As String
        Get
            Return strStudyID
        End Get
        Set(ByVal Value As String)
            strStudyID = Value
        End Set
    End Property
    Public Property Description() As String
        Get
            Return strDescription
        End Get
        Set(ByVal Value As String)
            strDescription = Value
        End Set
    End Property
    Public Property BeginDate() As String
        Get
            Return strBeginDate
        End Get
        Set(ByVal Value As String)
            strBeginDate = Value
        End Set
    End Property
    Public Property EndDate() As String
        Get
            Return strEndDate
        End Get
        Set(ByVal Value As String)
            strEndDate = Value
        End Set
    End Property
    Public Property FileType() As String
        Get
            Return strFileType
        End Get
        Set(ByVal Value As String)
            strFileType = Value
        End Set
    End Property
#End Region

End Class


#End Region


