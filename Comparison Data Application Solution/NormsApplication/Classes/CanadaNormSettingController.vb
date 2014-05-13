Option Explicit On 
Option Strict On

Imports System.Text
Imports System.Data.SqlClient
Imports System.io
Imports NormsApplicationBusinessObjectsLibrary

Public Class CanadaNormSettingController

#Region " Private Fields"

    Private mNormSetting As New CanadaNormSetting
    Private mComparisonTypes As New ComparisonTypeCollection
    Private mApproveInfo As CanadaNormSettingApproveCollection

#End Region

#Region " Public Properties"

    Public ReadOnly Property NormSetting() As CanadaNormSetting
        Get
            Return mNormSetting
        End Get
    End Property

    Public ReadOnly Property ComparisonTypes() As ComparisonTypeCollection
        Get
            Return mComparisonTypes
        End Get
    End Property

    Public Property ApproveInfo() As CanadaNormSettingApproveCollection
        Get
            Return mApproveInfo
        End Get
        Set(ByVal Value As CanadaNormSettingApproveCollection)
            mApproveInfo = Value
        End Set
    End Property

#End Region

#Region " Public Methods"

    Public Function SelectNormList() As SqlClient.SqlDataReader
        Return DataAccess.GetCanadaNormList()
    End Function

    Public Sub Load()
        Me.mNormSetting.Load()
        Me.mComparisonTypes.Load(mNormSetting.NormID)
    End Sub

    Public Function IsNormLabelExist(ByRef whichLabel As String) As Boolean
        Dim id As Integer
        Dim label As String

        id = Me.mNormSetting.NormID
        label = Me.mNormSetting.NormLabel
        If (DataAccess.IsNormLabelExist(id, label)) Then
            whichLabel = "Norm"
            Return True
        End If

        Dim comp As ComparisonType
        For Each comp In Me.mComparisonTypes
            id = comp.CompTypeID
            label = comp.SelectionBox
            If (DataAccess.IsComparisonLabelExist(id, label)) Then
                whichLabel = comp.NormType.ToString
                Return True
            End If
        Next
    End Function

    Public Function SelectClientUsed() As SqlClient.SqlDataReader
        Return DataAccess.SelectCanadaClientUsed(mNormSetting.NormID)
    End Function

    Public Function SelectClientUnused() As SqlClient.SqlDataReader
        Return DataAccess.SelectCanadaClientUnused(mNormSetting.NormID)
    End Function

    Public Function SelectNormSurvey() As SqlClient.SqlDataReader
        Return DataAccess.SelectCanadaNormSurvey(mNormSetting.NormID, ConcateClientIDs())
    End Function

    Public Function LoadSurveyFromFile(ByVal path As String) As SqlClient.SqlDataReader
        Dim surveylist() As StringBuilder = LoadSurveyList(path)
        If (surveylist(0).Length = 0) Then Return (Nothing)
        CheckLoadedSurveyID(surveylist)
        Return (DataAccess.SelectCanadaLoadedSurvey(surveylist))
    End Function

    Public Function SelectNormRollup() As SqlClient.SqlDataReader
        Return DataAccess.SelectCanadaNormRollup(mNormSetting.NormID, ConcateClientIDs())
    End Function

    Public Sub UpdateNormSettings()
        Dim avgComparison As ComparisonType = Me.mComparisonTypes.SpecifiedComparison(NormType.StandardNorm)
        Dim hpComparison As ComparisonType = Me.mComparisonTypes.SpecifiedComparison(NormType.BestNorm)
        Dim lpComparison As ComparisonType = Me.mComparisonTypes.SpecifiedComparison(NormType.WorstNorm)

        Dim hasAvgNorm As Boolean = False
        Dim avgNormCompTypeID As Integer
        Dim avgNormLabel As String = String.Empty
        Dim avgNormDescription As String = String.Empty
        Dim hasHpNorm As Boolean = False
        Dim hpNormCompTypeID As Integer
        Dim hpNormLabel As String = String.Empty
        Dim hpNormDescription As String = String.Empty
        Dim hpNormUnitIncluded As Integer
        Dim hasLpNorm As Boolean = False
        Dim lpNormCompTypeID As Integer
        Dim lpNormLabel As String = String.Empty
        Dim lpNormDescription As String = String.Empty
        Dim lpNormUnitIncluded As Integer
        Dim surveyList(4) As StringBuilder
        Dim rollupList(0) As StringBuilder
        Dim whichLabel As String = String.Empty

        'Check if norm labels are in use
        If (IsNormLabelExist(whichLabel)) Then
            Throw New ArgumentException("Norm or comparison label is already in use")
        End If

        'Update
        If (Not avgComparison Is Nothing) Then
            hasAvgNorm = True
            With avgComparison
                avgNormCompTypeID = .CompTypeID
                avgNormLabel = .SelectionBox
                avgNormDescription = .Description
            End With
        End If

        If (Not hpComparison Is Nothing) Then
            hasHpNorm = True
            With hpComparison
                hpNormCompTypeID = .CompTypeID
                hpNormLabel = .SelectionBox
                hpNormDescription = .Description
                hpNormUnitIncluded = .NormParam
            End With
        End If

        If (Not lpComparison Is Nothing) Then
            hasLpNorm = True
            With lpComparison
                lpNormCompTypeID = .CompTypeID
                lpNormLabel = .SelectionBox
                lpNormDescription = .Description
                lpNormUnitIncluded = .NormParam
            End With
        End If

        Me.NormSetting.ConcatedSurveyList(surveyList)
        Me.NormSetting.ConcatedRollupList(rollupList)

        Dim rdr As SqlDataReader = Nothing

        Try
            rdr = DataAccess.UpdateCanadaNormSettings( _
                                      mNormSetting.NormID, _
                                      mNormSetting.NormLabel, _
                                      mNormSetting.NormDescription, _
                                      mNormSetting.CriteriaStmt, _
                                      mNormSetting.WeightingType, _
                                      mNormSetting.ReportDateBegin, _
                                      mNormSetting.ReportDateEnd, _
                                      mNormSetting.ReturnDateMax, _
                                      CurrentUser.Member.MemberId, _
                                      hasAvgNorm, _
                                      avgNormCompTypeID, _
                                      avgNormLabel, _
                                      avgNormDescription, _
                                      hasHpNorm, _
                                      hpNormCompTypeID, _
                                      hpNormLabel, _
                                      hpNormDescription, _
                                      hpNormUnitIncluded, _
                                      hasLpNorm, _
                                      lpNormCompTypeID, _
                                      lpNormLabel, _
                                      lpNormDescription, _
                                      lpNormUnitIncluded, _
                                      surveyList, _
                                      rollupList _
                                     )

            If (rdr.Read) Then
                If (mNormSetting.NormID = 0) Then
                    mNormSetting.NormID = CInt(rdr("Norm_ID"))
                End If
                If (hasAvgNorm AndAlso avgComparison.CompTypeID = 0) Then
                    avgComparison.CompTypeID = CInt(rdr("AvgNormCompType_ID"))
                End If
                If (hasHpNorm AndAlso hpComparison.CompTypeID = 0) Then
                    hpComparison.CompTypeID = CInt(rdr("HpNormCompType_ID"))
                End If
                If (hasLpNorm AndAlso lpComparison.CompTypeID = 0) Then
                    lpComparison.CompTypeID = CInt(rdr("LpNormCompType_ID"))
                End If
            End If

        Catch ex As Exception
            Throw ex
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
        End Try

    End Sub

    Public Sub SelectApproveInfo()
        mApproveInfo = New CanadaNormSettingApproveCollection(mNormSetting.NormID)
    End Sub

