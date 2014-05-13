Imports System.ComponentModel
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Formatters.Binary

<Serializable()> Public Class UserSettings
    Implements ISerializable

#Region " Private Members "
    Private mCommentFont As Font
    Private mCodeFont As Font
    Private mAdvanceKey As Keys
    Private mFinishKey As Keys
    Private mMaskKey As Keys
    Private mBackUpKey As Keys
    Private mResetKey As Keys
#End Region

#Region " Exposed Events "
    Public Event CommentFontChanged As EventHandler
    Public Event CodeFontChanged As EventHandler

    Public Event AdvanceKeyChanged As EventHandler
    Public Event FinishKeyChanged As EventHandler
    Public Event MaskKeyChanged As EventHandler

    Public Event AdvanceLabelChanged As EventHandler
    Public Event FinishLabelChanged As EventHandler
#End Region

#Region " Public Properties "
    <Category("Appearance"), Description("The font that will be used to display and edit comment text.")> _
    Public Property CommentFont() As Font
        Get
            Return mCommentFont
        End Get
        Set(ByVal Value As Font)
            mCommentFont = Value
            RaiseEvent CommentFontChanged(Me, New EventArgs)
        End Set
    End Property

    <Category("Appearance"), Description("The font that will be used to display comment code values.")> _
    Public Property CodeFont() As Font
        Get
            Return mCodeFont
        End Get
        Set(ByVal Value As Font)
            mCodeFont = Value
            RaiseEvent CodeFontChanged(Me, New EventArgs)
        End Set
    End Property

    <Category("Behavior"), Description("The key to press that will advance to the next comment.")> _
    Public Property AdvanceKey() As Keys
        Get
            Return mAdvanceKey
        End Get
        Set(ByVal Value As Keys)
            mAdvanceKey = Value
            RaiseEvent AdvanceKeyChanged(Me, New EventArgs)
            RaiseEvent AdvanceLabelChanged(Me, New EventArgs)
        End Set
    End Property

    <Category("Behavior"), Description("The key to press to save the current comment and finish working.")> _
    Public Property FinishKey() As Keys
        Get
            Return mFinishKey
        End Get
        Set(ByVal Value As Keys)
            mFinishKey = Value
            RaiseEvent FinishKeyChanged(Me, New EventArgs)
            RaiseEvent FinishLabelChanged(Me, New EventArgs)
        End Set
    End Property

    <Category("Behavior"), Description("The key to press to mask highlighted text.")> _
    Public Property MaskKey() As Keys
        Get
            Return mMaskKey
        End Get
        Set(ByVal Value As Keys)
            mMaskKey = Value
            RaiseEvent MaskKeyChanged(Me, New EventArgs)
        End Set
    End Property

    <Category("System")> _
    Public ReadOnly Property AdvanceLabel() As String
        Get
            Return String.Format("Advance ({0})", System.Enum.GetName(GetType(Keys), AdvanceKey))
        End Get
    End Property

    <Category("System")> _
    Public ReadOnly Property FinishLabel() As String
        Get
            Return String.Format("Finish ({0})", System.Enum.GetName(GetType(Keys), FinishKey))
        End Get
    End Property

    <Category("Behavior"), Description("The key to press to back up to the previous comment.")> _
    Public Property BackUpKey() As Keys
        Get
            Return mBackUpKey
        End Get
        Set(ByVal Value As Keys)
            mBackUpKey = Value
        End Set
    End Property

    <Category("Behavior"), Description("The key to press to reset data to its original state.")> _
    Public Property ResetKey() As Keys
        Get
            Return mResetKey
        End Get
        Set(ByVal Value As Keys)
            mResetKey = Value
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private Shared ReadOnly Property FilePath() As String
        Get
            Return String.Format("{0}\{1}\UserSettings.dat", Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), AppName)
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
        mCommentFont = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        mCodeFont = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))

        mAdvanceKey = Keys.F10
        mFinishKey = Keys.F11
        mMaskKey = Keys.F12
        mBackUpKey = Keys.Escape
        mResetKey = Keys.F8
    End Sub

    Private Sub New(ByVal info As SerializationInfo, ByVal context As StreamingContext)
        mCommentFont = CType(info.GetValue("CommentFont", GetType(Font)), Font)
        mCodeFont = CType(info.GetValue("CodeFont", GetType(Font)), Font)

        mAdvanceKey = CType(info.GetValue("AdvanceKey", GetType(Keys)), Keys)
        mFinishKey = CType(info.GetValue("FinishKey", GetType(Keys)), Keys)
        mMaskKey = CType(info.GetValue("MaskKey", GetType(Keys)), Keys)
        mBackUpKey = CType(info.GetValue("BackUpKey", GetType(Keys)), Keys)
        mResetKey = CType(info.GetValue("ResetKey", GetType(Keys)), Keys)
    End Sub
