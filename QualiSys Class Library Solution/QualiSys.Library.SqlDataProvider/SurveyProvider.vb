Imports Nrc.Framework.Data

Public Class SurveyProvider
    Inherits Nrc.QualiSys.Library.DataProvider.SurveyProvider

    Friend Shared Function PopulateSurvey(ByVal rdr As SafeDataReader) As Survey

        Return PopulateSurvey(rdr, Nothing)

    End Function

    Friend Shared Function PopulateSurvey(ByVal rdr As SafeDataReader, ByVal parentStudy As Study, Optional ByVal loadSubtypes As Boolean = True) As Survey

        Dim newObj As New Survey(parentStudy)

        Dim survey_id As Integer = rdr.GetInteger("Survey_id")

        ReadOnlyAccessor.SurveyId(newObj) = survey_id
        newObj.Name = rdr.GetString("strSurvey_nm", String.Empty).Trim
        newObj.ContractNumber = rdr.GetString("Contract", String.Empty).Trim
        newObj.Description = rdr.GetString("strSurvey_dsc", String.Empty)
        newObj.StudyId = rdr.GetInteger("Study_id")
        newObj.CutoffResponseCode = CType(rdr.GetString("strCutoffResponse_cd", CStr(CutoffFieldType.SampleCreate)), CutoffFieldType)
        newObj.CutoffTableId = rdr.GetInteger("CutoffTable_id", -1)
        newObj.CutoffFieldId = rdr.GetInteger("CutoffField_id", -1)
        newObj.SampleEncounterTableId = rdr.GetInteger("SampleEncounterTable_Id", -1)
        newObj.SampleEncounterFieldId = rdr.GetInteger("SampleEncounterField_Id", -1)
        If loadSubtypes Then
            If (newObj.SampleEncounterTableId <> -1 AndAlso newObj.SampleEncounterFieldId <> -1) Then
                newObj.SampleEncounterField = StudyTableColumn.Get(newObj.SampleEncounterTableId, newObj.SampleEncounterFieldId)
            End If
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
        newObj.UseUSPSAddrChangeService = rdr.GetBoolean("UseUSPSAddrChangeService")
        newObj.IsHandout = rdr.GetBoolean("IsHandout")
        newObj.IsPointInTime = rdr.GetBoolean("IsPointInTime")

        If loadSubtypes Then
            newObj.QuestionnaireType = SelectSurveyTypeForCategory(survey_id, SubtypeCategories.QuestionnaireType)
            newObj.QuestionnaireType.ResetDirtyFlag()

            newObj.ResurveyExclusionType = SelectSurveyTypeForCategory(survey_id, SubtypeCategories.ResurveyExclusionType)
            newObj.ResurveyExclusionType.ResetDirtyFlag()

            newObj.SurveySubTypes = SelectSurveySubTypes(survey_id, SubtypeCategories.Subtype)
            newObj.SurveySubTypes.ResetDirtyFlag()
        End If

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

                    ' Now handle the subtype subtypes
                    If srvy.SurveySubTypes.IsDirty Then
                        '    DeleteSurveySubtypes(srvy.Id, SubtypeCategories.Subtype, tran)
                        For Each st As SubType In srvy.SurveySubTypes
                            If st.IsNew Then
                                SurveyProvider.InsertSurveySubType(srvy.Id, st.SubTypeId, tran)
                            ElseIf st.NeedsDeleted Then
                                SurveyProvider.DeleteSurveySubtype(srvy.Id, st.SubTypeId, SubtypeCategories.Subtype, tran)
                            End If
                        Next
                    End If

                    ' Now handle the questionnairetype subtypes
                    If srvy.QuestionnaireType IsNot Nothing Then
                        If srvy.QuestionnaireType.IsDirty Then
                            If srvy.QuestionnaireType.SubTypeId > 0 Then
                                SurveyProvider.UpdateSurveySubType(srvy.Id, srvy.QuestionnaireType.SubTypeId, SubtypeCategories.QuestionnaireType, tran)
                            ElseIf srvy.QuestionnaireType.NeedsDeleted Then
                                SurveyProvider.DeleteSurveySubtypeForCategory(srvy.Id, SubtypeCategories.QuestionnaireType, tran)
                            End If
                        End If
                    End If

                    ' Now handle the resurveyexclusiontype subtypes
                    If srvy.ResurveyExclusionType IsNot Nothing Then
                        If srvy.ResurveyExclusionType.IsDirty Then
                            If srvy.ResurveyExclusionType.SubTypeId > 0 Then
                                SurveyProvider.UpdateSurveySubType(srvy.Id, srvy.ResurveyExclusionType.SubTypeId, SubtypeCategories.ResurveyExclusionType, tran)
                            ElseIf srvy.ResurveyExclusionType.NeedsDeleted Then
                                SurveyProvider.DeleteSurveySubtypeForCategory(srvy.Id, SubtypeCategories.ResurveyExclusionType, tran)
                            End If
                        End If
                    End If

                    If srvy.ClearFacilityMappings Then
                        ClearSurveyFacilityMappings(srvy.Id, tran)
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
                If srvy.SurveySubTypes IsNot Nothing Then srvy.SurveySubTypes.ResetDirtyFlag()
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

            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateSurveyProperties, .Id, .Name, .Description, .ResponseRateRecalculationPeriod, .ResurveyPeriod, .ResurveyMethod,
                                                           .SurveyStartDate, .SurveyEndDate, .SamplingAlgorithm, .EnforceSkip, CStr(.CutoffResponseCode),
                                                           SafeDataReader.ToDBValue(.CutoffTableId, -1), SafeDataReader.ToDBValue(.CutoffFieldId, -1),
                                                           SafeDataReader.ToDBValue(sampleEncounterTableId, -1), SafeDataReader.ToDBValue(sampleEncounterFieldId, -1),
                                                           .ClientFacingName, .SurveyType, .SurveyTypeDefId, GetHouseHoldingTypeCharacter(.HouseHoldingType), .IsValidated,
                                                           SafeDataReader.ToDBValue(.DateValidated), .IsFormGenReleased, .ContractNumber, .IsActive, .ContractedLanguages, .UseUSPSAddrChangeService,
                                                           .IsHandout, .IsPointInTime, .LocationProviderResurveyDays)

            ExecuteNonQuery(cmd, tran)
        End With

    End Sub

    Public Overrides Function Insert(ByVal studyId As Integer,
                                     ByVal name As String,
                                     ByVal description As String,
                                     ByVal responseRateRecalculationPeriod As Integer,
                                     ByVal resurveyMethodId As ResurveyMethod,
                                     ByVal resurveyPeriod As Integer,
                                     ByVal surveyStartDate As Date,
                                     ByVal surveyEndDate As Date,
                                     ByVal samplingAlgorithmId As Integer,
                                     ByVal enforceSkip As Boolean,
                                     ByVal cutoffResponseCode As String,
                                     ByVal cutoffTableId As Integer,
                                     ByVal cutoffFieldId As Integer,
                                     ByVal sampleEncounterField As StudyTableColumn,
                                     ByVal clientFacingName As String,
                                     ByVal surveyTypeId As Integer,
                                     ByVal surveyTypeDefId As Integer,
                                     ByVal houseHoldingType As HouseHoldingType,
                                     ByVal contractNumber As String,
                                     ByVal isActive As Boolean,
                                     ByVal contractedLanguages As String,
                                     ByVal surveysubtypes As SubTypeList,
                                     ByVal questionnairesubtype As SubType,
                                     ByVal resurveyExclustionSubtype As SubType,
                                     ByVal useUSPSAddrChangeService As Boolean,
                                     ByVal isHandout As Boolean,
                                     ByVal isPointInTime As Boolean,
                                     ByVal locationProviderResurveyDays As Integer
                                    ) As Survey

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
                    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertSurvey, studyId, name, description, responseRateRecalculationPeriod, resurveyPeriod,
                                                                   CType(resurveyMethodId, Integer), surveyStartDate, surveyEndDate, samplingAlgorithmId, enforceSkip,
                                                                   cutoffResponseCode, SafeDataReader.ToDBValue(cutoffTableId, -1), SafeDataReader.ToDBValue(cutoffFieldId, -1),
                                                                   SafeDataReader.ToDBValue(sampleEncounterTableId, -1), SafeDataReader.ToDBValue(sampleEncounterFieldId, -1),
                                                                   clientFacingName, surveyTypeId, surveyTypeDefId, GetHouseHoldingTypeCharacter(houseHoldingType),
                                                                   contractNumber, isActive, contractedLanguages, useUSPSAddrChangeService, isHandout, isPointInTime,
                                                                   locationProviderResurveyDays)

                    surveyId = ExecuteInteger(cmd, tran)

                    ' Now handle the subtype subtypes
                    If surveysubtypes.IsDirty Then
                        '    DeleteSurveySubtypes(srvy.Id, SubtypeCategories.Subtype, tran)
                        For Each st As SubType In surveysubtypes
                            If st.IsNew Then
                                SurveyProvider.InsertSurveySubType(surveyId, st.SubTypeId, tran)
                            ElseIf st.NeedsDeleted Then
                                SurveyProvider.DeleteSurveySubtype(surveyId, st.SubTypeId, SubtypeCategories.Subtype, tran)
                            End If
                        Next
                    End If

                    ' Now handle the questionnairetype subtypes
                    If questionnairesubtype IsNot Nothing Then
                        If questionnairesubtype.SubTypeId > 0 Then
                            SurveyProvider.UpdateSurveySubType(surveyId, questionnairesubtype.SubTypeId, SubtypeCategories.QuestionnaireType, tran)
                        End If
                    End If

                    ' Now handle the resurveyExclusionSubtype subtypes
                    If resurveyExclustionSubtype IsNot Nothing Then
                        If resurveyExclustionSubtype.SubTypeId > 0 Then
                            SurveyProvider.UpdateSurveySubType(surveyId, resurveyExclustionSubtype.SubTypeId, SubtypeCategories.ResurveyExclusionType, tran)
                        End If
                    End If

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

    Public Overrides Function SelectSubTypes(ByVal surveytypeid As Integer, ByVal categorytype As SubtypeCategories, ByVal surveyid As Integer) As SubTypeList

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectSubTypes", surveytypeid, categorytype, surveyid)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New SubTypeList
            Dim SubType_Id As Integer
            Dim SurveyType_Id As Integer
            Dim SubType_NM As String
            Dim SubtypeCategory_Id As Integer
            Dim SubtypeCategory_NM As String
            Dim isMultiselect As Boolean
            Dim isRuleOverride As Boolean
            Dim isSelected As Boolean
            Dim ParentSubType_Id As Integer
            Dim isQuestionnaireRequired As Boolean
            Dim isActive As Boolean

            If (categorytype = SubtypeCategories.QuestionnaireType Or categorytype = SubtypeCategories.ResurveyExclusionType) Then
                items.Add(New SubType(0, 0, -1, "N/A", False, True, False))
            End If

            Do While rdr.Read

                isActive = rdr.GetBoolean("bitActive")
                SubType_NM = rdr.GetString("SubType_NM")
                SubType_Id = rdr.GetInteger("SubType_id")
                SurveyType_Id = rdr.GetInteger("SurveyType_ID")
                SubtypeCategory_Id = rdr.GetInteger("SubtypeCategory_ID")
                SubtypeCategory_NM = rdr.GetString("Subtypecategory_NM")
                isMultiselect = rdr.GetBoolean("bitMultiSelect")
                isRuleOverride = rdr.GetBoolean("bitRuleOverride")
                isSelected = rdr.GetInteger("bitSelected") = 1
                ParentSubType_Id = rdr.GetInteger("ParentSubType_id")
                isQuestionnaireRequired = rdr.GetBoolean("bitQuestionnaireRequired")
                items.Add(New SubType(SubType_Id, SubtypeCategory_Id, SurveyType_Id, SubType_NM, isRuleOverride, isSelected, ParentSubType_Id, isQuestionnaireRequired, isActive))

            Loop

            Return items
        End Using

    End Function

    Private Shared Function SelectSurveySubTypes(ByVal surveyid As Integer, ByVal categorytype As SubtypeCategories) As SubTypeList

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectSurveySubtypes", surveyid, categorytype)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Dim items As New SubTypeList
            Dim SubType_Id As Integer
            Dim SubType_NM As String
            Dim SubTypeCategory_id As Integer
            Dim isRuleOverride As Boolean
            Dim isActive As Boolean
            SubTypeCategory_id = Convert.ToInt32(categorytype)
            Do While rdr.Read
                SubType_NM = rdr.GetString("SubType_NM")
                SubType_Id = rdr.GetInteger("SubType_id")
                isRuleOverride = rdr.GetBoolean("bitRuleOverride")
                isActive = rdr.GetBoolean("bitActive")
                items.Add(New SubType(SubType_Id, SubTypeCategory_id, SubType_NM, isRuleOverride, isActive, True))

            Loop

            Return items
        End Using

    End Function

    Private Shared Function SelectSurveyTypeForCategory(ByVal surveyid As Integer, ByVal categorytype As SubtypeCategories) As SubType
        ' there will only be one questionnaire subtype in the list

        Dim list As SubTypeList = SelectSurveySubTypes(surveyid, categorytype)

        If list.Count = 0 Then
            list.Add(New SubType(0, 0, -1, "N/A", False, True, False))
        End If

        Return list.Item(0)

    End Function


    Private Shared Sub InsertSurveySubType(ByVal surveyId As Integer, ByVal subtypeId As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_InsertSurveySubType", surveyId, subtypeId)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Private Shared Sub UpdateSurveySubType(ByVal surveyId As Integer, ByVal subtypeid As Integer, ByVal categoryId As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_UpdateSurveySubType", surveyId, subtypeid, categoryId)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Public Shared Sub DeleteSurveySubtype(ByVal surveyId As Integer, ByVal subtypeid As Integer, ByVal categorytype_id As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_DeleteSurveySubtype", surveyId, subtypeid, categorytype_id)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Public Shared Sub DeleteSurveySubtypeForCategory(ByVal surveyId As Integer, ByVal categorytype_id As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_DeleteSurveyQuestionnaireSubtype", surveyId, categorytype_id)
        ExecuteNonQuery(cmd, tran)

    End Sub

    'Public Shared Sub DeleteSurveySubtypes(ByVal surveyId As Integer, ByVal categorytype_id As Integer, ByVal tran As DbTransaction)

    '    Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_DeleteSurveySubtypes", surveyId, categorytype_id)
    '    ExecuteNonQuery(cmd, tran)

    'End Sub

    Public Shared Sub ClearSurveyFacilityMappings(ByVal surveyId As Integer, ByVal tran As DbTransaction)

        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_ClearSurveyFacilityMappings", surveyId)
        ExecuteNonQuery(cmd, tran)

    End Sub

    Public Overrides Function HasFacilityMapping(ByVal surveyID As Integer) As Boolean

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.HasFacilityMapping, surveyID)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return rdr.GetBoolean(0)
            End If
        End Using

        Return False

    End Function


End Class
