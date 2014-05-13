<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BarcodeSearchNavigator
    Inherits QualiSys_Scanner_Interface.Navigator

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.SearchMoviePictureBox = New System.Windows.Forms.PictureBox
        CType(Me.SearchMoviePictureBox, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SearchMoviePictureBox
        '
        Me.SearchMoviePictureBox.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SearchMoviePictureBox.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.AnimatedSearch
        Me.SearchMoviePictureBox.Location = New System.Drawing.Point(0, 0)
        Me.SearchMoviePictureBox.Name = "SearchMoviePictureBox"
        Me.SearchMoviePictureBox.Size = New System.Drawing.Size(186, 427)
        Me.SearchMoviePictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage
        Me.SearchMoviePictureBox.TabIndex = 1
        Me.SearchMoviePictureBox.TabStop = False
        Me.SearchMoviePictureBox.Visible = False
        '
        'BarcodeSearchNavigator
        '
        Me.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center
        Me.Controls.Add(Me.SearchMoviePictureBox)
        Me.DoubleBuffered = True
        Me.Name = "BarcodeSearchNavigator"
        Me.Size = New System.Drawing.Size(186, 427)
        CType(Me.SearchMoviePictureBox, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SearchMoviePictureBox As System.Windows.Forms.PictureBox

End Class