#End Region

#Region " Private Methods"

    Private Function ConcateClientIDs() As String
        Dim clientStr As New StringBuilder
        Dim clientIDs() As Integer = Me.mNormSetting.ClientIDs

        Dim i As Integer
        For i = 0 To clientIDs.Length - 1
            If i > 0 Then clientStr.Append(",")
            clientStr.Append(clientIDs(i))
        Next
        Return clientStr.ToString
    End Function

    Private Function LoadSurveyList(ByVal path As String) As StringBuilder()
        Dim sr As StreamReader = Nothing
        Dim surveyID As Integer
        Dim surveyList() As StringBuilder = {New StringBuilder, New StringBuilder, New StringBuilder, New StringBuilder, New StringBuilder}
        Dim str As New StringBuilder
        Dim i As Integer = 0
        Dim line As Integer = 0
        Dim msg As String

        Try
            sr = File.OpenText(path)
            Do Until sr.Peek = -1
                If (surveyList(i).Length >= 7990) Then i += 1
                line += 1
                str.Remove(0, str.Length)
                str.Append(sr.ReadLine.Trim)
                If (str.ToString <> "") Then
                    surveyID = CInt(str.ToString)
                    If (surveyID <= 0) Then
                        Throw New InvalidCastException
                    End If
                    surveyList(i).Append(surveyID & ",")
                End If
            Loop

            Return (surveyList)

        Catch ex As InvalidCastException
            msg = String.Format("Line {0}: ""{1}"" is not a valid survey ID", line, str)
            Throw New ArgumentException(msg)
        Catch ex As Exception
            Throw ex
        Finally
            sr.Close()
        End Try

    End Function

    Private Sub CheckLoadedSurveyID(ByVal surveyList() As StringBuilder)
        Dim rdr As SqlDataReader = Nothing
        Dim msg As New StringBuilder("There are some incorrect data in the file." + vbCrLf + vbCrLf)
        Dim hasInvalidRec As Boolean = False

        Try
            rdr = DataAccess.SelectCanadaInvalidSurvey(surveyList)
            Do While rdr.Read
                hasInvalidRec = True
                msg.Append("Survey ID: ")
                msg.Append(CInt(rdr("Survey_ID")))
                msg.Append("    Error: ")
                msg.Append(CStr(rdr("ErrMsg")))
                msg.Append(vbCrLf)
            Loop

            If (hasInvalidRec) Then Throw New ArgumentException(msg.ToString)
        Catch ex As Exception
            Throw ex
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
        End Try
    End Sub

#End Region

End Class
