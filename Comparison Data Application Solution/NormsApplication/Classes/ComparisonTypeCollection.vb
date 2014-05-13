Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary

Public Class ComparisonTypeCollection
    Inherits CollectionBase

#Region " Public Properties"

    Default Public Property Item(ByVal index As Integer) As ComparisonType
        Get
            Return CType(MyBase.List.Item(index), ComparisonType)
        End Get
        Set(ByVal Value As ComparisonType)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal dest As ComparisonType)
        MyBase.List.Add(dest)
    End Sub

#End Region

#Region " Public Methods"

    Public Function SpecifiedComparison(ByVal normType As NormType) As ComparisonType
        Dim comparison As ComparisonType
        For Each comparison In Me
            If (comparison.NormType = normType) Then Return comparison
        Next
        Return Nothing
    End Function


    Public Sub Load(ByVal normID As Integer)
        If (normID <= 0) Then Return
        Dim dr As SqlDataReader = DataAccess.LoadCanadaComparisons(normID)
        Me.Clear()
        Dim comparison As ComparisonType
        Do While (dr.Read)
            comparison = New ComparisonType
            With comparison
                .Task = TaskType.UpdateNorm
                .CompTypeID = CInt(dr("CompType_ID"))
                .SelectionBox = CStr(dr("Selection_Box"))
                .SelectionType = CStr(dr("Selection_Type"))
                .Description = CStr(dr("Description"))
                .NormType = CType(dr("NormType"), NormType)
                .NormParam = CInt(dr("NormParam"))
            End With
            Me.Add(comparison)
        Loop
        dr.Close()
    End Sub

    Public Sub SetComparisonData(ByVal normType As NormType, _
                                 ByVal label As String, _
                                 ByVal description As String)

        Dim comparison As ComparisonType = SpecifiedComparison(normType)
        If (comparison Is Nothing) Then
            AddNewComparison(normType, label, description)
        Else
            comparison.SelectionBox = label
            comparison.Description = description
        End If
    End Sub

    Public Sub RemoveSpecifiedComparison(ByVal normType As NormType)
        Dim comparison As ComparisonType = SpecifiedComparison(normType)
        If (comparison Is Nothing) Then Return
        If (comparison.Task = TaskType.UpdateNorm) Then Return
        Me.RemoveItem(comparison)
    End Sub

    'Public Sub SetComparisonUnitCount(ByVal normType As NormType, _
    '                                  ByVal unitIncludedInNorm As Integer)
    '    If (normType <> normType.BestNorm AndAlso normType <> normType.WorstNorm) Then Return
    '    Dim comparison As ComparisonType = GetSpecifiedComparison(normType)
    '    If (comparison Is Nothing) Then Return
    '    comparison.UnitIncludedInBenchmarkNorm = unitIncludedInNorm
    'End Sub

#End Region

#Region " Private methods"

    Private Sub AddNewComparison(ByVal normType As NormType, _
                                 ByVal label As String, _
                                 ByVal description As String _
                                )

        Dim comparison As New ComparisonType

        With comparison
            .Task = TaskType.NewNorm
            .SelectionBox = label
            .SelectionType = "N"
            .Description = description
            .NormType = normType
            .NormParam = ComparisonType.DefaultNormParam(normType)
        End With

        Me.Add(comparison)

    End Sub

    Private Sub RemoveItem(ByVal comparison As ComparisonType)
        Dim i As Integer = 0

        For i = 0 To Me.Count - 1
            If Me.Item(i) Is comparison Then
                Me.RemoveAt(i)
                Return
            End If
        Next

    End Sub

#End Region

End Class
