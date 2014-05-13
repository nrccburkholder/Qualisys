Imports System.Collections.Specialized

Public Class SurveyValidationResult

    Public Enum ValidationResult
        None = 0
        Success = 1
        SuccessWithWarnings = 2
        Failed = 3
    End Enum

    Private mPassList As New StringCollection
    Private mWarningList As New StringCollection
    Private mFailureList As New StringCollection

    Public ReadOnly Property PassList() As StringCollection
        Get
            Return mPassList
        End Get
    End Property

    Public ReadOnly Property WarningList() As StringCollection
        Get
            Return mWarningList
        End Get
    End Property

    Public ReadOnly Property FailureList() As StringCollection
        Get
            Return mFailureList
        End Get
    End Property

    Public ReadOnly Property Result() As ValidationResult
        Get
            If mFailureList.Count > 0 Then
                Return ValidationResult.Failed
            ElseIf mWarningList.Count > 0 Then
                Return ValidationResult.SuccessWithWarnings
            Else
                Return ValidationResult.Success
            End If
        End Get
    End Property

End Class
