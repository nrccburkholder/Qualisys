Imports System.Data.SqlClient

Public Class frmLithoCode
    Inherits System.Windows.Forms.Form

    Private mbolOKClicked As Boolean
    Private mstrFirstLitho As String = ""

    Private mintClientID As Integer
    Private mstrClientName As String
    Private mintStudyID As Integer
    Private mstrStudyName As String
    Private mintSurveyID As Integer
    Private mstrSurveyName As String
    Private mintPopID As Integer
    Private mintSamplePopID As Integer
    Private mstrFName As String
    Private mstrLName As String
    Private mintQuestionFormID As Integer   '** Added 08-25-04 JJF

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents grpLithoCode As System.Windows.Forms.GroupBox
    Friend WithEvents lblLithoCode As System.Windows.Forms.Label
    Friend WithEvents txtLithoCode As System.Windows.Forms.TextBox
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.grpLithoCode = New System.Windows.Forms.GroupBox
        Me.txtLithoCode = New System.Windows.Forms.TextBox
        Me.lblLithoCode = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.grpLithoCode.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpLithoCode
        '
        Me.grpLithoCode.Controls.Add(Me.txtLithoCode)
        Me.grpLithoCode.Controls.Add(Me.lblLithoCode)
        Me.grpLithoCode.Location = New System.Drawing.Point(12, 8)
        Me.grpLithoCode.Name = "grpLithoCode"
        Me.grpLithoCode.Size = New System.Drawing.Size(180, 48)
        Me.grpLithoCode.TabIndex = 0
        Me.grpLithoCode.TabStop = False
        '
        'txtLithoCode
        '
        Me.txtLithoCode.Location = New System.Drawing.Point(88, 16)
        Me.txtLithoCode.MaxLength = 10
        Me.txtLithoCode.Name = "txtLithoCode"
        Me.txtLithoCode.Size = New System.Drawing.Size(80, 20)
        Me.txtLithoCode.TabIndex = 1
        Me.txtLithoCode.Text = ""
        '
        'lblLithoCode
        '
        Me.lblLithoCode.Location = New System.Drawing.Point(12, 20)
        Me.lblLithoCode.Name = "lblLithoCode"
        Me.lblLithoCode.Size = New System.Drawing.Size(76, 16)
        Me.lblLithoCode.TabIndex = 0
        Me.lblLithoCode.Text = "LithoCode:"
        '
        'btnOK
        '
        Me.btnOK.Location = New System.Drawing.Point(32, 68)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(75, 28)
        Me.btnOK.TabIndex = 1
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(116, 68)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 28)
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        '
        'frmLithoCode
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(202, 107)
        Me.ControlBox = False
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.grpLithoCode)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmLithoCode"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Enter LithoCode"
        Me.grpLithoCode.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Form Events"

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click

        Dim strMsg As String

        'Make sure the entered litho is numeric
        If LithoCode.Length = 0 Then
            strMsg = "You must enter a LithoCode!"
            MessageBox.Show(strMsg, "Missing LithoCode", MessageBoxButtons.OK, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button1)
            txtLithoCode.Focus()
            Exit Sub
        ElseIf Not IsNumeric(LithoCode) Then
            strMsg = "You must enter a numeric LithoCode!"
            MessageBox.Show(strMsg, "Bad LithoCode", MessageBoxButtons.OK, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button1)
            txtLithoCode.Focus()
            Exit Sub
        End If

        If mstrFirstLitho.Length = 0 Then
            'This is the first time the user entered the LithoCode
            mstrFirstLitho = LithoCode
            With txtLithoCode
                .Text = ""
                .Focus()
            End With
            Me.Text = "Verify LithoCode"
        Else
            'This is the second time so check and see if they match
            If mstrFirstLitho = LithoCode Then
                'They match so validate
                If IsDataValid() Then
                    OKClicked = True
                    Me.Hide()
                Else
                    'Reset the screen
                    mstrFirstLitho = ""
                    With txtLithoCode
                        .Text = ""
                        .Focus()
                    End With
                    Me.Text = "Enter LithoCode"
                End If
            Else
                'They do not match so display and error and retry
                strMsg = "The litho codes entered do not match!" & vbCrLf & vbCrLf & _
                         "First Entry: " & mstrFirstLitho & vbCrLf & _
                         "Second Entry: " & LithoCode & vbCrLf & vbCrLf & _
                         "Please try again."
                MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)

                'Reset the screen
                mstrFirstLitho = ""
                With txtLithoCode
                    .Text = ""
                    .Focus()
                End With
                Me.Text = "Enter LithoCode"
            End If
        End If


    End Sub


    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click

        OKClicked = False
        Me.Hide()

    End Sub

#End Region

