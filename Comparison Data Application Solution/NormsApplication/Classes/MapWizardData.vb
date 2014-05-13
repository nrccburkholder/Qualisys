Option Explicit On 
Option Strict On

Public Class MapWizardData

    Shared DEFAULT_UNVISIT_COLOR As Color = Color.LightGray
    Shared DEFAULT_VISITED_COLOR As Color = Color.Gray
    Shared DEFAULT_CURRENT_STEP_COLOR As Color = Color.Lime

#Region " Private Fields"

    Private mStepID As Integer
    Private mStepBox As Panel
    Private mStepLabel As Label
    Private mEnableCancelButton As Boolean
    Private mEnableBackButton As Boolean
    Private mEnableNextButton As Boolean
    Private mEnableFinishButton As Boolean
    Private mCancelButtonText As String
    Private mBackButtonText As String
    Private mNextButtonText As String
    Private mFinishButtonText As String
    Private mUnvisitColor As Color
    Private mVisitedColor As Color
    Private mCurrentStepColor As Color
    Private mVisited As Boolean = False
    Private mIsCurrentStep As Boolean = False

#End Region

#Region " Public Properties"

    Public ReadOnly Property StepID() As Integer
        Get
            Return Me.mStepID
        End Get
    End Property

    Public ReadOnly Property StepBox() As Panel
        Get
            Return Me.mStepBox
        End Get
    End Property

    Public ReadOnly Property StepLabel() As Label
        Get
            Return Me.mStepLabel
        End Get
    End Property

    Public ReadOnly Property EnableCancelButton() As Boolean
        Get
            Return Me.mEnableCancelButton
        End Get
    End Property

    Public ReadOnly Property EnableBackButton() As Boolean
        Get
            Return Me.mEnableBackButton
        End Get
    End Property

    Public ReadOnly Property EnableNextButton() As Boolean
        Get
            Return Me.mEnableNextButton
        End Get
    End Property

    Public ReadOnly Property EnableFinishButton() As Boolean
        Get
            Return Me.mEnableFinishButton
        End Get
    End Property

    Public ReadOnly Property CancelButtonText() As String
        Get
            Return Me.mCancelButtonText
        End Get
    End Property

    Public ReadOnly Property BackButtonText() As String
        Get
            Return Me.mBackButtonText
        End Get
    End Property

    Public ReadOnly Property NextButtonText() As String
        Get
            Return Me.mNextButtonText
        End Get
    End Property

    Public ReadOnly Property FinishButtonText() As String
        Get
            Return Me.mFinishButtonText
        End Get
    End Property

    Public Property Visited() As Boolean
        Get
            Return Me.mVisited
        End Get
        Set(ByVal Value As Boolean)
            Me.mVisited = Value
        End Set
    End Property

    Public Property IsCurrentStep() As Boolean
        Get
            Return Me.mIsCurrentStep
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsCurrentStep = Value
        End Set
    End Property

    Public ReadOnly Property StepBoxColor() As Color
        Get
            If (Me.IsCurrentStep) Then
                Return Me.mCurrentStepColor
            ElseIf (Me.Visited) Then
                Return Me.mVisitedColor
            Else
                Return Me.mUnvisitColor
            End If
        End Get
    End Property

    Public ReadOnly Property StepLabelFont() As Font
        Get
            If IsCurrentStep Then
                Return New Font(mStepLabel.Font.Name, mStepLabel.Font.Size, FontStyle.Bold)
            Else
                Return New Font(mStepLabel.Font.Name, mStepLabel.Font.Size, FontStyle.Regular)
            End If
        End Get
    End Property
#End Region

#Region " Public Methods"

    Public Sub New(ByVal stepID As Integer, _
                   ByVal stepBox As Panel, _
                   ByVal stepLabel As Label, _
                   ByVal enableCancelButton As Boolean, _
                   ByVal enableBackButton As Boolean, _
                   ByVal enableNextButton As Boolean, _
                   ByVal enableFinishButton As Boolean, _
                   ByVal cancelButtonText As String, _
                   ByVal backButtonText As String, _
                   ByVal nextButtonText As String, _
                   ByVal finishButtonText As String, _
                   ByVal unvisitColor As Color, _
                   ByVal visitedColor As Color, _
                   ByVal currentStepColor As Color)

        Me.mStepID = stepID
        Me.mStepBox = stepBox
        Me.mStepLabel = stepLabel
        Me.mEnableCancelButton = enableCancelButton
        Me.mEnableBackButton = enableBackButton
        Me.mEnableNextButton = enableNextButton
        Me.mEnableFinishButton = enableFinishButton
        Me.mCancelButtonText = cancelButtonText
        Me.mBackButtonText = backButtonText
        Me.mNextButtonText = nextButtonText
        Me.mFinishButtonText = finishButtonText
        Me.mUnvisitColor = unvisitColor
        Me.mVisitedColor = visitedColor
        Me.mCurrentStepColor = currentStepColor

    End Sub

    Public Sub New(ByVal stepID As Integer, _
                   ByVal stepBox As Panel, _
                   ByVal stepLabel As Label, _
                   ByVal enableCancelButton As Boolean, _
                   ByVal enableBackButton As Boolean, _
                   ByVal enableNextButton As Boolean, _
                   ByVal enableFinishButton As Boolean, _
                   ByVal cancelButtonText As String, _
                   ByVal backButtonText As String, _
                   ByVal nextButtonText As String, _
                   ByVal finishButtonText As String)

        Me.New(stepID, _
               stepBox, _
               stepLabel, _
               enableCancelButton, _
               enableBackButton, _
               enableNextButton, _
               enableFinishButton, _
               cancelButtonText, _
               backButtonText, _
               nextButtonText, _
               finishButtonText, _
               DEFAULT_UNVISIT_COLOR, _
               DEFAULT_VISITED_COLOR, _
               DEFAULT_CURRENT_STEP_COLOR)

    End Sub

    Public Sub New(ByVal stepID As Integer, _
                   ByVal stepBox As Panel, _
                   ByVal stepLabel As Label, _
                   ByVal enableCancelButton As Boolean, _
                   ByVal enableBackButton As Boolean, _
                   ByVal enableNextButton As Boolean, _
                   ByVal enableFinishButton As Boolean, _
                   ByVal cancelButtonText As String, _
                   ByVal backButtonText As String, _
                   ByVal nextButtonText As String, _
                   ByVal finishButtonText As String, _
                   ByVal unvisitColor As Color)

        Me.New(stepID, _
               stepBox, _
               stepLabel, _
               enableCancelButton, _
               enableBackButton, _
               enableNextButton, _
               enableFinishButton, _
               cancelButtonText, _
               backButtonText, _
               nextButtonText, _
               finishButtonText, _
               unvisitColor, _
               DEFAULT_VISITED_COLOR, _
               DEFAULT_CURRENT_STEP_COLOR)

    End Sub

    Public Sub Reset()
        Me.mVisited = False
        Me.mIsCurrentStep = False
    End Sub

#End Region

End Class
