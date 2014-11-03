Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports Nrc.Framework.Data

Public Class MailingProvider
    Inherits Nrc.QualiSys.Library.DataProvider.MailingProvider

    Private Function PopulateMailing(ByVal rdr As SafeDataReader) As Mailing
        Dim newObj As New Mailing
        ReadOnlyAccessor.SentMailId(newObj) = rdr.GetInteger("SentMail_id")
        ReadOnlyAccessor.LithoCode(newObj) = rdr.GetString("strLithoCode")
        ReadOnlyAccessor.MethodologyStepId(newObj) = rdr.GetInteger("MailingStep_id")
        ReadOnlyAccessor.MethodologyStepName(newObj) = rdr.GetString("strMailingStep_nm")
        ReadOnlyAccessor.StudyId(newObj) = rdr.GetInteger("Study_id")
        ReadOnlyAccessor.SurveyId(newObj) = rdr.GetInteger("Survey_id")
        ReadOnlyAccessor.PopId(newObj) = rdr.GetInteger("Pop_id")
        ReadOnlyAccessor.LanguageId(newObj) = rdr.GetInteger("LangId")
        ReadOnlyAccessor.ScheduledGenerationDate(newObj) = rdr.GetDate("datGenerationScheduled")
        ReadOnlyAccessor.GenerationDate(newObj) = rdr.GetDate("datGenerated")
        ReadOnlyAccessor.PrintDate(newObj) = rdr.GetDate("datPrinted")
        ReadOnlyAccessor.MailDate(newObj) = rdr.GetDate("datMailed")
        ReadOnlyAccessor.NonDeliveryDate(newObj) = rdr.GetDate("datUndeliverable")
        ReadOnlyAccessor.ReturnDate(newObj) = rdr.GetDate("datReturned")
        ReadOnlyAccessor.ExpirationDate(newObj) = rdr.GetDate("datExpire")
        newObj.ResetDirtyFlag()
        Return newObj
    End Function
    Public Overrides Function SelectByLitho(ByVal litho As String) As Mailing
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectMailingByLitho, litho)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMailing(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectByBarcode(ByVal barcode As String) As Mailing
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectMailingByBarcode, barcode)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMailing(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectByWac(ByVal wac As String) As Mailing
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectMailingByWAC, wac)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If rdr.Read Then
                Return PopulateMailing(rdr)
            Else
                Return Nothing
            End If
        End Using
    End Function

    Public Overrides Function SelectByPopId(ByVal popId As Integer, ByVal studyId As Integer) As Collection(Of Mailing)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.SelectMailingsByPopId, popId, studyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of Mailing)(rdr, AddressOf PopulateMailing)
        End Using
    End Function

    Public Overrides Sub DeleteFutureMailings(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.DeleteFutureMailings, litho, dispositionId, receiptTypeId, userName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub ChangeRespondentAddress(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal address1 As String, ByVal address2 As String, ByVal city As String, ByVal delPt As String, ByVal country As CountryCode, ByVal state As String, ByVal province As String, ByVal zip5 As String, ByVal zip4 As String, ByVal postalCode As String, ByVal addrStat As String, ByVal addrErr As String)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.ChangeRespondentAddress, litho, dispositionId, address1, address2, city, delPt, state, zip4, zip5, addrStat, addrErr, country, province, postalCode, receiptTypeId, userName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub RegenerateMailing(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal languageId As Integer)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.RegenerateMailing, litho, dispositionId, SafeDataReader.ToDBValue(languageId, 0), receiptTypeId, userName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub TakeOffCallList(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.TakeOffCallList, litho, dispositionId, receiptTypeId, userName)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub LogContactRequest(ByVal litho As String, ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal emailText As String)
        Dim cmd As DBCommand = Db.GetStoredProcCommand(SP.LogContactRequest, litho, dispositionId, emailText, receiptTypeId, userName)
        ExecuteNonQuery(cmd)
    End Sub

End Class