#Region "Properties"

    Public ReadOnly Property LithoCode() As String
        Get
            Return txtLithoCode.Text.Trim
        End Get
    End Property


    Public Property OKClicked() As Boolean
        Get
            Return mbolOKClicked
        End Get
        Set(ByVal Value As Boolean)
            mbolOKClicked = Value
        End Set
    End Property


    Public ReadOnly Property ClientID() As Integer
        Get
            Return mintClientID
        End Get
    End Property


    Public ReadOnly Property ClientName() As String
        Get
            Return mstrClientName
        End Get
    End Property


    Public ReadOnly Property ClientString() As String
        Get
            Return mstrClientName & " - (" & mintClientID.ToString & ")"
        End Get
    End Property


    Public ReadOnly Property StudyID() As Integer
        Get
            Return mintStudyID
        End Get
    End Property


    Public ReadOnly Property StudyName() As String
        Get
            Return mstrStudyName
        End Get
    End Property


    Public ReadOnly Property StudyString() As String
        Get
            Return mstrStudyName & " - (" & mintStudyID.ToString & ")"
        End Get
    End Property


    Public ReadOnly Property SurveyID() As Integer
        Get
            Return mintSurveyID
        End Get
    End Property


    Public ReadOnly Property SurveyName() As String
        Get
            Return mstrSurveyName
        End Get
    End Property


    Public ReadOnly Property SurveyString() As String
        Get
            Return mstrSurveyName & " - (" & mintSurveyID.ToString & ")"
        End Get
    End Property


    Public ReadOnly Property PopID() As Integer
        Get
            Return mintPopID
        End Get
    End Property


    Public ReadOnly Property SamplePopID() As Integer
        Get
            Return mintSamplePopID
        End Get
    End Property


    Public ReadOnly Property FName() As String
        Get
            Return mstrFName
        End Get
    End Property


    Public ReadOnly Property LName() As String
        Get
            Return mstrLName
        End Get
    End Property


    Public ReadOnly Property FullName() As String
        Get
            Return mstrFName & " " & mstrLName
        End Get
    End Property

    '** Added 08-25-04 JJF
    Public ReadOnly Property QuestionFormID() As Integer
        Get
            Return mintQuestionFormID
        End Get
    End Property
    '** End of add 08-25-04 JJF

#End Region

#Region "Worker Routines"

    Private Function IsDataValid() As Boolean

        Dim strMsg As String = ""

        'Build the command
        Dim objCommand As SqlCommand = New SqlCommand("sp_BDUS_GetInitialInfo")
        With objCommand
            .Connection = Globals.gobjConnection
            .CommandTimeout = 600
            .CommandType = CommandType.StoredProcedure
            .Parameters.Add("@strLithoCode", SqlDbType.VarChar, 10).Value = LithoCode
        End With

        'Populate the data reader
        Dim objReader As SqlDataReader = objCommand.ExecuteReader

        'Populate the local variables
        Try
            objReader.Read()
            If Not objReader.HasRows Then
                'No matching record was found
                strMsg = "Invalid LithoCode entered!" & vbCrLf & vbCrLf & "Please try again."
                txtLithoCode.Focus()

            ElseIf Not IsDBNull(objReader.Item("intToclID")) Then
                'The respondent is present on the TOCL
                strMsg = "This respondent has already been added to the Take Off Call List!" & vbCrLf & vbCrLf & "Please try again."
                txtLithoCode.Focus()

            ElseIf Not IsDBNull(objReader.Item("datUndeliverable")) Then
                'This mailing step has already been marked as undeliverable
                strMsg = "This mailing has already been marked as Final PND!" & vbCrLf & vbCrLf & "Please try again."
                txtLithoCode.Focus()

            ElseIf objReader.Item("intQtyFields") <= 0 Then
                'Survey is not setup to use the BDUS
                strMsg = "This Survey is not setup to be used with the" & vbCrLf & _
                         "Background Data Update System!" & vbCrLf & vbCrLf & _
                         "Please try again."
                txtLithoCode.Focus()

            ElseIf objReader.Item("bitCutOffFieldError") <> 0 Then
                'Survey is setup to update the CutOff Field...  NOT!!!!
                strMsg = "This survey is setup to update the Cut Off Field!" & vbCrLf & vbCrLf & _
                         objReader.Item("strCutOffFieldName") & vbCrLf & vbCrLf & _
                         "This is not allowed due to issues related to updating" & vbCrLf & _
                         "the DataMart."
                txtLithoCode.Focus()

            Else
                'All seems okey dokey so set the properties
                mintClientID = IIf(IsDBNull(objReader("intClientID")), -1, objReader("intClientID"))
                mstrClientName = IIf(IsDBNull(objReader("strClientName")), -1, objReader("strClientName"))
                mintStudyID = IIf(IsDBNull(objReader("intStudyID")), -1, objReader("intStudyID"))
                mstrStudyName = IIf(IsDBNull(objReader("strStudyName")), -1, objReader("strStudyName"))
                mintSurveyID = IIf(IsDBNull(objReader("intSurveyID")), -1, objReader("intSurveyID"))
                mstrSurveyName = IIf(IsDBNull(objReader("strSurveyName")), -1, objReader("strSurveyName"))
                mintPopID = IIf(IsDBNull(objReader("intPopID")), -1, objReader("intPopID"))
                mintSamplePopID = IIf(IsDBNull(objReader("intSamplePopID")), -1, objReader("intSamplePopID"))
                mstrFName = IIf(IsDBNull(objReader("strFName")), -1, objReader("strFName"))
                mstrLName = IIf(IsDBNull(objReader("strLName")), -1, objReader("strLName"))
                mintQuestionFormID = IIf(IsDBNull(objReader("intQuestionFormID")), -1, objReader("intQuestionFormID"))  '** Added 08-25-04 JJF

            End If


        Catch ex As Exception
            strMsg = "The following unexpected error occured!" & vbCrLf & vbCrLf & _
                     "Source: " & ex.Source & vbCrLf & ex.Message
            txtLithoCode.Focus()

        End Try

        'Cleanup
        objReader.Close()

        'Determine return value and property values
        If strMsg.Trim.Length = 0 Then
            Return True
        Else
            MessageBox.Show(strMsg, Application.ProductName, MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End If

    End Function

#End Region

End Class
