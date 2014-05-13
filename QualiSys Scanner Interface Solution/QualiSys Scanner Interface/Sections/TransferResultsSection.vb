Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsSection

#Region " Private Members "

    Private mSubSection As Section
    Private mVendorSection As TransferResultsVendorSection
    Private mFileSection As TransferResultsFileSection
    Private mSurveySection As TransferResultsSurveySection
    Private mErrorCodes As ErrorCodeCollection

    Private WithEvents mNavControl As TransferResultsNavigator

#End Region

#Region " Private Properties "

    Private ReadOnly Property ErrorCodes() As ErrorCodeCollection
        Get
            If mErrorCodes Is Nothing Then
                mErrorCodes = ErrorCode.GetAll
            End If

            Return mErrorCodes
        End Get
    End Property

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        mNavControl.PopulateTree(True)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mSubSection Is Nothing Then
            Return True
        Else
            Return mSubSection.AllowInactivate
        End If

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavControl = DirectCast(navCtrl, TransferResultsNavigator)

    End Sub

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mVendorSection = New TransferResultsVendorSection(ErrorCodes)
        mFileSection = New TransferResultsFileSection(ErrorCodes)
        mSurveySection = New TransferResultsSurveySection(ErrorCodes)

    End Sub

#End Region

#Region " Navigator Events "

    Private Sub mNavControl_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavControl.SelectedNodeChanging

        e.Cancel = Not AllowInactivate()

    End Sub

    Private Sub mNavControl_SelectedNodeChanged(ByVal sender As Object, ByVal e As SelectedNodeChangedEventArgs) Handles mNavControl.SelectedNodeChanged

        Dim oldSection As Section = mSubSection

        'Create the new control
        If TypeOf e.Node Is TransferResultsVendorNode Then
            'Create a new Vendor Section
            mVendorSection.InitializeSection(DirectCast(e.Node, TransferResultsVendorNode))
            mSubSection = mVendorSection
        ElseIf TypeOf e.Node Is TransferResultsFileNode Then
            'Create a new File Section
            mFileSection.InitializeSection(DirectCast(e.Node, TransferResultsFileNode))
            mSubSection = mFileSection
        ElseIf TypeOf e.Node Is TransferResultsSurveyNode Then
            'Create a new Survey Section
            mSurveySection.InitializeSection(DirectCast(e.Node, TransferResultsSurveyNode))
            mSubSection = mSurveySection
        End If

        'Display the new control
        If oldSection Is Nothing OrElse (oldSection.GetType IsNot mSubSection.GetType) Then
            Controls.Clear()
            mSubSection.Dock = DockStyle.Fill
            Controls.Add(mSubSection)
        End If

    End Sub

#End Region

#Region " Private Methods "

#End Region

End Class
