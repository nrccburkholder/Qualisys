Imports Nrc.Framework.Data

Public Class ClientGroupProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ClientGroupProvider

#Region " Private Methods "

    Private Shared Function PopulateClientGroup(ByVal rdr As SafeDataReader) As ClientGroup

        Return PopulateClientGroup(rdr, Nothing)

    End Function

    Private Shared Function PopulateClientGroup(ByVal rdr As SafeDataReader, ByVal childClients As Collection(Of Client)) As ClientGroup

        Dim group As New ClientGroup(childClients)

        ReadOnlyAccessor.ClientGroupID(group) = rdr.GetInteger("ClientGroup_ID")
        With group
            .Name = rdr.GetString("ClientGroup_Nm").Trim
            .ReportName = rdr.GetString("ClientGroupReporting_Nm").Trim
            .IsActive = rdr.GetBoolean("Active")
            .Created = rdr.GetDate("DateCreated")
            .IsAllowAutoSample = rdr.GetBoolean("AllowAutoSample")
            .ResetDirtyFlag()
        End With

        Return group

    End Function

#End Region

#Region " Public Methods "

    Public Overrides Function [Select](ByVal clientGroupID As Integer) As ClientGroup

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientGroup, clientGroupID)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateClientGroup(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectAllClientGroups() As System.Collections.ObjectModel.Collection(Of ClientGroup)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllClientGroups)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ClientGroup)(rdr, AddressOf PopulateClientGroup)
        End Using
    End Function

    Public Overrides Function SelectClientGroupsAndClientsByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)

        'Get the dataset of client groups and clients
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientGroupsAndClientsByUser, userName, showAllClients)
        Dim ds As DataSet = ExecuteDataSet(cmd)

        'Create the relationship between the client group table and the client table
        ds.Relations.Add("ClientGroupClient", ds.Tables(0).Columns("ClientGroup_ID"), ds.Tables(1).Columns("ClientGroup_ID"))

        'Create the client group collection
        Dim groupList As New Collection(Of ClientGroup)

        'Iterate through each client group row
        Using groupRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using groupReader As New SafeDataReader(groupRowReader)
                While groupReader.Read
                    'Create a new client group object and specify what will be the client collection
                    Dim clients As New Collection(Of Client)
                    Dim group As ClientGroup = PopulateClientGroup(groupReader, clients)

                    'Iterate through each client related to the client group row
                    Using clientRowReader As New DataRowReader(groupRowReader.CurrentRow.GetChildRows("ClientGroupClient"))
                        Using clientReader As New SafeDataReader(clientRowReader)
                            While clientReader.Read
                                'Create a new client object and add it to the client collection
                                Dim clnt As Client = ClientProvider.PopulateClient(clientReader, group)
                                clients.Add(clnt)
                            End While
                        End Using
                    End Using

                    'Add the client group to the client group collection
                    groupList.Add(group)
                End While
            End Using
        End Using

        'Return the new client group collection
        Return groupList

    End Function

    Public Overrides Function SelectClientGroupsClientsAndStudiesByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)

        'Get the dataset of client groups, clients, and studies
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientGroupsClientsAndStudiesByUser, userName, showAllClients)
        Dim ds As DataSet = ExecuteDataSet(cmd)

        'Create the relationship between the client group table and the client table
        ds.Relations.Add("ClientGroupClient", ds.Tables(0).Columns("ClientGroup_ID"), ds.Tables(1).Columns("ClientGroup_ID"))

        'Create the relationship between the client table and the study table
        ds.Relations.Add("ClientStudy", ds.Tables(1).Columns("Client_id"), ds.Tables(2).Columns("Client_id"))

        'Create the client group collection
        Dim groupList As New Collection(Of ClientGroup)

        'Iterate through each client group row
        Using groupRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using groupReader As New SafeDataReader(groupRowReader)
                While groupReader.Read
                    'Create a new client group object and specify what will be the client collection
                    Dim clients As New Collection(Of Client)
                    Dim group As ClientGroup = PopulateClientGroup(groupReader, clients)

                    'Iterate through each client related to the client group row
                    Using clientRowReader As New DataRowReader(groupRowReader.CurrentRow.GetChildRows("ClientGroupClient"))
                        Using clientReader As New SafeDataReader(clientRowReader)
                            While clientReader.Read
                                'Create a new client object and specify what will be the study collection
                                Dim studies As New Collection(Of Study)
                                Dim clnt As Client = ClientProvider.PopulateClient(clientReader, group, studies)

                                'Iterate through each study related to the client row
                                Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                                    Using studyReader As New SafeDataReader(studyRowReader)
                                        While studyReader.Read
                                            'Create a new study object and add it to the study collection
                                            Dim stdy As Study = StudyProvider.PopulateStudy(studyReader, clnt)
                                            studies.Add(stdy)
                                        End While
                                    End Using
                                End Using

                                'Add the client to the client collection
                                clients.Add(clnt)
                            End While
                        End Using
                    End Using

                    'Add the client group to the client group collection
                    groupList.Add(group)
                End While
            End Using
        End Using

        'Return the new client group collection
        Return groupList

    End Function

    Public Overrides Function SelectClientGroupsClientsStudiesAndSurveysByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of ClientGroup)

        'Get the dataset of client groups, clients, and studies
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientGroupsClientsStudysAndSurveysByUser, userName, showAllClients)
        Dim ds As DataSet = ExecuteDataSet(cmd)

        'Create the relationship between the client group table and the client table
        ds.Relations.Add("ClientGroupClient", ds.Tables(0).Columns("ClientGroup_ID"), ds.Tables(1).Columns("ClientGroup_ID"))

        'Create the relationship between the client table and the study table
        ds.Relations.Add("ClientStudy", ds.Tables(1).Columns("Client_id"), ds.Tables(2).Columns("Client_id"))

        'Create the relationship between the study table and the survey table
        ds.Relations.Add("StudySurvey", ds.Tables(2).Columns("Study_id"), ds.Tables(3).Columns("Study_id"))

        'Create the client group collection
        Dim groupList As New Collection(Of ClientGroup)

        'Iterate through each client group row
        Using groupRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using groupReader As New SafeDataReader(groupRowReader)
                While groupReader.Read
                    'Create a new client group object and specify what will be the client collection
                    Dim clients As New Collection(Of Client)
                    Dim group As ClientGroup = PopulateClientGroup(groupReader, clients)

                    'Iterate through each client related to the client group row
                    Using clientRowReader As New DataRowReader(groupRowReader.CurrentRow.GetChildRows("ClientGroupClient"))
                        Using clientReader As New SafeDataReader(clientRowReader)
                            While clientReader.Read
                                'Create a new client object and specify what will be the study collection
                                Dim studies As New Collection(Of Study)
                                Dim clnt As Client = ClientProvider.PopulateClient(clientReader, group, studies)

                                'Iterate through each study related to the client row
                                Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                                    Using studyReader As New SafeDataReader(studyRowReader)
                                        While studyReader.Read
                                            'Create a new study object and specify what will be the survey collection
                                            Dim surveys As New Collection(Of Survey)
                                            Dim stdy As Study = StudyProvider.PopulateStudy(studyReader, clnt, surveys)

                                            'Iterate through each survey related to the study row
                                            Using surveyRowReader As New DataRowReader(studyRowReader.CurrentRow.GetChildRows("StudySurvey"))
                                                Using surveyReader As New SafeDataReader(surveyRowReader)
                                                    While surveyReader.Read
                                                        'Create a new survey object and add it to the survey collection
                                                        Dim srvy As Survey = SurveyProvider.PopulateSurvey(surveyReader, stdy)
                                                        surveys.Add(srvy)
                                                    End While
                                                End Using
                                            End Using

                                            'Add the study to the study collection
                                            studies.Add(stdy)
                                        End While
                                    End Using
                                End Using

                                'Add the client to the client collection
                                clients.Add(clnt)
                            End While
                        End Using
                    End Using

                    'Add the client group to the client group collection
                    groupList.Add(group)
                End While
            End Using
        End Using

        'Return the new client group collection
        Return groupList

    End Function

    Public Overrides Function Insert(ByVal name As String, ByVal reportName As String, ByVal isActive As Boolean) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertClientGroup, name, reportName, isActive)
        Dim newId As Integer = ExecuteInteger(cmd)

        Return newId

    End Function

    Public Overrides Sub Delete(ByVal clientGroupID As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteClientGroup, clientGroupID)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Function AllowDelete(ByVal clientGroupID As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowDeleteClientGroup, clientGroupID)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)

    End Function

    Public Overrides Sub Update(ByVal clntGroup As ClientGroup)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateClientGroup, clntGroup.Id, clntGroup.Name, clntGroup.ReportName, clntGroup.IsActive)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
