Imports Nrc.Qualisys.QualisysDataEntry.Library

Public Class frmLithoStatus
    Inherits Nrc.Framework.WinForms.DialogForm

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
    Friend WithEvents txtLitho As System.Windows.Forms.TextBox
    Friend WithEvents btnGo As System.Windows.Forms.Button
    Friend WithEvents lblLitho As System.Windows.Forms.Label
    Friend WithEvents lblStatus As System.Windows.Forms.Label
    Friend WithEvents btnClose As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.txtLitho = New System.Windows.Forms.TextBox
        Me.btnGo = New System.Windows.Forms.Button
        Me.lblLitho = New System.Windows.Forms.Label
        Me.lblStatus = New System.Windows.Forms.Label
        Me.btnClose = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Litho Status Report"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(342, 26)
        '
        'txtLitho
        '
        Me.txtLitho.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtLitho.Location = New System.Drawing.Point(80, 40)
        Me.txtLitho.Name = "txtLitho"
        Me.txtLitho.Size = New System.Drawing.Size(208, 21)
        Me.txtLitho.TabIndex = 1
        Me.txtLitho.Text = ""
        '
        'btnGo
        '
        Me.btnGo.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnGo.Location = New System.Drawing.Point(296, 40)
        Me.btnGo.Name = "btnGo"
        Me.btnGo.Size = New System.Drawing.Size(32, 23)
        Me.btnGo.TabIndex = 2
        Me.btnGo.Text = "Go"
        '
        'lblLitho
        '
        Me.lblLitho.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLitho.Location = New System.Drawing.Point(8, 40)
        Me.lblLitho.Name = "lblLitho"
        Me.lblLitho.Size = New System.Drawing.Size(64, 23)
        Me.lblLitho.TabIndex = 3
        Me.lblLitho.Text = "Litho Code:"
        Me.lblLitho.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStatus
        '
        Me.lblStatus.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblStatus.Location = New System.Drawing.Point(16, 80)
        Me.lblStatus.Name = "lblStatus"
        Me.lblStatus.Size = New System.Drawing.Size(312, 224)
        Me.lblStatus.TabIndex = 4
        Me.lblStatus.Text = "Status:"
        '
        'btnClose
        '
        Me.btnClose.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnClose.Location = New System.Drawing.Point(136, 320)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.TabIndex = 6
        Me.btnClose.Text = "Close"
        '
        'frmLithoStatus
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.Caption = "Litho Status Report"
        Me.ClientSize = New System.Drawing.Size(344, 352)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.lblStatus)
        Me.Controls.Add(Me.lblLitho)
        Me.Controls.Add(Me.btnGo)
        Me.Controls.Add(Me.txtLitho)
        Me.DockPadding.All = 1
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmLithoStatus"
        Me.Text = "frmLithoStatus"
        Me.Controls.SetChildIndex(Me.txtLitho, 0)
        Me.Controls.SetChildIndex(Me.btnGo, 0)
        Me.Controls.SetChildIndex(Me.lblLitho, 0)
        Me.Controls.SetChildIndex(Me.lblStatus, 0)
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnGo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGo.Click
        Dim rdr As IDataReader = QDEForm.GetLithoStatus(txtLitho.Text)
        Dim status As String = ""
        Dim lithoFound As Boolean = False
        While rdr.Read
            lithoFound = True
            status &= String.Format("Comment {0}:{1}", rdr("QstnCore"), vbCrLf)
            If rdr("strKeyedBy").ToString = "" Then
                status &= String.Format("    Awaiting Keying{0}", vbCrLf)
            Else
                status &= String.Format("    Keyed by {0} on {1}{2}", rdr("strKeyedBy").ToString, rdr("datKeyed").ToString, vbCrLf)
            End If
            If rdr("strKeyVerifiedBy").ToString = "" Then
                status &= String.Format("    Awaiting Key Verification{0}", vbCrLf)
            Else
                status &= String.Format("    Key Verified by {0} on {1}{2}", rdr("strKeyVerifiedBy").ToString, rdr("datKeyVerified").ToString, vbCrLf)
            End If
            If rdr("strCodedBy").ToString = "" Then
                status &= String.Format("    Awaiting Coding{0}", vbCrLf)
            Else
                status &= String.Format("    Coded by {0} on {1}{2}", rdr("strCodedBy").ToString, rdr("datCoded").ToString, vbCrLf)
            End If
            If rdr("strCodeVerifiedBy").ToString = "" Then
                status &= String.Format("    Awaiting Code Verification{0}", vbCrLf)
            Else
                status &= String.Format("    Code Verified by {0} on {1}{2}", rdr("strCodeVerifiedBy").ToString, rdr("datCodeVerified").ToString, vbCrLf)
            End If
            If rdr("datFinalized").ToString = "" Then
                status &= String.Format("    Awaiting Finalization{0}", vbCrLf)
            Else
                status &= String.Format("    Finalized on {0}{1}", rdr("datFinalized").ToString, vbCrLf)
            End If

        End While

        If Not lithoFound Then
            status = "Litho not found."
        End If

        lblStatus.Text = status
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        DialogResult = Windows.Forms.DialogResult.OK
        Close()
    End Sub
End Class
