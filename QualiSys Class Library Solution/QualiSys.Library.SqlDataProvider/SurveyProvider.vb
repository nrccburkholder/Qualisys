Imports Nrc.Framework.Data

Public Class SurveyProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SurveyProvider

    Friend Shared Function PopulateSurvey(ByVal rdr As SafeDataReader) As Survey

        Return PopulateSurvey(rdr, Nothing)

    End Function

    Friend Shared Function PopulateSurvey(ByVal rdr As SafeDataReader, ByVal parentStudy As Study) As Survey

        Dim newObj As New Survey(parentStudy)

        ReadOnlyAccessor.SurveyId(newObj) = rdr.GetInteger("Survey_id")
        newObj.Name = rdr.GetString("strSurvey_nm", String.Empty).Trim
        newObj.ContractNumber = rdr.GetString("Contract", String.Empty).Trim
        newObj.Description = rdr.GetString("strSurvey_dsc", String.Empty)
        newObj.StudyId = rdr.GetInteger("Study_id")
        newObj.CutoffResponseCode = CType(rdr.GetString("strCutoffResponse_cd", CStr(CutoffFieldType.SampleCreate)), CutoffFieldType)
        newObj.CutoffTableId = rdr.GetInteger("CutoffTable_id", -1)
        newObj.CutoffFieldId = rdr.GetInteger("CutoffField_id", -1)
        Dim sampleEncounterTableId As Integer = rdr.GetInteger("SampleEncounterTable_Id", -1)
        Dim sampleEncounterFieldId As Integer = rdr.GetInteger("SampleEncounterField_Id", -1)
        If (sampleEncounterTableId <> -1 AndAlso sampleEncounterFieldId <> -1) Then
            newObj.SampleEncounterField = StudyTableColumn.Get(sampleEncounterTableId, sampleEncounterFieldId)
        End If
        newObj.IsValidated = rdr.GetBoolean("bitValidated_flg")
        newObj.DateValidated = rdr.GetDate("datValidated")
        newObj.IsFormGenReleased = rdr.GetBoolean("bitFormGenRelease")
        newObj.SamplePlanId = rdr.GetInteger("SamplePlan_id")
        newObj.ResponseRateRecalculationPeriod = rdr.GetInteger("intResponse_Recalc_Period", 0)
        newObj.ResurveyMethod = CType(rdr.GetInteger("ReSurveyMethod_id", ResurveyMethod.NumberOfDays), ResurveyMethod)
        newObj.ResurveyPeriod = rdr.GetInteger("intResurvey_Period", 0)
        newObj.SurveyStartDate = rdr.GetDate("datSurvey_Start_Dt")
        newObj.SurveyEndDate = rdr.GetDate("datSurvey_End_Dt")
        newObj.SamplingAlgorithm = CType(rdr.GetInteger("SamplingAlgorithmId", SamplingAlgorithm.Static), SamplingAlgorithm)
        newObj.EnforceSkip = rdr.GetBoolean("bitEnforceSkip")
        newObj.ClientFacingName = rdr.GetString("strClientFacingName", String.Empty)
        newObj.SurveyType = CType(rdr.GetInteger("SurveyType_Id", SurveyTypes.DefaultSurvey), SurveyTypes)
        newObj.SurveyTypeDefId = rdr.GetInteger("SurveyTypeDef_Id", 0)
        Select Case rdr.GetString("strHouseholdingType", String.Empty)
            Case "M"
                newObj.HouseHoldingType = HouseHoldingType.Minor
            Case "A"
                newObj.HouseHoldingType = HouseHoldingType.All
            Case Else
                newObj.HouseHoldingType = HouseHoldingType.None
        End Select
        newObj.IsActive = rdr.GetBoolean("Active")
        newObj.ContractedLanguages = rdr.GetString("ContractedLanguages", String.Empty)
        newObj.SurveySubType = rdr.GetInteger("SurveySubType_Id", 0)
        newObj.QuestionnaireType = rdr.GetInteger("QuestionnaireType_Id", 0)
        newObj.ResetDirtyFlag()

        Return newObj

    End Function

    Public Overrides Function [Select](ByVal surveyId As Integer) As Survey

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurvey, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateSurvey(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Function SelectByStudy(ByVal study As Study) As System.Collections.ObjectModel.Collection(Of Survey)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveysByStudyId, study.Id)
        Dim surveys As New Collection(Of Survey)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                surveys.Add(PopulateSurvey(rdr, study))
            End While
        End Using

        Return surveys

    End Function

    Public Overrides Function SelectBySurveyTypeMailOnly(ByVal srvyType As SurveyType) As System.Collections.ObjectModel.Collection(Of Survey)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveysBySurveyTypeMailOnly, srvyType.Id)
        Dim surveys As New Collection(Of Survey)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                surveys.Add(PopulateSurvey(rdr))
            End While
        End Using

        Return surveys

    End Function

    Public Overrides Function SelectSurveyTypes() As List(Of ListItem(Of SurveyTypes))

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveyTypes)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of ListItem(Of SurveyTypes))
            Dim label As String
            Dim svryType As SurveyTypes
            Do While rdr.Read
                label = rdr.GetString("SurveyType_Dsc")
                svryType = CType(rdr.GetInteger("SurveyType_Id"), SurveyTypes)
                items.Add(New ListItem(Of SurveyTypes)(label, svryType))
            Loop

            Return items
        End Using

    End Function

    Public Overrides Function SelectCAHPSTypes(ByVal surveyType As Integer) As List(Of ListItem(Of CAHPSType))

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCAHPSTypes, surveyType)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of ListItem(Of CAHPSType))
            Dim label As String
            Dim cahpsType As CAHPSType
            Do While rdr.Read
                label = rdr.GetString("SurveyType_Dsc")
                cahpsType = CType(rdr.GetInteger("CAHPSType_Id"), CAHPSType)
                items.Add(New ListItem(Of CAHPSType)(label, cahpsType))
            Loop

            Return items
        End Using

    End Function

    Public Overrides Function SelectSamplingAlgorithms() As List(Of ListItem(Of SamplingAlgorithm))

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSamplingAlgorithms)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of ListItem(Of SamplingAlgorithm))
            Dim label As String
            Dim algorithm As SamplingAlgorithm

            Do While rdr.Read
                label = rdr.GetString("AlgorithmName")
                algorithm = CType(rdr.GetInteger("SamplingAlgorithmId"), SamplingAlgorithm)
                items.Add(New ListItem(Of SamplingAlgorithm)(label, algorithm))
            Loop

            Return items
        End Using

    End Function

    Public Overrides Function SelectResurveyMethod() As List(Of ListItem(Of ResurveyMethod))

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectResurveyMethod)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of ListItem(Of ResurveyMethod))
            Dim label As String
            Dim resvryMethod As ResurveyMethod

            Do While rdr.Read
                label = rdr.GetString("ResurveyMethodName")
                resvryMethod = CType(rdr.GetInteger("ResurveyMethod_Id"), ResurveyMethod)
                items.Add(New ListItem(Of ResurveyMethod)(label, resvryMethod))
            Loop

            Return items
        End Using

    End Function

    Public Overrides Function IsSurveySampled(ByVal surveyID As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.IsSurveySampled, surveyID)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return rdr.GetBoolean(0)
            End If
        End Using

        Return False

    End Function

    Public Overrides Sub Update(ByVal srvy As Survey)

        Using con As DbConnection = Db.CreateConnection
            con.Open()

            Using tran As DbTransaction = con.BeginTransaction
                Try
                    If srvy.IsDirty Then
                        UpdateProperties(srvy, tran)
                    End If

                    If srvy.BusinessRules IsNot Nothing Then
                        Dim i As Integer
                        For i = (srvy.BusinessRules.Count - 1) To 0 Step -1
                            Dim busRule As BusinessRule = srvy.BusinessRules.Item(i)
                            If busRule.IsDirty Then
                                If busRule.NeedsDeleted AndAlso busRule.Id = 0 Then
                                    'remove from collection
                                    srvy.BusinessRules.RemoveAt(i)
                                ElseIf busRule.NeedsDeleted AndAlso busRule.Id > 0 Then
                                    'delete in database and remove from collection
                                    BusinessRuleProvider.DeleteBusinessRule(busRule, tran)
                                    srvy.BusinessRules.RemoveAt(i)
                                ElseIf busRule.NeedsDeleted = False AndAlso busRule.Id = 0 Then
                                    'A new rule is added to the database.  We must update the IDs on our existing object.
                                    Dim tmpBusRule As BusinessRule
                                    tmpBusRule = BusinessRule.Get(BusinessRuleProvider.InsertBusinessRule(busRule, tran), srvy)
                                    busRule.Id = tmpBusRule.Id
                                    busRule.CriteriaId = tmpBusRule.CriteriaId
                                    busRule.Criteria = tmpBusRule.Criteria
                                    busRule.ResetDirtyFlag()
                                ElseIf busRule.Id <> 0 Then
                                    'update
                                    BusinessRuleProvider.UpdateBusinessRule(busRule, tran)
                                    busRule.ResetDirtyFlag()
                                End If
                            End If
                        Next
                    End If

                    If srvy.HouseHoldingFields IsNot Nothing AndAlso srvy.HouseHoldingFields.IsDirty Then
                        SurveyProvider.DeleteHouseHoldingFieldsBySurveyId(srvy.Id, tran)
                        For Each hh As StudyTableColumn In srvy.HouseHoldingFields
                            SurveyProvider.InsertHouseHoldingField(srvy.Id, hh.TableId, hh.Id, tran)
                        Next
                    End If

                    tran.Commit()

                Catch ex As Exception
                    tran.Rollback()
                    Throw

                End Try

                'Reset all of the dirty flags
                srvy.ResetDirtyFlag()
                If srvy.BusinessRules IsNot Nothing Then
                    For Each busRule As BusinessRule In srvy.BusinessRules
                        busRule.ResetDirtyFlag()
                    Next
                End If
                If srvy.HouseHoldingFields IsNot Nothing Then srvy.HouseHoldingFields.ResetDirtyFlag()
            End Using
        End Using

    End Sub

    Private Function GetHouseHoldingTypeCharacter(ByVal houseHoldingType As HouseHoldingType) As Char

        Select Case houseHoldingType
            Case Library.HouseHoldingType.All
                Return Char.Parse("A")

            Case Library.HouseHoldingType.Minor
                Return Char.Parse("M")

            Case Else
                Return Char.Parse("N")

        End Select

    End Function

    Private Sub UpdateProperties(ByVal srvy As Survey, ByVal tran As DbTransaction)

        With srvy
            Dim sampleEncounterTableId As Integer = -1
            Dim sampleEncounterFieldId As Integer = -1

            If (srvy.SampleEncounterField IsNot Nothing) Then
                sampleEncounterTableId = srvy.SampleEncounterField.TableId
                sampleEncounterFieldId = srvy.SampleEncounterField.Id
            End If

            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSurveyProperties, .Id, .Name, .Description, .ResponseRateRecalculationPeriod, .ResurveyPeriod, .ResurveyMethod, _
                                                           .SurveyStartDate, .SurveyEndDate, .SamplingAlgorithm, .EnforceSkip, CStr(.CutoffResponseCode), _
                                                           SafeDataReader.ToDBValue(.CutoffTableId, -1), SafeDataReader.ToDBValue(.CutoffFieldId, -1), _
                                                           SafeDataReader.ToDBValue(sampleEncounterTableId, -1), SafeDataReader.ToDBValue(sampleEncounterFieldId, -1), _
                                                           .ClientFacingName, .SurveyType, .SurveyTypeDefId, GetHouseHoldingTypeCharacter(.HouseHoldingType), .IsValidated, _
                                                           SafeDataReader.ToDBValue(.DateValidated), .IsFormGenReleased, .ContractNumber, .IsActive, .ContractedLanguages, .SurveySubType, .QuestionnaireType)

            ExecuteNonQuery(cmd, tran)
        End With

    End Sub

    Public Overrides Function Insert(ByVal studyId As Integer, ByVal name As String, ByVal description As String, ByVal responseRateRecalculationPeriod As Integer, _
                                     ByVal resurveyMethodId As ResurveyMethod, ByVal resurveyPeriod As Integer, ByVal surveyStartDate As Date, ByVal surveyEndDate As Date, _
                                     ByVal samplingAlgorithmId As Integer, ByVal enforceSkip As Boolean, ByVal cutoffResponseCode As String, ByVal cutoffTableId As Integer, _
                                     ByVal cutoffFieldId As Integer, ByVal sampleEncounterField As StudyTableColumn, ByVal clientFacingName As String, ByVal surveyTypeId As Integer, _
                                     ByVal surveyTypeDefId As Integer, ByVal houseHoldingType As HouseHoldingType, ByVal contractNumber As String, ByVal isActive As Boolean, _
                                     ByVal contractedLanguages As String, ByVal surveySubTypeId As Integer, ByVal questionnaireTypeId As Integer) As Survey

        Dim surveyId As Integer

        Dim sampleEncounterTableId As Integer = -1
        Dim sampleEncounterFieldId As Integer = -1

        If (sampleEncounterField IsNot Nothing) Then
            sampleEncounterTableId = sampleEncounterField.TableId
            sampleEncounterFieldId = sampleEncounterField.Id
        End If

        Using con As DbConnection = Db.CreateConnection
            con.Open()

            Using tran As DbTransaction = con.BeginTransaction
                Try
                    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSurvey, studyId, name, description, responseRateRecalculationPeriod, resurveyPeriod, _
                                                                   CType(resurveyMethodId, Integer), surveyStartDate, surveyEndDate, samplingAlgorithmId, enforceSkip, _
                                                                   cutoffResponseCode, SafeDataReader.ToDBValue(cutoffTableId, -1), SafeDataReader.ToDBValue(cutoffFieldId, -1), _
                                                                   SafeDataReader.ToDBValue(sampleEncounterTableId, -1), SafeDataReader.ToDBValue(sampleEncounterFieldId, -1), _
                                                                   clientFacingName, surveyTypeId, surveyTypeDefId, GetHouseHoldingTypeCharacter(houseHoldingType), _
                                                                   contractNumber, isActive, contractedLanguages, surveySubTypeId, questionnaireTypeId)

                    surveyId = ExecuteInteger(cmd, tran)

                    tran.Commit()

                    'Add the required DQ rules
                    cmd = Db.GetStoredProcCommand(SP.InsertDefaultDQRules, surveyId)
                    ExecuteNonQuery(cmd)

                Catch ex As Exception
                    tran.Rollback()
                    Throw

                End Try

            End Using
        End Using

        Return Library.Survey.[Get](surveyId)

    End Function

    Private Shared Sub DeleteHouseHoldingFieldsBySurveyId(ByVal surveyId As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteHouseHoldingFieldsBySurveyId, surveyId)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Private Shared Sub InsertHouseHoldingField(ByVal surveyId As Integer, ByVal tableId As Integer, ByVal fieldId As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertHouseHoldingField, surveyId, tableId, fieldId)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Public Overrides Function AllowDelete(ByVal surveyId As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.AllowDeleteSurvey, surveyId)
        Dim result As Integer = ExecuteInteger(cmd)

        Return (result = 1)

    End Function

    Public Overrides Sub Delete(ByVal surveyId As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteSurvey, surveyId)
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Function PerformSurveyValidation(ByVal surveyId As Integer) As SurveyValidationResult

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ValidateSurvey, surveyId)
        Dim result As New SurveyValidationResult

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                Select Case rdr.GetInteger("Error")
                    Case 0  'Pass
                        result.PassList.Add(rdr.GetString("strMessage"))

                    Case 1  'Failures
                        result.FailureList.Add(rdr.GetString("strMessage"))

                    Case 2  'Warnings
                        result.WarningList.Add(rdr.GetString("strMessage"))

                    Case Else
                        Throw New DataAccessException("Unknown value encountered for column 'Error' in survey validation results'")

                End Select
            End While
        End Using

        Return result

    End Function

    Public Overrides Function SelectSurveySubTypes(ByVal surveytypeid As Integer) As List(Of SurveySubType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSurveySubTypes, surveytypeid)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of SurveySubType)
            Dim Description As String
            Dim SurveySubType_Id As Integer
            Dim SurveyType_Id As Integer
            Dim QuestionnaireType_Id As Integer = 0
            Do While rdr.Read
                Description = rdr.GetString("SubType_NM")
                SurveySubType_Id = CType(rdr.GetInteger("SurveySubType_id"), SurveyTypes)
                If Not rdr.IsDBNull("QuestionnaireType_ID") Then
                    QuestionnaireType_Id = rdr.GetShort("QuestionnaireType_ID")
                End If
                SurveyType_Id = rdr.GetInteger("SurveyType_ID")
                items.Add(New SurveySubType(SurveySubType_Id, SurveyType_Id, Description, QuestionnaireType_Id))
            Loop

            Return items
        End Using

    End Function


    Public Overrides Function SelectQuestionnaireTypes(ByVal surveytypeid As Integer, ByVal questionnairetypeid As Integer) As List(Of QuestionnaireType)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectQuestionnaireTypes, surveytypeid, questionnairetypeid)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New List(Of QuestionnaireType)
            Dim Description As String
            Dim QuestionnaireType_id As Integer
            Dim SurveyType_Id As Integer
            Do While rdr.Read
                Description = rdr.GetString("Description")
                QuestionnaireType_id = CType(rdr.GetInteger("QuestionnaireType_id"), SurveyTypes)
                SurveyType_Id = rdr.GetInteger("SurveyType_ID")
                items.Add(New QuestionnaireType(QuestionnaireType_id, SurveyType_Id, Description))
            Loop

            Return items
        End Using

    End Function


End Class
