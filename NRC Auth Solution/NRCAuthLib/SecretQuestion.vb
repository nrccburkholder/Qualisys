Imports NRC.Data
<AutoPopulate()> _
Public Class SecretQuestion

    <SQLField("Hint_id")> Private mSecretQuestionId As Integer
    <SQLField("strHint")> Private mSecretQuestionText As String

    Public ReadOnly Property SecretQuestionId() As Integer
        Get
            Return mSecretQuestionId
        End Get
    End Property

    Public ReadOnly Property SecretQuestionText() As String
        Get
            Return mSecretQuestionText
        End Get
    End Property

    Public Shared Function GetSecretQuestions() As ArrayList
        Dim list As IList
        list = New ArrayList
        Dim rdr As IDataReader = DAL.SelectSecretQuestionList
        Populator.FillCollection(rdr, GetType(SecretQuestion), list)

        Return DirectCast(list, ArrayList)
    End Function

End Class
