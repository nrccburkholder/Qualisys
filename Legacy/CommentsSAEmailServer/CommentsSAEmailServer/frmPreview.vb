Imports System
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Drawing
Imports System.Resources
Imports System.Runtime.CompilerServices
Imports System.Windows.Forms

Namespace CommentsSAEmailServer
    Public Class frmPreview
        Inherits Form
        ' Methods
        Public Sub New(ByVal strPreview As String)
            AddHandler MyBase.Load, New EventHandler(AddressOf Me.frmPreview_Load)
            Me.InitializeComponent
            Me.txtPreview.Text = strPreview
            Me.txtPreview.Select(0, 0)
        End Sub

        Private Sub btnFinished_Click(ByVal sender As Object, ByVal e As EventArgs)
            Me.Close
        End Sub

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing AndAlso (Not Me.components Is Nothing)) Then
                Me.components.Dispose
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Sub frmPreview_Load(ByVal sender As Object, ByVal e As EventArgs)
        End Sub

        <DebuggerStepThrough> _
        Private Sub InitializeComponent()
            Dim manager As New ResourceManager(GetType(frmPreview))
            Me.txtPreview = New TextBox
            Me.btnFinished = New Button
            Me.SuspendLayout
            Me.txtPreview.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.txtPreview.AutoSize = False
            Me.txtPreview.Font = New Font("Courier New", 9.75!, FontStyle.Regular, GraphicsUnit.Point, 0)
            Dim point As New Point(8, 8)
            Me.txtPreview.Location = point
            Me.txtPreview.Multiline = True
            Me.txtPreview.Name = "txtPreview"
            Me.txtPreview.ReadOnly = True
            Me.txtPreview.ScrollBars = ScrollBars.Vertical
            Dim size As New Size(&H218, 280)
            Me.txtPreview.Size = size
            Me.txtPreview.TabIndex = 0
            Me.txtPreview.Text = ""
            Me.btnFinished.Anchor = (AnchorStyles.Right Or AnchorStyles.Bottom)
            point = New Point(&H1C0, &H128)
            Me.btnFinished.Location = point
            Me.btnFinished.Name = "btnFinished"
            size = New Size(&H60, &H1C)
            Me.btnFinished.Size = size
            Me.btnFinished.TabIndex = 1
            Me.btnFinished.Text = "&Finished"
            size = New Size(5, 14)
            Me.AutoScaleBaseSize = size
            size = New Size(&H228, &H14D)
            Me.ClientSize = size
            Me.Controls.AddRange(New Control() { Me.btnFinished, Me.txtPreview })
            Me.Font = New Font("Tahoma", 8.25!, FontStyle.Regular, GraphicsUnit.Point, 0)
            Me.Icon = DirectCast(manager.GetObject("$this.Icon"), Icon)
            Me.MaximizeBox = False
            size = New Size(560, 360)
            Me.MinimumSize = size
            Me.Name = "frmPreview"
            Me.ShowInTaskbar = False
            Me.StartPosition = FormStartPosition.CenterParent
            Me.Text = "frmPreview"
            Me.ResumeLayout(False)
        End Sub


        ' Properties
        Friend Overridable Property btnFinished As Button
            Get
                Return Me._btnFinished
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnFinished Is Nothing) Then
                    RemoveHandler Me._btnFinished.Click, New EventHandler(AddressOf Me.btnFinished_Click)
                End If
                Me._btnFinished = WithEventsValue
                If (Not Me._btnFinished Is Nothing) Then
                    AddHandler Me._btnFinished.Click, New EventHandler(AddressOf Me.btnFinished_Click)
                End If
            End Set
        End Property

        Friend Overridable Property txtPreview As TextBox
            Get
                Return Me._txtPreview
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As TextBox)
                If (Not Me._txtPreview Is Nothing) Then
                End If
                Me._txtPreview = WithEventsValue
                If (Not Me._txtPreview Is Nothing) Then
                End If
            End Set
        End Property


        ' Fields
        <AccessedThroughProperty("btnFinished")> _
        Private _btnFinished As Button
        <AccessedThroughProperty("txtPreview")> _
        Private _txtPreview As TextBox
        Private components As IContainer
    End Class
End Namespace

