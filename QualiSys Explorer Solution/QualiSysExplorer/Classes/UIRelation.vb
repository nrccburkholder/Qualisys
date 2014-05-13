Public Class UIRelation
    Private mTab As Nrc.Framework.WinForms.MultiPaneTab
    Private mNavControl As Control
    Private mMainControl As ContentControlBase

    Public ReadOnly Property Tab() As Nrc.Framework.WinForms.MultiPaneTab
        Get
            Return mTab
        End Get
    End Property
    Public ReadOnly Property NavControl() As Control
        Get
            Return mNavControl
        End Get
    End Property
    Public ReadOnly Property MainControl() As ContentControlBase
        Get
            Return mMainControl
        End Get
    End Property

    Public Sub New(ByVal tab As Nrc.Framework.WinForms.MultiPaneTab, ByVal navControl As Control, ByVal mainControl As ContentControlBase)
        mTab = tab
        mNavControl = navControl
        mMainControl = mainControl

        'Register the navigation control
        mMainControl.RegisterNavControl(mNavControl)
    End Sub

End Class
Public Class UIRelationCollection
    Inherits System.Collections.DictionaryBase

    Default Public ReadOnly Property Item(ByVal key As Nrc.Framework.WinForms.MultiPaneTab) As UIRelation
        Get
            Return CType(MyBase.Dictionary.Item(key), UIRelation)
        End Get
    End Property

    Public Sub Add(ByVal relation As UIRelation)
        MyBase.Dictionary.Add(relation.Tab, relation)
    End Sub
End Class