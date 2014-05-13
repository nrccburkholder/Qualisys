Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config

    Public Shared ReadOnly Property MaxConcurrentLoads() As Integer
        Get
            If Not AppConfig.Params("RunDTSExecutions").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentLoads").IntegerValue
            End If
        End Get
    End Property

    Public Shared ReadOnly Property MaxConcurrentCleaning() As Integer
        Get
            If Not AppConfig.Params("RunAddressCleaning").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentCleaning").IntegerValue
            End If
        End Get
    End Property

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

    Public Shared ReadOnly Property MaxConcurrentLoadToLiveDupChecks() As Integer
        Get
            If Not AppConfig.Params("RunLoadToLiveDupChecks").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentLoadToLiveDupChecks").IntegerValue
            End If
        End Get
    End Property

    Public Shared ReadOnly Property MaxConcurrentLoadToLiveUpdates() As Integer
        Get
            If Not AppConfig.Params("RunLoadToLiveUpdates").StringValue.Equals("true", StringComparison.CurrentCultureIgnoreCase) Then
                Return 0
            Else
                Return AppConfig.Params("MaxConcurrentLoadToLiveUpdates").IntegerValue
            End If
        End Get
    End Property

End Class
