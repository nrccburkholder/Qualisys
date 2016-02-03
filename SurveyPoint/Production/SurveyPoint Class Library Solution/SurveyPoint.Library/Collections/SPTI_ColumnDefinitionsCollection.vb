Imports Nrc.Framework.BusinessLogic

''' <summary>Column Defintion Collection.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class SPTI_ColumnDefinitionCollection
    Inherits BusinessListBase(Of SPTI_ColumnDefinitionCollection, SPTI_ColumnDefinition)

    ''' <summary>Allows the adding of new columnDef to the collection</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function AddNewCore() As Object
        Dim newObj As SPTI_ColumnDefinition = SPTI_ColumnDefinition.NewSPTI_ColumnDefinition
        Me.Add(newObj)
        Return newObj
    End Function
    ''' <summary>Finds the passed in column def and removes it from the collection.</summary>
    ''' <param name="item"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub RemoveColumnDef(ByVal item As SPTI_ColumnDefinition)
        Dim index As Integer = 0
        For i As Integer = 0 To Me.Count - 1
            If Me(i).ColumnDefID = item.ColumnDefID AndAlso Me(i).Ordinal = item.Ordinal Then
                index = i
                Exit For
            End If
        Next
        MyBase.RemoveItem(index)
    End Sub    
    ''' <summary>Finds the column def by ordinal and move it up or down in the collection.</summary>
    ''' <param name="ordinal"></param>
    ''' <param name="direction"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ChangeOrdinal(ByVal ordinal As Integer, ByVal direction As OrdinalDirection)
        If Me.Count = 1 Then
            Me(0).Ordinal = 1
        ElseIf Me.Count > 0 Then
            Dim ordList As New List(Of Integer)
            For i As Integer = 0 To Me.Count - 1
                ordList.Add(Me(i).Ordinal)
            Next
            ordList.Sort()
            If ordList(0) = ordinal AndAlso direction = OrdinalDirection.MoveUp Then
                'Do nothing
            ElseIf ordList(ordList.Count - 1) = ordinal AndAlso direction = OrdinalDirection.MoveDown Then
                'Do nothing
            Else
                Dim orgIndex As Integer = 0
                Dim affectedIndex As Integer = 0
                GetIndexes(ordList, orgIndex, affectedIndex, ordinal, direction)
                If direction = OrdinalDirection.MoveUp Then
                    Dim tempOrd As Integer = Me(affectedIndex).Ordinal
                    Me(affectedIndex).Ordinal = ordinal
                    Me(orgIndex).Ordinal = tempOrd
                Else ' Move down
                    Dim tempOrd As Integer = Me(affectedIndex).Ordinal
                    Me(affectedIndex).Ordinal = Me(orgIndex).Ordinal
                    Me(orgIndex).Ordinal = tempOrd
                End If
                'Now that the orindals are in correct order, re-number them sequencially.
                SynchronizeOrdinals()
            End If
        End If
    End Sub
    ''' <summary>Keeps the ordinals in an n+1 sync.  Basically, makes 1,3,5,6 1,2,3,4.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub SynchronizeOrdinals()
        Dim ordList As New List(Of Integer)
        For i As Integer = 0 To Me.Count - 1
            ordList.Add(Me(i).Ordinal)
        Next
        ordList.Sort()
        Dim indexList As New List(Of Integer)
        For i As Integer = 0 To ordList.Count - 1
            For j As Integer = 0 To Me.Count - 1
                If ordList(i) = Me(j).Ordinal Then
                    indexList.Add(j)
                    Exit For
                End If
            Next
        Next
        For i As Integer = 0 To indexList.Count - 1
            Me(indexList(i)).Ordinal = i + 1
        Next
    End Sub
    ''' <summary>Returns an ordered list of indexes by sorted by their ordinals.</summary>
    ''' <param name="ordList"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function getIndexList(ByVal ordList As List(Of Integer)) As List(Of Integer)
        Dim retVal As New List(Of Integer)
        For i As Integer = 0 To ordList.Count - 1
            For j As Integer = 0 To Me.Count - 1
                If ordList(i) = Me(j).Ordinal Then
                    retVal.Add(j)
                    Exit For
                End If
            Next
        Next
        Return retVal
    End Function
    ''' <summary>Returns the index of the columns to change when changing ordinals.</summary>
    ''' <param name="ordList"></param>
    ''' <param name="ordIndex"></param>
    ''' <param name="affectedIndex"></param>
    ''' <param name="ordinal"></param>
    ''' <param name="direction"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub GetIndexes(ByVal ordList As List(Of Integer), ByRef ordIndex As Integer, ByRef affectedIndex As Integer, ByVal ordinal As Integer, ByVal direction As OrdinalDirection)
        Dim affectedOrd As Integer = 0
        For i As Integer = 0 To ordList.Count - 1
            If ordList(i) = ordinal Then
                If direction = OrdinalDirection.MoveUp Then
                    affectedOrd = ordList(i - 1)
                Else ' Move Down
                    affectedOrd = ordList(i + 1)
                End If
            End If
        Next
        For i As Integer = 0 To Me.Count - 1
            If Me(i).Ordinal = ordinal Then
                ordIndex = i
            End If
            If Me(i).Ordinal = affectedOrd Then
                affectedIndex = i
            End If
        Next
    End Sub
    Public Function GetColumnDefByName(ByVal name As String) As SPTI_ColumnDefinition
        Dim retVal As SPTI_ColumnDefinition = Nothing
        For i As Integer = 0 To Me.Count - 1
            If Me(i).Name = name Then
                Return Me(i)
            End If
        Next
        Return retVal
    End Function

End Class

