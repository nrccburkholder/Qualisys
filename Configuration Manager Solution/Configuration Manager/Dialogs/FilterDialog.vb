Imports Nrc.Qualisys.Library

Public Class FilterDialog

#Region " Private Members "

    Private mViewMode As FilterViewModes

#End Region

#Region " Public Enums "

    Public Enum FilterViewModes
        ValueTextBox = 0
        ValueComboBox = 1
    End Enum

#End Region

#Region " Public Properties "

    Public Property ViewMode() As FilterViewModes
        Get
            Return mViewMode
        End Get
        Private Set(ByVal value As FilterViewModes)
            mViewMode = value
            ValueTextBox.Visible = (mViewMode = FilterViewModes.ValueTextBox)
            ValueComboBox.Visible = (mViewMode = FilterViewModes.ValueComboBox)
        End Set
    End Property


    Public ReadOnly Property FilterString() As String
        Get
            'Get the Column
            Dim filterColumnName As String
            Dim filterColumn As DataGridViewColumn = DirectCast(ColumnComboBox.SelectedItem, ListItem(Of DataGridViewColumn)).Value
            If String.IsNullOrEmpty(filterColumn.DataPropertyName) Then
                filterColumnName = CStr(filterColumn.Tag)
            Else
                filterColumnName = filterColumn.DataPropertyName
            End If

            'Get the operator
            Dim filterOperator As String = OperatorComboBox.SelectedItem.ToString

            'Get the value
            Dim filterValue As String = String.Empty
            Select Case mViewMode
                Case FilterViewModes.ValueTextBox
                    filterValue = ValueTextBox.Text

                Case FilterViewModes.ValueComboBox
                    filterValue = ValueComboBox.SelectedValue.ToString

            End Select

            'Return the filter string
            Return filterColumnName & " " & filterOperator & " " & filterValue
        End Get
    End Property


    Public ReadOnly Property FilterToolTip() As String
        Get
            'Get the Column
            Dim filterColumnName As String = DirectCast(ColumnComboBox.SelectedItem, ListItem(Of DataGridViewColumn)).Value.HeaderText

            'Get the operator
            Dim filterOperator As String = OperatorComboBox.SelectedItem.ToString

            'Get the value
            Dim filterValue As String = String.Empty
            Select Case mViewMode
                Case FilterViewModes.ValueTextBox
                    filterValue = ValueTextBox.Text

                Case FilterViewModes.ValueComboBox
                    filterValue = ValueComboBox.Text

            End Select

            'Return the filter string
            Return filterColumnName & " " & filterOperator & " " & filterValue
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal columnList As Collection(Of ListItem(Of DataGridViewColumn)))

        'Call the designer generated code
        Me.InitializeComponent()

        'Set the view mode
        ViewMode = FilterViewModes.ValueTextBox

        'Setup the operator list
        With OperatorComboBox
            .Items.Add("=")
            .Items.Add("Like")
            .Enabled = False
        End With

        'Set the column list
        With ColumnComboBox
            .DisplayMember = "Label"
            .ValueMember = "Value"
            .DataSource = columnList
        End With

        'Setup the value
        ValueTextBox.Enabled = False
        ValueComboBox.Enabled = False

    End Sub

#End Region

#Region " Events Handlers "

    Private Sub FilterDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub


    Private Sub OK_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        'Validate the data
        If IsDataValid Then
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()
        End If

    End Sub


    Private Sub Cancel_Button_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        'We are out of here
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub


    Private Sub ColumnComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ColumnComboBox.SelectedIndexChanged

        'Determine if we have a valid selection
        If ColumnComboBox.SelectedIndex < 0 Then Exit Sub

        'Get a reference to the DataGridViewColumn
        Dim column As Object = ColumnComboBox.SelectedValue

        'Take action based on the column type
        Dim cboColumn As DataGridViewComboBoxColumn = TryCast(column, DataGridViewComboBoxColumn)
        If cboColumn IsNot Nothing Then
            'We are dealing with a combobox column
            ViewMode = FilterViewModes.ValueComboBox

            'Setup the operator combobox
            With OperatorComboBox
                .SelectedItem = "="
                .Enabled = False
            End With

            'Setup the value combobox 
            With ValueComboBox
                .DisplayMember = cboColumn.DisplayMember
                .ValueMember = cboColumn.ValueMember
                .DataSource = cboColumn.DataSource
                .Enabled = True
            End With
        Else
            'We as not dealing with a combobox column
            ViewMode = FilterViewModes.ValueTextBox

            'Setup the operator combobox
            With OperatorComboBox
                .SelectedIndex = -1
                .Enabled = True
            End With

            'Setup the value textbox
            With ValueTextBox
                .Text = String.Empty
                .Enabled = False
            End With
        End If

        'Validate
        IsColumnValid()

    End Sub


    Private Sub OperatorComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OperatorComboBox.SelectedIndexChanged

        'Determine if we have a valid selection
        If OperatorComboBox.SelectedIndex < 0 Then Exit Sub

        'Unlock the value
        Select Case mViewMode
            Case FilterViewModes.ValueComboBox
                ValueComboBox.Enabled = True

            Case FilterViewModes.ValueTextBox
                ValueTextBox.Enabled = True

        End Select

        'Validate
        IsOperatorValid()

    End Sub


    Private Sub ValueComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ValueComboBox.SelectedIndexChanged

        'Validate
        IsValueValid()

    End Sub


    Private Sub ValueTextBox_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ValueTextBox.TextChanged

        'Validate
        IsValueValid()

    End Sub

#End Region

#Region " Private Methods "

    Private Function IsDataValid() As Boolean

        'Clear any current errors
        ErrorControl.Clear()

        'Validate the fields
        Return (IsColumnValid() And IsOperatorValid() And IsValueValid())

    End Function


    Private Function IsColumnValid() As Boolean

        'Validate the fields
        If ColumnComboBox.SelectedIndex < 0 Then
            'You must select a column
            With ErrorControl
                .SetIconPadding(ColumnComboBox, -(ColumnComboBox.Width))
                .SetError(ColumnComboBox, "You must select a column to filter on!")
            End With
            Return False
        End If

        'If we made it to here then all is well
        ErrorControl.SetError(ColumnComboBox, "")
        Return True

    End Function


    Private Function IsOperatorValid() As Boolean

        'Validate the fields
        If OperatorComboBox.SelectedIndex < 0 Then
            'You must select an operator
            With ErrorControl
                .SetIconPadding(OperatorComboBox, -(OperatorComboBox.Width))
                .SetError(OperatorComboBox, "You must select an operator to filter by!")
            End With
            Return False
        End If

        'If we made it to here then all is well
        ErrorControl.SetError(OperatorComboBox, "")
        Return True

    End Function


    Private Function IsValueValid() As Boolean

        'Validate the fields
        If mViewMode = FilterViewModes.ValueComboBox AndAlso ValueComboBox.SelectedIndex < 0 Then
            'You must select an value
            With ErrorControl
                .SetIconPadding(ValueComboBox, -(ValueComboBox.Width))
                .SetError(ValueComboBox, "You must select a valid value to filter by!")
            End With
            Return False
        End If

        'If we made it to here then all is well
        ErrorControl.SetError(ValueComboBox, "")
        ErrorControl.SetError(ValueTextBox, "")
        Return True

    End Function

#End Region

End Class