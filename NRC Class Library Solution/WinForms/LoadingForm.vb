Imports System.Threading
Imports System.Windows.Forms
Imports System.Drawing

Public Class LoadingForm
    Private ReadOnly _loadingText As String
    Private _ellipsis As Integer

    Private ReadOnly _timer As System.Timers.Timer

    Public Sub New(ByVal loadingText As String)
        MyBase.New()
        InitializeComponent()

        _loadingText = loadingText
        LoadingLabel.Text = _loadingText + "    "

        _ellipsis = -1

        Me.Show()
        Me.Update()

        ' Now that we've autosized, let's grab our dimensions and set them
        Dim meSize As New Size(Me.Size.Width, Me.Size.Height)
        Dim boxSize As New Size(Box.Size.Width, Box.Size.Height)
        Dim labelSize As New Size(LoadingLabel.Size.Width, LoadingLabel.Size.Height)

        Me.AutoSize = False
        Box.AutoSize = False
        LoadingLabel.AutoSize = False

        Me.Size = meSize
        Box.Size = boxSize
        LoadingLabel.Size = labelSize

        Tick()

        _timer = New System.Timers.Timer()
        _timer.SynchronizingObject = Me
        _timer.Interval = 200
        AddHandler _timer.Elapsed, AddressOf Tick
        _timer.Start()
    End Sub

    Public Overloads Sub Dispose()
        Me.Close()
        MyBase.Dispose()
    End Sub

#Region "Private Methods"
    Private Sub Tick()
        _ellipsis = (_ellipsis + 1) Mod 4

        Dim text As String = _loadingText
        For i As Integer = 1 To _ellipsis
            text += "."
        Next

        Redraw(text)
    End Sub

    Private Sub Redraw(ByVal text As String)
        Me.LoadingLabel.Text = text
        LoadingLabel.Refresh()
        Box.Refresh()
        Me.Refresh()
    End Sub
#End Region
End Class