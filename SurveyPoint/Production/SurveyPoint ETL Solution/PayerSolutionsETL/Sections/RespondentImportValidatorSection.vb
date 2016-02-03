Imports System.Text
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Data
Imports Nrc.SurveyPoint.Library

Public Class RespondentImportValidatorSection
#Region " Fields "    
    Private mLines As List(Of String) = Nothing
    Private mRespValidator As SPETL_RespondentImportValidator = Nothing    
#End Region
#Region " Event handlers "
    Private Sub cmdGetFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdGetFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtRespondentFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdLoadFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdLoadFile.Click
        Try
            LoadFile()
        Catch myEx As System.Exception
            Globals.ReportException(myEx)
        End Try
    End Sub
    Private Sub cboFileIndex_SelectedValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboFileIndex.SelectedValueChanged
        Try
            Dim line As String = CStr(cboFileIndex.SelectedItem)
            PopulateTabs(line)                        
        Catch ex As Exception
            Globals.ReportException(ex)
        End Try        
    End Sub
    Private Sub RespondentImportValidatorSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
#End Region
#Region " ValidatorMethods "
    Private Sub LoadFile()        
        If mLines IsNot Nothing Then
            mLines = Nothing
        End If        
        ClearUI()
        If Not System.IO.File.Exists(Me.txtRespondentFile.Text) Then
            Me.txtResults.Text = Me.txtResults.Text & "The Specified File Does not exist." & vbCrLf
        Else
            LoadLines()
        End If
    End Sub
    Private Sub LoadLines()
        Me.mLines = New List(Of String)
        Try
            Dim myReader As New StreamReader(Me.txtRespondentFile.Text)
            Do While myReader.Peek >= 0
                Dim tempString As String = myReader.ReadLine
                If tempString.Length > 0 Then
                    mLines.Add(tempString)
                End If                
            Loop
            If mLines.Count > 0 Then
                For i As Integer = 0 To mLines.Count - 1
                    Me.cboFileIndex.Items.Add((i + 1) & ":  " & mLines(i))
                Next                
            End If
            myReader.Close()
            myReader = Nothing
        Catch ex As Exception
            Me.txtResults.Text = Me.txtResults.Text & "The Following Exeption occured reading the file: " & ex.Message & vbCrLf
            Throw ex
        End Try
    End Sub
    Private Sub ClearUI()
        Me.cboFileIndex.Items.Clear()
        Me.txtResults.Text = ""
        Me.txtSurvey.Text = ""
        Me.txtClient.Text = ""
        Me.txtSurveyInstance.Text = ""
        Me.txtFileDef.Text = ""
        Me.txtTemplate.Text = ""
        Me.txtRespondent.Text = ""
        Me.grdFileDef.DataSource = Nothing
        Me.grdEventLog.DataSource = Nothing
        Me.grdRespondentData.DataSource = Nothing
        Me.grdRespProperties.DataSource = Nothing        
        Me.mRespValidator = Nothing
    End Sub
    Public Sub PopulateTabs(ByVal line As String)
        Dim counterIndex As Integer = line.IndexOf(":"c)
        line = line.Substring(counterIndex + 3)
        mRespValidator = SPETL_RespondentImportValidator.NewImportValidator(line)
        Try
            mRespValidator.SetData()
        Catch ex As Exception
            Me.txtResults.Text = Me.txtResults.Text & ex.Message & vbCrLf
        End Try
        Me.txtResults.Text = Me.txtResults.Text & "All information has been loaded." & vbCrLf
        PopulateUI()
    End Sub
    Public Sub populateUI()
        If Me.mRespValidator.BaseInformationSet IsNot Nothing AndAlso Me.mRespValidator.BaseInformationSet.Rows.Count > 0 Then
            Me.txtSurvey.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("Survey"))
            Me.txtSurveyInstance.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("SurveyInstance"))
            Me.txtScript.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("Script"))
            Me.txtClient.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("Client"))
            Me.txtTemplate.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("Template"))
            Me.txtFileDef.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("FileDef"))
            Me.txtRespondent.Text = CStr(Me.mRespValidator.BaseInformationSet.Rows(0)("Respondent"))
            Me.grdRespondentData.DataSource = Me.mRespValidator.RespondentData
            Me.grdRespProperties.DataSource = Me.mRespValidator.RespondentProperties
            Me.grdEventLog.DataSource = Me.mRespValidator.RespondentEventLog
            Me.grdFileDef.DataSource = Me.mRespValidator.FileDefTable
        End If
    End Sub
#End Region        
End Class
