Imports NormsApplicationBusinessObjectsLibrary
Public Class CountriesList
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
    Friend WithEvents lstCountries As System.Windows.Forms.ListBox
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lstCountries = New System.Windows.Forms.ListBox
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lstCountries
        '
        Me.lstCountries.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lstCountries.Location = New System.Drawing.Point(8, 40)
        Me.lstCountries.Name = "lstCountries"
        Me.lstCountries.Size = New System.Drawing.Size(184, 173)
        Me.lstCountries.TabIndex = 16
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Countries"
        Me.SectionPanel1.Controls.Add(Me.lstCountries)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(208, 224)
        Me.SectionPanel1.TabIndex = 17
        '
        'CountriesList
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "CountriesList"
        Me.Size = New System.Drawing.Size(208, 224)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Property SelectedCountry() As Country
        Get
            Return DirectCast(lstCountries.SelectedItem, Country)
        End Get
        Set(ByVal Value As Country)
            lstCountries.SelectedItem = Value
        End Set
    End Property

    Public Sub PopulateCountries()
        Dim Countries As DataSet
        Dim CountryList As New CountryCollection

        lstCountries.DataSource = Nothing
        Countries = DataAccess.GetCountries()
        For Each row As DataRow In Countries.Tables(0).Rows
            CountryList.Add(Country.getCountryfromDataRow(row))
        Next
        lstCountries.DataSource = CountryList
        lstCountries.DisplayMember = "Name"
    End Sub
End Class
