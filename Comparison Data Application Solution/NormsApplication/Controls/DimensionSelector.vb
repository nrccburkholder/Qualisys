Imports NormsApplicationBusinessObjectsLibrary
Public Class DimensionSelector
    Inherits System.Windows.Forms.UserControl

    Public Event UserChanged(ByVal User As String)
    Public Event DimensionChanged(ByVal Dimen As Dimension)
    Private mSelectionType As SelectionType = SelectionType.MultipleSelect

    Public Enum SelectionType
        SingleSelect = 0
        MultipleSelect = 1
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
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents lstUsers As System.Windows.Forms.ListBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents btnAddDimensions As System.Windows.Forms.Button
    Friend WithEvents lstDimensions As System.Windows.Forms.ListBox
    Friend WithEvents lstSurveyTypesDimensions As System.Windows.Forms.ListBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents txtDimensions As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lklRefresh As System.Windows.Forms.LinkLabel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.lklRefresh = New System.Windows.Forms.LinkLabel
        Me.lstUsers = New System.Windows.Forms.ListBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.btnAddDimensions = New System.Windows.Forms.Button
        Me.lstDimensions = New System.Windows.Forms.ListBox
        Me.lstSurveyTypesDimensions = New System.Windows.Forms.ListBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.txtDimensions = New System.Windows.Forms.TextBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Select Dimensions"
        Me.SectionPanel1.Controls.Add(Me.lklRefresh)
        Me.SectionPanel1.Controls.Add(Me.lstUsers)
        Me.SectionPanel1.Controls.Add(Me.Label10)
        Me.SectionPanel1.Controls.Add(Me.btnAddDimensions)
        Me.SectionPanel1.Controls.Add(Me.lstDimensions)
        Me.SectionPanel1.Controls.Add(Me.lstSurveyTypesDimensions)
        Me.SectionPanel1.Controls.Add(Me.Label7)
        Me.SectionPanel1.Controls.Add(Me.Label8)
        Me.SectionPanel1.Controls.Add(Me.txtDimensions)
        Me.SectionPanel1.Controls.Add(Me.Label9)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(752, 304)
        Me.SectionPanel1.TabIndex = 0
        '
        'lklRefresh
        '
        Me.lklRefresh.Location = New System.Drawing.Point(16, 192)
        Me.lklRefresh.Name = "lklRefresh"
        Me.lklRefresh.Size = New System.Drawing.Size(100, 16)
        Me.lklRefresh.TabIndex = 24
        Me.lklRefresh.TabStop = True
        Me.lklRefresh.Text = "Refresh All Lists"
        '
        'lstUsers
        '
        Me.lstUsers.Location = New System.Drawing.Point(8, 80)
        Me.lstUsers.Name = "lstUsers"
        Me.lstUsers.Size = New System.Drawing.Size(136, 108)
        Me.lstUsers.TabIndex = 22
        '
        'Label10
        '
        Me.Label10.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.Location = New System.Drawing.Point(16, 40)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(112, 28)
        Me.Label10.TabIndex = 21
        Me.Label10.Text = "User"
        '
        'btnAddDimensions
        '
        Me.btnAddDimensions.Location = New System.Drawing.Point(344, 200)
        Me.btnAddDimensions.Name = "btnAddDimensions"
        Me.btnAddDimensions.Size = New System.Drawing.Size(64, 24)
        Me.btnAddDimensions.TabIndex = 20
        Me.btnAddDimensions.Text = "Add"
        '
        'lstDimensions
        '
        Me.lstDimensions.Location = New System.Drawing.Point(394, 80)
        Me.lstDimensions.Name = "lstDimensions"
        Me.lstDimensions.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lstDimensions.Size = New System.Drawing.Size(344, 108)
        Me.lstDimensions.TabIndex = 17
        '
        'lstSurveyTypesDimensions
        '
        Me.lstSurveyTypesDimensions.Location = New System.Drawing.Point(192, 80)
        Me.lstSurveyTypesDimensions.Name = "lstSurveyTypesDimensions"
        Me.lstSurveyTypesDimensions.Size = New System.Drawing.Size(162, 108)
        Me.lstSurveyTypesDimensions.TabIndex = 16
        '
        'Label7
        '
        Me.Label7.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.Location = New System.Drawing.Point(402, 40)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(168, 23)
        Me.Label7.TabIndex = 15
        Me.Label7.Text = "Dimensions"
        '
        'Label8
        '
        Me.Label8.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.Location = New System.Drawing.Point(192, 40)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(152, 28)
        Me.Label8.TabIndex = 14
        Me.Label8.Text = "Survey Types"
        '
        'txtDimensions
        '
        Me.txtDimensions.Location = New System.Drawing.Point(16, 240)
        Me.txtDimensions.Multiline = True
        Me.txtDimensions.Name = "txtDimensions"
        Me.txtDimensions.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtDimensions.Size = New System.Drawing.Size(722, 48)
        Me.txtDimensions.TabIndex = 18
        Me.txtDimensions.Text = ""
        '
        'Label9
        '
        Me.Label9.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.Location = New System.Drawing.Point(16, 216)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(186, 24)
        Me.Label9.TabIndex = 19
        Me.Label9.Text = "Selected Dimension(s)"
        '
        'DimensionSelector
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "DimensionSelector"
        Me.Size = New System.Drawing.Size(752, 304)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Public Properties"
    Public Property SelectedDimensions() As String
        Get
            Return txtDimensions.Text
        End Get
        Set(ByVal Value As String)
            txtDimensions.Text = Value
        End Set
    End Property

    Public Property SingleSelect() As SelectionType
        Get
            Return mSelectionType
        End Get
        Set(ByVal Value As SelectionType)
            mSelectionType = Value
            If Value = SelectionType.SingleSelect Then
                lstDimensions.SelectionMode = SelectionMode.One
                txtDimensions.Visible = False
                btnAddDimensions.Visible = False
                Me.Height = 210
                SectionPanel1.Height = 210
            End If
        End Set
    End Property

