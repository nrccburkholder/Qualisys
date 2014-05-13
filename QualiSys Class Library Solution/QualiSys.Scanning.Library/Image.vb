Imports System.IO

Public Class Image

#Region " Private Members "

    Private mBarcode As String
    Private mImageFile As FileInfo
    Private mValidBarcode As Boolean

#End Region


#Region " Constructors "

    Public Sub New(ByVal barcode As String, ByVal imageFile As FileInfo)

        Me.Barcode = barcode
        mImageFile = imageFile

    End Sub

#End Region


#Region " Public Properties "

    Public Property Barcode() As String
        Get
            Return mBarcode
        End Get
        Set(ByVal Value As String)
            mBarcode = Value

            mValidBarcode = ValidateBarcode()
        End Set
    End Property


    Public ReadOnly Property ImageFile() As FileInfo
        Get
            Return mImageFile
        End Get
    End Property


    Public ReadOnly Property IsBarcodeValid() As Boolean
        Get
            Return mValidBarcode
        End Get
    End Property


    Public ReadOnly Property LithoCode() As String
        Get
            Return Litho.BarcodeToLitho(mBarcode)
        End Get
    End Property

#End Region


#Region " Public Shared Methods "

    Public Shared Function ValidateBarcode(ByVal newBarcode As String, ByRef errorMsg As String) As Boolean

        If newBarcode.Length <> 8 Then
            'Barcode is not the correct length
            errorMsg = "Barcode must be 8 characters in length!"
            Return False
        ElseIf Not Litho.IsCheckDigitValid(newBarcode) Then
            'The check digit is not valid
            errorMsg = "Barcode check digit is invalid!"
            Return False
        Else
            'Barcode is valid
            errorMsg = ""
            Return True
        End If

    End Function

#End Region


#Region " Private Methods "

    Private Function ValidateBarcode() As Boolean

        Dim errorMsg As String = ""
        Return Image.ValidateBarcode(mBarcode, errorMsg)

    End Function

#End Region

End Class
