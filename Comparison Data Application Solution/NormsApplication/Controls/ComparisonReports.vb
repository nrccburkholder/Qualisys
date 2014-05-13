Public Class ComparisonReports
    Inherits System.Windows.Forms.UserControl
    Public Event btnPressed(ByVal SelectedButton As ComparisonButtons)

    Public Enum ComparisonButtons
        btnDemoCounts = 0
        btnquestioncounts = 1
        btnFrequencies = 2
        btnAverage = 3
        btnScoresandRanks = 4
        btnPercentiles = 5
        btnQuestionUsers = 6
    End Enum


#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnDemoCounts As System.Windows.Forms.Button
    Friend WithEvents btnquestioncounts As System.Windows.Forms.Button
    Friend WithEvents btnFrequencies As System.Windows.Forms.Button
    Friend WithEvents btnAverage As System.Windows.Forms.Button
    Friend WithEvents btnScoresandRanks As System.Windows.Forms.Button
    Friend WithEvents btnPercentiles As System.Windows.Forms.Button
    Friend WithEvents btnQuestionUsers As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnQuestionUsers = New System.Windows.Forms.Button
        Me.btnPercentiles = New System.Windows.Forms.Button
        Me.btnScoresandRanks = New System.Windows.Forms.Button
        Me.btnAverage = New System.Windows.Forms.Button
        Me.btnFrequencies = New System.Windows.Forms.Button
        Me.btnquestioncounts = New System.Windows.Forms.Button
        Me.btnDemoCounts = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.SystemColors.Control
        Me.Panel1.Controls.Add(Me.btnQuestionUsers)
        Me.Panel1.Controls.Add(Me.btnPercentiles)
        Me.Panel1.Controls.Add(Me.btnScoresandRanks)
        Me.Panel1.Controls.Add(Me.btnAverage)
        Me.Panel1.Controls.Add(Me.btnFrequencies)
        Me.Panel1.Controls.Add(Me.btnquestioncounts)
        Me.Panel1.Controls.Add(Me.btnDemoCounts)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(160, 320)
        Me.Panel1.TabIndex = 0
        '
        'btnQuestionUsers
        '
        Me.btnQuestionUsers.Location = New System.Drawing.Point(8, 108)
        Me.btnQuestionUsers.Name = "btnQuestionUsers"
        Me.btnQuestionUsers.Size = New System.Drawing.Size(144, 23)
        Me.btnQuestionUsers.TabIndex = 6
        Me.btnQuestionUsers.Text = "Question Users"
        '
        'btnPercentiles
        '
        Me.btnPercentiles.Location = New System.Drawing.Point(8, 272)
        Me.btnPercentiles.Name = "btnPercentiles"
        Me.btnPercentiles.Size = New System.Drawing.Size(144, 23)
        Me.btnPercentiles.TabIndex = 5
        Me.btnPercentiles.Text = "Percentiles 1 to 100"
        '
        'btnScoresandRanks
        '
        Me.btnScoresandRanks.Location = New System.Drawing.Point(8, 231)
        Me.btnScoresandRanks.Name = "btnScoresandRanks"
        Me.btnScoresandRanks.Size = New System.Drawing.Size(144, 23)
        Me.btnScoresandRanks.TabIndex = 4
        Me.btnScoresandRanks.Text = "Group Scores and Ranks"
        '
        'btnAverage
        '
        Me.btnAverage.Location = New System.Drawing.Point(8, 190)
        Me.btnAverage.Name = "btnAverage"
        Me.btnAverage.Size = New System.Drawing.Size(144, 23)
        Me.btnAverage.TabIndex = 3
        Me.btnAverage.Text = "Average Scores"
        '
        'btnFrequencies
        '
        Me.btnFrequencies.Location = New System.Drawing.Point(8, 149)
        Me.btnFrequencies.Name = "btnFrequencies"
        Me.btnFrequencies.Size = New System.Drawing.Size(144, 23)
        Me.btnFrequencies.TabIndex = 2
        Me.btnFrequencies.Text = "Frequencies"
        '
        'btnquestioncounts
        '
        Me.btnquestioncounts.Location = New System.Drawing.Point(8, 67)
        Me.btnquestioncounts.Name = "btnquestioncounts"
        Me.btnquestioncounts.Size = New System.Drawing.Size(144, 23)
        Me.btnquestioncounts.TabIndex = 1
        Me.btnquestioncounts.Text = "Question Counts"
        '
        'btnDemoCounts
        '
        Me.btnDemoCounts.Location = New System.Drawing.Point(8, 26)
        Me.btnDemoCounts.Name = "btnDemoCounts"
        Me.btnDemoCounts.Size = New System.Drawing.Size(144, 23)
        Me.btnDemoCounts.TabIndex = 0
        Me.btnDemoCounts.Text = "Demographic Counts"
        '
        'ComparisonReports
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.Panel1)
        Me.Name = "ComparisonReports"
        Me.Size = New System.Drawing.Size(160, 320)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Private Sub btnDemoCounts_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDemoCounts.Click
        RaiseEvent btnPressed(ComparisonButtons.btnDemoCounts)
    End Sub

    Private Sub btnquestioncounts_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnquestioncounts.Click
        RaiseEvent btnPressed(ComparisonButtons.btnquestioncounts)
    End Sub

    Private Sub btnFrequencies_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFrequencies.Click
        RaiseEvent btnPressed(ComparisonButtons.btnFrequencies)
    End Sub

    Private Sub btnAverage_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAverage.Click
        RaiseEvent btnPressed(ComparisonButtons.btnAverage)
    End Sub

    Private Sub btnScoresandRanks_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnScoresandRanks.Click
        RaiseEvent btnPressed(ComparisonButtons.btnScoresandRanks)
    End Sub

    Private Sub btnPercentiles_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPercentiles.Click
        RaiseEvent btnPressed(ComparisonButtons.btnPercentiles)
    End Sub

    Private Sub btnQuestionUsers_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnQuestionUsers.Click
        RaiseEvent btnPressed(ComparisonButtons.btnQuestionUsers)
    End Sub
End Class
