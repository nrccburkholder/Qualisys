''' <summary>Base class for all section UI Controls</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public Class Section
    Inherits UserControl


    ''' <summary>This gives you a reference to the sections navigator control</summary>
    ''' <param name="navCtrl"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Overridable Sub RegisterNavControl(ByVal navCtrl As Navigator)
    End Sub

    
    ''' <summary>In your child class, you can override this to add handles to respond to events raised in your navigator control.</summary>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Overridable Sub ActivateSection()
    End Sub

    ''' <summary>In your child class, you can override this to remove handles to events raised in your navigator control.</summary>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Overridable Sub InactivateSection()
    End Sub

    ''' <summary>Child class can implement logic to not allow user to navigate to another section.</summary>
    ''' <returns></returns>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Overridable Function AllowInactivate() As Boolean
        Return True
    End Function

End Class
