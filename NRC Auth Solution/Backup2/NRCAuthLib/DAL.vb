Imports NRC.Data

Friend Class DAL

    Private Shared ReadOnly Property NRCAuthCon() As String
        Get
            Return AppConfig.Instance.NRCAuthConnection
        End Get
    End Property
    Private Shared ReadOnly Property DataMartCon() As String
        Get
            Return AppConfig.Instance.DataMartConnection
        End Get
    End Property
    Private Shared ReadOnly Property Today() As Date
        Get
            Return Date.Parse(Date.Now.ToShortDateString)
        End Get
    End Property

#Region " SP Declarations "
    Private Class SP
        Public Const ClientList As String = "Auth_ClientList"
        Public Const DeleteGroupMember As String = "Auth_DeleteGroupMember"
        Public Const DocumentUsage As String = "Auth_DocumentUsage"
        Public Const InsertApplication As String = "Auth_InsertApplication"
        Public Const InsertGroup As String = "Auth_InsertGroup"
        Public Const InsertGroupPrivilege As String = "Auth_InsertGroupPrivilege"
        Public Const InsertGroupsMember As String = "Auth_InsertGroupsMember"
        Public Const InsertMember As String = "Auth_InsertMember"
        Public Const InsertMemberPrivilege As String = "Auth_InsertMemberPrivilege"
        Public Const InsertNRCMembers As String = "Auth_InsertNRCMembers"
        Public Const InsertOrgUnit As String = "Auth_InsertOrgUnit"
        Public Const InsertOrgUnitPrivilege As String = "Auth_InsertOrgUnitPrivilege"
        Public Const InsertPrivilege As String = "Auth_InsertPrivilege"
        Public Const LogSignInFailure As String = "Auth_LogSignInFailure"
        Public Const LogSignInSuccess As String = "Auth_LogSignInSuccess"
        Public Const LogWebEvent As String = "Auth_LogWebEvent"
        Public Const LogWebException As String = "Auth_LogWebException"
        Public Const RetireGroup As String = "Auth_RetireGroup"
        Public Const RetireMember As String = "Auth_RetireMember"
        Public Const RevokeOrgUnitPrivilege As String = "Auth_RevokeOrgUnitPrivilege"
        Public Const Rights As String = "Auth_Rights"
        Public Const SelectApplication As String = "Auth_SelectApplication"
        Public Const SelectAllApplications As String = "Auth_SelectAllApplications"
        Public Const SelectGroupApplications As String = "Auth_SelectGroupApplications"
        Public Const SelectGroupMembers As String = "Auth_SelectGroupMembers"
        Public Const SelectMembers As String = "Auth_SelectMembers"
        Public Const SelectMembersByEmailAddress As String = "Auth_SelectMembersByEmailAddress"
        Public Const SelectGroups As String = "Auth_SelectGroups"
        Public Const SelectGroupsbyName As String = "Auth_SelectGroupsbyName"
        Public Const SelectMember As String = "Auth_SelectMember"
        Public Const SelectMemberById As String = "Auth_SelectMemberInfo"
        Public Const SelectMemberApplications As String = "Auth_SelectMemberApplications"
        Public Const SelectMemberGroups As String = "Auth_SelectMemberGroups"
        Public Const SelectNRCMember As String = "Auth_SelectNRCMember"
        Public Const SelectOrgUnit As String = "Auth_SelectOrgUnit"
        Public Const SelectOrgUnitApplications As String = "Auth_SelectOrgUnitApplications"
        Public Const SelectOrgUnitChildren As String = "Auth_SelectOrgUnitChildren"
        Public Const SelectOrgUnitGroups As String = "Auth_SelectOrgUnitGroups"
        Public Const SelectOrgUnitMembers As String = "Auth_SelectOrgUnitMembers"
        Public Const SelectSecretQuestionList As String = "Auth_SelectSecretQuestionList"
        Public Const UpdateApplication As String = "Auth_UpdateApplication"
        Public Const UpdateGroup As String = "Auth_UpdateGroup"
        Public Const UpdateGroupPrivilege As String = "Auth_UpdateGroupPrivilege"
        Public Const UpdateGroupsRights As String = "Auth_UpdateGroupsRights"
        Public Const UpdateMemberPrivilege As String = "Auth_UpdateMemberPrivilege"
        Public Const UpdateMemberRetireDate As String = "Auth_UpdateMemberRetireDate"
        Public Const UpdateMemberType As String = "Auth_UpdateMemberType"
        Public Const UpdateOrgUnit As String = "Auth_UpdateOrgUnit"
        Public Const UpdateOrgUnitRights As String = "Auth_UpdateOrgUnitRights"
        Public Const UpdatePassword As String = "Auth_UpdatePassword"
        Public Const UpdatePrivilege As String = "Auth_UpdatePrivilege"
        Public Const UpdateProfile As String = "Auth_UpdateProfile"
        Public Const UpdateSecretQuestion As String = "Auth_UpdateSecretQuestion"
        Public Const UserNameExists As String = "Auth_UserNameExists"
    End Class
