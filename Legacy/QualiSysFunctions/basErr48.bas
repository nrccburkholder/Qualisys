Attribute VB_Name = "basErr48"
' Keep a global object on the thread to
' keep the project from unloading when
' the last reference to it goes away
' It has to be public to trick VB into
' thinking that the thread is not done
Public gt_objDummy As New IDummy

' Sample Sub main function
Public Sub Main()
    ' First line of code should be to instantiate
    ' the dummy class. Be sure to set the Sun Main
    ' as the Startup Object in the project properties.
    Set gt_objDummy = New IDummy
    
    ' Do rest of work if any
    
End Sub
