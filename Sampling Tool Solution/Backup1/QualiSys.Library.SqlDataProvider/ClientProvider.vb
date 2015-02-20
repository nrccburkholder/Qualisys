Imports Nrc.Framework.Data

Public Class ClientProvider
    Inherits Nrc.QualiSys.Library.DataProvider.ClientProvider

#Region " Friend Methods "

    Friend Shared Function PopulateClient(ByVal rdr As SafeDataReader) As Client

        Return PopulateClient(rdr, Nothing, Nothing)

    End Function

    Friend Shared Function PopulateClient(ByVal rdr As SafeDataReader, ByVal parentGroup As ClientGroup) As Client

        Return PopulateClient(rdr, parentGroup, Nothing)

    End Function

    Friend Shared Function PopulateClient(ByVal rdr As SafeDataReader, ByVal parentGroup As ClientGroup, ByVal childStudies As Collection(Of Study)) As Client

        Dim clnt As New Client(parentGroup, childStudies)

        ReadOnlyAccessor.ClientId(clnt) = rdr.GetInteger("Client_id")
        With clnt
            .Name = rdr.GetString("strClient_nm").Trim
            .OrgName = rdr.GetString("strClient_nm").Trim
            .IsActive = rdr.GetBoolean("Active")
            .ClientGroupID = rdr.GetInteger("ClientGroup_ID", -1)
            .ResetDirtyFlag()
        End With

        Return clnt

    End Function

#End Region

#Region " Public Methods "

    Public Overrides Function [Select](ByVal clientId As Integer) As Client

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClient, clientId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateClient(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectClientsAndStudiesByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of Client)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientsAndStudysByUser, userName, showAllClients)
        Dim ds As DataSet = ExecuteDataSet(cmd)

        ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))

        Dim clientList As New Collection(Of Client)

        Using clientRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using clientReader As New SafeDataReader(clientRowReader)
                While clientReader.Read
                    Dim studies As New Collection(Of Study)
                    Dim clnt As Client = PopulateClient(clientReader, Nothing, studies)

                    Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                        Using studyReader As New SafeDataReader(studyRowReader)
                            While studyReader.Read
                                Dim stdy As Study = StudyProvider.PopulateStudy(studyReader, clnt)
                                studies.Add(stdy)
                            End While

                            clientList.Add(clnt)
                        End Using
                    End Using
                End While
            End Using
        End Using

        Return clientList

    End Function

    Public Overrides Function SelectClientsStudiesAndSurveysByUser(ByVal userName As String, ByVal showAllClients As Boolean) As Collection(Of Client)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientsStudysAndSurveysByUser, userName, showAllClients)
        Dim ds As DataSet = ExecuteDataSet(cmd)

        ds.Relations.Add("ClientStudy", ds.Tables(0).Columns("Client_id"), ds.Tables(1).Columns("Client_id"))
        ds.Relations.Add("StudySurvey", ds.Tables(1).Columns("Study_id"), ds.Tables(2).Columns("Study_id"))

        Dim clientList As New Collection(Of Client)
        Dim clnt As Client
        Dim stdy As Study

        'Iterate through each client row
        Using clientRowReader As New DataRowReader(ds.Tables(0).Rows)
            Using clientReader As New SafeDataReader(clientRowReader)
                While clientReader.Read
                    'Create a new client object and specify what will be the study collection
                    Dim studies As New Collection(Of Study)
                    clnt = PopulateClient(clientReader, Nothing, studies)

                    'Iterate through each study related to the client row
                    Using studyRowReader As New DataRowReader(clientRowReader.CurrentRow.GetChildRows("ClientStudy"))
                        Using studyReader As New SafeDataReader(studyRowReader)
                            While studyReader.Read
                                Dim surveys As New Collection(Of Survey)
                                stdy = StudyProvider.PopulateStudy(studyReader, clnt, surveys)
                                'Iterate through each survey related to the study row
                                Using surveyRowReader As New DataRowReader(studyRowReader.CurrentRow.GetChildRows("StudySurvey"))
                                    Using surveyReader As New SafeDataReader(surveyRowReader)
                                        While surveyReader.Read
                                            Dim srvy As Survey = SurveyProvider.PopulateSurvey(surveyReader, stdy)
                                            surveys.Add(srvy)
                                        End While
                                    End Using
                                End Using
                                studies.Add(stdy)
                            End While
                        End Using
                    End Using

                    'Add the client to the client collection
                    clientList.Add(clnt)
                End While
            End Using
        End Using

        Return clientList

    End Function

    Public Overrides Function SelectClientsByClientGroupID(ByVal clientGroup As ClientGroup) As Collection(Of Client)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectClientsByClientGroupID, clientGroup.Id)
        Dim clients As New Collection(Of Client)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                clients.Add(PopulateClient(rdr))
            End While
        End Using

        Return clients

    End Function

    Public Overrides Function Insert(ByVal clientName As String, ByVal isActive As Boolean, ByVal clientGroupID As Integer) As Integer

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertClient, clientName, isActive, clientGroupID)
        Dim newId As Integer = ExecuteInteger(cmd)

        Return newId

    End Function

    Public Overrides Sub Delete(ByVal clientId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteClient, clientId)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Function AllowDelete(ByVal clientId As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowDeleteClient, clientId)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)

    End Function

    Public Overrides Sub Update(ByVal clnt As Client)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateClient, clnt.Id, clnt.Name, clnt.OrgName, clnt.IsActive, clnt.ClientGroupID)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
