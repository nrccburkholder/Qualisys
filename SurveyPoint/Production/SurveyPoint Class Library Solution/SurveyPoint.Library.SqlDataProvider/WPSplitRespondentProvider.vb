'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class WPSplitRespondentProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.WPSplitRespondentProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " SPU_FileLayout Procs "

    Private Function PopulateWPSplitRespondent(ByVal rdr As SafeDataReader) As WPSplitRespondent
        Dim newObject As WPSplitRespondent = WPSplitRespondent.NewWPSplitRespondent
        Dim privateInterface As IWPSplitRespondent = newObject
        newObject.BeginPopulate()
        privateInterface.WPSplitRespondentID = CStr(rdr.GetInteger("RespondentID"))
        newObject.FirstName = rdr.GetString("FirstName")
        newObject.LastName = rdr.GetString("LastName")
        newObject.DOB = rdr.GetNullableDate("DOB")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function GetDuplicateRespondents(ByVal id As String, ByVal clientID As Integer, ByVal surveyInstanceStartDate As System.Nullable(Of Date)) As WPSplitRespondentCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.GetWPSplitRespondentDuplicates, id, clientID, surveyInstanceStartDate)
        Dim col As New WPSplitRespondentCollection
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                col.Add(PopulateWPSplitRespondent(rdr))
            End While
        End Using
        Return col
    End Function

    Public Overrides Sub InsertWPRespondentForDupCheck(ByVal id As String, ByVal firstName As String, ByVal lastName As String, ByVal dob As System.Nullable(Of Date))
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertWPSplitRespondentForDupCheck, id, firstName, lastName, SafeDataReader.ToDBValue(dob))
        ExecuteNonQuery(cmd)
    End Sub    

#End Region


End Class