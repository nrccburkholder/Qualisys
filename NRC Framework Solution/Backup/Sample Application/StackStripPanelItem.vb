Imports System.ComponentModel
Imports System.Windows.Forms.Design

Public Class StackStripPanelItem

    Private mImage As Image
    Private mImageTransparentColor As Color
    Private mText As String

    Public Property Image() As Image
        Get
            Return mImage
        End Get
        Set(ByVal value As Image)
            mImage = value
        End Set
    End Property

    Public Property ImageTransparentColor() As Color
        Get
            Return mImageTransparentColor
        End Get
        Set(ByVal value As Color)
            mImageTransparentColor = value
        End Set
    End Property

    Public Property Text() As String
        Get
            Return mText
        End Get
        Set(ByVal value As String)
            mText = value
        End Set
    End Property

    Public Overrides Function ToString() As String
        If String.IsNullOrEmpty(mText) Then
            Return MyBase.ToString()
        Else
            Return mText
        End If


    End Function
End Class


Public Class StackStripPanelItemCollection
    Inherits Collections.ObjectModel.Collection(Of StackStripPanelItem)

    Public Event ItemAdded As EventHandler
    Public Event ItemRemoved As EventHandler

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As StackStripPanelItem)
        MyBase.InsertItem(index, item)

        RaiseEvent ItemAdded(Me, EventArgs.Empty)
    End Sub

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        MyBase.RemoveItem(index)

        RaiseEvent ItemRemoved(Me, EventArgs.Empty)
    End Sub

End Class