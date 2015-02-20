''' <summary>
''' A custom collection of MethodologyStep objects
''' </summary>
''' <remarks>This is a custom collection so that it can keep an IsDirty flag</remarks>
Public Class MethodologyStepCollection
    Inherits Collection(Of MethodologyStep)

#Region " Private Fields "
    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    Public ReadOnly Property IsDirty() As Boolean
        Get
            'If the collection is dirty (items added/removed) then just return true
            If mIsDirty Then
                Return True
            Else
                'Otherwise, we have to check each item in the collection to
                'determine if it is dirty
                For Each methStep As MethodologyStep In Me.Items
                    If methStep.IsDirty Then
                        Return True
                    End If
                Next

                'If none of the items in the collection are dirty then the
                'collection as a whole is not dirty
                Return False
            End If
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
#End Region

#Region " Base Class Overrides "
    Protected Overrides Sub ClearItems()
        If Me.Count > 0 Then
            MarkAsDirty()
        End If
        MyBase.ClearItems()
    End Sub

    Protected Overrides Sub InsertItem(ByVal index As Integer, ByVal item As MethodologyStep)
        MyBase.InsertItem(index, item)
        item.ParentCollection = Me
        MarkAsDirty()
    End Sub

    Protected Overrides Sub RemoveItem(ByVal index As Integer)
        MyBase.Item(index).ParentCollection = Nothing
        MyBase.RemoveItem(index)

        MarkAsDirty()
    End Sub

    Protected Overrides Sub SetItem(ByVal index As Integer, ByVal item As MethodologyStep)
        MyBase.SetItem(index, item)
        item.ParentCollection = Me
        MarkAsDirty()
    End Sub

#End Region

#Region " Public Methods "
    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

    Public Function FindById(ByVal id As Integer) As MethodologyStep
        For Each methStep As MethodologyStep In Me.Items
            If methStep.Id = id Then
                Return methStep
            End If
        Next

        Return Nothing
    End Function

    Public Function FindBySequenceNumber(ByVal sequenceNumber As Integer) As MethodologyStep
        For Each methStep As MethodologyStep In Me.Items
            If methStep.SequenceNumber = sequenceNumber Then
                Return methStep
            End If
        Next

        Return Nothing
    End Function
#End Region

#Region " Private Methods "
    Private Sub MarkAsDirty()
        mIsDirty = True
    End Sub

#End Region

End Class