#End Region

#Region " GetKeyEventShortCut Method "
    Public Shared Function GetKeyEventShortCut(ByVal e As KeyEventArgs) As Shortcut
        'Ctrl+Shift
        If e.Control AndAlso e.Shift Then
            Select Case e.KeyData
                Case Keys.D0
                    Return Shortcut.CtrlShift0
                Case Keys.D1
                    Return Shortcut.CtrlShift1
                Case Keys.D2
                    Return Shortcut.CtrlShift2
                Case Keys.D3
                    Return Shortcut.CtrlShift3
                Case Keys.D4
                    Return Shortcut.CtrlShift4
                Case Keys.D5
                    Return Shortcut.CtrlShift5
                Case Keys.D6
                    Return Shortcut.CtrlShift6
                Case Keys.D7
                    Return Shortcut.CtrlShift7
                Case Keys.D8
                    Return Shortcut.CtrlShift8
                Case Keys.D9
                    Return Shortcut.CtrlShift9
                Case Keys.A
                    Return Shortcut.CtrlShiftA
                Case Keys.B
                    Return Shortcut.CtrlShiftB
                Case Keys.C
                    Return Shortcut.CtrlShiftC
                Case Keys.D
                    Return Shortcut.CtrlShiftD
                Case Keys.E
                    Return Shortcut.CtrlShiftE
                Case Keys.F
                    Return Shortcut.CtrlShiftF
                Case Keys.F1
                    Return Shortcut.CtrlShiftF1
                Case Keys.F2
                    Return Shortcut.CtrlShiftF2
                Case Keys.F3
                    Return Shortcut.CtrlShiftF3
                Case Keys.F4
                    Return Shortcut.CtrlShiftF4
                Case Keys.F5
                    Return Shortcut.CtrlShiftF5
                Case Keys.F6
                    Return Shortcut.CtrlShiftF6
                Case Keys.F7
                    Return Shortcut.CtrlShiftF7
                Case Keys.F8
                    Return Shortcut.CtrlShiftF7
                Case Keys.F9
                    Return Shortcut.CtrlShiftF9
                Case Keys.F10
                    Return Shortcut.CtrlShiftF10
                Case Keys.F11
                    Return Shortcut.CtrlShiftF11
                Case Keys.F12
                    Return Shortcut.CtrlShiftF12
                Case Keys.G
                    Return Shortcut.CtrlShiftG
                Case Keys.H
                    Return Shortcut.CtrlShiftH
                Case Keys.I
                    Return Shortcut.CtrlShiftI
                Case Keys.J
                    Return Shortcut.CtrlShiftJ
                Case Keys.K
                    Return Shortcut.CtrlShiftK
                Case Keys.L
                    Return Shortcut.CtrlShiftL
                Case Keys.M
                    Return Shortcut.CtrlShiftM
                Case Keys.N
                    Return Shortcut.CtrlShiftN
                Case Keys.O
                    Return Shortcut.CtrlShiftO
                Case Keys.P
                    Return Shortcut.CtrlShiftP
                Case Keys.Q
                    Return Shortcut.CtrlShiftQ
                Case Keys.R
                    Return Shortcut.CtrlShiftR
                Case Keys.S
                    Return Shortcut.CtrlShiftS
                Case Keys.T
                    Return Shortcut.CtrlShiftT
                Case Keys.U
                    Return Shortcut.CtrlShiftU
                Case Keys.V
                    Return Shortcut.CtrlShiftV
                Case Keys.W
                    Return Shortcut.CtrlShiftW
                Case Keys.X
                    Return Shortcut.CtrlShiftX
                Case Keys.Y
                    Return Shortcut.CtrlShiftY
                Case Keys.Z
                    Return Shortcut.CtrlShiftZ
            End Select
        End If

        'Control
        If e.Control Then
            Select Case e.KeyData
                Case Keys.D0
                    Return Shortcut.Ctrl0
                Case Keys.D1
                    Return Shortcut.Ctrl1
                Case Keys.D2
                    Return Shortcut.Ctrl2
                Case Keys.D3
                    Return Shortcut.Ctrl3
                Case Keys.D4
                    Return Shortcut.Ctrl4
                Case Keys.D5
                    Return Shortcut.Ctrl5
                Case Keys.D6
                    Return Shortcut.Ctrl6
                Case Keys.D7
                    Return Shortcut.Ctrl7
                Case Keys.D8
                    Return Shortcut.Ctrl8
                Case Keys.D9
                    Return Shortcut.Ctrl9
                Case Keys.A
                    Return Shortcut.CtrlA
                Case Keys.B
                    Return Shortcut.CtrlB
                Case Keys.C
                    Return Shortcut.CtrlC
                Case Keys.D
                    Return Shortcut.CtrlD
                Case Keys.E
                    Return Shortcut.CtrlE
                Case Keys.F
                    Return Shortcut.CtrlF
                Case Keys.G
                    Return Shortcut.CtrlG
                Case Keys.H
                    Return Shortcut.CtrlH
                Case Keys.I
                    Return Shortcut.CtrlI
                Case Keys.J
                    Return Shortcut.CtrlJ
                Case Keys.K
                    Return Shortcut.CtrlK
                Case Keys.L
                    Return Shortcut.CtrlL
                Case Keys.M
                    Return Shortcut.CtrlM
                Case Keys.N
                    Return Shortcut.CtrlN
                Case Keys.O
                    Return Shortcut.CtrlO
                Case Keys.P
                    Return Shortcut.CtrlP
                Case Keys.Q
                    Return Shortcut.CtrlQ
                Case Keys.R
                    Return Shortcut.CtrlR
                Case Keys.S
                    Return Shortcut.CtrlS
                Case Keys.T
                    Return Shortcut.CtrlT
                Case Keys.U
                    Return Shortcut.CtrlU
                Case Keys.V
                    Return Shortcut.CtrlV
                Case Keys.W
                    Return Shortcut.CtrlW
                Case Keys.X
                    Return Shortcut.CtrlX
                Case Keys.Y
                    Return Shortcut.CtrlY
                Case Keys.Z
                    Return Shortcut.CtrlZ
                Case Keys.Delete
                    Return Shortcut.CtrlDel
                Case Keys.Insert
                    Return Shortcut.CtrlIns
                Case Keys.F1
                    Return Shortcut.CtrlF1
                Case Keys.F2
                    Return Shortcut.CtrlF2
                Case Keys.F3
                    Return Shortcut.CtrlF3
                Case Keys.F4
                    Return Shortcut.CtrlF4
                Case Keys.F5
                    Return Shortcut.CtrlF5
                Case Keys.F6
                    Return Shortcut.CtrlF6
                Case Keys.F7
                    Return Shortcut.CtrlF7
                Case Keys.F8
                    Return Shortcut.CtrlF8
                Case Keys.F9
                    Return Shortcut.CtrlF9
                Case Keys.F10
                    Return Shortcut.CtrlF10
                Case Keys.F11
                    Return Shortcut.CtrlF11
                Case Keys.F12
                    Return Shortcut.CtrlF12
            End Select
        End If

        'Shift
        If e.Shift Then
            Select Case e.KeyData
                Case Keys.Delete
                    Return Shortcut.ShiftDel
                Case Keys.F1
                    Return Shortcut.ShiftF1
                Case Keys.F2
                    Return Shortcut.ShiftF2
                Case Keys.F3
                    Return Shortcut.ShiftF3
                Case Keys.F4
                    Return Shortcut.ShiftF4
                Case Keys.F5
                    Return Shortcut.ShiftF5
                Case Keys.F6
                    Return Shortcut.ShiftF6
                Case Keys.F7
                    Return Shortcut.ShiftF7
                Case Keys.F8
                    Return Shortcut.ShiftF8
                Case Keys.F9
                    Return Shortcut.ShiftF9
                Case Keys.F10
                    Return Shortcut.ShiftF10
                Case Keys.F11
                    Return Shortcut.ShiftF11
                Case Keys.F12
                    Return Shortcut.ShiftF12
                Case Keys.Insert
                    Return Shortcut.ShiftIns
            End Select
        End If


        If e.Alt Then
            Select Case e.KeyData
                Case Keys.D0
                    Return Shortcut.Alt0
                Case Keys.D1
                    Return Shortcut.Alt1
                Case Keys.D2
                    Return Shortcut.Alt2
                Case Keys.D3
                    Return Shortcut.Alt3
                Case Keys.D4
                    Return Shortcut.Alt4
                Case Keys.D5
                    Return Shortcut.Alt5
                Case Keys.D6
                    Return Shortcut.Alt6
                Case Keys.D7
                    Return Shortcut.Alt7
                Case Keys.D8
                    Return Shortcut.Alt8
                Case Keys.D9
                    Return Shortcut.Alt9
                Case Keys.F1
                    Return Shortcut.AltF1
                Case Keys.F2
                    Return Shortcut.AltF2
                Case Keys.F3
                    Return Shortcut.AltF3
                Case Keys.F4
                    Return Shortcut.AltF4
                Case Keys.F5
                    Return Shortcut.AltF5
                Case Keys.F6
                    Return Shortcut.AltF6
                Case Keys.F7
                    Return Shortcut.AltF7
                Case Keys.F8
                    Return Shortcut.AltF8
                Case Keys.F9
                    Return Shortcut.AltF9
                Case Keys.F10
                    Return Shortcut.AltF10
                Case Keys.F11
                    Return Shortcut.AltF11
                Case Keys.F12
                    Return Shortcut.AltF12
                Case Keys.Back
                    Return Shortcut.AltBksp
            End Select
        End If

        Select Case e.KeyData
            Case Keys.F1
                Return Shortcut.F1
            Case Keys.F2
                Return Shortcut.F2
            Case Keys.F3
                Return Shortcut.F3
            Case Keys.F4
                Return Shortcut.F4
            Case Keys.F5
                Return Shortcut.F5
            Case Keys.F6
                Return Shortcut.F6
            Case Keys.F7
                Return Shortcut.F7
            Case Keys.F8
                Return Shortcut.F8
            Case Keys.F9
                Return Shortcut.F9
            Case Keys.F10
                Return Shortcut.F10
            Case Keys.F11
                Return Shortcut.F11
            Case Keys.F12
                Return Shortcut.F12
            Case Keys.Delete
                Return Shortcut.Del
            Case Keys.Insert
                Return Shortcut.Ins
        End Select

        Return Shortcut.None
    End Function
