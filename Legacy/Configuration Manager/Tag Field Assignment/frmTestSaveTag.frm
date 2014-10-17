VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   1440
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4755
   LinkTopic       =   "Form1"
   ScaleHeight     =   1440
   ScaleWidth      =   4755
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim SaveTags1 As nrcTagField.clsSaveTagFields
    
    On Error GoTo FormLoad_Error
    
    Set SaveTags1 = CreateObject("nrcTagField.clsSaveTagFields")
    Me.MousePointer = vbHourglass
    Form1.Caption = "Tag Fields are being generated now..."
    SaveTags1.Go 1, 1, True
    Form1.Caption = "Tag Fields have been refreshed!"
    Me.Hide
    Set SaveTags1 = Nothing
    Me.MousePointer = vbNormal
    Unload Me
    
    GoTo FormLoad_Exit
    
FormLoad_Error:
    MsgBox "Error#: " & Err.Number & vbCrLf _
            & "Error Description: " & Err.Description & vbCrLf & vbCrLf _
            & "Error Saving Tags: FormLoad:" & vbCrLf
    Resume FormLoad_Exit

FormLoad_Exit:

End Sub
