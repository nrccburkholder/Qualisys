Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Configuration

<Serializable()> _
Public Class MailingStepMethod
    Inherits BusinessBase(Of MailingStepMethod)

#Region "Private Fields"
    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mName As String
#End Region


#Region " Public Properties "

    ''' <summary>The unique identifier of the MailingStepMethod</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>The name of the MailingStepMethod</summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Friend Sub New()

    End Sub

#End Region

#Region " Factory Methods "
    Public Shared Function NewMailingStepMethod() As MailingStepMethod
        Dim obj As New MailingStepMethod
        Return obj
    End Function


#End Region

#Region "Overrides"
    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If

    End Function
#End Region


#Region " Public Methods "

    Public Shared Function GetBySurveyID(ByVal surveyID As Integer) As MailingStepMethodCollection

        Return MailingStepMethodProvider.Instance.SelectBySurveyId(surveyID)

    End Function

#End Region

End Class