#End Region

#Region " Member Procs "
    Public Shared Function InsertMember(ByVal creatorMemberId As Integer, ByVal orgUnitId As Integer, ByVal userName As String, ByVal eMail As String, ByVal passwordHash As String, ByVal passwordSalt As String, ByVal memberType As Member.MemberTypeEnum) As Integer
        Return CType(SqlHelper.ExecuteScalar(NRCAuthCon, SP.InsertMember, creatorMemberId, orgUnitId, userName, eMail, passwordHash, passwordSalt, memberType, Member.PASSWORD_EXPIRES_DAYS), Integer)
    End Function

    Public Shared Sub UpdateSecretQuestion(ByVal memberId As Integer, ByVal secretQuestionId As Integer, ByVal secretAnswerHash As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateSecretQuestion, memberId, secretQuestionId, secretAnswerHash, authorId)
    End Sub

    Public Shared Function UpdatePassword(ByVal memberId As Integer, ByVal passwordHash As String, ByVal isReset As Boolean, ByVal authorId As Integer) As Boolean
        Return CType(SqlHelper.ExecuteScalar(NRCAuthCon, SP.UpdatePassword, memberId, passwordHash, isReset, authorId), Boolean)
    End Function

    Public Shared Sub UpdateProfile(ByVal memberId As Integer, ByVal firstName As String, ByVal lastName As String, ByVal email As String, ByVal facility As String, ByVal title As String, ByVal phone As String, ByVal city As String, ByVal state As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateProfile, memberId, firstName, lastName, email, title, phone, city, state, facility, authorId)
    End Sub

    Public Shared Sub RetireMember(ByVal memberId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.RetireMember, memberId, DBNull.Value, authorId)
    End Sub

    Public Shared Sub RetireMember(ByVal memberId As Integer, ByVal retireDate As Date, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.RetireMember, memberId, retireDate, authorId)
    End Sub

    Public Shared Sub UpdateNTLogin(ByVal memberId As Integer, ByVal ntLogin As String)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertNRCMembers, memberId, ntLogin)
    End Sub

    Public Shared Sub UpdateRetireDate(ByVal memberId As Integer, ByVal retireDate As Date, ByVal authorMemberId As Integer)
        Dim retireValue As Object = retireDate
        If retireDate = Date.MinValue Then
            retireValue = DBNull.Value
        End If
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateMemberRetireDate, memberId, retireValue, authorMemberId)
    End Sub

    Public Shared Function UserNameExists(ByVal userName As String) As Boolean
        Return CType(SqlHelper.ExecuteScalar(NRCAuthCon, SP.UserNameExists, userName), Boolean)
    End Function

    Public Shared Function SelectMember(ByVal userName As String) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectMember, userName)
    End Function

    Public Shared Function SelectMember(ByVal memberId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectMemberById, memberId)
    End Function

    Public Shared Function SelectNTMember(ByVal NTLoginName As String) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectNRCMember, NTLoginName)
    End Function

    Public Shared Function SelectOrgUnitMembers(ByVal orgUnitId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectOrgUnitMembers, orgUnitId)
    End Function

    Public Shared Sub UpdateMemberType(ByVal memberId As Integer, ByVal memberType As Member.MemberTypeEnum, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateMemberType, memberId, memberType, authorId)
    End Sub

    'Temporary code for hashing passwords already in the database
    'Public Shared Sub SetPassword(ByVal memberId As Integer, ByVal passwordHash As String, ByVal salt As String)
    '    Dim sql As String
    '    sql = "UPDATE Member SET strPassword = '{0}', datPasswordChanged = GETDATE(), SaltValue = '{1}' WHERE Member_id = {2}"
    '    sql = String.Format(sql, passwordHash, salt, memberId)

    '    SqlHelper.ExecuteNonQuery(NRCAuthCon, CommandType.Text, sql)
    'End Sub

