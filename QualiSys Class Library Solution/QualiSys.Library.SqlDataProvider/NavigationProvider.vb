Imports Nrc.QualiSys.Library.Navigation
Imports Nrc.Framework.Data

Public Class NavigationProvider
    Inherits Nrc.QualiSys.Library.DataProvider.NavigationProvider

#Region " Population Methods "

    Private Shared Function PopulateClientGroup(ByVal rdr As SafeDataReader, ByVal navTree As NavigationTree) As Navigation.ClientGroupNavNode

        Dim group As New Navigation.ClientGroupNavNode(navTree)

        group.Id = rdr.GetInteger("ClientGroup_ID")
        group.Name = rdr.GetString("ClientGroup_Nm").Trim
        group.IsActive = rdr.GetBoolean("Active")

        Return group

    End Function

    Private Shared Function PopulateClient(ByVal rdr As SafeDataReader, ByVal navTree As NavigationTree) As Navigation.ClientNavNode

        Dim clnt As New Navigation.ClientNavNode(navTree)

        clnt.Id = rdr.GetInteger("Client_id")
        clnt.Name = rdr.GetString("strClient_nm").Trim
        clnt.IsActive = rdr.GetBoolean("Active")

        Return clnt

    End Function

    Private Shared Function PopulateClient(ByVal rdr As SafeDataReader, ByVal group As Navigation.ClientGroupNavNode) As Navigation.ClientNavNode

        Dim clnt As New Navigation.ClientNavNode(group)

        clnt.Id = rdr.GetInteger("Client_id")
        clnt.Name = rdr.GetString("strClient_nm").Trim
        clnt.IsActive = rdr.GetBoolean("Active")

        Return clnt

    End Function

    Private Shared Function PopulateStudy(ByVal rdr As SafeDataReader, ByVal clnt As Navigation.ClientNavNode) As Navigation.StudyNavNode

        Dim stdy As New Navigation.StudyNavNode(clnt)

        stdy.Id = rdr.GetInteger("Study_id")
        stdy.Name = rdr.GetString("strStudy_nm").Trim
        stdy.IsActive = rdr.GetBoolean("Active")

        Return stdy

    End Function

    Private Shared Function PopulateSurvey(ByVal rdr As SafeDataReader, ByVal stdy As Navigation.StudyNavNode) As Navigation.SurveyNavNode

        Dim srvy As New Navigation.SurveyNavNode(stdy)

        srvy.Id = rdr.GetInteger("Survey_id")
        srvy.Name = rdr.GetString("strSurvey_nm").Trim
        srvy.IsValidated = rdr.GetBoolean("bitValidated_flg")
        srvy.SurveyType = CType(rdr.GetInteger("SurveyType_id"), SurveyTypes)
        srvy.IsActive = rdr.GetBoolean("Active")

        Return srvy

    End Function

#End Region

#Region " Public Methods "

    Public Overloads Overrides Function GetNavigationTreeByUser(ByVal userName As String, ByVal initialDepth As Navigation.InitialPopulationDepth, ByVal includeGroups As Boolean) As Navigation.NavigationTree

        Dim cmd As DbCommand

        'Determine the population depth required
        Dim depth As Integer = GetPopulationDepth(initialDepth)

        'Get the stored prcedure to be used
        If includeGroups Then
            cmd = Db.GetStoredProcCommand(SP.SelectClientGroupsClientsStudysAndSurveysByUser, userName, True)
        Else
            cmd = Db.GetStoredProcCommand(SP.SelectClientsStudysAndSurveysByUser, userName, True)
        End If

        'Populate the tree as specified
        Using ds As DataSet = ExecuteDataSet(cmd)
            'Define the relationships for the data tables
            DefineRelations(ds, depth, includeGroups)

            If includeGroups Then
                Return PopulateTreeFromClientGroup(depth, ds)
            Else
                Return PopulateTreeFromClient(depth, ds)
            End If
        End Using

    End Function

#End Region

