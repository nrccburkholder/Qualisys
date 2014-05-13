Imports NormsApplicationBusinessObjectsLibrary
Public Class SurveyTypesList
    Inherits System.Windows.Forms.UserControl

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
    Friend WithEvents lstSurveyTypes As System.Windows.Forms.ListBox
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lstSurveyTypes = New System.Windows.Forms.ListBox
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lstSurveyTypes
        '
        Me.lstSurveyTypes.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lstSurveyTypes.Location = New System.Drawing.Point(8, 40)
        Me.lstSurveyTypes.Name = "lstSurveyTypes"
        Me.lstSurveyTypes.Size = New System.Drawing.Size(184, 173)
        Me.lstSurveyTypes.TabIndex = 16
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Survey Types"
        Me.SectionPanel1.Controls.Add(Me.lstSurveyTypes)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(208, 224)
        Me.SectionPanel1.TabIndex = 17
        '
        'SurveyTypesList
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "SurveyTypesList"
        Me.Size = New System.Drawing.Size(208, 224)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Property SelectedSurveyType() As SurveyType
        Get
            Return DirectCast(lstSurveyTypes.SelectedItem, SurveyType)
        End Get
        Set(ByVal Value As SurveyType)
            lstSurveyTypes.SelectedItem = Value
        End Set
    End Property

    Public Sub PopulateSurveyTypes()
        Dim SurveyTypes As DataSet
        Dim SurveysList As New SurveyTypesCollection

        lstSurveyTypes.DataSource = Nothing
        SurveyTypes = DataAccess.GetSurveyTypes()
        For Each row As DataRow In SurveyTypes.Tables(0).Rows
            SurveysList.Add(SurveyType.getSurveyTypefromDataRow(row))
        Next
        lstSurveyTypes.DataSource = SurveysList
        lstSurveyTypes.DisplayMember = "Name"
    End Sub
End Class
