Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Config
    Private Const LDUploadedFileReport As String = "LDUploadedFileReport"
    Private Const LDReportServer As String = "LDReportServer"
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentTypes
        Get
            Return AppConfig.EnvironmentType
        End Get
    End Property

    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return AppConfig.EnvironmentName
        End Get
    End Property
#Region " Custom Configuration Properties "
    ''' <summary>SMTP Server based on which enironement your in (DEV, Stage, Prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return AppConfig.SMTPServer
        End Get
    End Property
    ''' <summary>Conn string for NRC Auth connection based on which environment your in (Dev, stage, prod, etc)</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return AppConfig.NrcAuthConnection
            'Settings("NrcAuthConnection")
        End Get
    End Property
    Public Shared ReadOnly Property UploadedFileReport() As String
        Get
            Dim UploadedFileReportParam As Param = AppConfig.Params(LDUploadedFileReport)
            If UploadedFileReportParam IsNot Nothing Then
                Return UploadedFileReportParam.StringValue
            Else
                Throw New Exception(GetExceptionMessage(LDUploadedFileReport))
            End If
        End Get
    End Property
    Public Shared ReadOnly Property ReportServer() As String
        Get
            Dim ReportServerParam As Param = AppConfig.Params(LDReportServer)
            If ReportServerParam IsNot Nothing Then
                Return ReportServerParam.StringValue
            Else
                Throw New Exception(GetExceptionMessage(LDReportServer))
            End If
        End Get
    End Property
    Public Shared Function GetExceptionMessage(ByVal paramName As String) As String
        Dim message As New System.Text.StringBuilder
        message.Append("Can't find ")
        message.Append(paramName)
        message.Append("  setting in QualPro_Params table")
        Return message.ToString
    End Function
#End Region
End Class
