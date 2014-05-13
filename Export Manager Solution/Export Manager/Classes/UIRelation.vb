Public Class UIRelation

    Private mNavCtrl As Navigator
    Private mSectionCtrl As Section

    Public Property NavigationControl() As Navigator
        Get
            Return mNavCtrl
        End Get
        Set(ByVal value As Navigator)
            mNavCtrl = value
        End Set
    End Property

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

    Public Sub New(ByVal navigationControl As Navigator, ByVal sectionControl As Section)
        Me.mNavCtrl = navigationControl
        Me.mSectionCtrl = sectionControl
        Me.mSectionCtrl.RegisterNavControl(mNavCtrl)
    End Sub

End Class

