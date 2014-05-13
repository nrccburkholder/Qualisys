Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class PropCalcHistory

#Region "Private Members"

    Private mMedicareNumber As MedicareNumber

#End Region

#Region "Constructors"

    Public Sub New(ByVal medicareNum As MedicareNumber)

        InitializeComponent()

        mMedicareNumber = medicareNum

    End Sub

#End Region

#Region "Event Handlers"

    Private Sub PropCalcHistory_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Caption = String.Format("Recalc History for: {0} ({1})", mMedicareNumber.MedicareNumber, mMedicareNumber.Name)

        Dim url As New Uri(String.Format("{0}&MedicareNumber={1}", AppConfig.Params("CMRecalcHistoryReport").StringValue, mMedicareNumber.MedicareNumber))
        wbReport.Url = url

    End Sub

    Private Sub cmdClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClose.Click

        Close()

    End Sub

#End Region

End Class