#End Region

#Region " OrgUnit Procs "
    Public Shared Function SelectOrgUnit(ByVal orgUnitId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectOrgUnit, orgUnitId, False)
    End Function

    Public Shared Function SelectOrgUnitTree(ByVal orgUnitId As Integer) As DataSet
        Return SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectOrgUnit, orgUnitId, True)
    End Function


    Public Shared Function SelectOrgUnitChildren(ByVal orgUnitId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectOrgUnitChildren, orgUnitId)
    End Function

    Public Shared Function InsertOrgUnit(ByVal name As String, ByVal description As String, ByVal orgUnitType As Integer, ByVal parentOrgUnitId As Integer, ByVal QPClientId As Integer, ByVal authorId As Integer) As Integer
        Return CType(SqlHelper.ExecuteScalar(NRCAuthCon, SP.InsertOrgUnit, name, description, orgUnitType, parentOrgUnitId, authorId, QPClientId), Integer)
    End Function

    Public Shared Sub UpdateOrgUnit(ByVal orgUnitId As Integer, ByVal name As String, ByVal description As String, ByVal orgUnitType As Integer, ByVal parentOrgUnitId As Integer, ByVal isActive As Boolean, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateOrgUnit, orgUnitId, name, description, orgUnitType, parentOrgUnitId, isActive, authorId)
    End Sub


#End Region

#Region " Privilege Procs "
    Public Shared Sub InsertMemberPrivilege(ByVal memberId As Integer, ByVal OuPrivilegeId As Integer, ByVal dateRevoked As Date, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertMemberPrivilege, memberId, OuPrivilegeId, authorId, Today, dateRevoked.Date)
    End Sub

    Public Shared Sub InsertMemberPrivilege(ByVal memberId As Integer, ByVal OuPrivilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertMemberPrivilege, memberId, OuPrivilegeId, authorId, Today, DBNull.Value)
    End Sub

    Public Shared Sub InsertGroupPrivilege(ByVal groupId As Integer, ByVal OuPrivilegeId As Integer, ByVal dateRevoked As Date, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertGroupPrivilege, groupId, OuPrivilegeId, authorId, Today, dateRevoked.Date)
    End Sub

    Public Shared Sub InsertGroupPrivilege(ByVal groupId As Integer, ByVal OuPrivilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertGroupPrivilege, groupId, OuPrivilegeId, authorId, Today, DBNull.Value)
    End Sub

    Public Shared Sub InsertOrgUnitPrivilege(ByVal orgUnitId As Integer, ByVal privilegeId As Integer, ByVal dateRevoked As Date, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertOrgUnitPrivilege, orgUnitId, privilegeId, dateRevoked.Date, authorId)
    End Sub

    Public Shared Sub InsertOrgUnitPrivilege(ByVal orgUnitId As Integer, ByVal privilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertOrgUnitPrivilege, orgUnitId, privilegeId, DBNull.Value, authorId)
    End Sub

    Public Shared Sub DeleteMemberPrivilege(ByVal memberPrivilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateMemberPrivilege, memberPrivilegeId, authorId, Today)
    End Sub

    Public Shared Sub DeleteOrgUnitPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.RevokeOrgUnitPrivilege, orgUnitPrivilegeId, authorId)
    End Sub

    Public Shared Sub DeleteGroupPrivilege(ByVal groupPrivilegeId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateGroupPrivilege, groupPrivilegeId, authorId, Today)
    End Sub

    Public Shared Function InsertPrivilege(ByVal applicationId As Integer, ByVal name As String, ByVal description As String, ByVal privilegeLevel As Privilege.PrivilegeLevelEnum, ByVal authorId As Integer) As Integer
        Dim newId As Integer = CInt(SqlHelper.ExecuteScalar(NRCAuthCon, SP.InsertPrivilege, applicationId, name, description, privilegeLevel, authorId))
        If newId < 0 Then
            Throw New Exception("The privilege could not be inserted")
        End If

        Return newId
    End Function

    Public Shared Sub UpdatePrivilege(ByVal privilegeId As Integer, ByVal name As String, ByVal description As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdatePrivilege, privilegeId, name, description, authorId)
    End Sub

#End Region

