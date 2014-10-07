Imports System.Data.SqlClient
Public Class frmTestPrint
    Inherits System.Windows.Forms.Form
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
    Friend objConnection As New SqlConnection
    Friend objDataAdapter As New SqlDataAdapter
    Friend objCommand As New SqlCommand
    Friend objdata As New DataSet
    Friend gEmployee_ID As Integer
    Friend gSurvey_ID As Integer
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lstCover As System.Windows.Forms.ListBox
    Friend WithEvents lstLanguage As System.Windows.Forms.ListBox
    Friend WithEvents grpSex As System.Windows.Forms.GroupBox
    Friend WithEvents chkFemale As System.Windows.Forms.CheckBox
    Friend WithEvents chkMale As System.Windows.Forms.CheckBox
    Friend WithEvents optSexDontcare As System.Windows.Forms.RadioButton
    Friend WithEvents optSexSpecified As System.Windows.Forms.RadioButton
    Friend WithEvents txtEmail As System.Windows.Forms.TextBox
    Friend WithEvents grpAge As System.Windows.Forms.GroupBox
    Friend WithEvents chkMinor As System.Windows.Forms.CheckBox
    Friend WithEvents optAgeDontcare As System.Windows.Forms.RadioButton
    Friend WithEvents optAgeSpecified As System.Windows.Forms.RadioButton
    Friend WithEvents btnOKoptAgeDontcare As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents chkAdult As System.Windows.Forms.CheckBox
    Friend WithEvents ckbMockup As System.Windows.Forms.CheckBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lstCover = New System.Windows.Forms.ListBox
        Me.lstLanguage = New System.Windows.Forms.ListBox
        Me.grpSex = New System.Windows.Forms.GroupBox
        Me.chkFemale = New System.Windows.Forms.CheckBox
        Me.chkMale = New System.Windows.Forms.CheckBox
        Me.optSexDontcare = New System.Windows.Forms.RadioButton
        Me.optSexSpecified = New System.Windows.Forms.RadioButton
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.txtEmail = New System.Windows.Forms.TextBox
        Me.grpAge = New System.Windows.Forms.GroupBox
        Me.chkMinor = New System.Windows.Forms.CheckBox
        Me.chkAdult = New System.Windows.Forms.CheckBox
        Me.optAgeDontcare = New System.Windows.Forms.RadioButton
        Me.optAgeSpecified = New System.Windows.Forms.RadioButton
        Me.btnOKoptAgeDontcare = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.ckbMockup = New System.Windows.Forms.CheckBox
        Me.grpSex.SuspendLayout()
        Me.grpAge.SuspendLayout()
        Me.SuspendLayout()
        '
        'lstCover
        '
        Me.lstCover.Location = New System.Drawing.Point(22, 32)
        Me.lstCover.Name = "lstCover"
        Me.lstCover.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.lstCover.Size = New System.Drawing.Size(274, 43)
        Me.lstCover.TabIndex = 0
        '
        'lstLanguage
        '
        Me.lstLanguage.Location = New System.Drawing.Point(22, 117)
        Me.lstLanguage.Name = "lstLanguage"
        Me.lstLanguage.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.lstLanguage.Size = New System.Drawing.Size(274, 43)
        Me.lstLanguage.TabIndex = 1
        '
        'grpSex
        '
        Me.grpSex.Controls.Add(Me.chkFemale)
        Me.grpSex.Controls.Add(Me.chkMale)
        Me.grpSex.Controls.Add(Me.optSexDontcare)
        Me.grpSex.Controls.Add(Me.optSexSpecified)
        Me.grpSex.Location = New System.Drawing.Point(22, 173)
        Me.grpSex.Name = "grpSex"
        Me.grpSex.Size = New System.Drawing.Size(122, 123)
        Me.grpSex.TabIndex = 2
        Me.grpSex.TabStop = False
        Me.grpSex.Text = "Sex"
        '
        'chkFemale
        '
        Me.chkFemale.Enabled = False
        Me.chkFemale.Location = New System.Drawing.Point(31, 92)
        Me.chkFemale.Name = "chkFemale"
        Me.chkFemale.Size = New System.Drawing.Size(73, 24)
        Me.chkFemale.TabIndex = 3
        Me.chkFemale.Text = "Female"
        '
        'chkMale
        '
        Me.chkMale.Enabled = False
        Me.chkMale.Location = New System.Drawing.Point(32, 64)
        Me.chkMale.Name = "chkMale"
        Me.chkMale.Size = New System.Drawing.Size(60, 24)
        Me.chkMale.TabIndex = 2
        Me.chkMale.Text = "Male"
        '
        'optSexDontcare
        '
        Me.optSexDontcare.Checked = True
        Me.optSexDontcare.Location = New System.Drawing.Point(16, 16)
        Me.optSexDontcare.Name = "optSexDontcare"
        Me.optSexDontcare.Size = New System.Drawing.Size(77, 24)
        Me.optSexDontcare.TabIndex = 1
        Me.optSexDontcare.TabStop = True
        Me.optSexDontcare.Text = "Don't Care"
        '
        'optSexSpecified
        '
        Me.optSexSpecified.Location = New System.Drawing.Point(16, 42)
        Me.optSexSpecified.Name = "optSexSpecified"
        Me.optSexSpecified.Size = New System.Drawing.Size(77, 24)
        Me.optSexSpecified.TabIndex = 0
        Me.optSexSpecified.Text = "Specified"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(25, 8)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(79, 16)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Cover Letter"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(24, 96)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(152, 16)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Language"
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(24, 316)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(152, 16)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "E-mail PDF to:"
        '
        'txtEmail
        '
        Me.txtEmail.Location = New System.Drawing.Point(22, 335)
        Me.txtEmail.Name = "txtEmail"
        Me.txtEmail.Size = New System.Drawing.Size(274, 20)
        Me.txtEmail.TabIndex = 7
        Me.txtEmail.Text = "TextBox1"
        '
        'grpAge
        '
        Me.grpAge.Controls.Add(Me.chkMinor)
        Me.grpAge.Controls.Add(Me.chkAdult)
        Me.grpAge.Controls.Add(Me.optAgeDontcare)
        Me.grpAge.Controls.Add(Me.optAgeSpecified)
        Me.grpAge.Location = New System.Drawing.Point(174, 173)
        Me.grpAge.Name = "grpAge"
        Me.grpAge.Size = New System.Drawing.Size(121, 123)
        Me.grpAge.TabIndex = 8
        Me.grpAge.TabStop = False
        Me.grpAge.Text = "Age"
        '
        'chkMinor
        '
        Me.chkMinor.Enabled = False
        Me.chkMinor.Location = New System.Drawing.Point(31, 92)
        Me.chkMinor.Name = "chkMinor"
        Me.chkMinor.Size = New System.Drawing.Size(73, 24)
        Me.chkMinor.TabIndex = 3
        Me.chkMinor.Text = "Minor"
        '
        'chkAdult
        '
        Me.chkAdult.Enabled = False
        Me.chkAdult.Location = New System.Drawing.Point(32, 64)
        Me.chkAdult.Name = "chkAdult"
        Me.chkAdult.Size = New System.Drawing.Size(60, 24)
        Me.chkAdult.TabIndex = 2
        Me.chkAdult.Text = "Adult"
        '
        'optAgeDontcare
        '
        Me.optAgeDontcare.Checked = True
        Me.optAgeDontcare.Location = New System.Drawing.Point(16, 16)
        Me.optAgeDontcare.Name = "optAgeDontcare"
        Me.optAgeDontcare.Size = New System.Drawing.Size(77, 24)
        Me.optAgeDontcare.TabIndex = 1
        Me.optAgeDontcare.TabStop = True
        Me.optAgeDontcare.Text = "Don't Care"
        '
        'optAgeSpecified
        '
        Me.optAgeSpecified.Location = New System.Drawing.Point(16, 42)
        Me.optAgeSpecified.Name = "optAgeSpecified"
        Me.optAgeSpecified.Size = New System.Drawing.Size(77, 24)
        Me.optAgeSpecified.TabIndex = 0
        Me.optAgeSpecified.Text = "Specified"
        '
        'btnOKoptAgeDontcare
        '
        Me.btnOKoptAgeDontcare.Location = New System.Drawing.Point(222, 380)
        Me.btnOKoptAgeDontcare.Name = "btnOKoptAgeDontcare"
        Me.btnOKoptAgeDontcare.TabIndex = 9
        Me.btnOKoptAgeDontcare.Text = "&OK"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(144, 380)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 10
        Me.btnCancel.Text = "&Cancel"
        '
        'ckbMockup
        '
        Me.ckbMockup.Location = New System.Drawing.Point(23, 378)
        Me.ckbMockup.Name = "ckbMockup"
        Me.ckbMockup.Size = New System.Drawing.Size(112, 24)
        Me.ckbMockup.TabIndex = 11
        Me.ckbMockup.Text = "Mock up"
        '
        'frmTestPrint
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(320, 414)
        Me.Controls.Add(Me.ckbMockup)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOKoptAgeDontcare)
        Me.Controls.Add(Me.grpAge)
        Me.Controls.Add(Me.txtEmail)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.grpSex)
        Me.Controls.Add(Me.lstLanguage)
        Me.Controls.Add(Me.lstCover)
        Me.Name = "frmTestPrint"
        Me.Text = "Test Prints"
        Me.grpSex.ResumeLayout(False)
        Me.grpAge.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOKoptAgeDontcare.Click
        Dim x As New PickedPrints
        Dim Ages As String = GetAges()
        Dim Sexes As String = GetSexes()
        Dim objCommand As New SqlCommand("sp_TestPrints", objConnection)
        Dim objDataAdapter As New SqlDataAdapter(objCommand)
        Dim objData As New DataSet
        Dim CoverDesc As String
        Dim LanguageDesc As String
        Dim Covers As String = GetSelected(lstCover, Coverdesc)
        Dim Languages As String = GetSelected(lstLanguage, LanguageDesc)
        Dim strCmd As String
        Dim s As String
        Dim params(4) As Object
        Dim lngReturn As Long

        With objCommand
            .Parameters.Add("@Survey_id", SqlDbType.Int).Value = gSurvey_ID
            .Parameters.Add("@sexes", SqlDbType.Char, 2).Value = Sexes
            .Parameters.Add("@ages", SqlDbType.Char, 2).Value = Ages
            .Parameters.Add("@languages", SqlDbType.VarChar, 20).Value = Languages
            .Parameters.Add("@covers", SqlDbType.VarChar).Value = Covers
            Dim objParam As SqlParameter = .Parameters.Add("intReturn", SqlDbType.Int)
            objParam.Direction = ParameterDirection.ReturnValue
            .CommandTimeout = 9600
            .CommandType = CommandType.StoredProcedure
        End With
        'objCommand.CommandText = strCmd

        objDataAdapter.Fill(objData, "griddata")


        If IsNothing(objData.Tables("griddata")) Then
            s = "No surveys available for Test Print."
        Else
            s = "The following " + CStr(objData.Tables("griddata").Rows.Count) + _
                " surveys will be generated and PDFs will be mailed to " + _
                Me.txtEmail.Text + vbCrLf + _
                "Each survey will have versions for " + _
                CoverDesc + " and in " + LanguageDesc

        End If

        'If Me.CheckBox1.Tag = "M" Then

        If x.showform(objData.Tables("griddata"), s, Me) = Windows.Forms.DialogResult.OK Then
            Me.Close()

            objCommand.Parameters.Add("@employee_id", SqlDbType.Int).Value = gEmployee_ID
            objCommand.Parameters.Add("@email", SqlDbType.VarChar).Value = Me.txtEmail.Text
            objCommand.Parameters.Add("@bitSchedule", SqlDbType.Bit).Value = 1
            objCommand.Parameters.Add("@bitMockup", SqlDbType.Bit).Value = Math.Abs(CInt(Me.ckbMockup.Checked))

            'strCmd = strCmd + ",@employee_id = " + CStr(gEmployee_ID) + _
            '      ",@email = '" + Me.txtEmail.Text + "'" + _
            '      ",@bitSchedule = 1, @bitMockup = " + CStr(Math.Abs(CInt(Me.ckbMockup.Checked)))
            objCommand.ExecuteNonQuery()
            lngReturn = objCommand.Parameters("intReturn").Value()

            Me.Text = CStr(lngReturn)

        End If
        If Not IsNothing(objData.Tables("griddata")) Then
            objData.Tables("griddata").Rows.Clear()
        End If

    End Sub

    Private Sub frmTestPrint_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load


    End Sub

    Private Sub optSexSpecified_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optSexSpecified.CheckedChanged
        Me.chkMale.Enabled = optSexSpecified.Checked
        Me.chkFemale.Enabled = optSexSpecified.Checked
    End Sub

    Private Sub optAgeSpecified_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optAgeSpecified.CheckedChanged
        Me.chkAdult.Enabled = optAgeSpecified.Checked
        Me.chkMinor.Enabled = optAgeSpecified.Checked
    End Sub

    Private Function GetSexes() As String
        If optSexDontcare.Checked Then
            GetSexes = "DC"
            Exit Function
        End If
        GetSexes = ""

        If chkFemale.Checked Then
            GetSexes = GetSexes + "F"
        End If

        If chkMale.Checked Then
            GetSexes = GetSexes + "M"
        End If

        If GetSexes = "" Then GetSexes = "DC"
    End Function

    Private Function GetAges() As String
        If optAgeDontcare.Checked Then
            GetAges = "DC"
            Exit Function
        End If
        GetAges = ""
        If chkAdult.Checked Then
            GetAges = GetAges + "A"
        End If

        If chkMinor.Checked Then
            GetAges = GetAges + "M"
        End If
        If GetAges = "" Then GetAges = "DC"
    End Function

    Private Function GetSelected(ByVal lst As Windows.Forms.ListBox, ByRef desc As String) As String
        Dim objSelectedIndexes As Windows.Forms.ListBox.SelectedObjectCollection = lst.SelectedItems
        Dim i As Integer
        GetSelected = ""
        desc = ""
        For i = 0 To objSelectedIndexes.Count - 1
            If i = objSelectedIndexes.Count - 1 Then
                GetSelected = GetSelected + objSelectedIndexes(i).Item(lst.ValueMember).ToString
                If desc.Length > 1 Then
                    desc = desc.Remove(desc.Length - 1, 1)
                End If
                If i > 0 Then
                    desc = desc + " && " + objSelectedIndexes(i).Item(lst.DisplayMember).ToString.Trim
                Else
                    desc = objSelectedIndexes(i).Item(lst.DisplayMember).ToString.Trim
                End If
            Else
                GetSelected = GetSelected + objSelectedIndexes(i).Item(lst.ValueMember).ToString + ","
                desc = desc + objSelectedIndexes(i).Item(lst.DisplayMember).ToString.Trim + ","
            End If
        Next


    End Function

    Private Sub chkAdult_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkAdult.CheckedChanged

    End Sub
End Class