#Region " Private Methods "

    Private Function PopulateTreeFromClient(ByVal depth As Integer, ByVal ds As DataSet) As Navigation.NavigationTree

        'Create a navigation tree object
        Dim tree As New NavigationTree

        'Iterate through each client
        Using clientRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using clientReader As New SafeDataReader(clientRowReader)
                While clientReader.Read
                    'Create a new client object and specify its parent
                    Dim clnt As Navigation.ClientNavNode = PopulateClient(clientReader, tree)

                    'If we are loading studies then proceed
                    If depth > 1 Then
                        'Iterate through each study related to the client row
                        Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                            Using studyReader As New SafeDataReader(studyRowReader)
                                While studyReader.Read
                                    'Create a new study object and specify its parent
                                    Dim stdy As Navigation.StudyNavNode = PopulateStudy(studyReader, clnt)

                                    'If we are loading surveys then proceed
                                    If depth > 2 Then
                                        'Iterate through each survey related to the study row
                                        Using surveyRowReader As New DataRowReader(studyRowReader.CurrentRow.GetChildRows("StudySurvey"))
                                            Using surveyReader As New SafeDataReader(surveyRowReader)
                                                While surveyReader.Read
                                                    'Create a new survey object and specify its parent
                                                    Dim srvy As Navigation.SurveyNavNode = PopulateSurvey(surveyReader, stdy)

                                                    'Add the survey object to the collection
                                                    stdy.Surveys.Add(srvy)
                                                End While
                                            End Using
                                        End Using
                                    End If

                                    'Add the study object to the collection
                                    clnt.Studies.Add(stdy)
                                End While
                            End Using
                        End Using
                    End If

                    'Add the client object to the collection
                    tree.Clients.Add(clnt)
                End While
            End Using
        End Using

        'Return the populated navigation tree
        Return tree

    End Function

    Private Function PopulateTreeFromClientGroup(ByVal depth As Integer, ByVal ds As DataSet) As Navigation.NavigationTree

        'Create a navigation tree object
        Dim tree As New NavigationTree

        'Iterate through each client group
        Using groupRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using groupReader As New SafeDataReader(groupRowReader)
                While groupReader.Read
                    'Create a new client group object and specify its parent
                    Dim group As Navigation.ClientGroupNavNode = PopulateClientGroup(groupReader, tree)

                    'If we are loading clients then proceed
                    If depth > 0 Then
                        'Iterate through each client related to the client group row
                        Using clientRowReader As New DataRowReader(groupRowReader.CurrentRow.GetChildRows("ClientGroupClient"))
                            Using clientReader As New SafeDataReader(clientRowReader)
                                While clientReader.Read
                                    'Create a new client object and specify its parent
                                    Dim clnt As Navigation.ClientNavNode = PopulateClient(clientReader, group)

                                    'If we are loading studies then proceed
                                    If depth > 1 Then
                                        'Iterate through each study related to the client row
                                        Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                                            Using studyReader As New SafeDataReader(studyRowReader)
                                                While studyReader.Read
                                                    'Create a new study object and specify its parent
                                                    Dim stdy As Navigation.StudyNavNode = PopulateStudy(studyReader, clnt)

                                                    'If we are loading surveys then proceed
                                                    If depth > 2 Then
                                                        'Iterate through each survey related to the study row
                                                        Using surveyRowReader As New DataRowReader(studyRowReader.CurrentRow.GetChildRows("StudySurvey"))
                                                            Using surveyReader As New SafeDataReader(surveyRowReader)
                                                                While surveyReader.Read
                                                                    'Create a new survey object and specify its parent
                                                                    Dim srvy As Navigation.SurveyNavNode = PopulateSurvey(surveyReader, stdy)

                                                                    'Add the survey object to the collection
                                                                    stdy.Surveys.Add(srvy)
                                                                End While
                                                            End Using
                                                        End Using
                                                    End If

                                                    'Add the study object to the collection
                                                    clnt.Studies.Add(stdy)
                                                End While
                                            End Using
                                        End Using
                                    End If

                                    'Add the client object to the collection
                                    group.Clients.Add(clnt)
                                End While
                            End Using
                        End Using
                    End If

                    'Add the client group object to the collection
                    tree.ClientGroups.Add(group)
                End While
            End Using
        End Using

        'Return the populated navigation tree
        Return tree

    End Function

    Private Function GetPopulationDepth(ByVal initialDepth As InitialPopulationDepth) As Integer

        Dim depth As Integer

        If (initialDepth And Navigation.InitialPopulationDepth.Client) = Navigation.InitialPopulationDepth.Client Then
            depth = 1
        End If
        If (initialDepth And Navigation.InitialPopulationDepth.Study) = Navigation.InitialPopulationDepth.Study Then
            depth = 2
        End If
        If (initialDepth And Navigation.InitialPopulationDepth.Survey) = Navigation.InitialPopulationDepth.Survey Then
            depth = 3
        End If

        Return depth

    End Function

    Private Sub DefineRelations(ByVal ds As DataSet, ByVal depth As Integer, ByVal includeGroups As Boolean)

        Dim startingTable As Integer = 0

        If includeGroups Then
            ds.Relations.Add("ClientGroupClient", ds.Tables(startingTable).Columns("ClientGroup_ID"), ds.Tables(startingTable + 1).Columns("ClientGroup_ID"))
            startingTable += 1
        End If

        If depth > 1 Then
            ds.Relations.Add("ClientStudy", ds.Tables(startingTable).Columns("Client_id"), ds.Tables(startingTable + 1).Columns("Client_id"))
            startingTable += 1
        End If

        If depth > 2 Then
            ds.Relations.Add("StudySurvey", ds.Tables(startingTable).Columns("Study_id"), ds.Tables(startingTable + 1).Columns("Study_id"))
            startingTable += 1
        End If

        If depth > 3 Then
            ds.Relations.Add("SurveyUnit", ds.Tables(startingTable).Columns("Survey_id"), ds.Tables(startingTable + 1).Columns("Survey_id"))
        End If

    End Sub

#End Region

End Class
