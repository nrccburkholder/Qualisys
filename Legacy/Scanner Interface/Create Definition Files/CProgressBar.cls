VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CProgressBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit
    
    'local variable(s) to hold property value(s)
    Private moStatusPanel As ComctlLib.Panel
    Private moProgressPanel As ComctlLib.Panel
    Private moProgressBar As ComctlLib.ProgressBar
    
    Private meStyle As eProgressBarStyles
    
    Public Enum eProgressBarStyles
        pbsPleaseWait = 0
        pbsProgressBar = 1
    End Enum
    
    
    
Public Property Let Style(ByVal eData As eProgressBarStyles)
    
    'Save the style
    meStyle = eData
    
    'Initialize the variables
    moStatusPanel.Text = ""
    moProgressBar.Value = 0
    
    Select Case meStyle
        Case pbsPleaseWait
            moProgressBar.Visible = False
            moProgressPanel.Text = "Please Wait ..."
        Case pbsProgressBar
            moProgressBar.Visible = True
            moProgressPanel.Text = ""
    End Select
    
End Property


Public Property Get Style() As eProgressBarStyles
    
    Style = meStyle
    
End Property




Public Property Let Progress(ByVal nData As Integer)
    
    moProgressBar.Value = nData
    
End Property


Public Property Get Progress() As Integer
    
    Progress = moProgressBar.Value
    
End Property



Public Property Let Status(ByVal sData As String)
    
    moStatusPanel.Text = sData
    
End Property


Public Property Get Status() As String
    
    Status = moStatusPanel.Text
    
End Property




Public Sub Register(oStatusPanel As ComctlLib.Panel, _
                    oProgressPanel As ComctlLib.Panel, _
                    oProgressBar As ComctlLib.ProgressBar)
    
    'Save the parameters
    Set moStatusPanel = oStatusPanel
    Set moProgressPanel = oProgressPanel
    Set moProgressBar = oProgressBar
    
    'Initialize the progress bar
    With moProgressBar
        .Min = 0
        .Max = 100
        .Value = 0
    End With
    
End Sub

Private Sub Class_Terminate()
    
    Set moStatusPanel = Nothing
    Set moProgressPanel = Nothing
    Set moProgressBar = Nothing
    
End Sub


