Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic

Imports System.Text
Imports DevExpress.XtraGrid
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Registrator
Imports System.ComponentModel
Imports DevExpress.XtraGrid.Views.Grid

Namespace WindowsFormsApplication1
	Public Class MyGridControl
		Inherits GridControl
		Protected Overrides Function CreateDefaultView() As BaseView
			Return CreateView("MyGridView")
		End Function
		Protected Overrides Sub RegisterAvailableViewsCore(ByVal collection As InfoCollection)
			MyBase.RegisterAvailableViewsCore(collection)
			collection.Add(New MyGridViewInfoRegistrator())
		End Sub
	End Class

	Public Class MyGridViewInfoRegistrator
		Inherits GridInfoRegistrator
		Public Overrides ReadOnly Property ViewName() As String
			Get
				Return "MyGridView"
			End Get
		End Property
		Public Overrides Function CreateView(ByVal grid As GridControl) As BaseView
			Return New MyGridView(TryCast(grid, GridControl))
		End Function
	End Class

	Public Class MyGridView
		Inherits DevExpress.XtraGrid.Views.Grid.GridView
		Public Sub New()
			Me.New(Nothing)
		End Sub
		Public Sub New(ByVal grid As DevExpress.XtraGrid.GridControl)
			MyBase.New(grid)
			' put your initialization code here
		End Sub

		Protected Overrides ReadOnly Property ViewName() As String
			Get
				Return "MyGridView"
			End Get
		End Property

		Protected Overrides Function CheckRowHandle(ByVal currentRowHandle As Integer, ByVal newRowHandle As Integer) As Integer
			If newRowHandle = DevExpress.XtraGrid.GridControl.InvalidRowHandle Then
				Return newRowHandle
			Else
				Return MyBase.CheckRowHandle(currentRowHandle, newRowHandle)
			End If
		End Function

		Protected Overrides Sub OnEnter()
			If FocusedRowHandle <> DevExpress.XtraGrid.GridControl.InvalidRowHandle Then
				MyBase.OnEnter()
			End If
		End Sub
	End Class
End Namespace
