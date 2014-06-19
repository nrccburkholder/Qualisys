Partial Public NotInheritable Class SP

    Public Const SelectSurvey As String = "QCL_SelectSurvey"
    Public Const SelectSurveysByStudyId As String = "QCL_SelectSurveysByStudyId"
    Public Const SelectSurveysBySurveyTypeMailOnly As String = "QCL_SelectSurveysBySurveyTypeMailOnly"
    Public Const SelectSurveyTypes As String = "QCL_SelectSurveyTypes"
    Public Const SelectCAHPSTypes As String = "QCL_SelectCAHPSTypesBySurveyType" 'Normally this returns None and HCAHPS for HCAHPS, for example (could also return CHART)
    Public Const SelectSamplingAlgorithms As String = "QCL_SelectSamplingAlgorithms"
    Public Const SelectResurveyMethod As String = "QCL_SelectReSurveyMethod"
    Public Const IsSurveySampled As String = "QCL_IsSurveySampled"
    Public Const UpdateSurveyProperties As String = "QCL_UpdateSurvey"
    Public Const InsertSurvey As String = "QCL_InsertSurvey"
    Public Const InsertHCAHPSDQRules As String = "QCL_InsertHCAHPSDQRules"
    Public Const InsertHHCAHPSDQRules As String = "QCL_InsertHHCAHPSDQRules"
    Public Const InsertPhysEmpDQRules As String = "QCL_InsertPhysEmpDQRules"
    Public Const InsertDefaultDQRules As String = "QCL_InsertDefaultDQRules"
    Public Const DeleteHouseHoldingFieldsBySurveyId As String = "QCL_DeleteHouseHoldingFieldsBySurveyId"
    Public Const InsertHouseHoldingField As String = "QCL_InsertHouseHoldingField"
    Public Const AllowDeleteSurvey As String = "QCL_AllowDeleteSurvey"
    Public Const DeleteSurvey As String = "QCL_DeleteSurvey"
    Public Const ValidateSurvey As String = "QCL_ValidateSurvey"
    Public Const SelectSurveySubTypes As String = "QCL_SelectSurveySubTypes"
    Public Const SelectQuestionaireTypes As String = "QCL_SelectQuestionaireTypes"
    Public Const SelectSurveySubTypeBySubTypeID As String = "QCL_SelectSurveySubTypeBySubTypeID"

End Class
