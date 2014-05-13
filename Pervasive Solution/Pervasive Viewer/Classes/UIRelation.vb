''' <summary>UI Relations link a tab (via the tab name) to a Navigator and Section Control</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public Class UIRelation

    Private mNavCtrl As Navigator
    Private mSectionCtrl As Section

    ''' <summary>The Navigator for a particular tab.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Property NavigationControl() As Navigator
        Get
            Return mNavCtrl
        End Get
        Set(ByVal value As Navigator)
            mNavCtrl = value
        End Set
    End Property

    ''' <summary>This section for a particular tab</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Property SectionControl() As Section
        Get
            Return mSectionCtrl
        End Get
        Set(ByVal value As Section)
            mSectionCtrl = value
        End Set
    End Property

    Public Sub New()
    End Sub

    ''' <summary>Constructor overload to set the navigator and section for a tab.</summary>
    ''' <param name="navigationControl"></param>
    ''' <param name="sectionControl"></param>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Sub New(ByVal navigationControl As Navigator, ByVal sectionControl As Section)
        Me.mNavCtrl = navigationControl
        Me.mSectionCtrl = sectionControl
        Me.mSectionCtrl.RegisterNavControl(mNavCtrl)
    End Sub

End Class

