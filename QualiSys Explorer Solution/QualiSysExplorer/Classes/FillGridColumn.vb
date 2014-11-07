

'Imports Microsoft.VisualBasic
'Imports System.Windows.Forms
Imports DevExpress.XtraGrid.Columns

Namespace FillEmptySpaceGridColumn
    Public Class FillGridColumn
        Inherits DevExpress.XtraGrid.Columns.GridColumn
        Private fillEmptySpace_Renamed As Boolean = False

        Public Sub New()
            MyBase.New()
        End Sub

        Protected Overridable Sub SetFillEmptySpace(ByVal value As Boolean)
            fillEmptySpace_Renamed = value
            If IsLoading OrElse View Is Nothing Then
                Return
            End If

            If fillEmptySpace_Renamed Then
                Me.Width += 1
                For i As Integer = 0 To View.Columns.Count - 1
                    If Not View.Columns(i).Equals(Me) AndAlso (View.Columns(i).GetType() Is GetType(FillGridColumn)) Then
                        If (CType(View.Columns(i), FillGridColumn)).FillEmptySpace Then
                            CType(View.Columns(i), FillGridColumn).FillEmptySpace = False
                            Return
                        End If
                    End If
                Next i
            Else
                Me.BestFit()
            End If
        End Sub

        Public Property FillEmptySpace() As Boolean
            Get
                Return fillEmptySpace_Renamed
            End Get
            Set(ByVal value As Boolean)
                SetFillEmptySpace(value)
            End Set
        End Property

    End Class
End Namespace

