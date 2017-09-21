Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class PropCalcHistory

#Region "Private Members"
    Private Const const_HCAHPS_SurveyTypeID As Integer = 2
    Private Const const_HHCAHPS_SurveyTypeID As Integer = 3
    Private Const const_OASCAHPS_SurveyTypeID As Integer = 16

    Private mMedicareNumber As MedicareNumber = Nothing
    Private mHHCAHPS_MedicareNumber As MedicareSurveyType = Nothing
    Private mOASCAHPS_MedicareNumber As MedicareSurveyType = Nothing
    Private mSurveyTypeID As Integer

#End Region

#Region "Public Properties"
    Public Property SurveyTypeID() As Integer
        Get
            Return mSurveyTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyTypeID Then
                mSurveyTypeID = value
            End If
        End Set
    End Property

#End Region

#Region "Constructors"

    Public Sub New(ByVal medicareNum As Object, Optional surveyTypeID As Integer = const_HCAHPS_SurveyTypeID)

        InitializeComponent()

        Select Case surveyTypeID
            Case const_HCAHPS_SurveyTypeID
                mMedicareNumber = CType(medicareNum, MedicareNumber)
            Case const_HHCAHPS_SurveyTypeID
                mHHCAHPS_MedicareNumber = CType(medicareNum, MedicareSurveyType)
            Case Else
                mOASCAHPS_MedicareNumber = CType(medicareNum, MedicareSurveyType)
        End Select

        mSurveyTypeID = surveyTypeID

    End Sub

#End Region

#Region "Event Handlers"

    Private Sub PropCalcHistory_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim medicareNumber As String
        Dim name As String

        Select Case SurveyTypeID
            Case const_HCAHPS_SurveyTypeID
                medicareNumber = mMedicareNumber.MedicareNumber
                name = mMedicareNumber.Name
            Case const_HHCAHPS_SurveyTypeID
                medicareNumber = mHHCAHPS_MedicareNumber.MedicareNumber
                name = mHHCAHPS_MedicareNumber.Name
            Case Else
                medicareNumber = mOASCAHPS_MedicareNumber.MedicareNumber
                name = mOASCAHPS_MedicareNumber.Name
        End Select

        Caption = String.Format("Recalc History for: {0} ({1})", medicareNumber, name)

        Dim url As New Uri(String.Format("{0}&MedicareNumber={1}&SurveyTypeID={2}", AppConfig.Params("CMRecalcHistoryReport").StringValue, medicareNumber, SurveyTypeID))

        wbReport.Url = url

    End Sub

    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click

        Close()

    End Sub

#End Region

End Class