#End Region

#Region " Public Methods "
    Public Sub Serialize()
        Dim fileinfo As IO.FileInfo
        Dim formatter As BinaryFormatter

        fileinfo = New IO.FileInfo(FilePath)

        If Not fileinfo.Directory.Exists Then
            fileinfo.Directory.Create()
        End If

        Using stream As New IO.FileStream(FilePath, IO.FileMode.Create)
            formatter = New BinaryFormatter
            formatter.Serialize(stream, Me)
        End Using

    End Sub

    Public Shared Function Deserialize() As UserSettings
        Dim settings As UserSettings
        Dim formatter As BinaryFormatter
        Dim fileinfo As New IO.FileInfo(FilePath)

        If Not fileinfo.Exists Then
            settings = New UserSettings
        Else
            Try
                Using stream As New IO.FileStream(FilePath, IO.FileMode.Open)
                    formatter = New BinaryFormatter
                    settings = CType(formatter.Deserialize(stream), UserSettings)
                End Using
            Catch ex As Exception
                settings = New UserSettings
            End Try
        End If

        Return settings
    End Function

    'Specifically add object to the SerializationInfo if we want them persisted
    'Normally the <Serializable> attributes are sufficient but it seems that when you 
    'expose events, that will no longer do the trick and .NET unsuccessfully tries to serialize 
    'any attached event handlers.  So, to get around it we have to implement ISerializable and manually
    'declare all things we want to serialize.
    Public Sub GetObjectData(ByVal info As SerializationInfo, ByVal context As StreamingContext) Implements ISerializable.GetObjectData
        info.AddValue("CommentFont", mCommentFont, GetType(Font))
        info.AddValue("CodeFont", mCodeFont, GetType(Font))
        info.AddValue("AdvanceKey", mAdvanceKey, GetType(Keys))
        info.AddValue("FinishKey", mFinishKey, GetType(Keys))
        info.AddValue("MaskKey", mMaskKey, GetType(Keys))
        info.AddValue("BackUpKey", mBackUpKey, GetType(Keys))
        info.AddValue("ResetKey", mResetKey, GetType(Keys))
    End Sub
#End Region

End Class
