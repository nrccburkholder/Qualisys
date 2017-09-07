
Imports Nrc.Framework.Data
Imports Nrc.QualiSys.Library

Public Class MedicareSurveyTypeProvider
    Inherits DataProvider.MedicareSurveyTypeProvider

    Private mGlobalDef As MedicareGlobalCalculationDefault

    Public ReadOnly Property GlobalDef As MedicareGlobalCalculationDefault
        Get
            If mGlobalDef Is Nothing Then
                mGlobalDef = MedicareGlobalCalculationDefault.GetAll()(0)
            End If
            Return mGlobalDef
        End Get
    End Property

#Region "Populate Method"

    Private Function PopulateMedicareSurveyType(ByVal rdr As SafeDataReader) As MedicareSurveyType
        Dim newMedicareNumber As MedicareNumber = MedicareNumber.NewMedicareNumber(GlobalDef)
        newMedicareNumber.MedicareNumber = rdr.GetString("MedicareNumber")
        newMedicareNumber.Name = rdr.GetString("MedicareName")

        Dim newObj As MedicareSurveyType = MedicareSurveyType.NewMedicareSurveyType(GlobalDef, newMedicareNumber, rdr.GetInteger("SurveyTypeID"))
        newObj.BeginPopulate()
        newObj.MedicareNumber = rdr.GetString("MedicareNumber")
        newObj.Name = rdr.GetString("MedicareName")
        newObj.SurveyTypeID = rdr.GetInteger("SurveyTypeID")

        newObj.EstAnnualVolume = rdr.GetInteger("EstAnnualVolume")
        newObj.EstResponseRate = rdr.GetDecimal("EstRespRate")
        newObj.SwitchToCalcDate = rdr.GetDate("SwitchToCalcDate")
        If DateTime.Compare(newObj.SwitchToCalcDate, #1/1/1900#) < 0 Then
            Dim quarterNumber As Integer = (Date.Now().Month() - 1) \ 3 + 1
            Dim firstDayOfQuarterNextYear As New DateTime(Date.Now().Year + 1, (quarterNumber - 1) * 3 + 1, 1)
            newObj.SwitchToCalcDate = firstDayOfQuarterNextYear
        End If
        newObj.AnnualReturnTarget = rdr.GetInteger("AnnualReturnTarget")
        If rdr.GetByte("SamplingLocked") = 0 Then
            newObj.SamplingLocked = False
        Else
            newObj.SamplingLocked = True
        End If
        newObj.ProportionChangeThreshold = rdr.GetDecimal("ProportionChangeThreshold")
        newObj.IsActive = rdr.GetBoolean("Active")
        newObj.NonSubmitting = rdr.GetBoolean("NonSubmitting")

        newObj.SwitchFromRateOverrideDate = rdr.GetDate("SwitchFromRateOverrideDate")
        If DateTime.Compare(newObj.SwitchFromRateOverrideDate, #1/1/1900#) < 0 Then
            newObj.SwitchFromRateOverrideDate = New Date(1900, 1, 1)
        End If

        newObj.SamplingRateOverride = rdr.GetDecimal("SamplingRateOverride")

        newObj.EndPopulate()

        Return newObj

    End Function

#End Region

#Region "Overrides"

    Public Overrides Function [Select](ByVal medicareNumber As String, ByVal surveyTypeID As Integer) As MedicareSurveyType

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectMedicareSurveyType, medicareNumber, surveyTypeID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMedicareSurveyType(rdr)
            Else
                Return Nothing
            End If
        End Using

    End Function

    Public Overrides Sub Insert(ByVal medicareSurveyType As MedicareSurveyType)

        Dim samplingLocked As Byte

        If medicareSurveyType.SamplingLocked Then
            samplingLocked = 1
        Else
            samplingLocked = 0
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertMedicareSurveyType, medicareSurveyType.MedicareNumber, medicareSurveyType.SurveyTypeID,
                                                       medicareSurveyType.EstAnnualVolume, medicareSurveyType.EstResponseRate, medicareSurveyType.SwitchToCalcDate,
                                                       medicareSurveyType.AnnualReturnTarget, samplingLocked, medicareSurveyType.ProportionChangeThreshold,
                                                       medicareSurveyType.IsActive, medicareSurveyType.NonSubmitting,
                                                       medicareSurveyType.SwitchFromRateOverrideDate, medicareSurveyType.SamplingRateOverride
                                )
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub Update(ByVal medicareSurveyType As MedicareSurveyType)

        Dim samplingLocked As Byte

        If medicareSurveyType.SamplingLocked Then
            samplingLocked = 1
        Else
            samplingLocked = 0
        End If

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateMedicareSurveyType, medicareSurveyType.MedicareNumber, medicareSurveyType.SurveyTypeID,
                                                       medicareSurveyType.EstAnnualVolume, medicareSurveyType.EstResponseRate, medicareSurveyType.SwitchToCalcDate,
                                                       medicareSurveyType.AnnualReturnTarget, samplingLocked, medicareSurveyType.ProportionChangeThreshold,
                                                       medicareSurveyType.IsActive, medicareSurveyType.NonSubmitting,
                                                       medicareSurveyType.SwitchFromRateOverrideDate, medicareSurveyType.SamplingRateOverride
                               )
        ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub Delete(ByVal medicareNumber As String, ByVal surveyTypeID As Integer)

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteMedicareSurveyType, medicareNumber, surveyTypeID)
        ExecuteNonQuery(cmd)

    End Sub

#End Region

End Class
