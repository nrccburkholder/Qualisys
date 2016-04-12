Attribute VB_Name = "modQueueManager"
'-----------------------------------------------------------------
' Copyright © National Research Corporation
'
' Required References:
'       Microsoft ActiveX Data Objects 2.5 Library
'       OLE Automation
'       Queue Manager DLL
'
' Revisions:
'       Date        By  Description
'       10-04-2002  SH  Recompiled with VB6.0 and moved EXE to
'                       \components\QualiSysEXEs\.
'       05-01-2006  SH  Added the image for HCAHPS.
'-----------------------------------------------------------------

Option Explicit

Global Const LISTVIEW_BUTTON = 11

Global Const conHospital = 70
Global Const conGroupedPrint = 20

''''''''''''''''''''''''''''''''''''
'''' February 13, 2015 Refactor Notes -- Chris Burkholder
''''''''''''''''''''''''''''''''''''
''''
'''' Below are the main constants now used to manage icon state in Queue Manager.
'''' The only exception above is that conHospital, now set to 70, is the default starting point
'''' The set of 14 constants below MUST MATCH the order of icons in the resource:
'''' Con(default): 70..83; HCAHPS: 28..41; HHCAHPS: 42-55; ACOCAHPS/ICHCAHPS: 56-69; <Red>: 84-97; HOSPICE: 98-111
'''' Currently, the first (Hospital) icon in the set must be evenly divisible by 14 = TotalStates below
''''
'''' IsHCAHPS, IsHHCAHPS, IsACOCAHPS functions have been eliminated.  These were only used to determine the icon set for an image.
'''' So, instead, taking the value: (image \ TotalStates) * TotalStates puts us back on the Hospital icon for the set, and then
'''' the state constant below may be added to land on the desired icon in the same set
''''
'''' Other cases were trying to figure out if the current icon index was any of the Hospital, or any of the MailBundle, etc.
'''' These cases could be handled by taking the value: index Mod TotalStates and testing that against Hospital or MailBundle, etc.
''''
'''' Here's hoping a port to .NET has become less daunting at this point...
''''
''''''''''''''''''''''''''''''''''''

Global Const Hospital = 0
Global Const Configuration = 1
Global Const Bundle = 2
Global Const FadedConfiguration = 3
Global Const GroupedPrintHospital = 4
Global Const GroupedPrintConfiguration = 5
Global Const CheckedHospital = 6
Global Const CheckedBundle = 7
Global Const CheckedConfiguration = 8
Global Const CheckedGroupedPrintHospital = 9
Global Const MailBundle = 10
Global Const AlreadyMailed = 11
Global Const Deleted = 12
Global Const Printing = 13

Global Const TotalStates = 14

Global Const BlueOffset = -42   '70 + -42 = 28 = conHospital + BlueOffset   = blueHospital
Global Const PurpleOffset = -28 '70 + -28 = 42 = conHospital + PurpleOffset = purpleHospital
Global Const OrangeOffset = -14 '70 + -14 = 56 = conHospital + OrangeOffset = orangeHospital
Global Const RedOffset = 14     '70 +  14 = 84 = conHospital + RedOffset    = redHospital
Global Const GreenOffset = 28   '70 +  28 = 98 = conHospital + GreenOffset  = greenHospital

Global Const OffsetHCAHPS = BlueOffset
Global Const OffsetHHCAHPS = PurpleOffset
Global Const OffsetACOCAHPS = OrangeOffset
Global Const OffsetICHCAHPS = OrangeOffset
Global Const OffsetHOSPICE = RedOffset
Global Const OffsetPQRSCAHPS = OrangeOffset
Global Const OffsetOASCAHPS = GreenOffset

Public fMainForm As frmMain

Sub Main()
    Set fMainForm = New frmMain
    fMainForm.Show
End Sub



