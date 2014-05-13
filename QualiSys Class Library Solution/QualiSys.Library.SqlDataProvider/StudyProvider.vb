Imports Nrc.Framework.Data

Public Class StudyProvider
    Inherits Nrc.QualiSys.Library.DataProvider.StudyProvider

    Friend Shared Function PopulateStudy(ByVal rdr As SafeDataReader) As Study

        Return PopulateStudy(rdr, Nothing, Nothing)

    End Function

    Friend Shared Function PopulateStudy(ByVal rdr As SafeDataReader, ByVal parentClient As Client) As Study

        Return PopulateStudy(rdr, parentClient, Nothing)

    End Function

    Friend Shared Function PopulateStudy(ByVal rdr As SafeDataReader, ByVal parentClient As Client, ByVal childSurveys As Collection(Of Survey)) As Study

        Dim newObj As New Study(parentClient, childSurveys)

        newObj.BeginPopulate()
        ReadOnlyAccessor.StudyId(newObj) = rdr.GetInteger("Study_id")
        newObj.Name = rdr.GetString("strStudy_nm").Trim
        newObj.Description = rdr.GetString("strStudy_dsc")
        newObj.ClientId = rdr.GetInteger("Client_id")
        ReadOnlyAccessor.StudyAccountDirectorEmployeeId(newObj) = rdr.GetInteger("ADEmployee_id")
        newObj.CreateDate = rdr.GetDate("datCreate_dt")
        newObj.UseAddressCleaning = rdr.GetBoolean("bitCleanAddr")
        newObj.UseProperCase = rdr.GetBoolean("bitProperCase")
        newObj.IsActive = rdr.GetBoolean("Active")
        newObj.EndPopulate()
        newObj.ResetDirtyFlag()

        Return newObj

    End Function

    Public Overrides Function [Select](ByVal studyId As Integer) As Study

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudy, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateStudy(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectByClientId(ByVal client As Client) As System.Collections.ObjectModel.Collection(Of Study)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStudiesByClientId, client.Id)
        Dim studies As New Collection(Of Study)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                studies.Add(PopulateStudy(rdr, client))
            End While
        End Using

        Return studies

    End Function

    Public Overrides Function AllowDelete(ByVal studyId As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowDeleteStudy, studyId)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)

    End Function

    Public Overrides Sub Delete(ByVal studyId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteStudy, studyId)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Function InsertStudy(ByVal instance As Study) As Integer

        Using conn As DbConnection = Db.CreateConnection
            conn.Open()
            Dim cmd As DbCommand
            Using tran As DbTransaction = conn.BeginTransaction
                cmd = Db.GetStoredProcCommand(SP.InsertStudy, instance.Name, instance.Description, instance.Client.Id, instance.AccountDirectorEmployeeId, instance.CreateDate, instance.UseAddressCleaning, instance.UseProperCase, instance.IsActive)
                Try
                    'Insert the Study
                    Dim studyId As Integer = ExecuteInteger(cmd, tran)

                    'Update the object with the new id
                    ReadOnlyAccessor.StudyId(instance) = studyId

                    'If we need to copy the data structure from another study then do so
                    If instance.CopyDataStructureFromStudyID > 0 Then
                        cmd = Db.GetStoredProcCommand(SP.CopyStudyDataStructure, instance.CopyDataStructureFromStudyID, instance.Id, 0)
                        ExecuteNonQuery(cmd, tran)
                    End If

                    'Delete any existing employees for study (currently added by trigger on study table)
                    cmd = Db.GetStoredProcCommand(SP.DeleteStudyEmployeeByStudyID, studyId)
                    ExecuteNonQuery(cmd, tran)

                    For Each employee As STUDY_EMPLOYEE In instance.StudyEmployees
                        cmd = Db.GetStoredProcCommand(SP.InsertStudyEmployee, employee.EMPLOYEEId, studyId)
                        ExecuteInteger(cmd, tran)

                        Dim privateInterface As ISTUDY_EMPLOYEE = employee
                        privateInterface.STUDYId = studyId
                    Next

                    instance.ResetDirtyFlag()
                    tran.Commit()

                    'Temporarily added SP for SQL 2000, removed when upgraded to SQL 2008
                    cmd = Db.GetStoredProcCommand("dbo.QCL_StudyAddUser", String.Concat("S", studyId.ToString))
                    ExecuteNonQuery(cmd)

                    Return studyId

                Catch ex As Exception
                    tran.Rollback()
                    Throw

                End Try
            End Using
        End Using

    End Function

    Public Overrides Sub UpdateStudy(ByVal instance As Study)

        Using conn As DbConnection = Db.CreateConnection
            conn.Open()
            Dim cmd As DbCommand
            Using tran As DbTransaction = conn.BeginTransaction
                cmd = Db.GetStoredProcCommand(SP.UpdateStudy, instance.Id, instance.Name, instance.Description, instance.Client.Id, instance.AccountDirectorEmployeeId, instance.CreateDate, instance.UseAddressCleaning, instance.UseProperCase, instance.IsActive)
                Try
                    'Update the study record
                    ExecuteNonQuery(cmd, tran)

                    'Delete any existing employees for study
                    cmd = Db.GetStoredProcCommand(SP.DeleteStudyEmployeeByStudyID, instance.Id)
                    ExecuteNonQuery(cmd, tran)

                    'Re-insert each study employee
                    For Each employee As STUDY_EMPLOYEE In instance.StudyEmployees
                        cmd = Db.GetStoredProcCommand(SP.InsertStudyEmployee, employee.EMPLOYEEId, instance.Id)
                        ExecuteInteger(cmd, tran)

                        Dim privateInterface As ISTUDY_EMPLOYEE = employee
                        privateInterface.STUDYId = instance.Id
                    Next

                    instance.ResetDirtyFlag()
                    tran.Commit()

                Catch ex As Exception
                    tran.Rollback()
                    Throw

                End Try
            End Using
        End Using

    End Sub

End Class
