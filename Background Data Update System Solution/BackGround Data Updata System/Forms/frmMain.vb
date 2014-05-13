Imports System.Data.SqlClient
Public Class frmMain
    Private mbolFormActivated As Boolean = False
    Private mintClientID As Integer
    Private mintStudyID As Integer
    Private mintSurveyID As Integer
    Private mintPopID As Integer
    Private mintSamplePopID As Integer
    Private mintQuestionFormID As Integer   '** Added 08-25-04 JJF


    Private mobjBGDataCol As clsBGDataCollection
#Region "Form Events"

    Private Sub frmMain_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Open the database connection
        'gobjConnection = New SqlConnection(connectionString:=GetSQLConnectString(strApplication:=gkstrRegBase))
        Globals.gobjConnection = New SqlConnection(connectionString:=Config.QP_ProdConnection)
        Globals.gobjConnection.Open()

        'Initialize the collection
        mobjBGDataCol = New clsBGDataCollection(objPanel:=pnlBGData)

        'Set the version number
        Me.Text = My.Application.Info.ProductName
        Me.lblEnvironment.Text = Config.EnvironmentName
        Me.lblUserName.Text = CurrentUser.UserName
        Me.lblVersion.Text = Application.ProductVersion

    End Sub


    Private Sub frmMain_Activated(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Activated

        'If this is not the first time then exit stage left
        If mbolFormActivated Then Exit Sub

        'Set the variable so we don't come here again
        mbolFormActivated = True

        'If we are still here then prompt the user for a litho code
        NewLithoCode()

    End Sub


    Private Sub frmMain_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing

        Dim strMsg As String

        'If there is a respondent on screen prompt the user to save
        If txtLithoCode.Text.Trim.Length > 0 Then
            strMsg = "Do you wish to save any changes made to" & vbCrLf & _
                     "the current respondent before exiting?"
            If MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                SaveData(bolPromptForLitho:=False)
            End If
        End If

    End Sub


    Private Sub frmMain_Closed(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Closed

        'Close the database connection
        Globals.gobjConnection.Close()

        'Cleanup
        mobjBGDataCol.ClearAll()
        mobjBGDataCol = Nothing

    End Sub


    Private Sub btnNewLitho_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNewLitho.Click

        Dim strMsg As String

        'If there is a respondent on screen prompt the user to save
        If txtLithoCode.Text.Trim.Length > 0 Then
            strMsg = "Do you wish to save any changes made" & vbCrLf & _
                     "to the current respondent?"
            If MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                SaveData(bolPromptForLitho:=False)
            End If
        End If

        'Get a new lithocode
        NewLithoCode()

    End Sub


    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click

        'Save the data
        SaveData(bolPromptForLitho:=True)

    End Sub

#End Region

#Region "Worker routines"

    Private Function NewLithoCode() As Boolean

        Dim bolOKClicked As Boolean = False

        'Lock the form
        LockForm(bolLocked:=True)

        'Initialize the data
        mintClientID = 0
        mintStudyID = 0
        mintSurveyID = 0
        mintPopID = 0
        mintSamplePopID = 0

        'Display the LithoCode screen
        Dim objLocalLithoCode As New frmLithoCode
        With objLocalLithoCode
            'Display the form
            .ShowDialog(Me)

            'Check for the result
            If .OKClicked Then
                'Save the values
                bolOKClicked = True
                mintClientID = .ClientID
                mintStudyID = .StudyID
                mintSurveyID = .SurveyID
                mintPopID = .PopID
                mintSamplePopID = .SamplePopID
                mintQuestionFormID = .QuestionFormID    '** Added 08-25-04 JJF

                'Set form values
                txtLithoCode.Text = .LithoCode
                txtClient.Text = .ClientString
                txtStudy.Text = .StudyString
                txtSurvey.Text = .SurveyString
                txtFullName.Text = .FullName
            End If
        End With

        'Unload the form
        objLocalLithoCode.Close()

        'Finish seting up the form
        If bolOKClicked Then
            'Unlock the form
            LockForm(bolLocked:=False)

            'Populate the BGData collection
            mobjBGDataCol.PopFromDB(intStudyID:=mintStudyID, intSurveyID:=mintSurveyID, intPopID:=mintPopID)

        Else
            'The user canceled so we are out of here
            btnNewLitho.Enabled = True

        End If
    End Function


    Private Sub LockForm(ByVal bolLocked As Boolean)

        'Lock the required controls
        grpCurrentInfo.Enabled = Not bolLocked
        grpBGData.Enabled = Not bolLocked
        btnSave.Enabled = Not bolLocked
        btnNewLitho.Enabled = Not bolLocked

        'Clear the background data collection and list
        If bolLocked Then
            Try
                'Clear the collection
                mobjBGDataCol.ClearAll()

            Catch
                'Do nothing

            End Try
        End If

        'Clear the form if we are locking it
        If bolLocked Then
            txtLithoCode.Text = ""
            txtClient.Text = ""
            txtStudy.Text = ""
            txtSurvey.Text = ""
            txtFullName.Text = ""
        End If

    End Sub


    Private Sub SaveData(ByVal bolPromptForLitho As Boolean)

        'If the data is not valid then we are out of here
        If Not IsDataValid() Then Exit Sub

        'Get the set clause
        Dim strSet As String = mobjBGDataCol.SetClause
        Dim strFields As String = mobjBGDataCol.FieldList   '** Added 08-25-04 JJF

        'Build the command
        Dim objCommand As SqlCommand = New SqlCommand("sp_BDUS_UpdateBackgroundInfo")
        With objCommand
            .Connection = Globals.gobjConnection
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@intStudyID", SqlDbType.Int).Value = mintStudyID
            .Parameters.Add("@intPopID", SqlDbType.Int).Value = mintPopID
            .Parameters.Add("@intSamplePopID", SqlDbType.Int).Value = mintSamplePopID
            .Parameters.Add("@intQuestionFormID", SqlDbType.Int).Value = mintQuestionFormID     '** Added 08-25-04 JJF
            .Parameters.Add("@strSetClause", SqlDbType.VarChar, 7800).Value = strSet
            .Parameters.Add("@strFieldList", SqlDbType.VarChar, 5000).Value = strFields         '** Added 08-25-04 JJF
            .Parameters.Add("@intProgram", SqlDbType.Int).Value = 2                             '** Added 08-25-04 JJF

        End With

        'Save the data
        Try
            objCommand.ExecuteNonQuery()

        Catch ex As Exception
            Dim strMsg As String = "The following error occured while attempting to update" & vbCrLf & _
                                   "the population record in QualiSys and the DataMart!" & vbCrLf & vbCrLf & _
                                   "Source: " & ex.Source & vbCrLf & ex.Message
            MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

        End Try

        'Get a new lithocode
        If bolPromptForLitho Then NewLithoCode()

    End Sub


    Private Function IsDataValid() As Boolean

        Dim strMsg As String = ""

        'Determine return value
        If mobjBGDataCol.IsDataValid(strMsg:=strMsg) Then
            Return True
        Else
            'An error was found so display the message
            MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End If

    End Function

#End Region

End Class