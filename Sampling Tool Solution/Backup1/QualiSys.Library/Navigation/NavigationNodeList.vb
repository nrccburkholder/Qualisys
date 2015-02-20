Namespace Navigation

    Public Class NavigationNodeList

        Inherits List(Of NavigationNode)

    End Class

    Public Class NavigationNodeList(Of T As NavigationNode)
        Inherits NavigationNodeList

        Default Public Overloads ReadOnly Property Item(ByVal index As Integer) As T
            Get
                Return DirectCast(MyBase.Item(index), T)
            End Get
        End Property

        Public Sub SortByName()

            MyBase.Sort(New NodeNameComparer)

        End Sub

        Private Class NodeNameComparer

            Implements IComparer(Of NavigationNode)

            Public Function Compare(ByVal x As NavigationNode, ByVal y As NavigationNode) As Integer Implements System.Collections.Generic.IComparer(Of NavigationNode).Compare

                'Overwrite CompareTo for Unassigned client group to always be at the bottom of the list
                If x.NodeType = NavigationNodeType.ClientGroup AndAlso x.Id = -1 Then
                    Return 1
                End If
                If y.NodeType = NavigationNodeType.ClientGroup AndAlso y.Id = -1 Then
                    Return -1
                End If

                Return x.Name.CompareTo(y.Name)

            End Function

        End Class

    End Class

End Namespace
