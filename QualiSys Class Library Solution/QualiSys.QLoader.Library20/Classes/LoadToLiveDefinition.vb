Imports NRC.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.QualiSys.QLoader.Library
Imports Nrc.QualiSys.QLoader.Library.SqlProvider
Imports System.Net.Mail

Public Interface ILoadToLiveDefinition
	Property Id As Integer
End Interface

<Serializable()> _
Public Class LoadToLiveDefinition
	Inherits BusinessBase(Of LoadToLiveDefinition)
	Implements ILoadToLiveDefinition

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDataFileId As Integer
    Private mTableName As String = String.Empty
    Private mFieldName As String = String.Empty
    Private mIsMatchField As Boolean
    Private mDataType As DataTypes

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements ILoadToLiveDefinition.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property DataFileId() As Integer
        Get
            Return mDataFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataFileId Then
                mDataFileId = value
                PropertyHasChanged("DataFileId")
            End If
        End Set
    End Property

    Public Property TableName() As String
        Get
            Return mTableName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTableName Then
                mTableName = value
                PropertyHasChanged("TableName")
            End If
        End Set
    End Property

    Public Property FieldName() As String
        Get
            Return mFieldName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFieldName Then
                mFieldName = value
                PropertyHasChanged("FieldName")
            End If
        End Set
    End Property

    Public Property IsMatchField() As Boolean
        Get
            Return mIsMatchField
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsMatchField Then
                mIsMatchField = value
                PropertyHasChanged("IsMatchField")
            End If
        End Set
    End Property

    Public Property DataType() As DataTypes
        Get
            Return mDataType
        End Get
        Set(ByVal value As DataTypes)
            If Not value = mDataType Then
                mDataType = value
                PropertyHasChanged("DataType")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewLoadToLiveDefinition() As LoadToLiveDefinition

        Return New LoadToLiveDefinition

    End Function

    Public Shared Function [Get](ByVal id As Integer) As LoadToLiveDefinition

        Return LoadToLiveDefinitionProvider.Instance.SelectLoadToLiveDefinition(id)

    End Function

    Public Shared Function GetAll() As LoadToLiveDefinitionCollection

        Return LoadToLiveDefinitionProvider.Instance.SelectAllLoadToLiveDefinitions()

    End Function

    Public Shared Function GetByDataFileID(ByVal dataFileID As Integer) As LoadToLiveDefinitionCollection

        Return LoadToLiveDefinitionProvider.Instance.SelectLoadToLiveDefinitionsByDataFileID(dataFileID)

    End Function

    Public Shared Function LoadToLiveDuplicateCheck(ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage, ByVal definitions As LoadToLiveDefinitionCollection) As DataTable

        Return LoadToLiveDefinitionProvider.Instance.LoadToLiveDuplicateCheck(dataFileID, tableName, package, definitions)

    End Function

    Public Shared Function LoadToLiveDuplicateCheckAllTables(ByVal dataFileID As Integer, ByVal package As DTSPackage) As Boolean

        'Get the load to live definitions for this file
        Dim definitions As LoadToLiveDefinitionCollection = LoadToLiveDefinition.GetByDataFileID(dataFileID)

        'Get the tables to be checked
        Dim tableNames As List(Of String) = definitions.GetTableList

        'Loop through all tables and check for duplicates
        For Each tableName As String In tableNames
            'Check this table for duplicates
            Dim duplicatesTable As DataTable = LoadToLiveDefinition.LoadToLiveDuplicateCheck(dataFileID, tableName, package, definitions)

            'If duplicates exist then return false
            If duplicatesTable.Rows.Count > 0 Then
                Return False
            End If
        Next

        'If we made it to here then all of the tables passed the dup check
        Return True

    End Function

    Public Shared Sub LoadToLiveDeleteDuplicate(ByVal row As DataRow, ByVal dataFileID As Integer, ByVal tableName As String, ByVal package As DTSPackage)

        LoadToLiveDefinitionProvider.Instance.LoadToLiveDeleteDuplicate(row, dataFileID, tableName, package)

    End Sub

    Public Shared Sub LoadToLiveUpdate(ByVal dataFileID As Integer, ByVal package As DTSPackage)

        Dim qualisysRecCount As Integer
        Dim datamartRecCount As Integer
        Dim catalystRecCount As Integer
        Dim counts As New List(Of LoadToLiveCount)

        'Get the load to live definitions for this table
        Dim definitions As LoadToLiveDefinitionCollection = LoadToLiveDefinition.GetByDataFileID(dataFileID)

        'Get the tables to be checked
        Dim tableNames As List(Of String) = definitions.GetTableList

        'Loop through all of the tables and run the update
        For Each tableName As String In tableNames
            'Update this table
            LoadToLiveDefinitionProvider.Instance.LoadToLiveUpdate(dataFileID, tableName, package, definitions, qualisysRecCount, datamartRecCount, catalystRecCount)

            'Populate the counts
            counts.Add(New LoadToLiveCount(tableName, qualisysRecCount, datamartRecCount, catalystRecCount, definitions.GetUpdateFieldsByTableName(tableName)))
        Next

        'Send the notification
        NotifyUpdate(dataFileID, package, counts)

    End Sub

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        Id = LoadToLiveDefinitionProvider.Instance.InsertLoadToLiveDefinition(Me)

    End Sub

    Protected Overrides Sub Update()

        LoadToLiveDefinitionProvider.Instance.UpdateLoadToLiveDefinition(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        LoadToLiveDefinitionProvider.Instance.DeleteLoadToLiveDefinition(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

    Private Shared Sub NotifyUpdate(ByVal dataFileID As Integer, ByVal package As DTSPackage, ByVal counts As List(Of LoadToLiveCount))

        Dim packageOwner As NRCAuthLib.Member
        If package.OwnerMemberID.HasValue Then
            packageOwner = Nrc.NRCAuthLib.Member.GetMember(package.OwnerMemberID.Value)
        Else
            packageOwner = Nothing
        End If

        Dim lastUserMemberID As Nullable(Of Integer) = GetLastUserMemberID(dataFileID)
        Dim currentUser As Nrc.NRCAuthLib.Member
        If lastUserMemberID.HasValue Then
            currentUser = Nrc.NRCAuthLib.Member.GetMember(lastUserMemberID.Value)
        Else
            currentUser = Nothing
        End If

        Dim recepients As New MailAddressCollection

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

        Dim mailMsg As New MailMessage()

        If AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            For Each address As MailAddress In recepients
                mailMsg.To.Add(address)
            Next
        Else
            mailMsg.To.Add(AppConfig.Params("QLPackageOwnersEmailGroup").StringValue)
            If currentUser IsNot Nothing Then
                mailMsg.To.Add(currentUser.EmailAddress)
            End If
        End If

        Dim body As String = ToHtml(dataFileID, package, recepients.ToString, counts)

        mailMsg.From = New MailAddress(AppConfig.Params("ClientSupportEmailAddress").StringValue)
        mailMsg.Subject = String.Format("Load To Live Complete ({0})", package.Study.ClientName)
        If Not AppConfig.EnvironmentType = EnvironmentTypes.Production Then
            mailMsg.Subject &= String.Format(" ({0})", System.Enum.GetName(GetType(EnvironmentTypes), AppConfig.EnvironmentType))
        End If

        mailMsg.Body = body
        mailMsg.IsBodyHtml = True

        'Add some error handling in case email can't be sent.
        'Give better error message.
        Try
            Dim smtpServer As SmtpClient = New SmtpClient(AppConfig.SMTPServer)
            smtpServer.Send(mailMsg)

        Catch ex As Exception
            Dim msg As String = String.Format("Notification/Mail Failure: {0}", vbCrLf)
            If Not mailMsg Is Nothing Then
                msg &= String.Format("To: {0}{1}", mailMsg.To, vbCrLf)
                msg &= String.Format("From: {0}{1}", mailMsg.From, vbCrLf)
                msg &= String.Format("Subject: {0}{1}", mailMsg.Subject, vbCrLf)
                msg &= ex.Message
            End If
            Throw New ApplicationException(msg, ex)

        End Try

    End Sub

    Private Shared Function ToHtml(ByVal dataFileID As Integer, ByVal package As DTSPackage, ByVal emailTo As String, ByVal counts As List(Of LoadToLiveCount)) As String

        Dim body As New Text.StringBuilder

        Dim message As String = String.Format("The listed file has updated applicable QualiSys and DataMart tables and has been unloaded.<BR><BR>For more information, please contact the <a href=""mailto:{0}"">Client Support Group</a>.", AppConfig.Params("ClientSupportEmailAddress").StringValue)

        Dim file As New DataFile
        file.LoadFromDB(dataFileID)

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
        body.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">Load To Live Update Notification</TD></TR>")
        body.AppendFormat("<TR><TD Class=""LabelCell"">To:</TD><TD Class=""DataCell"">{0}</TD></TR>", emailTo)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Client Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.ClientName, package.Study.ClientID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Study Name:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.Study.StudyName, package.Study.StudyID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">Package:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", package.PackageName, package.PackageID)
        body.AppendFormat("<TR><TD Class=""LabelCell"">File Loaded:</TD><TD Class=""DataCell"">{0} ({1})</TD></TR>", file.OriginalFileName, dataFileID)

        'File list table
        body.Append("<TR><TD Class=""HeaderRow"" Colspan=""2"">Load To Live Results</TD></TR>")
        body.Append("<TR><TD Class=""InfoCell"" Colspan=""2""><TABLE Class=""NotifyTable"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">")
        body.Append("<TR><TD Class=""LabelCell"">Table Name</TD><TD Class=""LabelCell"">QualiSys Records</TD><TD Class=""LabelCell"">DataMart Records</TD><TD Class=""LabelCell"">Columns Updated</TD></TR>")

        'Attach the records of information returned by UpdateDRG SP
        For Each count As LoadToLiveCount In counts
            body.AppendFormat("<TR><TD Class=""DataCell"">{0}</TD><TD Class=""DataCell"">{1}</TD><TD Class=""DataCell"">{2}</TD><TD Class=""DataCell"">{3}</TD></TR>", count.TableName, count.QualiSysRecCount, count.DataMartRecCount, String.Join(", ", count.UpdateFields.ToArray))
        Next
        body.Append("</TABLE></TD></TR>")

        body.AppendFormat("<TR><TD Class=""InfoCell"" Colspan=""2"">{0}</TD></TR>", message)
        body.Append("</TABLE>")

        body.Append("</BODY>")
        body.Append("</HTML>")

        Return body.ToString

    End Function

    Private Shared Function GetLastUserMemberID(ByVal dataFileID As Integer) As Nullable(Of Integer)

        Return PackageDB.GetLastUserMemberID(dataFileID)

    End Function

#End Region

End Class


