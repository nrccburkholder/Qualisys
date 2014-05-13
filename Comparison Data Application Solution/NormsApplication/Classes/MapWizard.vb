Option Explicit On 
Option Strict On

Public Class MapWizard
    Inherits Wizard

    Public Overrides Property CurrentStep() As Integer
        Get
            Return (mStep)
        End Get
        Set(ByVal Value As Integer)
            If Value < 0 Or Value >= mStepCount Then
                Return
            End If

            Dim moveForward As Boolean = CBool(IIf(Value >= CurrentStep, True, False))
            Dim page As MapWizardData
            Dim i As Integer

            mStep = Value

            'Reset current page flag for all pages
            For i = 0 To mStepPage.Length - 1
                page = CType(mStepPage(i), MapWizardData)
                page.IsCurrentStep = False
            Next

            'Set current step flag
            page = CType(mStepPage(mStep), MapWizardData)
            page.IsCurrentStep = True

            TriggerDisplayStep(mStep, mStepPage(mStep), moveForward)
        End Set
    End Property

    Sub New()
        MyBase.New()
    End Sub

    Sub New(ByVal steps As MapWizardData())
        MyBase.New(steps)
    End Sub

    Public Overrides Sub MoveNext()
        Dim bCancel As Boolean
        Dim page As MapWizardData
        Dim i As Integer

        'Validate current page
        TriggerValidate(mStep, bCancel)
        If bCancel Then ' If set to true then cancel the move.
            Exit Sub
        End If

        'Set visited flag
        page = CType(mStepPage(mStep), MapWizardData)
        page.Visited = True

        'Next step
        mStep = mStep + 1
        If mStep >= mStepCount Then
            TriggerTerminate()
            mStep = mStepCount - 1 ' Don't move on.
            Exit Sub
        End If

        'Reset current page flag for all pages
        For i = 0 To mStepPage.Length - 1
            page = CType(mStepPage(i), MapWizardData)
            page.IsCurrentStep = False
        Next

        'Set current step flag
        page = CType(mStepPage(mStep), MapWizardData)
        page.IsCurrentStep = True

        TriggerDisplayStep(mStep, mStepPage(mStep), True)
        ' Let owner update display for new step.
    End Sub

    Public Overrides Sub MoveBack()
        Dim page As MapWizardData
        Dim i As Integer

        'Previous step
        mStep = mStep - 1
        If mStep < 0 Then mStep = 0 ' Can't go back any more!

        'Reset current page flag for all pages
        For i = 0 To mStepPage.Length - 1
            page = CType(mStepPage(i), MapWizardData)
            page.IsCurrentStep = False
        Next

        'Set current step flag
        page = CType(mStepPage(mStep), MapWizardData)
        page.IsCurrentStep = True

        TriggerDisplayStep(mStep, mStepPage(mStep), False)
    End Sub

    Public Sub Finish()
        Dim bCancel As Boolean

        'Validate current page
        TriggerValidate(mStep, bCancel)
        If bCancel Then ' If set to true then cancel the move.
            Exit Sub
        End If

        TriggerTerminate()
    End Sub

End Class
