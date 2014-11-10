' Developer Express Code Central Example:
' Capability for a single column to fill an empty space in a grid view
' 
' In this example we added a FillEmptySpace option to the GridColumn descendant.
' Only one column in the grid view can have this option enabled, i.e. if you set
' the FillEmptySpace property to true for a single column other columns
' immediately set this option to false themselves. Column with this option enabled
' now recalculates its width after every layout change in order to fill an empty
' space in the grid view. This feature won't work if the grid view's option
' OptionsView.ColumnAutoWidth is enabled.
' 
' You can find sample updates and versions for different programming languages here:
' http://www.devexpress.com/example=E2436

Imports Microsoft.VisualBasic
Imports System
Imports DevExpress.XtraGrid
Imports DevExpress.XtraGrid.Columns
Imports DevExpress.XtraGrid.Views.Grid

Namespace FillEmptySpaceGridColumn
	Public Class FillGridView
		Inherits GridView
		Private needColumnRecalc As Boolean = False

		Public Sub New(ByVal ownerGrid As GridControl)
			MyBase.New(ownerGrid)
		End Sub
		Public Sub New()
		End Sub

		Protected Overridable Sub RecalculateColumnWidths()
			Dim colToResize As FillGridColumn = Nothing
			Dim totalWidth As Integer = 0
            For i As Integer = 0 To Columns.Count - 1
                If Not Columns(i).Visible Then
                    Continue For
                End If
                If (CType(Columns(i), FillGridColumn)).FillEmptySpace Then
                    colToResize = CType(Columns(i), FillGridColumn)
                Else
                    totalWidth += Columns(i).Width
                End If
            Next i

			If colToResize IsNot Nothing AndAlso ViewInfo.ViewRects.ColumnPanelWidth > 0 Then
				colToResize.Width = ViewInfo.ViewRects.ColumnPanelWidth - totalWidth
			End If
		End Sub

		Public Overrides Sub LayoutChanged()
			MyBase.LayoutChanged()
			If needColumnRecalc Then
				Return
			End If

			needColumnRecalc = True
			If (Not OptionsView.ColumnAutoWidth) Then
				RecalculateColumnWidths()
			End If
			needColumnRecalc = False
		End Sub

		Protected Overrides ReadOnly Property ViewName() As String
			Get
				Return "FillGridView"
			End Get
		End Property

		Protected Overrides Function CreateColumnCollection() As GridColumnCollection
			Return New FillGridColumnCollection(Me)
		End Function

	End Class
End Namespace