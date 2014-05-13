Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config

    Public Shared ReadOnly Property MaxConcurrentValidations() As Integer
        Get
            If Not AppConfig.Params("RunValidationReports").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentValidations").IntegerValue
            End If
        End Get
    End Property

    Public Shared ReadOnly Property MaxConcurrentApplies() As Integer
        Get
            If Not AppConfig.Params("RunApplies").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentApplies").IntegerValue
            End If
        End Get
    End Property

End Class
