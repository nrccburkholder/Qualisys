''' -----------------------------------------------------------------------------
''' Project	 : QualiSys Data Entry
''' Interface	 : QDE.IWorkSection
''' 
''' -----------------------------------------------------------------------------
''' <summary>
''' Defines an interface for a Section Control where work is performed on comments.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	7/30/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Interface IWorkSection

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Determines if data entry work is currently in progress on this section.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    ReadOnly Property IsWorking() As Boolean

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Signals to the section control that work should begin for the specified template.
    ''' </summary>
    ''' <param name="template">The template for which the user should begin work</param>
    ''' <param name="isVerification">True if the user is in verification mode</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Sub BeginWork(ByVal batchID As Integer, ByVal template As String, ByVal isVerification As Boolean)

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Signals to the section control that work should end for the specified template.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Function EndWork() As Boolean

    'Events for notifing the main form when work is begining and ending.
    Delegate Sub WorkBeginingEventHandler(ByVal sender As Object, ByVal e As WorkBeginingEventArgs)
    Delegate Sub WorkEndingEventHandler(ByVal sender As Object, ByVal e As WorkEndingEventArgs)
    Event WorkBegining As WorkBeginingEventHandler
    Event WorkEnding As WorkEndingEventHandler

End Interface

Public Class WorkBeginingEventArgs
    Inherits System.EventArgs

End Class

Public Class WorkEndingEventArgs
    Inherits System.EventArgs

End Class



