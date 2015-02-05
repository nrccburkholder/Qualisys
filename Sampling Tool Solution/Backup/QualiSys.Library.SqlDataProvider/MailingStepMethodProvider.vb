Imports Nrc.Framework.Data

Public Class MailingStepMethodProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MailingStepMethodProvider


#Region "Populate methods"

    Private Function PopulateMailingStepMethod(ByVal rdr As SafeDataReader) As MailingStepMethod
        Dim newObj As MailingStepMethod = CreateMailingStepMethod(rdr.GetInteger("MailingStepMethod_id"))
        newObj.Name = rdr.GetString("MailingStepMethod_nm").Trim
        Return newObj
    End Function
#End Region

    Public Overrides Function [Select](ByVal Id As Integer) As MailingStepMethod
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectMailingMethod", Id)

        'Get the Methodology
        Dim meth As MailingStepMethod
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                meth = PopulateMailingStepMethod(rdr)
            Else
                Return Nothing
            End If
        End Using



        Return meth
    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As MailingStepMethodCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectAvailableMailingMethodsBySurveyID", surveyId)

        'Gets all the Methodologies
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of MailingStepMethodCollection, MailingStepMethod)(rdr, AddressOf PopulateMailingStepMethod)
        End Using



    End Function

End Class