#Region " Application Procs "
    Public Shared Function SelectApplication(ByVal applicationId As Integer) As DataSet
        Dim ds As DataSet
        ds = SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectApplication, applicationId)
        ds.Relations.Add("AppPrivilege", ds.Tables(0).Columns("Application_id"), ds.Tables(1).Columns("Application_id"))
        Return ds
    End Function
    Public Shared Function SelectApplications() As DataSet
        Dim ds As DataSet
        ds = SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectAllApplications)
        ds.Relations.Add("AppPrivilege", ds.Tables(0).Columns("Application_id"), ds.Tables(1).Columns("Application_id"))
        Return ds
    End Function

    Public Shared Function SelectOrgUnitApplications(ByVal orgUnitId As Integer) As DataSet
        Dim ds As DataSet
        ds = SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectOrgUnitApplications, orgUnitId)
        ds.Relations.Add("AppPrivilege", ds.Tables(0).Columns("Application_id"), ds.Tables(1).Columns("Application_id"))
        Return ds
    End Function

    Public Shared Function SelectGroupApplications(ByVal groupId As Integer) As DataSet
        Dim ds As DataSet
        ds = SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectGroupApplications, groupId)
        ds.Relations.Add("AppPrivilege", ds.Tables(0).Columns("Application_id"), ds.Tables(1).Columns("Application_id"))
        Return ds
    End Function
    Public Shared Function SelectMemberApplications(ByVal memberId As Integer) As DataSet
        Dim ds As DataSet
        ds = SqlHelper.ExecuteDataset(NRCAuthCon, SP.SelectMemberApplications, memberId)
        ds.Relations.Add("AppPrivilege", ds.Tables(0).Columns("Application_id"), ds.Tables(1).Columns("Application_id"))
        Return ds
    End Function


    Public Shared Function InsertApplication(ByVal name As String, ByVal description As String, ByVal isInternal As Boolean, ByVal authorId As Integer, ByVal appDeploymentType As DeploymentType, ByVal path As String, ByVal imageData As Byte(), ByVal categoryName As String) As Integer
        Dim newId As Integer = CInt(SqlHelper.ExecuteScalar(NRCAuthCon, SP.InsertApplication, name, description, isInternal, authorId, CType(appDeploymentType, Integer), path, imageData, categoryName))
        If newId < 0 Then
            Throw New Exception("The application could not be inserted.")
        End If

        Return newId
    End Function

    Public Shared Sub UpdateApplication(ByVal applicationId As Integer, ByVal name As String, ByVal description As String, ByVal isInternal As Boolean, ByVal authorId As Integer, ByVal appDeploymentType As DeploymentType, ByVal path As String, ByVal imageData As Byte(), ByVal categoryName As String)
        Dim result As Integer = CInt(SqlHelper.ExecuteScalar(NRCAuthCon, SP.UpdateApplication, applicationId, name, description, isInternal, authorId, CType(appDeploymentType, Integer), path, imageData, categoryName))
        If result < 0 Then
            Throw New Exception("The application could not be updated.")
        End If
    End Sub
#End Region

