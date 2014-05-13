Option Explicit On 
Option Strict On

Imports System.Windows.Forms

''' -----------------------------------------------------------------------------
''' Project	 : DataLoadingClasses
''' Class	 : DataLoadingClasses.MyTextBox
''' 
''' -----------------------------------------------------------------------------
''' <summary>
'''   TextBox derived class which overrides the ProcessCmdKey method to prevent 
'''   the Tab and Shift-Tab keys (messages) from reaching the TextBox
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[BMao]	06/18/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class MyTextBox
    Inherits System.Windows.Forms.TextBox

#Region " User Events "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Occurs when Tab or Shift-Tab key is pressed.
    ''' </summary>
    ''' <remarks>
    '''   ProcessCmdKey method is overrided to prevent the Tab 
    '''   and Shift-Tab keys (messages) from reaching the TextBox.
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	06/18/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Event Moving(ByVal direction As MoveDirections)

#End Region

#Region " Protected Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    '''   Processes a command key.
    '''   Raises Moving event when Tab or Shift-Tab key is pressed.
    ''' </summary>
    ''' <param name="msg">
    '''   A Message, passed by reference, that represents the window message to process.
    ''' </param>
    ''' <param name="keyData">
    '''   One of the Keys values that represents the key to process. 
    ''' </param>
    ''' <returns>
    '''   true if the character was processed by the control; otherwise, false.
    ''' </returns>
    ''' <remarks>
    '''   This method is called during message preprocessing to handle command keys. 
    '''   Command keys are keys that always take precedence over regular input keys. 
    '''   Examples of command keys include accelerators and menu shortcuts. The method
    '''   must return true to indicate that it has processed the command key, or false
    '''   to indicate that the key is not a command key. This method is only called 
    '''   when the control is hosted in a Windows Forms application or as an ActiveX 
    '''   control.
    ''' </remarks>
    ''' <history>
    ''' 	[BMao]	06/18/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Protected Overrides Function ProcessCmdKey(ByRef msg As Message, ByVal keyData As Keys) As Boolean

        'Debug.WriteLine("key: " & keyData)
        Select Case keyData
            Case Keys.Tab
                RaiseEvent Moving(MoveDirections.Forward)
                Return True
            Case (Keys.Shift Or Keys.Tab)
                RaiseEvent Moving(MoveDirections.Backward)
                Return True
            Case Else
                Return MyBase.ProcessCmdKey(msg, keyData)
        End Select

    End Function

#End Region

End Class

