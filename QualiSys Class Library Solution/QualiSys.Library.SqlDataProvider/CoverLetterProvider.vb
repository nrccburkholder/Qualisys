Imports Nrc.Framework.Data

Public Class CoverLetterProvider
    Inherits Nrc.QualiSys.Library.DataProvider.CoverLetterProvider

    Private Function PopulateCoverLetter(ByVal rdr As SafeDataReader) As CoverLetter

        Dim newObj As CoverLetter = CreateCoverLetter(rdr.GetInteger("SelCover_id"), rdr.GetString("Description").Trim)
        Return newObj
    End Function

    Private Function PopulateCoverLetterWithItems(ByVal rdr As SafeDataReader) As CoverLetter

        Dim coverLetterItemObj As List(Of CoverLetterItem) = PopulateCoverLetterItems(rdr.GetInteger("Survey_id"), rdr.GetInteger("SelCover_id"))

        Dim newObj As CoverLetter = CreateCoverLetter(rdr.GetInteger("SelCover_id"), rdr.GetInteger("Survey_id"), rdr.GetString("Description").Trim, coverLetterItemObj)
        Return newObj
    End Function

    Public Overrides Function SelectBySurveyId(ByVal surveyId As Integer) As System.Collections.ObjectModel.Collection(Of CoverLetter)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCoverLettersBySurveyId, surveyId)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CoverLetter)(rdr, AddressOf PopulateCoverLetter)
        End Using
    End Function

    Public Overrides Function SelectBySurveyIdAndPageType(surveyId As Integer, pageType As Integer) As System.Collections.ObjectModel.Collection(Of CoverLetter)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectCoverLettersBySurveyIdAndPageType", surveyId, pageType)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of CoverLetter)(rdr, AddressOf PopulateCoverLetterWithItems)
        End Using

    End Function
    

    Private Function PopulateCoverLetterItems(ByVal surveyid As Integer, ByVal coverid As Integer) As List(Of CoverLetterItem)
        Dim cmd As DbCommand = Db.GetStoredProcCommand("QCL_SelectCoverLetterItems", surveyid, coverid)

        Dim items As New List(Of CoverLetterItem)

        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                items.Add(PopulateCoverLetterItem(rdr))
            End While
        End Using

        Return items
    End Function

    Private Function PopulateCoverLetterItem(ByVal rdr As SafeDataReader) As CoverLetterItem
        Dim newObj As New CoverLetterItem

        newObj.ItemID = rdr.GetInteger("QPC_Id")
        newObj.CoverID = rdr.GetInteger("CoverId")
        newObj.Label = rdr.GetString("Label")
        newObj.ItemType = rdr.GetInteger("ItemType")

        Return newObj
    End Function

End Class
