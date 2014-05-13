Public Class QSIDataFormQuestionItem

#Region " Private Members "

    Private mScaleItem As Integer
    Private mScaleItemText As String = String.Empty
    Private mResponseValue As Integer
    Private mScaleOrder As Integer

#End Region

#Region " Public Properties "

    Public Property ScaleItem() As Integer
        Get
            Return mScaleItem
        End Get
        Set(ByVal value As Integer)
            mScaleItem = value
        End Set
    End Property

    Public Property ScaleItemText() As String
        Get
            Return mScaleItemText
        End Get
        Set(ByVal value As String)
            mScaleItemText = value.Trim
        End Set
    End Property

    Public Property ResponseValue() As Integer
        Get
            Return mResponseValue
        End Get
        Set(ByVal value As Integer)
            mResponseValue = value
        End Set
    End Property

    Public Property ScaleOrder() As Integer
        Get
            Return mScaleOrder
        End Get
        Set(ByVal value As Integer)
            mScaleOrder = value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property ScaleItemLabel() As String
        Get
            Return String.Format("{0} ({1})", ScaleItemText, ScaleItem)
        End Get
    End Property

    Public ReadOnly Property ResponseValueLabel() As String
        Get
            Return String.Format("{0} ({1})", ScaleItemText, ResponseValue)
        End Get
    End Property

#End Region

#Region " Constructors "

#End Region

#Region " Public Methods "

#End Region

End Class


