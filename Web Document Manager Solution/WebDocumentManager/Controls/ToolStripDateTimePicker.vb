Public Class ToolStripDateTimePicker
    Inherits ToolStripControlHost

    ' Call the base constructor passing in a MonthCalendar instance.
    Public Sub New()
        MyBase.New(New DateTimePicker)
        Me.DateTimePickerControl.Width = 100
    End Sub

    Public ReadOnly Property DateTimePickerControl() As DateTimePicker
        Get
            Return CType(Control, DateTimePicker)
        End Get
    End Property

    Public Property Format() As DateTimePickerFormat
        Get
            Return DateTimePickerControl.Format
        End Get
        Set(ByVal value As DateTimePickerFormat)
            DateTimePickerControl.Format = value
        End Set
    End Property

    Public Property MaxDate() As Date
        Get
            Return DateTimePickerControl.MaxDate
        End Get
        Set(ByVal value As Date)
            DateTimePickerControl.MaxDate = value
        End Set
    End Property

    Public Property MinDate() As Date
        Get
            Return DateTimePickerControl.MinDate
        End Get
        Set(ByVal value As Date)
            DateTimePickerControl.MinDate = value
        End Set
    End Property

    Public Property Value() As Date
        Get
            Return DateTimePickerControl.Value
        End Get
        Set(ByVal value As Date)
            DateTimePickerControl.Value = value
        End Set
    End Property


    ' Subscribe and unsubscribe the control events you wish to expose.
    Protected Overrides Sub OnSubscribeControlEvents(ByVal c As Control)

        ' Call the base so the base events are connected.
        MyBase.OnSubscribeControlEvents(c)

        ' Cast the control to a DateTimePicker control.
        Dim datePicker As DateTimePicker = CType(c, DateTimePicker)

        ' Add the event.
        AddHandler datePicker.ValueChanged, AddressOf HandleDateChanged

    End Sub

    Protected Overrides Sub OnUnsubscribeControlEvents(ByVal c As Control)
        ' Call the base method so the basic events are unsubscribed.
        MyBase.OnUnsubscribeControlEvents(c)

        ' Cast the control to a DateTimePicker control.
        Dim datePicker As DateTimePicker = CType(c, DateTimePicker)

        ' Remove the event.
        RemoveHandler datePicker.ValueChanged, AddressOf HandleDateChanged

    End Sub

    ' Declare the DateChanged event.
    'Public Event DateChanged As DateRangeEventHandler

    ' Raise the DateChanged event.
    Private Sub HandleDateChanged(ByVal sender As Object, ByVal e As EventArgs)

        'RaiseEvent DateChanged(Me, e)
    End Sub
End Class
