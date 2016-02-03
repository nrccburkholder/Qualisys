Public Class ExportDefinitionLogSection
#Region " Fields "
    Friend WithEvents mExportDefLogNavigator As ExportDefinitionLogNavigator
    Private mExportDefLogCol As Nrc.SurveyPoint.Library.SPTI_ExportDefinitionLogCollection
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mExportDefLogNavigator = TryCast(navCtrl, ExportDefinitionLogNavigator)
    End Sub
    Public Overrides Sub ActivateSection()
        MyBase.ActivateSection()
        ' Add any initialization after the InitializeComponent() call.
        Me.mExportDefLogCol = Nrc.SurveyPoint.Library.SPTI_ExportDefinitionLog.GetAll
        Me.bsExportDefLog.DataSource = Me.mExportDefLogCol
    End Sub
#End Region
#Region " Constructors "
    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        'Me.mExportDefLogCol = Nrc.SurveyPoint.Library.SPTI_ExportDefinitionLog.GetAll
        'Me.bsExportDefLog.DataSource = Me.mExportDefLogCol
    End Sub
#End Region
#Region " Event Handlers "

#End Region
End Class
