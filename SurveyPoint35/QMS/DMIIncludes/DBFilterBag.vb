Option Explicit On
Option Strict On

Imports System.Collections
Imports System.Text

<Serializable()> _
Public Class DBFilterBag
    Protected _FilterHash As New Hashtable
    Protected _JoinClausesWithAnds As Boolean

    Public Sub New(Optional ByVal joinClausesWithAnds As Boolean = True)
        Me._JoinClausesWithAnds = joinClausesWithAnds
    End Sub

    Public Property JoinClausesWithAnds() As Boolean
        Get
            Return Me._JoinClausesWithAnds
        End Get
        Set(ByVal Value As Boolean)
            Me._JoinClausesWithAnds = Value
        End Set
    End Property

    Public ReadOnly Property IsEmpty() As Boolean
        Get
            Return (_FilterHash.Count = 0)

        End Get
    End Property

    Protected Sub AppendSelectFilter(ByRef sql As Text.StringBuilder, ByVal filter As String)
        If sql.Length > 0 Then
            If _JoinClausesWithAnds Then
                sql.AppendFormat(" AND {0}", filter)
            Else
                sql.AppendFormat(" OR {0}", filter)
            End If
        Else
            sql.Append(filter)
        End If
    End Sub

    Protected Sub AppendSelectFilter(ByRef sql As Text.StringBuilder, ByVal filterBag As DBFilterBag)
        Dim sBagSQL As String = filterBag.GenerateRestrictionClause()

        If (sBagSQL.Length > 0) Then
            If sql.Length > 0 Then
                If _JoinClausesWithAnds Then
                    sql.AppendFormat(" AND ({0})", sBagSQL)
                Else
                    sql.AppendFormat(" OR ({0})", sBagSQL)
                End If
            Else
                sql.AppendFormat("({0})", sBagSQL)
            End If
        End If
    End Sub

    Protected Shared Function StringEqualitySelectFilter(ByVal colName As String, ByVal filterValue As String) As String
        Return String.Format("({0} = '{1}')", colName, filterValue.Replace("'", "''"))
    End Function

    Protected Shared Function StringLikeSelectFilter(ByVal colName As String, ByVal filterValue As String) As String
        Return String.Format("({0} LIKE '{1}')", colName, filterValue.Replace("'", "''"))
    End Function

    Protected Shared Function EqualitySelectFilter(ByVal colName As String, ByVal filterValue As String) As String
        Return String.Format("({0} = {1})", colName, filterValue)
    End Function

    Public Sub AddSelectNumericFilter(ByVal filterKey As String, ByVal columnName As String, ByVal filterValue As String)
        _FilterHash(filterKey) = EqualitySelectFilter(columnName, filterValue)
    End Sub

    Public Sub AddSelectNumericFilter(ByVal columnName As String, ByVal filterValue As String)
        AddSelectNumericFilter(columnName, columnName, filterValue)

    End Sub

    Public Sub AddSelectStringFilter(ByVal filterKey As String, ByVal columnName As String, ByVal filterValue As String, Optional ByVal useLikeCompare As Boolean = False)
        If useLikeCompare Then
            _FilterHash(filterKey) = StringLikeSelectFilter(columnName, filterValue)
        Else
            _FilterHash(filterKey) = StringEqualitySelectFilter(columnName, filterValue)
        End If
    End Sub

    Public Sub AddSelectStringFilter(ByVal columnName As String, ByVal filterValue As String, Optional ByVal useLikeCompare As Boolean = False)
        AddSelectStringFilter(columnName, columnName, filterValue, useLikeCompare)

    End Sub

    Public Sub AddSelectCustomFilter(ByVal filterKey As String, ByVal sqlCustomFilter As String)
        _FilterHash(filterKey) = sqlCustomFilter
    End Sub

    Public Sub AddFilterGroup(ByVal filterKey As String, ByVal filterBag As DBFilterBag)
        _FilterHash(filterKey) = filterBag
    End Sub

    Public Sub AddSelectNullFilter(ByVal filterKey As String, ByVal columnName As String)
        _FilterHash(filterKey) = String.Format("{0} IS NULL", columnName)
    End Sub

    Public Sub AddSelectNullFilter(ByVal columnName As String)
        AddSelectNullFilter(columnName, columnName)
    End Sub

    Public Sub AddSelectNotNullFilter(ByVal filterKey As String, ByVal columnName As String)
        _FilterHash(filterKey) = String.Format("{0} IS NOT NULL", columnName)
    End Sub

    Public Sub AddSelectNotNullFilter(ByVal columnName As String)
        AddSelectNotNullFilter(columnName, columnName)
    End Sub

    Public Sub AddSelectDateFilter(ByVal filterKey As String, ByVal columnName As String, ByVal filterValue As Date, ByVal compareOperation As DMI.ComparisonTypes.ComparisonTypesEnum)
        _FilterHash(filterKey) = String.Format("({0} {1} '{2}')", columnName, ComparisonTypes.GetOperatorAsString(compareOperation), filterValue.ToString())
    End Sub

    Public Sub AddSelectDateFilter(ByVal columnName As String, ByVal filterValue As Date, ByVal compareOperation As DMI.ComparisonTypes.ComparisonTypesEnum)
        AddSelectDateFilter(columnName, columnName, filterValue, compareOperation)
    End Sub

    Public Function GenerateRestrictionClause() As String
        If (_FilterHash.Count > 0) Then
            Dim sbSQL As New StringBuilder

            For Each objVal As Object In _FilterHash.Values
                If (TypeOf objVal Is String) Then
                    AppendSelectFilter(sbSQL, CStr(objVal))
                ElseIf (TypeOf objVal Is DBFilterBag) Then
                    AppendSelectFilter(sbSQL, CType(objVal, DBFilterBag))
                End If
            Next

            Return sbSQL.ToString()
        End If

        Return ""
    End Function

    Public Function GenerateWhereClause() As String
        If (_FilterHash.Count > 0) Then
            Return String.Format("WHERE {0}", GenerateRestrictionClause())
        Else
            Return ""
        End If
    End Function

    Public Function ExtractSubFilter(ByVal ParamArray includeFilterKeys() As String) As DBFilterBag
        Dim subFilterBag As New DBFilterBag(_JoinClausesWithAnds)
        Dim includeKeys As New ArrayList(includeFilterKeys)

        If (includeKeys.Count > 0) Then
            Dim filterEnum As IDictionaryEnumerator = _FilterHash.GetEnumerator()
            While (filterEnum.MoveNext() AndAlso includeKeys.Count > 0)
                If (includeKeys.Contains(filterEnum.Key)) Then
                    subFilterBag._FilterHash.Add(filterEnum.Key, filterEnum.Value)
                    includeKeys.Remove(filterEnum.Key)
                End If
            End While
        End If

        Return subFilterBag
    End Function

    Public Function TranslateColumnFilter(ByVal translateKeys As Hashtable) As DBFilterBag
        Dim subFilterBag As New DBFilterBag(_JoinClausesWithAnds)

        If (translateKeys.Count > 0) Then
            Dim filterEnum As IDictionaryEnumerator = _FilterHash.GetEnumerator()
            While (filterEnum.MoveNext())
                If (translateKeys.Count > 0 AndAlso translateKeys.Contains(filterEnum.Key)) Then
                    Dim oldKey As String = filterEnum.Key.ToString
                    Dim newKey As String = translateKeys.Item(oldKey).ToString
                    Dim rx As RegularExpressions.Regex

                    subFilterBag._FilterHash.Add(newKey, rx.Replace(filterEnum.Value.ToString, String.Format("\b{0}\b", oldKey), newKey))
                    translateKeys.Remove(oldKey)

                Else
                    subFilterBag._FilterHash.Add(filterEnum.Key, filterEnum.Value)

                End If
            End While

        End If

        Return subFilterBag

    End Function
End Class
