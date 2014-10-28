VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CFormBase98"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "This class is used as a form's base class.  It give you the ability to locate forms as well as save and restore a forms location."
'/////////////////////////////////////////////////////////////////////////
'// Copyright © 1997  -  GalaxySoft  -  All Rights Reserved
'//
'// File Name:      CFormBase98.Cls
'// Language:       Visual Basic
'//
'// Author:         Jeffrey J. Fleming
'// Date:           01-23-97
'//
'// Description:    This class contains properties to allow it to save
'//                 and restore a forms screen location to the registry.
'//
'// Revisions:
'//     01-23-97    JJF     Implementation
'//     04-28-97    JJF     Updated to use the new registry server 97.
'//     04-01-98    JJF     Updated to use the new registry server 98.
'/////////////////////////////////////////////////////////////////////////

Option Explicit

    Private moForm    As Form
    Private mlHKey    As Long
    Private msSection As String


'/////////////////////////////////////////////////////////////////////////
'// Copyright © 1997  -  GalaxySoft  -  All Rights Reserved
'//
'// Routine:        CenterMeOn
'//
'// Author:         Jeffrey J. Fleming
'// Date:           01-23-97
'//
'// Purpose:        This routine allows you to center the registered form
'//                 on the specified form.
'//
'// Parameters:
'//     oCenterOn   Reference to the object that the registered form is to
'//                 be centered on.  This object must reference something
'//                 that has top, left, height, and width properties.
'//
'// Revisions:
'//     01-23-97    JJF     Implementation
'/////////////////////////////////////////////////////////////////////////
Public Sub CenterMeOn(oCenterOn As Object)

    Dim lLeft As Long
    Dim lTop  As Long
    
    'Center the form
    If TypeOf oCenterOn Is Screen Then
        lLeft = (oCenterOn.Width - moForm.Width) / 2
        lTop = (oCenterOn.Height - moForm.Height) / 2
    Else
        lLeft = oCenterOn.Left + (oCenterOn.Width - moForm.Width) / 2
        lTop = oCenterOn.Top + (oCenterOn.Height - moForm.Height) / 2
    End If
    moForm.Move lLeft, lTop
    
End Sub

'/////////////////////////////////////////////////////////////////////////
'// Copyright © 1997  -  GalaxySoft  -  All Rights Reserved
'//
'// Routine:        Register
'//
'// Author:         Jeffrey J. Fleming
'// Date:           01-23-97
'//
'// Purpose:        This routine registers the CFormBase object to the
'//                 specified form.
'//
'// Requires:       GalaxySoft Registration DB OLE Server DLL 98
'//
'// Parameters:
'//     oForm       Reference to the form object that this instance of the
'//                 CFormBase class is going to be in charge of.
'//     lHKey       Optional.  This is the registry HKey that will be used
'//                 to store the form's location.  The default value will
'//                 be set to HKEY_CURRENT_USER.
'//     sSection    Optional.  This is the registry section path that will
'//                 be used to store the form's location.  The default
'//                 will be set to an empty string.
'//
'// Revisions:
'//     01-23-97    JJF     Implementation
'//     02-15-97    JJF     Added the lHKey and the sSection parameters to
'//                         this routine so that they only have to be set
'//                         once as opposed to passing them in with the
'//                         location routines.
'//     04-28-97    JJF     Converted to work with the reg server 97.
'//     04-01-98    JJF     Converted to work with the reg server 98.
'/////////////////////////////////////////////////////////////////////////
Public Sub Register(oForm As Form, _
                    Optional ByVal lHKey As gsrsHKEYConstantsEnum = gsrsHKEYCurrentUser, _
                    Optional ByVal sSection As String = "")
    
    'Store the form pointer
    Set moForm = oForm
    
    'Set other member variables
    mlHKey = lHKey
    msSection = sSection
    
End Sub

