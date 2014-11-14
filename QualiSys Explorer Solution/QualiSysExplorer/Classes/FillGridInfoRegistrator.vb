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
Imports DevExpress.XtraGrid.Registrator
Imports DevExpress.XtraGrid.Views.Base

Namespace FillEmptySpaceGridColumn
	Public Class FillGridInfoRegistrator
		Inherits GridInfoRegistrator
		Public Overrides Function CreateView(ByVal grid As GridControl) As BaseView
			Return New FillGridView(TryCast(grid, GridControl))
		End Function

		Public Overrides ReadOnly Property ViewName() As String
			Get
				Return "FillGridView"
			End Get
		End Property
	End Class
End Namespace