#End Region

#Region "Public Methods"
    Public Sub PopulateDimensions()
        Dim DimensionUsers As DataSet
        Dim SurveyList As New SurveyTypesCollection
        Dim UserList As New NormUserCollection

        RemoveHandler lstSurveyTypesDimensions.SelectedValueChanged, AddressOf SurveyTypesDimensions_SelectedValueChanged
        RemoveHandler lstUsers.SelectedValueChanged, AddressOf Users_SelectedValueChanged

        DimensionUsers = DataAccess.GetDimensionUsers()
        For Each row As DataRow In DimensionUsers.Tables(0).Rows
            UserList.Add(NormUser.getUserfromDataRow(row))
        Next
        lstUsers.DataSource = UserList
        lstUsers.DisplayMember = "Name"

        Dim SurveyTypes As DataSet
        SurveyTypes = DataAccess.GetSurveyTypes()
        For Each row As DataRow In SurveyTypes.Tables(0).Rows
            SurveyList.Add(SurveyType.getSurveyTypefromDataRow(row))
        Next
        lstSurveyTypesDimensions.DataSource = SurveyList
        lstSurveyTypesDimensions.DisplayMember = "Name"

        AddHandler lstSurveyTypesDimensions.SelectedValueChanged, AddressOf SurveyTypesDimensions_SelectedValueChanged
        AddHandler lstUsers.SelectedValueChanged, AddressOf Users_SelectedValueChanged
    End Sub

#End Region

#Region "Private Methods"

    Private Sub lklRefresh_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lklRefresh.LinkClicked
        PopulateDimensions()
    End Sub

    Private Sub SurveyTypesDimensions_SelectedValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstSurveyTypesDimensions.SelectedValueChanged
        UpdateDimensionList()
    End Sub

    Private Sub Users_SelectedValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstUsers.SelectedValueChanged
        UpdateDimensionList()
        RaiseEvent UserChanged(DirectCast(lstUsers.SelectedItem, NormUser).Name)
    End Sub

    Private Sub UpdateDimensionList()
        Dim Dimensions As DataSet
        Dim DimensionList As New DimensionsCollection
        Dim eventArgs As New System.EventArgs
        'If Not Me.DesignMode Then
        If lstUsers.SelectedItems.Count > 0 And lstSurveyTypesDimensions.SelectedItems.Count > 0 Then
            Dimensions = DataAccess.GetDimensions(DirectCast(lstUsers.SelectedItem, NormUser).MemberID, DirectCast(lstSurveyTypesDimensions.SelectedItem, SurveyType).ID)
            For Each row As DataRow In Dimensions.Tables(0).Rows
                DimensionList.Add(Dimension.GetDimension(CInt(row("Dimension_ID"))))
            Next
            RemoveHandler lstDimensions.SelectedValueChanged, AddressOf lstDimensions_SelectedValueChanged
            lstDimensions.DataSource = DimensionList
            lstDimensions.DisplayMember = "Name"
            lstDimensions_SelectedValueChanged(lstDimensions, eventArgs)
            AddHandler lstDimensions.SelectedValueChanged, AddressOf lstDimensions_SelectedValueChanged
        End If
        'End If
    End Sub

    Private Sub AddDimensions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddDimensions.Click
        Dim SelectedValues As String = ""
        Dim tmpSelectedItem As Dimension
        If lstDimensions.SelectedItems.Count > 0 Then
            For Each tmpSelectedItem In lstDimensions.SelectedItems
                SelectedValues = SelectedValues & tmpSelectedItem.ID & ","
            Next
            SelectedValues = SelectedValues.Substring(0, SelectedValues.Length - 1)
            If txtDimensions.Text = "" Then
                txtDimensions.Text = SelectedValues
            Else
                txtDimensions.Text = txtDimensions.Text & "," & SelectedValues
            End If
        End If
    End Sub

    Private Sub lstDimensions_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstDimensions.SelectedValueChanged
        If Not lstDimensions.SelectedItem Is Nothing Then RaiseEvent DimensionChanged(lstDimensions.SelectedItem)
    End Sub
#End Region

End Class
