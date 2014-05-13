Option Explicit On 
Option Strict On

'======================================================================================
' Name:     Wizard
' Purpose:  Encapsulate the general functionality of a wizard.
'======================================================================================
' Usage:    (See frmTest for example)
'       Create a new form.
'       Add Back and Next Command Buttons.
'       Add Frame controls for each step. (Call them all fraStep, and make them a control array.)
'       Add other controls for each step.

'       Add the line, "Private WithEvents m_Wizard as CWizard",
'       to the declarations section of code.

'       Instance m_Wizard in Form_Load. (Set m_Wizard = New CWizard)
'       Set m_Wizard.StepCount = number of steps you want.
'       Set m_Wizard.Step = 0 (This will call the display step event).

'       Destroy m_Wizard in Form_Unload. (Set m_Wizard = Nothing)

'       Add "m_Wizard.MoveNext", in Next button click event handler.
'       Add "m_Wizard.MoveBack", in Back button click event handler.

'       Add code to show fraStep(m_Wizard.Step) and change buttons etc
'       in m_Wizard_DisplayStep event handler.

'       Add validation code in "m_Wizard_Validate" to check user input.
'       Set CancelMove = True to stop move if input is bad.
'       Also, add code to do 'stuff' here. Open files, run functions, etc.

'       Add code to the "m_Wizard_Finish" event handler, eg close form.
'======================================================================================

Public Class Wizard

#Region "Public Events"

    Public Event Validate(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
    Public Event DisplayStep(ByVal currentStep As Integer, ByVal page As Object)
    Public Event Finish()

#End Region

#Region "Private Members"

    Private mStep As Integer   ' Range: 0 To StepCount - 1
    Private mStepCount As Integer
    Private mStepPage() As Object

#End Region

#Region "Public Properties"

    ' --- Step ---
    Public Property CurrentStep() As Integer
        Get
            Return (mStep)
        End Get
        Set(ByVal Value As Integer)
            If Value < 0 Or Value >= mStepCount Then
                Return
            Else
                mStep = Value
                RaiseEvent DisplayStep(mStep, mStepPage(mStep))
            End If
        End Set
    End Property
    ' --- End Step ---

    ' --- StepCount ---
    Public Property StepCount() As Integer
        Get
            Return (mStepCount)
        End Get
        Set(ByVal Value As Integer)
            If Value < 0 Then
                Exit Property
            Else
                mStepCount = Value
            End If
        End Set
    End Property
    ' --- End StepCount ---

    Public Property StepPage() As Object()
        Get
            Return (mStepPage)
        End Get
        Set(ByVal Value As Object())
            mStepPage = Value
        End Set
    End Property

#End Region

#Region "Public Methods"

    Public Sub New(ByVal steps As Integer)
        StepCount = steps
    End Sub

    Public Sub New()
    End Sub

    Public Sub MoveNext()
        Dim bCancel As Boolean

        RaiseEvent Validate(mStep, bCancel) ' bCancel might be changed by event_proc.
        If bCancel Then ' If set to true then cancel the move.
            Exit Sub
        Else
            ' Next step
            mStep = mStep + 1
            If mStep >= mStepCount Then
                RaiseEvent Finish()
                mStep = mStepCount - 1 ' Don't move on.
                Exit Sub
            End If

            RaiseEvent DisplayStep(mStep, mStepPage(mStep))
            ' Let owner update display for new step.
        End If
    End Sub

    Public Sub MoveBack()
        mStep = mStep - 1
        If mStep < 0 Then mStep = 0 ' Can't go back any more!
        RaiseEvent DisplayStep(mStep, mStepPage(mStep))
    End Sub

#End Region

End Class
