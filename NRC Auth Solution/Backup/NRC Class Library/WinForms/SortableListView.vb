Imports System.ComponentModel
Imports System.ComponentModel.Design.Serialization
Imports System.Windows.Forms

Namespace WinForms
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SortableListView
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This is a ListView control where the columns are clickable for sorting.
    ''' </summary>
    ''' <remarks>
    ''' This is still a little buggy but is a good start.  For example, if you set the sort
    ''' order then re-fill the list, things are no longer sorted.
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/14/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Class SortableListView
        Inherits System.Windows.Forms.ListView

#Region " Windows Form Designer generated code "

        Public Sub New()
            MyBase.New()

            Me.SetStyle(ControlStyles.DoubleBuffer Or ControlStyles.ResizeRedraw, True)

            Me.FullRowSelect = True
            Me.GridLines = True
            Me.View = View.Details

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
        <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
            components = New System.ComponentModel.Container
        End Sub

#End Region

#Region " Private Members "
        Private mSortColumn As Integer = -1
        Private mSortASC As Boolean = True
        Private mColumns As New SortableColumnCollection(Me)
#End Region

#Region " Public Properties "

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The collection of SortableColumns that belong to this SortableListView
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), DesignerSerializationVisibility(DesignerSerializationVisibility.Content), Category("Behavior")> _
        Public Shadows ReadOnly Property Columns() As SortableColumnCollection
            Get
                Return Me.mColumns
            End Get
        End Property

#End Region

#Region " Public Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Sorts the listed based on the last sort column selected.  If no sort column
        ''' has been selected, nothing will happen.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub SortList()
            Me.SortList(mSortColumn, True)
        End Sub
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Generates an HTML Fragment string representing all the items in the ListView.
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function ToHtml() As String
            Dim sb As New System.Text.StringBuilder
            Dim item As ListViewItem
            Dim subitem As ListViewItem.ListViewSubItem

            sb.Append("Version:1.0")
            sb.Append(vbCrLf)
            sb.Append("StartHTML:000000-1")
            sb.Append(vbCrLf)
            sb.Append("EndHTML:000000-1")
            sb.Append(vbCrLf)
            sb.Append("StartFragment:000000-1")
            sb.Append(vbCrLf)
            sb.Append("EndFragment:000000-1")
            sb.Append(vbCrLf)
            sb.Append("<!DOCTYPE HTML PUBLIC " & Chr(34) & "-//W3C//DTD HTML 4.0 Transitional//EN" & Chr(34) & ">")
            sb.Append(vbCrLf)
            sb.Append("<html>")
            sb.Append(vbCrLf)
            sb.Append("<head>")
            sb.Append(vbCrLf)
            sb.Append("<META http-equiv=Content-Type content=" & Chr(34) & "text/html; charset=utf-8" & Chr(34) & ">")
            sb.Append(vbCrLf)
            sb.Append("<STYLE>")
            sb.Append(vbCrLf)
            sb.Append(".tableStyle{background-color: LightSteelBlue; font-family:Verdana; font-size:x-small;}")
            sb.Append(vbCrLf)
            sb.Append(".cellStyle{background-color: #FFFFFF;}")
            sb.Append(vbCrLf)
            sb.Append("</STYLE>")
            sb.Append(vbCrLf)
            sb.Append("</head>")
            sb.Append(vbCrLf)
            sb.Append("<body>")
            sb.Append(vbCrLf)
            sb.Append("<!--StartFragment-->")

            'Dynamic content

            sb.Append("<TABLE border=""1"" class=""tableStyle"" cellpadding=""4"" cellspacing=""1"">")
            sb.Append(vbCrLf)
            For Each item In Me.SelectedItems
                sb.Append("<TR>")
                For Each subitem In item.SubItems
                    sb.Append("<TD class=""cellStyle"">")
                    sb.Append(subitem.Text)
                    sb.Append("</TD>")
                Next
                sb.Append("</TR>")
                sb.Append(vbCrLf)
            Next

            sb.Append("</TABLE>")
            sb.Append(vbCrLf)

            'END
            sb.Append("<!--EndFragment-->")
            sb.Append(vbCrLf)
            sb.Append("</body>")
            sb.Append(vbCrLf)
            sb.Append("</html>")
            sb.Append(vbCrLf)

            Return sb.ToString
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Generates a Tab Delimited string containing all the items in the listview
        ''' </summary>
        ''' <returns>A string with all the items in the listview</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Function ToTabDelimitedString() As String
            Dim sb As New System.Text.StringBuilder
            Dim item As ListViewItem
            Dim subitem As ListViewItem.ListViewSubItem

            For Each item In Me.SelectedItems
                For Each subitem In item.SubItems
                    sb.Append(subitem.Text)
                    sb.Append(vbTab)
                Next
                sb.Append(vbCrLf)
            Next

            Return sb.ToString
        End Function

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Copies the contents of the SortableListView to the clipboard for pasting in other
        ''' applications.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Sub CopyToClipboard()
            Dim clipData As New DataObject
            Debug.WriteLine(Me.ToHtml)
            clipData.SetData(DataFormats.Html, True, Me.ToHtml)
            clipData.SetData(DataFormats.Text, True, Me.ToTabDelimitedString)
            Clipboard.SetDataObject(clipData, False)
        End Sub

