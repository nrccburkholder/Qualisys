VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "comctl32.ocx"
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "msflxgrd.ocx"
Begin VB.Form dlgShowCurrentUsers 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Transfer Results - Current Logins"
   ClientHeight    =   4365
   ClientLeft      =   150
   ClientTop       =   840
   ClientWidth     =   9075
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4365
   ScaleWidth      =   9075
   ShowInTaskbar   =   0   'False
   Begin MSFlexGridLib.MSFlexGrid MSFlexGrid1 
      Height          =   3375
      Left            =   0
      TabIndex        =   2
      Top             =   720
      Width           =   9090
      _ExtentX        =   16034
      _ExtentY        =   5953
      _Version        =   393216
      FixedCols       =   0
      BackColorBkg    =   -2147483637
   End
   Begin ComctlLib.StatusBar StatusBar1 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   4110
      Width           =   9075
      _ExtentX        =   16007
      _ExtentY        =   450
      Style           =   1
      SimpleText      =   ""
      _Version        =   327682
      BeginProperty Panels {0713E89E-850A-101B-AFC0-4210102A8DA7} 
         NumPanels       =   1
         BeginProperty Panel1 {0713E89F-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton OKButton 
      Cancel          =   -1  'True
      Caption         =   "OK"
      Height          =   375
      Left            =   7440
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   360
      Picture         =   "ShowCurrentUsersDialog.frx":0000
      Top             =   120
      Width           =   480
   End
End
Attribute VB_Name = "dlgShowCurrentUsers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private mRecordset As ADODB.Recordset

Private Sub Form_Load()

    LoadForm

End Sub

Private Sub LoadForm()
    
    On Error GoTo ErrorHandler
    
    Dim mConnection As ADODB.Connection
    Dim dbRecordset As ADODB.Recordset

    OpenDBConnection oConn:=mConnection, sConnString:=goRegMainDBConnString.Value

    Set mRecordset = New ADODB.Recordset
    mRecordset.CursorLocation = adUseClient
    mRecordset.Open "TR_SelectTransferResultsUserActivity", mConnection, adOpenForwardOnly
    
    PopulateGrid
    
    GoTo Cleanup
       
ErrorHandler:
    'Deal with the errors here
    Dim sMsg As String
    sMsg = "The following error was encountered: " & _
           "Error Source: " & Err.Source & " - " & _
           "Error #" & Err.Number & " - " & Err.Description
    MsgBox sMsg, vbCritical, "Show Current Users Error"
    
Cleanup:
    ' cleanup adodb objects
    If Not dbRecordset Is Nothing Then
        If dbRecordset.State = adStateOpen Then
            dbRecordset.Close
        End If
        Set dbRecordset = Nothing
    End If
    
    If Not mConnection Is Nothing Then
        If mConnection.State = adStateOpen Then
            CloseDBConnection oConn:=mConnection
        End If
        Set mConnection = Nothing
    End If

    Exit Sub

    
End Sub

Private Sub PopulateGrid()
    Dim i As Integer
    i = 1
    With MSFlexGrid1
        .Clear
        .Cols = 6
        .Rows = 2
        
        Dim iColCnt As Integer
        For iColCnt = 0 To mRecordset.Fields.Count - 1 Step 1
            .ColAlignment(iColCnt) = flexAlignCenterCenter
            .TextMatrix(0, iColCnt) = mRecordset.Fields(iColCnt).Name
        Next iColCnt
  
        .ColWidth(0) = 1000
        .ColWidth(1) = 1925
        .ColWidth(2) = 1925
        .ColWidth(3) = 1950
        .ColWidth(4) = 970
        .ColWidth(5) = 970
        
        If mRecordset.RecordCount > 0 Then
            If mRecordset.EOF <> True Then
                Do
                    Dim j As Integer
                    For j = 0 To mRecordset.Fields.Count - 1 Step 1
                        .TextMatrix(i, j) = mRecordset(j).Value
                    Next j
                    
                    i = i + 1
                    .Rows = .Rows + 1
                    mRecordset.MoveNext
                Loop Until mRecordset.EOF = True
            End If
        End If
    End With
    
    'ResizeGrid MSFlexGrid1, Me
    
    
End Sub

Public Sub ResizeGrid(pGrid As MSFlexGrid, pForm As Form)
    Dim intRow As Integer
    Dim intCol As Integer
   
    With pGrid
        For intCol = 0 To .Cols - 1
            For intRow = 0 To .Rows - 1
                If .ColWidth(intCol) < pForm.TextWidth(.TextMatrix(intRow, intCol)) + 700 Then
                   .ColWidth(intCol) = pForm.TextWidth(.TextMatrix(intRow, intCol)) + 700
                End If
            Next
        Next
    End With
End Sub

Private Sub Form_Resize()
    Me.Move Screen.Width - Me.Width - 7000, 700
End Sub

Private Sub OKButton_Click()
    Me.Hide
End Sub
