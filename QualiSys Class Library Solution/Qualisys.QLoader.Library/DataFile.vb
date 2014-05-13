Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports NRC.Framework.BusinessLogic.Configuration
Imports System.Net.Mail

Public Class DataFile

#Region " Private Members "

    Private mMail As MailMessage
    Private mSmtpServer As SmtpClient

    Protected mClientID As Integer
    Protected mStudyID As Integer
    Protected mPackageID As Integer
    Protected mVersion As Integer
    Protected mDataFileID As Integer
    Protected mOriginalFileName As String
    Protected mFileName As String
    Protected mFolder As String
    Protected mFileSize As Integer
    Protected mRecordCount As Integer
    Protected mDateReceived As Date
    Protected mRecordsLoaded As Integer
    Protected mDataSetType As DataSetTypes
    Protected mIsGrouped As Boolean
    Protected mGroupList As String
    Protected mApprovers As ArrayList
    Protected mFileState As DataFileStates
    Protected mFileStateDescr As String
    Protected mPreloadTable As String
    Protected mIsDRGUpdate As Boolean
    Protected mIsLoadToLive As Boolean

#End Region

#Region " Public Properties "

    Public Property DataFileID() As Integer
        Get
            Return mDataFileID
        End Get
        Set(ByVal value As Integer)
            mDataFileID = value
        End Set
    End Property

    Public Property OriginalFileName() As String
        Get
            Return mOriginalFileName
        End Get
        Set(ByVal value As String)
            mOriginalFileName = value
        End Set
    End Property

    Public Property FileName() As String
        Get
            Return mFileName
        End Get
        Set(ByVal value As String)
            mFileName = value
        End Set
    End Property

    Public Property Folder() As String
        Get
            Return mFolder
        End Get
        Set(ByVal value As String)
            mFolder = value
        End Set
    End Property

    Public Property FileSize() As Integer
        Get
            Return mFileSize
        End Get
        Set(ByVal value As Integer)
            mFileSize = value
        End Set
    End Property

    Public Property RecordCount() As Integer
        Get
            Return mRecordCount
        End Get
        Set(ByVal value As Integer)
            mRecordCount = value
        End Set
    End Property

    Public Property DateReceived() As Date
        Get
            Return mDateReceived
        End Get
        Set(ByVal value As Date)
            mDateReceived = value
        End Set
    End Property

    Public Property RecordsLoaded() As Integer
        Get
            Return mRecordsLoaded
        End Get
        Set(ByVal value As Integer)
            mRecordsLoaded = value
        End Set
    End Property

    Public Property DataSetType() As DataSetTypes
        Get
            Return mDataSetType
        End Get
        Set(ByVal value As DataSetTypes)
            mDataSetType = value
        End Set
    End Property

    Public Property IsDRGUpdate() As Boolean
        Get
            Return mIsDRGUpdate
        End Get
        Set(ByVal value As Boolean)
            mIsDRGUpdate = value
        End Set
    End Property

    Public Property IsLoadToLive() As Boolean
        Get
            Return mIsLoadToLive
        End Get
        Set(ByVal value As Boolean)
            mIsLoadToLive = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property ClientID() As Integer
        Get
            Return mClientID
        End Get
    End Property

    Public ReadOnly Property LastMail() As MailMessage
        Get
            Return mMail
        End Get
    End Property

    Public ReadOnly Property StudyID() As Integer
        Get
            Return mStudyID
        End Get
    End Property

    Public ReadOnly Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
    End Property

    Public ReadOnly Property Version() As Integer
        Get
            Return mVersion
        End Get
    End Property

    Public ReadOnly Property Extension() As String
        Get
            Dim i As Integer
            i = mFileName.LastIndexOf(".")
            Return mFileName.Substring(i + 1)
        End Get
    End Property

    Public ReadOnly Property Path() As String
        Get
            Path = mFolder
            If (Not Path.EndsWith("\")) Then Path &= "\"
            Path &= mFileName
            Return Path
        End Get
    End Property

    Public ReadOnly Property FileState() As DataFileStates
        Get
            Return mFileState
        End Get
    End Property

    Public ReadOnly Property FileStateDescription() As String
        Get
            Return mFileStateDescr
        End Get
    End Property

    Public ReadOnly Property PreloadTable() As String
        Get
            Return String.Format("DataFile_{0}", mDataFileID)
        End Get
    End Property

    Public ReadOnly Property ExceptionFilePath() As String
        Get
            Return String.Format("{0}.Exc", Path)
        End Get
    End Property

    Public ReadOnly Property IsGrouped() As Boolean
        Get
            Return mIsGrouped
        End Get
    End Property

    Public ReadOnly Property GroupList() As String
        Get
            Return mGroupList
        End Get
    End Property

    Public ReadOnly Property Approvers() As ArrayList
        Get
            Return mApprovers
        End Get
    End Property

    Public ReadOnly Property ReportURL() As String
        Get
            Return String.Format("{0}{1}&rs:Command=Render&rc:Parameters=false&DataFile_id={2}", AppConfig.Params("QLReportServer").StringValue, AppConfig.Params("QLValidationReport").StringValue, mDataFileID)
        End Get
    End Property

#End Region

#Region " Private ReadOnly Properties "

    Private ReadOnly Property SmtpServer() As SmtpClient
        Get
            If mSmtpServer Is Nothing Then
                mSmtpServer = New SmtpClient(AppConfig.SMTPServer)
            End If

            Return mSmtpServer
        End Get
    End Property

#End Region

#Region "Constructors"

    Public Sub New()

        mApprovers = New ArrayList

    End Sub

#End Region

#Region "Public Methods"

    Public Sub LoadFromDB(ByVal dataFileID As Integer)

        Dim tbl As DataTable = PackageDB.GetDataFile(dataFileID)

        If tbl.Rows.Count < 1 Then
            Throw New Exception("DataFile not found")
        End If

        Dim row As DataRow = tbl.Rows(0)

        mClientID = CType(row("Client_id"), Integer)
        mStudyID = CType(row("Study_id"), Integer)
        mDataFileID = CType(row("DataFile_id"), Integer)
        mVersion = CType(row("intVersion"), Integer)
        mDataSetType = CType(row("FileType_id"), DataSetTypes)
        mPackageID = CType(row("Package_id"), Integer)
        mFolder = row("strFileLocation").ToString
        mOriginalFileName = row("FileName").ToString
        mFileName = row("strFile_nm").ToString
        mFileSize = CType(row("intFileSize"), Integer)
        mRecordCount = CType(row("intRecords"), Integer)
        mDateReceived = CType(row("datReceived"), Date)
        If IsDBNull(row("intLoaded")) Then
            mRecordsLoaded = 0
        Else
            mRecordsLoaded = CType(row("intLoaded"), Integer)
        End If
        mFileState = CType(row("State_id"), DataFileStates)
        mFileStateDescr = row("StateDescription").ToString
        mGroupList = row("AssocDataFiles").ToString
        mIsGrouped = (mGroupList.IndexOf(",") > -1)
        mIsDRGUpdate = CType(row("isDRGUpdate"), Boolean)
        mIsLoadToLive = CType(row("IsLoadToLive"), Boolean)

        tbl = PackageDB.WhoApproved(dataFileID)
        If Not tbl Is Nothing Then
            For Each row In tbl.Rows
                mApprovers.Add(row("strNTLogin").ToString)
            Next
        End If

    End Sub

    Public Sub ChangeState(ByVal newState As DataFileStates, ByVal stateParameter As String, ByVal memberID As Integer)

        mFileState = newState
        ChangeState(mDataFileID, newState, stateParameter, memberID)

    End Sub

    Public Sub ChangeState(ByVal newState As DataFileStates, ByVal stateParameter As String)

        mFileState = newState
        Dim lastUserMemberID As Nullable(Of Integer) = GetLastUserMemberID()
        ChangeState(mDataFileID, newState, stateParameter, lastUserMemberID)

    End Sub

    Public Function QueueDataFile(ByVal packageID As Integer, ByVal version As Integer) As Integer

        Using conn As New SqlClient.SqlConnection(AppConfig.QLoaderConnection)
            conn.Open()

            Using trans As SqlClient.SqlTransaction = conn.BeginTransaction(IsolationLevel.ReadCommitted)
                Dim tbl As DataTable
                Dim newID As Integer
                Dim preload As String = String.Empty

                mPackageID = packageID
                mVersion = version

                Try
                    tbl = PackageDB.NewDataFile(trans, mPackageID, mVersion, mDataSetType, mFolder, mOriginalFileName, mFileName, mFileSize, mRecordCount, mIsDRGUpdate, mIsLoadToLive)

                    'If no row was returned then SP failed to save data file
                    If tbl.Rows.Count < 1 Then
                        Throw New Exception("Unable to create new Data File!")
                    End If

                    newID = CType(tbl.Rows(0)(0), Integer)
                    If newID = -1 Then
                        Throw New Exception("Unable to create preload table.")
                    End If

                    preload = tbl.Rows(0)(1).ToString
                    If preload.Length = 0 Then
                        Throw New Exception("Unable to identify preload table.")
                    End If

                    mDataFileID = newID
                    mPreloadTable = preload

                    trans.Commit()
                    Return newID

                Catch ex As Exception
                    trans.Rollback()
                    Throw ex

                Finally
                    conn.Close()

                End Try
            End Using
        End Using

    End Function

    Public Sub Approve(ByVal currentUser As User)

        Select Case FileState
            Case DataFileStates.AwaitingFirstApproval
                ChangeState(DataFileStates.AwaitingFinalApproval, "First Approval by " & currentUser.LoginName, currentUser.MemberId)
                NotifySecondApproval(currentUser)

            Case DataFileStates.AwaitingFinalApproval
                ChangeState(DataFileStates.AwaitingApply, "Final Approval by " & currentUser.LoginName, currentUser.MemberId)

        End Select

    End Sub

    Public Function GetLastUserMemberID() As Nullable(Of Integer)

        Return PackageDB.GetLastUserMemberID(DataFileID)

    End Function

    Public Sub Unload(ByVal currentUser As User)

        ChangeState(DataFileStates.Abandoned, "Abandonded by " & currentUser.LoginName, currentUser.MemberId)

    End Sub

    Public Sub Apply()

        PackageDB.ApplyFile(mDataFileID)
        NotifyApplySuccess()

    End Sub

    Public Sub UpdateDRG()

        Dim tbl As DataTable = PackageDB.UpdateDRG(mStudyID, mDataFileID)
        NotifyUpdateDRG(tbl)

    End Sub

    Public Function IsApprover(ByVal userName As String) As Boolean

        For Each user As String In mApprovers
            If user.ToLower = userName.ToLower Then
                Return True
            End If
        Next

        Return False

    End Function

    Public Function GetPackageByID(ByVal packageID As Integer) As DTSPackage

        Return New DTSPackage(packageID)

    End Function

#End Region

#Region " Public Shared Methods "

    Public Shared Sub RollbackDataFiles(ByVal datasetID As Integer, ByVal currentUser As User)

        Dim dataFileIDs() As Integer = PackageDB.GetDataFileIdsByDatasetId(datasetID)

        For Each dataFileID As Integer In dataFileIDs
            ChangeState(dataFileID, DataFileStates.RolledBack, String.Format("Rolled back by {0}", currentUser.LoginName), currentUser.MemberId)
        Next

    End Sub

#End Region

#Region "Private Methods"

    Private Sub NotifySecondApproval(ByVal currentUser As User)

        Dim package As DTSPackage = GetPackageByID(mPackageID)

        Dim packageOwner As NRCAuthLib.Member
        If package.OwnerMemberID.HasValue Then
            packageOwner = Nrc.NRCAuthLib.Member.GetMember(package.OwnerMemberID.Value)
        Else
            packageOwner = Nothing
        End If

        Dim recepients As New MailAddressCollection

        Dim currentUserEmailAddress As String = Nrc.NRCAuthLib.Member.GetMember(currentUser.MemberId).EmailAddress
        If packageOwner IsNot Nothing Then
            'Owner always gets an email
            recepients.Add(packageOwner.EmailAddress)

            'If applier is not the package owner the applier gets an email too.
            If currentUser IsNot Nothing AndAlso packageOwner.MemberId <> currentUser.MemberId Then
                recepients.Add(currentUserEmailAddress)
            End If
        Else
            'This should never happen in production (a package should always have an owner)
            recepients.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            If currentUser IsNot Nothing Then
                recepients.Add(currentUserEmailAddress)
            End If
        End If

        mMail = New MailMessage()

        If AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            For Each address As MailAddress In recepients
                mMail.To.Add(address)
            Next
        Else
            If Not mMail.To.Contains(New MailAddress(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)) Then
                mMail.To.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            End If
        End If

        'If not in production this will show where the emails intended to go
        Dim body As String = ToHtml(package, recepients.ToString, EmailTypes.FirstApproval)

        mMail.From = New MailAddress(AppConfig.Params("ClientSupportEmailAddress").StringValue)
        mMail.Subject = String.Format("Data File Loaded ({0})", package.Study.ClientName)
        If Not AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            mMail.Subject &= String.Format(" ({0})", System.Enum.GetName(GetType(EnvironmentTypes), AppConfig.EnvironmentType))
        End If

        mMail.Body = body
        mMail.IsBodyHtml = True

        'Add some error handling in case email can't be sent.
        'Give better error message.
        Try
            SmtpServer.Send(mMail)

        Catch ex As Exception
            Dim msg As String = String.Format("Notification/Mail Failure: {0}", vbCrLf)
            If Not mMail Is Nothing Then
                msg &= String.Format("To: {0}{1}", mMail.To, vbCrLf)
                msg &= String.Format("From: {0}{1}", mMail.From, vbCrLf)
                msg &= String.Format("Subject: {0}{1}", mMail.Subject, vbCrLf)
                msg &= ex.Message
            End If
            Throw New ApplicationException(msg, ex)

        End Try

    End Sub

    Private Sub NotifyApplySuccess()

        Dim package As DTSPackage = GetPackageByID(mPackageID)

        Dim packageOwner As NRCAuthLib.Member
        If package.OwnerMemberID.HasValue Then
            packageOwner = Nrc.NRCAuthLib.Member.GetMember(package.OwnerMemberID.Value)
        Else
            packageOwner = Nothing
        End If

        Dim lastUserMemberID As Nullable(Of Integer) = GetLastUserMemberID()
        Dim currentUser As Nrc.NRCAuthLib.Member
        If lastUserMemberID.HasValue Then
            currentUser = Nrc.NRCAuthLib.Member.GetMember(lastUserMemberID.Value)
        Else
            currentUser = Nothing
        End If

        Dim recepients As New MailAddressCollection
        Dim body As String

        mMail = New MailMessage

        If packageOwner IsNot Nothing Then
            'Owner always gets an email
            recepients.Add(packageOwner.EmailAddress)

            'If applier is not the package owner the applier gets an email too.
            If currentUser IsNot Nothing AndAlso packageOwner.MemberId <> currentUser.MemberId Then
                recepients.Add(currentUser.EmailAddress)
            End If
        Else
            'This should never happen
            recepients.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            If currentUser IsNot Nothing Then
                recepients.Add(currentUser.EmailAddress)
            End If
        End If

        If AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            For Each address As MailAddress In recepients
                mMail.To.Add(address)
            Next
        Else
            If Not mMail.To.Contains(New MailAddress(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)) Then
                mMail.To.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            End If
        End If

        body = ToHtml(package, recepients.ToString, EmailTypes.ApplySuccess)

        mMail.From = New MailAddress(AppConfig.Params("ClientSupportEmailAddress").StringValue)
        mMail.Subject = String.Format("Data File Applied ({0})", package.Study.ClientName)
        If Not AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            mMail.Subject &= String.Format(" ({0})", System.Enum.GetName(GetType(EnvironmentTypes), AppConfig.EnvironmentType))
        End If

        mMail.Body = body
        mMail.IsBodyHtml = True

        'Add some error handling in case email can't be sent.
        'Give better error message.
        Try
            SmtpServer.Send(mMail)

        Catch ex As Exception
            Dim msg As String = String.Format("Notification/Mail Failure: {0}", vbCrLf)
            If Not mMail Is Nothing Then
                msg &= String.Format("To: {0}{1}", mMail.To, vbCrLf)
                msg &= String.Format("From: {0}{1}", mMail.From, vbCrLf)
                msg &= String.Format("Subject: {0}{1}", mMail.Subject, vbCrLf)
                msg &= ex.Message
            End If
            Throw New ApplicationException(msg, ex)

        End Try

    End Sub

    Private Sub NotifyUpdateDRG(ByVal updateDRGResults As DataTable)

        Dim package As DTSPackage = GetPackageByID(mPackageID)

        Dim packageOwner As NRCAuthLib.Member
        If package.OwnerMemberID.HasValue Then
            packageOwner = Nrc.NRCAuthLib.Member.GetMember(package.OwnerMemberID.Value)
        Else
            packageOwner = Nothing
        End If

        Dim lastUserMemberID As Nullable(Of Integer) = GetLastUserMemberID()
        Dim currentUser As Nrc.NRCAuthLib.Member
        If lastUserMemberID.HasValue Then
            currentUser = Nrc.NRCAuthLib.Member.GetMember(lastUserMemberID.Value)
        Else
            currentUser = Nothing
        End If

        Dim recepients As New MailAddressCollection
        Dim body As String

        mMail = New MailMessage

        If packageOwner IsNot Nothing Then
            'Owner always gets an email
            recepients.Add(packageOwner.EmailAddress)

            'If applier is not the package owner the applier gets an email too.
            If currentUser IsNot Nothing AndAlso packageOwner.MemberId <> currentUser.MemberId Then
                recepients.Add(currentUser.EmailAddress)
            End If
        Else
            'This should never happen
            recepients.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            If currentUser IsNot Nothing Then
                recepients.Add(currentUser.EmailAddress)
            End If
        End If

        If AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            For Each address As MailAddress In recepients
                mMail.To.Add(address)
            Next
        Else
            If Not mMail.To.Contains(New MailAddress(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)) Then
                mMail.To.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            End If
        End If

        body = ToDRGHtml(package, recepients.ToString, updateDRGResults)

        mMail.From = New MailAddress(AppConfig.Params("ClientSupportEmailAddress").StringValue)
        mMail.Subject = String.Format("UpdateDRG Complete ({0})", package.Study.ClientName)
        If Not AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            mMail.Subject &= String.Format(" ({0})", System.Enum.GetName(GetType(EnvironmentTypes), AppConfig.EnvironmentType))
        End If

        mMail.Body = body
        mMail.IsBodyHtml = True

        'Add some error handling in case email can't be sent.
        'Give better error message.
        Try
            SmtpServer.Send(mMail)

        Catch ex As Exception
            Dim msg As String = String.Format("Notification/Mail Failure: {0}", vbCrLf)
            If Not mMail Is Nothing Then
                msg &= String.Format("To: {0}{1}", mMail.To, vbCrLf)
                msg &= String.Format("From: {0}{1}", mMail.From, vbCrLf)
                msg &= String.Format("Subject: {0}{1}", mMail.Subject, vbCrLf)
                msg &= ex.Message
            End If
            Throw New ApplicationException(msg, ex)

        End Try

    End Sub

    Private Function ToHtml(ByVal package As DTSPackage, ByVal emailTo As String, ByVal emailType As EmailTypes) As String

        Dim body As New Text.StringBuilder
        Dim file As DataFile
        Dim fileList() As String = mGroupList.Split(Char.Parse(","))
        Dim message As String = String.Empty

        If emailType = EmailTypes.FirstApproval Then
            message = String.Format("New data file(s) have been received and loaded. Before the file(s) can be applied and made available for sampling, the validation reports must be approved by a Client Service Team member.  The validation reports can be viewed and approved in the QLoader application.<BR><BR>For more information, please contact the <a href=""mailto:{0}"">Client Support Group</a>.", AppConfig.Params("ClientSupportEmailAddress").StringValue)
        ElseIf emailType = EmailTypes.ApplySuccess Then
            message = String.Format("The above listed file(s) have been applied and are now ready for sampling.<BR><BR>For more information, please contact the <a href=""mailto:{0}"">Client Support Group</a>.", AppConfig.Params("ClientSupportEmailAddress").StringValue)
        End If

        body.Append("<HTML>")
        body.Append("<HEAD>")
        body.Append("<STYLE>")
        body.AppendFormat(".NotifyTable{0}", "{background-color: #033791; font-family: Tahoma, Verdana, Arial; font-size:X-Small;}")
        body.AppendFormat(".HeaderRow{0}", "{Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;filter:progid:DXImageTransform.Microsoft.gradient(enabled='true', startColorstr=#5A87D7, endColorstr=#033791);progid:DXImageTransform.Microsoft.Blur(pixelradius=1)}")
        body.AppendFormat(".LabelCell{0}", "{background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold}")
        body.AppendFormat(".DataCell{0}", "{background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: nowrap}")
        body.AppendFormat(".InfoCell{0}", "{background-color: #FFFFFF; padding: 5px}")
        body.Append("</STYLE>")
        body.Append("</HEAD>")

        body.Append("<BODY>")
        body.Append("<TABLE Class=""NotifyTable"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">Data File Notification</TD></TR>")
        body.AppendFormat("<TR><TD Class=""LabelCell"">To:</TD><TD Class=""DataCell"">{0}</TD></TR>", emailTo)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Client Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.ClientName, package.Study.ClientID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Study Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.StudyName, package.Study.StudyID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Report Link:</TD><TD Class=""DataCell""><a href='{0}'>Archived Report</a></TD></TR>", ReportURL)

        'File list table
        body.Append("<TR><TD Class=""LabelCell"" valign=""Top"">Files Loaded:</TD><TD Class=""InfoCell"" Colspan=""1"">")
        body.Append("<TABLE Class=""NotifyTable"" Width=""400"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""LabelCell"">Package</TD><TD Class=""LabelCell"">File Name</TD><TD Class=""LabelCell"">Records</TD></TR>")

        body.AppendFormat("<TR><TD Class=""DataCell"">{0} ({1})</TD><TD Class=""DataCell"">{2} ({3})</TD><TD Class=""DataCell"">{4}</TD></TR>", package.PackageName, package.PackageID, mOriginalFileName, mDataFileID, mRecordCount)
        For Each fileID As String In fileList
            If Not Integer.Parse(fileID) = mDataFileID Then
                file = New DataFile
                file.LoadFromDB(CType(fileID, Integer))
                If Not file.PackageID = package.PackageID Then
                    package = New DTSPackage(file.PackageID)
                End If
                body.AppendFormat("<TR><TD Class=""DataCell"">{0} ({1})</TD><TD Class=""DataCell"">{2} ({3})</TD><TD Class=""DataCell"">{4}</TD></TR>", package.PackageName, package.PackageID, file.OriginalFileName, file.DataFileID, file.RecordCount)
            End If
        Next
        body.Append("</TABLE></TD></TR>")
        'End File list table

        body.AppendFormat("<TR><TD Class=""InfoCell"" Colspan=""2"">{0}</TD></TR>", message)
        body.Append("</TABLE>")

        body.Append("</BODY>")
        body.Append("</HTML>")

        Return body.ToString

    End Function

    Private Function ToDRGHtml(ByVal package As DTSPackage, ByVal emailTo As String, ByVal updateDRGResults As DataTable) As String

        Dim body As New Text.StringBuilder

        Dim message As String = String.Format("The listed file has updated applicable DRGs and has been unloaded.<BR><BR>For more information, please contact the <a href=""mailto:{0}"">Client Support Group</a>.", AppConfig.Params("ClientSupportEmailAddress").StringValue)

        body.Append("<HTML>")
        body.Append("<HEAD>")
        body.Append("<STYLE>")
        body.AppendFormat(".NotifyTable{0}", "{background-color: #033791; font-family: Tahoma, Verdana, Arial; font-size:X-Small;}")
        body.AppendFormat(".HeaderRow{0}", "{background-color: #009900;Text-Align: Center; Color: #FFFFFF; font-weight:Bold;font-size:medium;padding: 3px;}")
        body.AppendFormat(".LabelCell{0}", "{background-color: #77ff99;White-space: nowrap; padding: 5px; font-weight: bold}")
        body.AppendFormat(".DataCell{0}", "{background-color: #ccffcc;Width: 100%; padding: 5px; White-space: nowrap}")
        body.AppendFormat(".InfoCell{0}", "{background-color: #FFFFFF; padding: 5px}")
        body.Append("</STYLE>")
        body.Append("</HEAD>")

        body.Append("<BODY>")
        body.Append("<TABLE Class=""NotifyTable"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">DRG Update Notification</TD></TR>")
        body.AppendFormat("<TR><TD Class=""LabelCell"">To:</TD><TD Class=""DataCell"">{0}</TD></TR>", emailTo)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Client Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.ClientName, package.Study.ClientID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Study Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.StudyName, package.Study.StudyID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Package:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.PackageName, package.PackageID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Files Loaded:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", OriginalFileName, DataFileID)

        'Attach the records of information returned by UpdateDRG SP
        For Each row As DataRow In updateDRGResults.Rows
            body.AppendFormat("<TR><TD Class=""LabelCell"">{0}</TD><TD Class=""DataCell"">{1}</TD></TR>", row("RecordType").ToString, row("RecordsValue").ToString)
        Next

        body.AppendFormat("<TR><TD Class=""InfoCell"" Colspan=""2"">{0}</TD></TR>", message)
        body.Append("</TABLE>")

        body.Append("</BODY>")
        body.Append("</HTML>")

        Return body.ToString

    End Function

#End Region

#Region " Private Shared Methods "

    Private Shared Sub ChangeState(ByVal dataFileID As Integer, ByVal newState As DataFileStates, ByVal stateParameter As String, ByVal memberID As Nullable(Of Integer))

        PackageDB.UpdateFileState(dataFileID, newState, stateParameter, System.Enum.GetName(GetType(DataFileStates), newState), memberID)

    End Sub

#End Region

End Class