#End Region

#Region " Private Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Sorts the list based on a certain column.
        ''' </summary>
        ''' <param name="column">The column number that should be sorted.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Private Sub SortList(ByVal column As Integer, ByVal resort As Boolean)
            If column = -1 Then Exit Sub

            If column = Me.mSortColumn Then
                If Not resort Then
                    Me.mSortASC = Not Me.mSortASC
                End If
            Else
                Me.mSortColumn = column
                If Not resort Then
                    Me.mSortASC = True
                End If
            End If

            Dim List As New SortedList
            Dim item As ListViewItem
            Dim index As Integer = 0
            Dim key As String
            Dim keyOrig As String

            For Each item In Me.Items
                key = item.SubItems(column).Text
                index = 0

                Select Case Me.Columns(column).DataType
                    Case SortableColumn.ColumnDataType.Integer
                        key = key.PadLeft(5, "0")
                    Case SortableColumn.ColumnDataType.CheckBox
                        If item.Checked Then
                            key = "1"
                        Else
                            key = "0"
                        End If
                End Select

                keyOrig = key
                While Not List(key) Is Nothing
                    index += 1
                    key = keyOrig & "_" & index
                End While
                List.Add(key, item)
            Next

            Me.Items.Clear()

            If Me.mSortASC Then
                For index = 0 To List.Count - 1
                    Me.Items.Add(List.GetByIndex(index))
                Next
            Else
                For index = List.Count - 1 To 0 Step -1
                    Me.Items.Add(List.GetByIndex(index))
                Next
            End If
        End Sub

#End Region

#Region " Protected Methods "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides OnColumnClick and performs the item sort based on that column.
        ''' </summary>
        ''' <param name="e">the ColumnClickEventArgs for this event.</param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnColumnClick(ByVal e As System.Windows.Forms.ColumnClickEventArgs)
            MyBase.OnColumnClick(e)
            Me.SortList(e.Column, False)

        End Sub

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' Overrides OnKeyUp and checks for a Ctrl+C combination.  If Ctrl+C was pressed then
        ''' the contents of the SortableListView are copied to the clipboard.
        ''' </summary>
        ''' <param name="e"></param>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Protected Overrides Sub OnKeyUp(ByVal e As System.Windows.Forms.KeyEventArgs)
            If e.Control AndAlso e.KeyCode = Keys.C Then
                Debug.WriteLine("Copying to clipboard")
                Me.CopyToClipboard()
            End If
        End Sub
#End Region

    End Class

#Region " SortableColumn Class "
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SortableColumn
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This is a ColumnHeader that also contains the DataType so that the SortableListView
    ''' control knows how to sort items in this column.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/14/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <Serializable()> _
    Public Class SortableColumn
        Inherits System.Windows.Forms.ColumnHeader

        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The data type of the column.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        Public Enum ColumnDataType
            Text = 0
            [Integer] = 1
            CheckBox = 2
        End Enum

        Private mDataType As ColumnDataType = ColumnDataType.Text


        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The type of data that will be stored in this column.  This information is used
        ''' in the sorting process.
        ''' </summary>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	7/14/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Browsable(True), Category("Misc")> _
        Public Property DataType() As ColumnDataType
            Get
                Return Me.mDataType
            End Get
            Set(ByVal Value As ColumnDataType)
                Me.mDataType = Value
            End Set
        End Property
    End Class
#End Region

#Region " SortableColumnCollection Class "
    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : WinForms.SortableColumnCollection
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' A collection of SortableColumns.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/14/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <Serializable()> _
        Public Class SortableColumnCollection
        Inherits System.Windows.Forms.ListView.ColumnHeaderCollection

        Sub New(ByVal owner As ListView)
            MyBase.New(owner)
        End Sub

        Default Public Shadows ReadOnly Property Item(ByVal index As Integer) As SortableColumn
            Get
                Return MyBase.Item(index)
            End Get
        End Property

        Public Shadows Function Add(ByVal item As SortableColumn) As Integer
            MyBase.Add(item)
        End Function

    End Class

#End Region

End Namespace
