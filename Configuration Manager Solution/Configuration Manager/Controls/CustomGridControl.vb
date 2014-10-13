Imports Microsoft.VisualBasic
Imports System
Imports System.Collections.Generic
Imports System.Collections.ObjectModel

Imports System.Text
Imports DevExpress.XtraGrid
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Registrator
Imports System.ComponentModel
Imports DevExpress.XtraGrid.Views.Grid


Public Class GridControlEx
    Inherits GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Protected Overrides Function CreateDefaultView() As BaseView
        Return CreateView("GridViewEx")
    End Function
    Protected Overrides Sub RegisterAvailableViewsCore(ByVal collection As InfoCollection)
        MyBase.RegisterAvailableViewsCore(collection)
        collection.Add(New GridViewInfoRegistratorEx())
    End Sub

    Private Sub InitializeComponent()
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'GridView1
        '
        Me.GridView1.GridControl = Me
        Me.GridView1.Name = "GridView1"
        '
        'MyGridControl
        '
        Me.MainView = Me.GridView1
        Me.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
End Class

Public Class GridViewInfoRegistratorEx
    Inherits GridInfoRegistrator
    Public Overrides ReadOnly Property ViewName() As String
        Get
            Return "GridViewEx"
        End Get
    End Property
    Public Overrides Function CreateView(ByVal grid As GridControl) As BaseView
        Return New GridViewEx(TryCast(grid, GridControl))
    End Function
End Class

Public Class GridViewEx
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
            Return "GridViewEx"
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

