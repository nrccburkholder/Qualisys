Imports System.Windows.Forms
Imports System.Reflection
Namespace WinForms

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SplashScreen
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents an introductory "splash" screen for an application.  
    ''' </summary>
    ''' <remarks>
    ''' When a class derives from NRC.WinForms.SpashScreen the form will automatically display
    ''' the current application name, version, copyright text, and a logo.  The client application
    ''' can then override the functionality of any of these elements to customize the splash screen.
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/16/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SplashScreen
        Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Default constructor.
        ''' </summary>
        ''' <remarks>
        ''' This constructor is required so that inheriting forms can be displayed in the designer.
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/16/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New()
            MyBase.New()

            'This call is required by the Windows Form Designer.
            InitializeComponent()

            'Add any initialization after the InitializeComponent() call
            mAutoClose = True
        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Constructor that initializes the autoClose field.
        ''' </summary>
        ''' <param name="autoClose">A boolean that determines if the splash screen will automatically
        ''' close after it has been displayed or if the client app will manually close it.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/16/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub New(ByVal autoClose As Boolean, ByVal initMethod As [Delegate])
            MyBase.New()

            'This call is required by the Windows Form Designer.
            InitializeComponent()

            'Add any initialization after the InitializeComponent() call
            mAutoClose = autoClose
            'mFadeDelay = fadeDelay
            mInitMethod = initMethod
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
        Protected WithEvents lblTitle As System.Windows.Forms.Label
        Protected WithEvents lblVersion As System.Windows.Forms.Label
        Protected WithEvents lblCopyright As System.Windows.Forms.Label
        Protected WithEvents imgSplashImage As System.Windows.Forms.PictureBox
        <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
            Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(SplashScreen))
            Me.lblTitle = New System.Windows.Forms.Label
            Me.lblVersion = New System.Windows.Forms.Label
            Me.lblCopyright = New System.Windows.Forms.Label
            Me.imgSplashImage = New System.Windows.Forms.PictureBox
            Me.SuspendLayout()
            '
            'lblTitle
            '
            Me.lblTitle.Dock = System.Windows.Forms.DockStyle.Top
            Me.lblTitle.Font = New System.Drawing.Font("Tahoma", 14.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.lblTitle.Location = New System.Drawing.Point(0, 0)
            Me.lblTitle.Name = "lblTitle"
            Me.lblTitle.Size = New System.Drawing.Size(432, 23)
            Me.lblTitle.TabIndex = 2
            Me.lblTitle.Text = "Application.ProductName"
            Me.lblTitle.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
            '
            'lblVersion
            '
            Me.lblVersion.Dock = System.Windows.Forms.DockStyle.Bottom
            Me.lblVersion.Font = New System.Drawing.Font("Tahoma", 9.75!, CType((System.Drawing.FontStyle.Bold Or System.Drawing.FontStyle.Italic), System.Drawing.FontStyle), System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.lblVersion.Location = New System.Drawing.Point(0, 354)
            Me.lblVersion.Name = "lblVersion"
            Me.lblVersion.Size = New System.Drawing.Size(432, 23)
            Me.lblVersion.TabIndex = 4
            Me.lblVersion.Text = "Application.ProductVersion"
            Me.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
            '
            'lblCopyright
            '
            Me.lblCopyright.Dock = System.Windows.Forms.DockStyle.Bottom
            Me.lblCopyright.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
            Me.lblCopyright.Location = New System.Drawing.Point(0, 377)
            Me.lblCopyright.Name = "lblCopyright"
            Me.lblCopyright.Size = New System.Drawing.Size(432, 23)
            Me.lblCopyright.TabIndex = 3
            Me.lblCopyright.Text = "Assembly.CopyRight"
            Me.lblCopyright.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
            '
            'imgSplashImage
            '
            Me.imgSplashImage.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                        Or System.Windows.Forms.AnchorStyles.Left) _
                        Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
            Me.imgSplashImage.Image = CType(resources.GetObject("imgSplashImage.Image"), System.Drawing.Image)
            Me.imgSplashImage.Location = New System.Drawing.Point(48, 40)
            Me.imgSplashImage.Name = "imgSplashImage"
            Me.imgSplashImage.Size = New System.Drawing.Size(336, 303)
            Me.imgSplashImage.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage
            Me.imgSplashImage.TabIndex = 5
            Me.imgSplashImage.TabStop = False
            '
            'SplashScreen
            '
            Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
            Me.ClientSize = New System.Drawing.Size(432, 400)
            Me.Controls.Add(Me.imgSplashImage)
            Me.Controls.Add(Me.lblVersion)
            Me.Controls.Add(Me.lblCopyright)
            Me.Controls.Add(Me.lblTitle)
            Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
            Me.Name = "SplashScreen"
            Me.ShowInTaskbar = False
            Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
            Me.ResumeLayout(False)

        End Sub

#End Region

        Private mAutoClose As Boolean = True
        'Private mFadeDelay As Integer = 2
        Private mInitMethod As System.Delegate
        Private Delegate Sub BeginFadeInDelegate(ByVal fadeSeconds As Integer)
        Private Delegate Sub EndFadeInDelegate(ByVal ar As IAsyncResult)
        Private Delegate Sub UpdateOpacityDelegate(ByVal newValue As Double)


        Private Sub SplashScreen_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
            If Not Me.DesignMode Then
                Me.Opacity = 0

                Dim asm As AssemblyCopyrightAttribute
                asm = Attribute.GetCustomAttribute([Assembly].GetAssembly(Me.GetType), GetType(AssemblyCopyrightAttribute))

                Me.lblVersion.Text = "Version " & Application.ProductVersion
                Me.lblTitle.Text = Application.ProductName

                Me.lblCopyright.Text = asm.Copyright

                Dim beginMethod As New BeginFadeInDelegate(AddressOf FadeIn)
                Dim endMethod As New AsyncCallback(AddressOf FadeInCallback)
                beginMethod.BeginInvoke(1, endMethod, beginMethod)
            End If

        End Sub

        Private Sub FadeIn(ByVal fadeSeconds As Integer)
            Dim startTime As DateTime = DateTime.Now
            Dim total = fadeSeconds * 1000
            Dim millisecondsElapsed As Integer = 0

            'While less than fadeSeconds seconds have passed, keep adjusting the opacity
            While millisecondsElapsed < total
                millisecondsElapsed = DateTime.Now.Subtract(startTime).TotalMilliseconds
                UpdateOpacity(millisecondsElapsed / total)
                System.Threading.Thread.Sleep(20)
            End While

            'Set to fully opaque
            Me.Opacity = 1

            'If we have an initialization delegate to run then fire it off on the parent thread
            If Not mInitMethod Is Nothing AndAlso Not Me.Owner Is Nothing Then
                Me.Owner.Invoke(mInitMethod)
            End If

            'Make sure that the splash screen has been on for as least 3 seconds
            millisecondsElapsed = DateTime.Now.Subtract(startTime).TotalMilliseconds
            While millisecondsElapsed < 3000
                millisecondsElapsed = DateTime.Now.Subtract(startTime).TotalMilliseconds
                System.Threading.Thread.Sleep(250)
            End While
        End Sub

        Private Sub FadeInCallback(ByVal ar As IAsyncResult)
            If Me.InvokeRequired Then
                Me.BeginInvoke(New EndFadeInDelegate(AddressOf FadeInCallback), New Object() {ar})
            Else
                Dim beginmethod As BeginFadeInDelegate = DirectCast(ar.AsyncState, BeginFadeInDelegate)
                beginmethod.EndInvoke(ar)

                If mAutoClose Then Me.Close()
            End If
        End Sub

        Private Sub UpdateOpacity(ByVal newValue As Double)
            If Me.InvokeRequired Then
                Me.BeginInvoke(New UpdateOpacityDelegate(AddressOf UpdateOpacity), New Object() {newValue})
            Else
                Me.Opacity = newValue
            End If
        End Sub

    End Class
End Namespace
