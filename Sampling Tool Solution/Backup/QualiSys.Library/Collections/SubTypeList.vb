Imports Nrc.Framework.BusinessLogic

<Serializable()> _
Public Class SubTypeList
    Inherits List(Of SubType)

    Private mIsDirty As Boolean

    Public ReadOnly Property IsDirty() As Boolean
        Get
            mIsDirty = False
            For Each Item As SubType In Me
                If Item.IsDirty Then
                    mIsDirty = True
                    Exit For
                End If
            Next
            Return mIsDirty
        End Get
    End Property

    Public Overloads Sub Add(ByVal item As SubType)
        MyBase.Add(item)
        Me.mIsDirty = True
    End Sub

    Protected Overloads Sub Clear()
        MyBase.Clear()
        Me.mIsDirty = True
    End Sub

    Protected Overloads Sub Remove(ByVal item As SubType)
        MyBase.Remove(item)
        Me.mIsDirty = True
    End Sub

    Public Sub ResetDirtyFlag()
        For Each Item As SubType In Me
            Item.ResetDirtyFlag()
        Next
        mIsDirty = False
    End Sub

End Class