#Region " Group Procs "
    Public Shared Function SelectGroup(ByVal groupId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectGroups, groupId)
    End Function

    Public Shared Function SelectGroup(ByVal groupName As String, ByVal orgUnitID As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectGroupsbyName, groupName, orgUnitID)
    End Function

    Public Shared Function SelectOrgUnitGroups(ByVal orgUnitId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectOrgUnitGroups, orgUnitId)
    End Function

    Public Shared Function SelectGroupMembers(ByVal groupId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectGroupMembers, groupId)
    End Function

    Public Shared Function SelectMembers(ByVal memberIds As String) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectMembers, memberIds)
    End Function

    ''' <summary>Get a collection of usernames associated with the provided email
    ''' address</summary>
    ''' <remarks>if email address parameter contains a single apostraphe, this function
    ''' will send the SP two apostraphes.</remarks>
    ''' <param name="emailAddress"></param>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK - 8/24/2008 - Initial Creation </revision>
    Public Shared Function SelectMembersByEmailAddress(ByVal emailAddress As String) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectMembersByEmailAddress, emailAddress.Replace("'", "''"))
    End Function

    Public Shared Function SelectMemberGroups(ByVal memberId As Integer) As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectMemberGroups, memberId)
    End Function

    Public Shared Function InsertGroup(ByVal orgUnitId As Integer, ByVal groupName As String, ByVal description As String, ByVal email As String, ByVal authorId As Integer) As Integer
        Return CType(SqlHelper.ExecuteScalar(NRCAuthCon, SP.InsertGroup, orgUnitId, groupName, description, email, authorId), Integer)
    End Function

    Public Shared Sub InsertGroupMember(ByVal groupId As Integer, ByVal memberId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.InsertGroupsMember, groupId, memberId, authorId)
    End Sub

    Public Shared Sub UpdateGroup(ByVal groupId As Integer, ByVal groupName As String, ByVal Description As String, ByVal email As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.UpdateGroup, groupId, groupName, Description, email, authorId)
    End Sub

    Public Shared Sub DeleteGroup(ByVal groupId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.RetireGroup, groupId, authorId)
    End Sub

    Public Shared Sub DeleteGroupMember(ByVal groupId As Integer, ByVal memberId As Integer, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.DeleteGroupMember, groupId, memberId, authorId)
    End Sub

#End Region

#Region " Security Log Procs "

    Public Shared Sub LogWebEvent(ByVal userName As String, ByVal sessionId As String, ByVal applicationName As String, ByVal pageName As String, ByVal eventType As String, ByVal eventData As String)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.LogWebEvent, userName, sessionId, applicationName, pageName, eventType, eventData)
    End Sub

    Public Shared Sub LogWebException(ByVal userName As String, ByVal sessionId As String, ByVal applicationName As String, ByVal urlPath As String, ByVal pageName As String, ByVal isHandled As Boolean, ByVal message As String, ByVal exceptionType As String, ByVal stackTrace As String)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.LogWebException, userName, sessionId, applicationName, urlPath, pageName, isHandled, message, exceptionType, stackTrace)
    End Sub

    Public Shared Sub LogDocumentDownload(ByVal memberId As Integer, ByVal documentId As Integer, ByVal documentNodeId As Integer)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.DocumentUsage, documentId, memberId, documentNodeId)
    End Sub

    Public Shared Sub LogSignInSuccess(ByVal userName As String, ByVal sessionId As String, ByVal ipAddress As String, ByVal browserType As String, ByVal browserVersion As String, ByVal userAgent As String, ByVal applicationName As String, ByVal host As String, ByVal machineName As String, ByVal UrlPath As String)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.LogSignInSuccess, userName, sessionId, ipAddress, browserType, browserVersion, userAgent, applicationName, host, machineName, UrlPath)
    End Sub

    Public Shared Sub LogSignInFailure(ByVal userName As String, ByVal sessionId As String, ByVal ipAddress As String, ByVal browserType As String, ByVal browserVersion As String, ByVal userAgent As String, ByVal applicationName As String, ByVal host As String, ByVal machineName As String, ByVal UrlPath As String)
        SqlHelper.ExecuteNonQuery(NRCAuthCon, SP.LogSignInFailure, userName, sessionId, ipAddress, browserType, browserVersion, userAgent, applicationName, host, machineName, UrlPath)
    End Sub

#End Region

#Region " Lookup Lists "
    Public Shared Function SelectSecretQuestionList() As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.SelectSecretQuestionList)
    End Function

#End Region

#Region " Survey Results Procs "
    Public Shared Function SelectGroupSurveyResultsAccessTree(ByVal orgUnitId As Integer, ByVal parentOrgUnitId As Integer, ByVal groupId As Integer) As DataSet
        Return SqlHelper.ExecuteDataset(DataMartCon, SP.Rights, orgUnitId, parentOrgUnitId, groupId)
    End Function
    Public Shared Function SelectOrgUnitSurveyResultsAccessTree(ByVal orgUnitId As Integer, ByVal parentOrgUnitId As Integer) As DataSet
        Return SqlHelper.ExecuteDataset(DataMartCon, SP.Rights, orgUnitId, parentOrgUnitId, DBNull.Value)
    End Function
    Public Shared Sub UpdateOrgUnitSurveyResultsAccess(ByVal orgUnitId As Integer, ByVal selectedNodes As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(DataMartCon, SP.UpdateOrgUnitRights, authorId, orgUnitId, selectedNodes)
    End Sub
    Public Shared Sub UpdateGroupSurveyResultsAccess(ByVal groupId As Integer, ByVal orgUnitId As Integer, ByVal selectedNodes As String, ByVal authorId As Integer)
        SqlHelper.ExecuteNonQuery(DataMartCon, SP.UpdateGroupsRights, authorId, groupId, orgUnitId, selectedNodes)
    End Sub
#End Region

#Region " Client Procs "
    Public Shared Function SelectClientList() As IDataReader
        Return SqlHelper.ExecuteReader(NRCAuthCon, SP.ClientList)
    End Function

#End Region

End Class