'/////////////////////////////////////////////////////////////////////////
'// Copyright © 1997  -  GalaxySoft  -  All Rights Reserved
'//
'// Routine:        LocateMe
'//
'// Author:         Jeffrey J. Fleming
'// Date:           01-23-97
'//
'// Purpose:        This routine retrieves the registered form's size and
'//                 location from the registry and applies it to the form.
'//
'// Parameters:     None
'//
'// Revisions:
'//     01-23-97    JJF     Implementation
'//     02-15-97    JJF     Made the sSection and lHKey member variables
'//                         that get set in the Register routine.
'//                         Changed so that it only changes the width and
'//                         height of the form if the border style is such
'//                         that the user is allowed to change it's size.
'//                         Added the with statement around the access to
'//                         the form to speed up the execution.
'//     04-28-97    JJF     Changed to use the new registry server 97 and
'//                         the RegRect object instead of RegSgl.
'//     11-13-97    JJF     Added code to restore a maximized state if
'//                         required.
'//     04-01-98    JJF     Updated to work with reg server 98.
'/////////////////////////////////////////////////////////////////////////
Public Sub LocateMe()
Attribute LocateMe.VB_Description = "This routine retrieves the registered form's size and location from the registry and applies it to the form.  sSection specified the path in the registry."

    Dim oRegTemp  As New RegDBServer98.RegRect
    Dim oRegBool  As New RegDBServer98.RegBool   '** Added 11-13-97 JJF
    Dim fLeft     As Single
    Dim fTop      As Single
    Dim fWidth    As Single
    Dim fHeight   As Single
    Dim sFormName As String
    Dim fTemp     As Single
    
    With moForm
        'Initialize loction and size by centering it on the screen
        fLeft = (Screen.Width - .Width) / 2
        fTop = (Screen.Height - .Height) / 2
        fWidth = .Width
        fHeight = .Height
        
        'Now get the stored location data if it exists
        sFormName = .Name
        oRegTemp.Register sSection:=msSection, sKey:=sFormName, lHKey:=mlHKey
        fTemp = oRegTemp.Left
        If oRegTemp.IsPresent Then
            fLeft = oRegTemp.Left
            fTop = oRegTemp.Top
            If .BorderStyle = 2 Or .BorderStyle = 5 Then
                'Only pay attention to the width and height if the form's
                '  border style allows the user to change the size
                fWidth = oRegTemp.Width
                fHeight = oRegTemp.Height
            End If
        End If
        
        'Make sure that the bottom and right of the form are not off the
        '  edge of the screen
        If fLeft + fWidth > Screen.Width Then fLeft = 0
        If fTop + fHeight > Screen.Height Then fTop = 0
        
        'Locate the form
        .Move fLeft, fTop, fWidth, fHeight
        
        'Now check to see if the last location was maximized
        oRegBool.Register sSection:=msSection, sKey:=sFormName & " Maximized", _
                            lHKey:=mlHKey     '** Added 11-13-97 JJF
        If oRegBool.Value Then .WindowState = 2     '** Added 11-13-97 JJF
    End With
    
    'Clean up
    Set oRegTemp = Nothing
    Set oRegBool = Nothing  '** Added 11-13-97 JJF

End Sub

'/////////////////////////////////////////////////////////////////////////
'// Copyright © 1997  -  GalaxySoft  -  All Rights Reserved
'//
'// Routine:        SaveLocation
'//
'// Author:         Jeffrey J. Fleming
'// Date:           01-23-97
'//
'// Purpose:        This routine saves the registered form's size and
'//                 location to the registry.
'//
'// Parameters:     None
'//
'// Revisions:
'//     01-23-97    JJF     Implementation
'//     02-15-97    JJF     Made the sSection and lHKey member variables
'//                         that get set in the Register routine.
'//                         Added the with statement around the access to
'//                         the form to speed up the execution.
'//     04-28-97    JJF     Changed to use the new registry server 97 and
'//                         the RegRect object instead of RegSgl.
'//     11-13-97    JJF     Added code to store the maximized state if
'//                         required.
'//     04-01-98    JJF     Update to work with reg server 98.
'/////////////////////////////////////////////////////////////////////////
Public Sub SaveLocation()
Attribute SaveLocation.VB_Description = "This routine saves the registered form's size and location to the registry.  sSection specified the path in the registry."

    Dim oRegTemp  As New RegDBServer98.RegRect
    Dim oRegBool  As New RegDBServer98.RegBool   '** Added 11-13-97 JJF
    Dim sFormName As String
    
    'Get the screens name
    sFormName = moForm.Name
    
    'Save the maximized state and restore to normal state
    oRegBool.Register sSection:=msSection, sKey:=sFormName & " Maximized", _
                        lHKey:=mlHKey     '** Added 11-13-97 JJF
    oRegBool.Value = (moForm.WindowState = 2)     '** Added 11-13-97 JJF
    moForm.WindowState = 0    '** Added 11-13-97 JJF
    
    'Now save the location data to the registry
    oRegTemp.Register sSection:=msSection, sKey:=sFormName, lHKey:=mlHKey
    oRegTemp.SetFromObject oObject:=moForm

    'Clean up
    Set oRegTemp = Nothing
    Set oRegBool = Nothing  '** Added 11-13-97 JJF
    
End Sub

Private Sub Class_Terminate()

    Set moForm = Nothing
    
End Sub



