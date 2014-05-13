Option Explicit On 
Option Strict On

Public Class frmTestReview
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents ctlReview As LoadReviewSection
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctlReview = New LoadReviewSection
        Me.SuspendLayout()
        '
        'ctlReview
        '
        Me.ctlReview.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ctlReview.Location = New System.Drawing.Point(0, 0)
        Me.ctlReview.Name = "ctlReview"
        Me.ctlReview.Size = New System.Drawing.Size(704, 397)
        Me.ctlReview.TabIndex = 0
        '
        'frmTestReview
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(704, 397)
        Me.Controls.Add(Me.ctlReview)
        Me.Name = "frmTestReview"
        Me.Text = "TestReview"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub MockupData()
        Dim package As New DTSPackage
        
        With package
            .Source = MockupSource()

            .Destinations = New DTSDestinationCollection
            .Destinations.Add(MockupDestTable1(package))
            .Destinations.Add(MockupDestTable2(package))
        End With

        ctlReview.ReviewCtrl.Initial(1, False)

    End Sub

    Private Function MockupSource() As DTSDataSet
        Dim dataset As New DTSTextData
        Dim col As SourceColumn

        With dataset

            col = New SourceColumn
            col.Ordinal = 1
            col.ColumnName = "Sex"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 2
            col.ColumnName = "Age"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 3
            col.ColumnName = "Pop_ID"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 4
            col.ColumnName = "Addr"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 5
            col.ColumnName = "City"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 6
            col.ColumnName = "ST"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 7
            col.ColumnName = "Zip5"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 8
            col.ColumnName = "LName"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 9
            col.ColumnName = "FName"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 10
            col.ColumnName = "MRN"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 11
            col.ColumnName = "FacilityNum"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 12
            col.ColumnName = "AdmitDate"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 13
            col.ColumnName = "DischargeUnit"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 14
            col.ColumnName = "VisitNum"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 15
            col.ColumnName = "Enc_ID"
            .Columns.Add(col)

            col = New SourceColumn
            col.Ordinal = 16
            col.ColumnName = "VisitType"
            .Columns.Add(col)

        End With

        Return dataset

    End Function

    Private Function MockupDestTable1(ByVal package As DTSPackage) As DTSDestination
        Dim dest As DTSDestination
        Dim col As DestinationColumn
        Dim srcColumns As ColumnCollection

        dest = New DTSDestination(package)
        dest.UsedInPackage = True
        dest.TableID = 1
        dest.TableName = "bm_Population"

        With dest
            col = New DestinationColumn
            col.Ordinal = 1
            col.ColumnName = "Sex"
            col.Formula = "=Sex"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Sex"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 2
            col.ColumnName = "Age"
            col.Formula = "=Age"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Age"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 3
            col.ColumnName = "Pop_ID"
            col.Formula = "=Pop_ID"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Pop_ID"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 4
            col.ColumnName = "Addr"
            col.Formula = "=Addr"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Addr"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 5
            col.ColumnName = "City"
            col.Formula = "=City"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "City"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 6
            col.ColumnName = "ST"
            col.Formula = "=ST"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "ST"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 7
            col.ColumnName = "Zip5"
            col.Formula = "=Zip5"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Zip5"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 8
            col.ColumnName = "LName"
            col.Formula = "=LName"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "LName"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 9
            col.ColumnName = "FName"
            col.Formula = "=FName"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "FName"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 10
            col.ColumnName = "MRN"
            col.Formula = "=MRN"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "MRN"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 11
            col.ColumnName = "FullAddr"
            col.Formula = "=Addr + "", "" + City + "", "" + ST + "" "" + Zip5"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Addr"))
            srcColumns.Add(SearchSrcColumn(package, "City"))
            srcColumns.Add(SearchSrcColumn(package, "ST"))
            srcColumns.Add(SearchSrcColumn(package, "Zip5"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

        End With

        Return dest

    End Function

    Private Function MockupDestTable2(ByVal package As DTSPackage) As DTSDestination
        Dim dest As DTSDestination
        Dim col As DestinationColumn
        Dim srcColumns As ColumnCollection

        dest = New DTSDestination(package)
        dest.UsedInPackage = True
        dest.TableID = 2
        dest.TableName = "bm_Enounter"

        With dest
            col = New DestinationColumn
            col.Ordinal = 1
            col.ColumnName = "FacilityNum"
            col.Formula = "=FacilityNum"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "FacilityNum"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 2
            col.ColumnName = "AdmitDate"
            col.Formula = "=AdmitDate"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "AdmitDate"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 3
            col.ColumnName = "DischargeUnit"
            col.Formula = "=DischargeUnit"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "DischargeUnit"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 4
            col.ColumnName = "VisitNum"
            col.Formula = "=VisitNum"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "VisitNum"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 5
            col.ColumnName = "Pop_ID"
            col.Formula = "=Pop_ID"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Pop_ID"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 6
            col.ColumnName = "Enc_ID"
            col.Formula = "=Enc_ID"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "Enc_ID"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

            col = New DestinationColumn
            col.Ordinal = 7
            col.ColumnName = "VisitType"
            col.Formula = "=VisitType"
            srcColumns = New ColumnCollection
            srcColumns.Add(SearchSrcColumn(package, "VisitType"))
            col.SourceColumns = srcColumns
            .Columns.Add(col)

        End With

        Return dest

    End Function

    Private Function SearchSrcColumn( _
                ByVal package As DTSPackage, _
                ByVal columnName As String _
            ) As SourceColumn

        Dim srcColumns As ColumnCollection = package.Source.Columns
        columnName = columnName.ToLower
        Dim col As SourceColumn

        For Each col In srcColumns
            If (col.ColumnName.ToLower = columnName) Then Return col
        Next

        Return Nothing
    End Function

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '
    ' Mock up based on the return from the SP
    '
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    Private Sub MockupData2()
        Dim package As New DTSPackage
        Dim ds As DataSet
        Dim dt As DataTable
        Dim fileID As Integer = 1

        ds = package.Review(fileID, 1, False)
        With package
            dt = ds.Tables(2)
            .Source = MockupSource2(dt)
            dt = ds.Tables(4)
            .Destinations = MockupDestination2(package, dt)
        End With

        ctlReview.ReviewCtrl.Initial(1, False)

    End Sub

    Private Function MockupSource2(ByVal dt As DataTable) As DTSDataSet
        Dim dataset As New DTSTextData
        Dim dc As DataColumn
        Dim col As SourceColumn
        Dim i As Integer = 1

        For Each dc In dt.Columns
            If (dc.ColumnName.ToLower = "df_id" OrElse _
                dc.ColumnName.ToLower = "datafile_id") Then
                GoTo NextLoop
            End If

            col = New SourceColumn
            col.Ordinal = i
            col.ColumnName = dc.ColumnName
            dataset.Columns.Add(col)
            i += 1
NextLoop:
        Next

        Return dataset

    End Function

    Private Function MockupDestination2(ByVal package As DTSPackage, ByVal dt As DataTable) As DTSDestinationCollection
        Dim dests As New DTSDestinationCollection
        Dim dest As DTSDestination = Nothing
        Dim prevTableName As String = ""
        Dim col As DestinationColumn
        Dim srcColumns As ColumnCollection
        Dim dr As DataRow
        Dim tableID As Integer = 1
        Dim ordinal As Integer
        Dim srcCol As SourceColumn

        For Each dr In dt.Rows
            If (dr.Item(1).ToString.ToLower = "df_id" OrElse _
                dr.Item(1).ToString.ToLower = "datafile_id") Then
                GoTo NextLoop
            End If

            'Create new DTSDestination
            If (dr.Item(0).ToString <> prevTableName) Then
                dest = New DTSDestination(package)
                dest.UsedInPackage = True
                dest.TableID = tableID
                dest.TableName = dr.Item(0).ToString
                dests.Add(dest)
                prevTableName = dr.Item(0).ToString
                tableID += 1
                ordinal = 1
            End If

            col = New DestinationColumn
            col.Ordinal = ordinal
            ordinal += 1
            col.ColumnName = dr.Item(1).ToString
            col.Formula = "=" & col.ColumnName
            srcColumns = New ColumnCollection
            srcCol = SearchSrcColumn(package, col.ColumnName)
            If (Not srcCol Is Nothing) Then srcColumns.Add(srcCol)
            col.SourceColumns = srcColumns
            dest.Columns.Add(col)
NextLoop:
        Next

        Return dests

    End Function

    Private Sub frmTestReview_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        MockupData2()
    End Sub
End Class
