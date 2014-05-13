Public Class BarcodeSearchResult

#Region " Private Members "

    Private mSelected As Boolean = False
    Private mSearchString As String = String.Empty
    Private mBarcode As String = String.Empty
    Private mBarcodeFileName As String = String.Empty
    Private mBarcodeFileLineNum As Integer = 0
    Private mStringFileName As String = String.Empty
    Private mStringFileLineNum As Integer = 0
    Private mStringFileLine As String = String.Empty

#End Region

#Region " Properties "

    Public Property Selected() As Boolean
        Get
            Return mSelected
        End Get
        Set(ByVal value As Boolean)
            mSelected = value
            Debug.Print("Barcode: {0}, Selected {1}", mBarcode, mSelected)
        End Set
    End Property

    Public ReadOnly Property SearchString() As String
        Get
            Return mSearchString
        End Get
    End Property

    Public ReadOnly Property Barcode() As String
        Get
            Return mBarcode
        End Get
    End Property

    Public ReadOnly Property BarcodeFileName() As String
        Get
            Return mBarcodeFileName
        End Get
    End Property

    Public ReadOnly Property BarcodeFileLineNum() As Integer
        Get
            Return mBarcodeFileLineNum
        End Get
    End Property

    Public Property StringFileName() As String
        Get
            Return mStringFileName
        End Get
        Friend Set(ByVal value As String)
            mStringFileName = value
        End Set
    End Property

    Public Property StringFileLineNum() As Integer
        Get
            Return mStringFileLineNum
        End Get
        Friend Set(ByVal value As Integer)
            mStringFileLineNum = value
        End Set
    End Property

    Public Property StringFileLine() As String
        Get
            Return mStringFileLine
        End Get
        Friend Set(ByVal value As String)
            mStringFileLine = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal searchString As String, ByVal barcode As String, ByVal barcodeFileLineNum As Integer, ByVal barcodeFileName As String)

        mSearchString = searchString
        mBarcode = barcode
        mBarcodeFileLineNum = barcodeFileLineNum
        mBarcodeFileName = barcodeFileName

    End Sub

#End Region

End Class
