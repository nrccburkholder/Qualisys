Imports Nrc.Framework.Data

Public Class MethodologyProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MethodologyProvider

#Region " Populate Methods "
    ''' <summary>
    ''' Populates a Methodology object from a DataReader
    ''' </summary>
    Private Function PopulateMethodology(ByVal rdr As SafeDataReader) As Methodology
        Dim newObj As Methodology = CreateMethodology(rdr.GetInteger("Methodology_id"), _
                                                    rdr.GetInteger("Survey_id"), _
                                                    Convert.ToBoolean(rdr.GetInteger("bitAllowEdit")), _
                                                    rdr.GetBoolean("bitCustom"), _
                                                    rdr.GetDate("datCreate_dt"), _
                                                    rdr.GetInteger("StandardMethodologyId"))
        newObj.Name = rdr.GetString("strMethodology_nm").Trim
        newObj.IsActive = rdr.GetBoolean("bitActiveMethodology")

        newObj.ResetDirtyFlag()
        Return newObj
    End Function

    ''' <summary>
    ''' Populates a MethodologyStep from a DataReader
    ''' </summary>
    Private Function PopulateMethodologyStep(ByVal rdr As SafeDataReader, ByVal stepIndex As Dictionary(Of Integer, MethodologyStep)) As MethodologyStep
        'Create the object
        Dim newObj As MethodologyStep = CreateMethodologyStep(rdr.GetInteger("MailingStep_id"))
        'Add it to the dictionary
        stepIndex.Add(newObj.Id, newObj)

        newObj.Name = rdr.GetString("strMailingStep_nm").Trim
        newObj.MethodologyId = rdr.GetInteger("Methodology_id")
        newObj.SurveyId = rdr.GetInteger("Survey_id")
        newObj.CoverLetterId = rdr.GetInteger("SelCover_id")
        newObj.DaysSincePreviousStep = rdr.GetInteger("intIntervalDays")
        newObj.IsSurvey = rdr.GetBoolean("bitSendSurvey")
        newObj.IsThankYouLetter = rdr.GetBoolean("bitThankYouItem")
        newObj.IsFirstSurvey = rdr.GetBoolean("bitFirstSurvey")
        newObj.OverrideLanguageId = rdr.GetNullableInteger("Override_Langid")
        newObj.QuotaID = rdr.GetNullableInteger("Quota_ID")
        newObj.QuotaStopCollectionAt = rdr.GetInteger("QuotaStopCollectionAt")
        newObj.DaysInField = rdr.GetInteger("DaysInField")
        newObj.NumberOfAttempts = rdr.GetInteger("NumberOfAttempts")
        newObj.IsWeekDayDayCall = rdr.GetBoolean("WeekDay_Day_Call")
        newObj.IsWeekDayEveCall = rdr.GetBoolean("WeekDay_Eve_Call")
        newObj.IsSaturdayDayCall = rdr.GetBoolean("Sat_Day_Call")
        newObj.IsSaturdayEveCall = rdr.GetBoolean("Sat_Eve_Call")
        newObj.IsSundayDayCall = rdr.GetBoolean("Sun_Day_Call")
        newObj.IsSundayEveCall = rdr.GetBoolean("Sun_Eve_Call")
        newObj.IsCallBackOtherLang = rdr.GetBoolean("CallBackOtherLang")
        newObj.IsCallBackUsingTTY = rdr.GetBoolean("CallbackUsingTTY")
        newObj.IsAcceptPartial = rdr.GetBoolean("AcceptPartial")
        newObj.IsEmailBlast = rdr.GetBoolean("SendEmailBlast")
        newObj.VendorID = rdr.GetNullableInteger("Vendor_ID")
        newObj.OrgVendorID = rdr.GetNullableInteger("Vendor_ID")

        'If there is no MMMailingStep_id then link to self
        If rdr.IsDBNull("MMMailingStep_id") OrElse rdr.GetInteger("MMMailingStep_id") = 0 Then
            'Set it to itself
            newObj.LinkedStep = newObj
        Else    'Otherwise find the step that is linked to and reference it
            'Find the step in our list of methodology steps
            Dim linkStepId As Integer = rdr.GetInteger("MMMailingStep_id")
            If Not stepIndex.ContainsKey(linkStepId) Then
                'Throw New DataAccessException("Methodology Step " & linkStepId & " cannot be found in the methodology.")
                newObj.LinkedStep = SelectMethodologyStep(linkStepId)
            Else
                newObj.LinkedStep = stepIndex(linkStepId)
            End If
        End If
        newObj.StepMethodId = rdr.GetInteger("MailingStepMethod_id")
        newObj.ExpirationDays = rdr.GetInteger("ExpireInDays")

        Dim expireStepId As Integer = rdr.GetInteger("ExpireFromStep")
        If expireStepId = newObj.Id Then
            'link to self
            newObj.ExpireFromStep = newObj
        Else
            'Find the expiring step and reference it
            If Not stepIndex.ContainsKey(expireStepId) Then
                'Throw New DataAccessException("Methodology Step " & expireStepId & " cannot be found in the methodology.")
                newObj.LinkedStep = SelectMethodologyStep(expireStepId)
            Else
                newObj.ExpireFromStep = stepIndex(expireStepId)
            End If
        End If

        newObj.ResetDirtyFlag()
        Return newObj
    End Function

    ''' <summary>
    ''' Populates a StandardMethodologyStep from a DataReader
    ''' </summary>
    Private Function PopulateStandardMethodologyStep(ByVal rdr As SafeDataReader, ByVal stepIndex As Dictionary(Of Integer, MethodologyStep)) As MethodologyStep
        'Create it with no ID
        Dim newObj As MethodologyStep = CreateMethodologyStep(0)
        'Add it to the dictionary
        stepIndex.Add(rdr.GetInteger("StandardMailingStepId"), newObj)

        'Fill in the rest of the properties
        newObj.Name = rdr.GetString("strMailingStep_nm").Trim
        newObj.DaysSincePreviousStep = rdr.GetInteger("intIntervalDays")
        newObj.IsSurvey = rdr.GetBoolean("bitSendSurvey")
        newObj.IsThankYouLetter = rdr.GetBoolean("bitThankYouItem")
        newObj.IsFirstSurvey = rdr.GetBoolean("bitFirstSurvey")
        newObj.OverrideLanguageId = Nothing
        newObj.QuotaID = rdr.GetNullableInteger("Quota_ID")
        newObj.QuotaStopCollectionAt = rdr.GetInteger("QuotaStopCollectionAt")
        newObj.DaysInField = rdr.GetInteger("DaysInField")
        newObj.NumberOfAttempts = rdr.GetInteger("NumberOfAttempts")
        newObj.IsWeekDayDayCall = rdr.GetBoolean("WeekDay_Day_Call")
        newObj.IsWeekDayEveCall = rdr.GetBoolean("WeekDay_Eve_Call")
        newObj.IsSaturdayDayCall = rdr.GetBoolean("Sat_Day_Call")
        newObj.IsSaturdayEveCall = rdr.GetBoolean("Sat_Eve_Call")
        newObj.IsSundayDayCall = rdr.GetBoolean("Sun_Day_Call")
        newObj.IsSundayEveCall = rdr.GetBoolean("Sun_Eve_Call")
        newObj.IsCallBackOtherLang = rdr.GetBoolean("CallBackOtherLang")
        newObj.IsCallBackUsingTTY = rdr.GetBoolean("CallbackUsingTTY")
        newObj.IsAcceptPartial = rdr.GetBoolean("AcceptPartial")
        newObj.IsEmailBlast = rdr.GetBoolean("SendEmailBlast")

        If rdr.IsDBNull("MMMailingStep_id") Then
            'Set it to itself
            newObj.LinkedStep = newObj
        Else
            'Find linked step and reference it
            If Not stepIndex.ContainsKey(rdr.GetInteger("MMMailingStep_id")) Then
                Throw New DataAccessException(String.Format("Methodology Step {0} cannot be found in the methodology.", rdr.GetInteger("MMMailingStep_id")))
            Else
                newObj.LinkedStep = stepIndex(rdr.GetInteger("MMMailingStep_id"))
            End If
        End If
        newObj.StepMethodId = Convert.ToInt32(rdr.GetByte("MailingStepMethod_id"))
        newObj.ExpirationDays = rdr.GetInteger("ExpireInDays")

        Dim expireStepId As Integer = rdr.GetInteger("ExpireFromStep")
        If Not stepIndex.ContainsKey(expireStepId) Then
            Throw New DataAccessException(String.Format("Methodology Step {0} cannot be found in the methodology.", expireStepId))
        Else
            newObj.ExpireFromStep = stepIndex(expireStepId)
        End If

        newObj.ResetDirtyFlag()
        Return newObj
    End Function

    ''' <summary>
    ''' Populates a MethodologyStepType from a DataReader
    ''' </summary>
    Private Function PopulateMethodologyStepType(ByVal rdr As SafeDataReader) As MethodologyStepType
        Dim newObj As MethodologyStepType = CreateMethodologyStepType( _
                                            rdr.GetInteger("MethodologyStepTypeId"), _
                                            rdr.GetBoolean("bitSendSurvey"), _
                                            rdr.GetBoolean("bitThankYouItem"), _
                                            rdr.GetString("strMailingStep_nm"), _
                                            rdr.GetInteger("MailingStepMethod_id"), _
                                            rdr.GetBoolean("CoverLetterRequired"), _
                                            rdr.GetInteger("ExpireInDays"), _
                                            rdr.GetNullableInteger("Quota_ID"), _
                                            rdr.GetInteger("QuotaStopCollectionAt"), _
                                            rdr.GetInteger("DaysInField"), _
                                            rdr.GetInteger("NumberOfAttempts"), _
                                            rdr.GetBoolean("WeekDay_Day_Call"), _
                                            rdr.GetBoolean("WeekDay_Eve_Call"), _
                                            rdr.GetBoolean("Sat_Day_Call"), _
                                            rdr.GetBoolean("Sat_Eve_Call"), _
                                            rdr.GetBoolean("Sun_Day_Call"), _
                                            rdr.GetBoolean("Sun_Eve_Call"), _
                                            rdr.GetBoolean("CallBackOtherLang"), _
                                            rdr.GetBoolean("CallbackUsingTTY"), _
                                            rdr.GetBoolean("AcceptPartial"), _
                                            rdr.GetBoolean("SendEmailBlast"))

        Return newObj
    End Function

    ''' <summary>
    ''' Populates a StandardMethodology from a DataReader
    ''' </summary>
    Private Function PopulateStandardMethodology(ByVal rdr As SafeDataReader) As StandardMethodology
        Dim newObj As StandardMethodology = CreateStandardMethodology( _
                                rdr.GetInteger("StandardMethodologyId"), _
                                rdr.GetString("strStandardMethodology_nm"), _
                                rdr.GetBoolean("bitCustom"))

        Return newObj
    End Function
#End Region

    Public Overrides Function [Select](ByVal methodologyId As Integer) As Methodology
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMethodology, methodologyId)

        'Get the Methodology
        Dim meth As Methodology
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                meth = PopulateMethodology(rdr)
            Else
                Return Nothing
            End If
        End Using

        'Now get all the steps for the methodology
        If meth IsNot Nothing Then
            Dim steps As MethodologyStepCollection = SelectMethodologyStepsByMethodologyId(meth.Id)
            For Each methStep As MethodologyStep In steps
                'For each step, get all of the email blasts
                Dim eblasts As EmailBlastCollection = EmailBlast.GetByMAILINGSTEPId(methStep.Id)
                For Each eblast As EmailBlast In eblasts
                    methStep.EmailBlastList.Add(eblast)
                Next
                'For each step, get the vovici survey id
                Dim details As VendorFile_VoviciDetailCollection = VendorFile_VoviciDetail.GetByMailingStepId(methStep.Id)
                If details.Count > 0 Then
                    'Expecting only 1 item in collection, ignore the rest
                    methStep.VendorVoviciDetail = details.Item(0)
                End If
                methStep.ResetDirtyFlag()
                meth.MethodologySteps.Add(methStep)
            Next
            meth.MethodologySteps.ResetDirtyFlag()
        End If

        Return meth
    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As System.Collections.ObjectModel.Collection(Of Methodology)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMethodologiesBySurveyId, surveyId)

        'Gets all the Methodologies
        Dim list As New Collection(Of Methodology)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            list = PopulateCollection(Of Methodology)(rdr, AddressOf PopulateMethodology)
        End Using

        'For each methodology, get all the steps
        For Each meth As Methodology In list
            Dim steps As MethodologyStepCollection = SelectMethodologyStepsByMethodologyId(meth.Id)
            For Each methStep As MethodologyStep In steps
                'For each step, get all of the email blasts
                Dim eblasts As EmailBlastCollection = EmailBlast.GetByMAILINGSTEPId(methStep.Id)
                For Each eblast As EmailBlast In eblasts
                    methStep.EmailBlastList.Add(eblast)
                Next
                'For each step, get the vovici survey id
                Dim details As VendorFile_VoviciDetailCollection = VendorFile_VoviciDetail.GetByMailingStepId(methStep.Id)
                If details.Count > 0 Then
                    'Expecting only 1 item in collection, ignore the rest
                    methStep.VendorVoviciDetail = details.Item(0)
                End If
                methStep.ResetDirtyFlag()
                meth.MethodologySteps.Add(methStep)
            Next
            meth.MethodologySteps.ResetDirtyFlag()
        Next

        Return list
    End Function

    Public Overrides Function SelectMethodologyStepsByMethodologyId(ByVal methodologyId As Integer) As MethodologyStepCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMethodologyStepsByMethodologyId, methodologyId)

        Dim stepCollection As New MethodologyStepCollection
        Dim stepIndex As New Dictionary(Of Integer, MethodologyStep)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                stepCollection.Add(PopulateMethodologyStep(rdr, stepIndex))
            End While
        End Using

        Return stepCollection
    End Function

    Public Overrides Function SelectStandardMethodologySteps(ByVal standardMethodologyId As Integer) As MethodologyStepCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStandardMethodologySteps, standardMethodologyId)

        Dim stepCollection As New MethodologyStepCollection
        Dim stepIndex As New Dictionary(Of Integer, MethodologyStep)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                stepCollection.Add(PopulateStandardMethodologyStep(rdr, stepIndex))
            End While
        End Using

        Return stepCollection
    End Function

    Public Overrides Function SelectAllMethodologyStepTypes() As System.Collections.ObjectModel.Collection(Of MethodologyStepType)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllMethodologyStepTypes)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MethodologyStepType)(rdr, AddressOf PopulateMethodologyStepType)
        End Using
    End Function

    Public Overrides Function SelectStandardMethodology(ByVal standardMethodologyId As Integer) As StandardMethodology
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStandardMethodology, standardMethodologyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateStandardMethodology(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    'Public Overrides Function SelectStandardMethodologiesBySurveyType(ByVal srvyType As SurveyTypes) As System.Collections.ObjectModel.Collection(Of StandardMethodology)
    '    Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStandardMethodologiesBySurveyTypeId, srvyType, Nothing)

    '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
    '        Return PopulateCollection(Of StandardMethodology)(rdr, AddressOf PopulateStandardMethodology)
    '    End Using
    'End Function

    Public Overrides Function SelectStandardMethodologiesBySurveyType(ByVal srvyType As SurveyTypes, ByVal subType As SubType) As System.Collections.ObjectModel.Collection(Of StandardMethodology)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectStandardMethodologiesBySurveyTypeId, srvyType, SubType.SubTypeId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of StandardMethodology)(rdr, AddressOf PopulateStandardMethodology)
        End Using
    End Function

    Public Overrides Function SelectMethodologyStep(ByVal Id As Integer) As MethodologyStep
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMethodologyStep, Id)
        Dim stepIndex As New Dictionary(Of Integer, MethodologyStep)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Dim methStep As MethodologyStep = PopulateMethodologyStep(rdr, stepIndex)
                Dim eblasts As EmailBlastCollection = EmailBlast.GetByMAILINGSTEPId(methStep.Id)
                For Each eblast As EmailBlast In eblasts
                    methStep.EmailBlastList.Add(eblast)
                Next
                Dim details As VendorFile_VoviciDetailCollection = VendorFile_VoviciDetail.GetByMailingStepId(methStep.Id)
                If details.Count > 0 Then
                    'Expecting only 1 item in collection, ignore the rest
                    methStep.VendorVoviciDetail = details.Item(0)
                End If
                methStep.ResetDirtyFlag()

                Return methStep
            End If
        End Using
    End Function

    Public Overrides Function Insert(ByVal meth As Methodology) As Integer
        Using conn As DbConnection = Db.CreateConnection
            conn.Open()
            Dim cmd As DbCommand
            Using tran As DbTransaction = conn.BeginTransaction
                cmd = Db.GetStoredProcCommand(SP.InsertMethodology, meth.SurveyId, meth.Name, meth.StandardMethodologyId)
                Try
                    'Insert the methodology
                    Dim methodologyId As Integer = ExecuteInteger(cmd, tran)

                    'Update the object with the new id
                    ReadOnlyAccessor.MethodologyId(meth) = methodologyId

                    'Insert each of the methodology steps
                    Dim stepId As Integer
                    For Each methStep As MethodologyStep In meth.MethodologySteps
                        'Update properties on step
                        methStep.MethodologyId = methodologyId
                        methStep.SurveyId = meth.SurveyId

                        Dim params(28) As Object
                        params(0) = methodologyId
                        params(1) = meth.SurveyId
                        params(2) = methStep.SequenceNumber
                        params(3) = methStep.CoverLetterId
                        params(4) = methStep.IsSurvey
                        params(5) = methStep.DaysSincePreviousStep
                        params(6) = methStep.IsThankYouLetter
                        params(7) = methStep.Name
                        params(8) = methStep.IsFirstSurvey
                        params(9) = GetNullableParam(Of Integer)(methStep.OverrideLanguageId)
                        params(10) = methStep.LinkedStepId
                        params(11) = methStep.StepMethodId
                        params(12) = methStep.ExpirationDays
                        params(13) = methStep.ExpireFromStepId
                        params(14) = GetNullableParam(Of Integer)(methStep.QuotaID)
                        params(15) = methStep.QuotaStopCollectionAt
                        params(16) = methStep.DaysInField
                        params(17) = methStep.NumberOfAttempts
                        params(18) = methStep.IsWeekDayDayCall
                        params(19) = methStep.IsWeekDayEveCall
                        params(20) = methStep.IsSaturdayDayCall
                        params(21) = methStep.IsSaturdayEveCall
                        params(22) = methStep.IsSundayDayCall
                        params(23) = methStep.IsSundayEveCall
                        params(24) = methStep.IsCallBackOtherLang
                        params(25) = methStep.IsCallBackUsingTTY
                        params(26) = methStep.IsAcceptPartial
                        params(27) = methStep.IsEmailBlast
                        params(28) = GetNullableParam(Of Integer)(methStep.VendorID)
                        cmd = Db.GetStoredProcCommand(SP.InsertMethodologyStep, params)
                        stepId = ExecuteInteger(cmd, tran)

                        'Update ID on step
                        ReadOnlyAccessor.MethodologyStepId(methStep) = stepId

                        'Save Step's Email Blast Information
                        Dim eBlastId As Integer
                        For Each eblast As EmailBlast In methStep.EmailBlastList
                            Dim blastparams(3) As Object
                            eblast.MAILINGSTEPId = stepId
                            blastparams(0) = eblast.MAILINGSTEPId
                            blastparams(1) = eblast.EmailBlastId
                            blastparams(2) = eblast.DaysFromStepGen
                            blastparams(3) = GetNullableParam(Of Date)(eblast.DateSent)

                            cmd = Db.GetStoredProcCommand(SP.InsertEmailBlast, blastparams)
                            eBlastId = ExecuteInteger(cmd, tran)

                            Dim privateInterface As IEmailBlast = eblast
                            privateInterface.Id = eBlastId
                        Next

                        'Save the Vovici Survey Data
                        Dim vendorFileId As Integer
                        If methStep.VendorVoviciDetail IsNot Nothing Then
                            Dim voviciparams(3) As Object
                            With methStep.VendorVoviciDetail
                                .MailingStepId = stepId
                                .SurveyId = methStep.SurveyId

                                voviciparams(0) = .SurveyId
                                voviciparams(1) = .MailingStepId
                                voviciparams(2) = .VoviciSurveyId
                                voviciparams(3) = .VoviciSurveyName
                            End With

                            cmd = Db.GetStoredProcCommand(SP.InsertVendorFile_VoviciDetail, voviciparams)
                            vendorFileId = ExecuteInteger(cmd, tran)

                            Dim privateInterface As IVendorFile_VoviciDetail = methStep.VendorVoviciDetail
                            privateInterface.VendorFile_VoviciDetailId = vendorFileId
                        End If

                        methStep.ResetDirtyFlag()
                    Next
                    meth.MethodologySteps.ResetDirtyFlag()
                    meth.ResetDirtyFlag()
                    tran.Commit()
                    Return methodologyId
                Catch ex As Exception
                    tran.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Function

    Public Overrides Sub Update(ByVal meth As Methodology)
        Using conn As DbConnection = Db.CreateConnection
            conn.Open()
            Dim cmd As DbCommand
            Using tran As DbTransaction = conn.BeginTransaction
                cmd = Db.GetStoredProcCommand(SP.UpdateMethodology, meth.Id, meth.SurveyId, meth.Name, meth.StandardMethodologyId)
                Try
                    'Update the methodology record
                    ExecuteNonQuery(cmd, tran)

                    'Delete any previous steps
                    cmd = Db.GetStoredProcCommand(SP.DeleteMethodologyStepsByMethodologyId, meth.Id)
                    ExecuteNonQuery(cmd, tran)

                    'Re-insert each methodology
                    Dim stepId As Integer
                    For Each methStep As MethodologyStep In meth.MethodologySteps
                        'Need to reset methodology id since we deleted existing steps
                        'This ensures that step linkings to same step are sent to db properly
                        ReadOnlyAccessor.MethodologyStepId(methStep) = 0
                        Dim params(28) As Object
                        params(0) = meth.Id
                        params(1) = meth.SurveyId
                        params(2) = methStep.SequenceNumber
                        params(3) = methStep.CoverLetterId
                        params(4) = methStep.IsSurvey
                        params(5) = methStep.DaysSincePreviousStep
                        params(6) = methStep.IsThankYouLetter
                        params(7) = methStep.Name
                        params(8) = methStep.IsFirstSurvey
                        params(9) = GetNullableParam(Of Integer)(methStep.OverrideLanguageId)
                        params(10) = methStep.LinkedStepId
                        params(11) = methStep.StepMethodId
                        params(12) = methStep.ExpirationDays
                        params(13) = methStep.ExpireFromStepId
                        params(14) = GetNullableParam(Of Integer)(methStep.QuotaID)
                        params(15) = methStep.QuotaStopCollectionAt
                        params(16) = methStep.DaysInField
                        params(17) = methStep.NumberOfAttempts
                        params(18) = methStep.IsWeekDayDayCall
                        params(19) = methStep.IsWeekDayEveCall
                        params(20) = methStep.IsSaturdayDayCall
                        params(21) = methStep.IsSaturdayEveCall
                        params(22) = methStep.IsSundayDayCall
                        params(23) = methStep.IsSundayEveCall
                        params(24) = methStep.IsCallBackOtherLang
                        params(25) = methStep.IsCallBackUsingTTY
                        params(26) = methStep.IsAcceptPartial
                        params(27) = methStep.IsEmailBlast
                        params(28) = GetNullableParam(Of Integer)(methStep.VendorID)
                        cmd = Db.GetStoredProcCommand(SP.InsertMethodologyStep, params)
                        stepId = ExecuteInteger(cmd, tran)

                        'Update ID on step
                        ReadOnlyAccessor.MethodologyStepId(methStep) = stepId

                        'Save Step's Email Blast Information
                        Dim eBlastId As Integer
                        For Each eblast As EmailBlast In methStep.EmailBlastList
                            Dim blastparams(3) As Object
                            eblast.MAILINGSTEPId = stepId
                            blastparams(0) = eblast.MAILINGSTEPId
                            blastparams(1) = eblast.EmailBlastId
                            blastparams(2) = eblast.DaysFromStepGen
                            blastparams(3) = GetNullableParam(Of Date)(eblast.DateSent)
                            cmd = Db.GetStoredProcCommand(SP.InsertEmailBlast, blastparams)
                            eBlastId = ExecuteInteger(cmd, tran)

                            Dim privateInterface As IEmailBlast = eblast
                            privateInterface.Id = eBlastId
                        Next

                        'Save the Vovici Survey Data
                        Dim vendorFileId As Integer
                        If methStep.VendorVoviciDetail IsNot Nothing Then
                            Dim voviciparams(3) As Object
                            With methStep.VendorVoviciDetail
                                .MailingStepId = stepId
                                .SurveyId = methStep.SurveyId

                                voviciparams(0) = .SurveyId
                                voviciparams(1) = .MailingStepId
                                voviciparams(2) = .VoviciSurveyId
                                voviciparams(3) = .VoviciSurveyName
                            End With

                            cmd = Db.GetStoredProcCommand(SP.InsertVendorFile_VoviciDetail, voviciparams)
                            vendorFileId = ExecuteInteger(cmd, tran)

                            Dim privateInterface As IVendorFile_VoviciDetail = methStep.VendorVoviciDetail
                            privateInterface.VendorFile_VoviciDetailId = vendorFileId
                        End If

                        methStep.ResetDirtyFlag()
                    Next
                    meth.MethodologySteps.ResetDirtyFlag()
                    meth.ResetDirtyFlag()
                    tran.Commit()
                Catch ex As Exception
                    tran.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Public Overrides Sub UpdateActiveState(ByVal methodologyId As Integer, ByVal isActive As Boolean)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMethodologyActiveFlag, methodologyId, isActive)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub UpdateVendor(ByVal meth As Methodology)
        For Each methStep As MethodologyStep In meth.MethodologySteps
            Dim params(1) As Object
            params(0) = methStep.Id
            params(1) = GetNullableParam(Of Integer)(methStep.VendorID)
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMethodologyStepVendor, params)
            ExecuteNonQuery(cmd)

            'Save the Vovici Survey Data
            If methStep.VendorVoviciDetail IsNot Nothing Then
                With methStep.VendorVoviciDetail
                    .MailingStepId = methStep.Id
                    .SurveyId = methStep.SurveyId
                    .Save()
                End With
            End If

            methStep.ResetDirtyFlag()
        Next
        meth.MethodologySteps.ResetDirtyFlag()
        meth.ResetDirtyFlag()
    End Sub

    Public Overrides Sub Delete(ByVal methodologyId As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMethodology, methodologyId)
        ExecuteNonQuery(cmd)
    End Sub

End Class
