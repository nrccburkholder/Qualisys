Imports NormsApplicationBusinessObjectsLibrary
Public Class NormList
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
    Friend WithEvents scpNormGroups As NRC.WinForms.SectionPanel
    Friend WithEvents lstNormsList As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.scpNormGroups = New NRC.WinForms.SectionPanel
        Me.lstNormsList = New System.Windows.Forms.ListBox
        Me.scpNormGroups.SuspendLayout()
        Me.SuspendLayout()
        '
        'scpNormGroups
        '
        Me.scpNormGroups.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpNormGroups.Caption = " Norms"
        Me.scpNormGroups.Controls.Add(Me.lstNormsList)
        Me.scpNormGroups.Dock = System.Windows.Forms.DockStyle.Fill
        Me.scpNormGroups.DockPadding.All = 1
        Me.scpNormGroups.Location = New System.Drawing.Point(0, 0)
        Me.scpNormGroups.Name = "scpNormGroups"
        Me.scpNormGroups.ShowCaption = True
        Me.scpNormGroups.Size = New System.Drawing.Size(336, 160)
        Me.scpNormGroups.TabIndex = 35
        '
        'lstNormsList
        '
        Me.lstNormsList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lstNormsList.HorizontalScrollbar = True
        Me.lstNormsList.Location = New System.Drawing.Point(24, 32)
        Me.lstNormsList.Name = "lstNormsList"
        Me.lstNormsList.Size = New System.Drawing.Size(288, 121)
        Me.lstNormsList.TabIndex = 14
        '
        'NormList
        '
        Me.Controls.Add(Me.scpNormGroups)
        Me.Name = "NormList"
        Me.Size = New System.Drawing.Size(336, 160)
        Me.scpNormGroups.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mIncludeNew As Boolean
    Private mUseProduction As Boolean
    Public Event SelectedNormChanged(ByVal SelectedNorm As USNormSetting)

    Private Sub NormList_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Populate()
    End Sub

    Public Sub Populate()
        Dim NormsCollection As New USNormSettingCollection
        lstNormsList.DataSource = Nothing
        If mIncludeNew = True Then
            Dim newNorm As New USNormSetting
            newNorm.NormLabel = " New"
            NormsCollection.Add(newNorm)
        End If
        For Each norm As USNormSetting In USNormSetting.GetAllNorms(mUseProduction)
            NormsCollection.Add(norm)
        Next
        lstNormsList.DataSource = NormsCollection
        lstNormsList.DisplayMember = "NormLabel"
    End Sub

    Public Property includeNew() As Boolean
        Get
            Return mIncludeNew
        End Get
        Set(ByVal Value As Boolean)
            mIncludeNew = Value
        End Set
    End Property

    Public Property UseProduction() As Boolean
        Get
            Return mUseProduction
        End Get
        Set(ByVal Value As Boolean)
            mUseProduction = Value
        End Set
    End Property

    Private Sub lstNormsList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstNormsList.SelectedIndexChanged
        RaiseEvent SelectedNormChanged(DirectCast(lstNormsList.SelectedItem, USNormSetting))
    End Sub
End Class
