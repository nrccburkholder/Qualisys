Public Class TranslatorError

#Region " Private Members "

    Private mRowNumber As Integer
    Private mLithoCode As String = String.Empty
    Private mErrorMessage As String = String.Empty

#End Region

#Region " Public Properties "

    Public ReadOnly Property RowNumber() As Integer
        Get
            Return mRowNumber
        End Get
    End Property

    Public ReadOnly Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
    End Property

    Public ReadOnly Property ErrorMessage() As String
        Get
            Return mErrorMessage
        End Get
    End Property

#End Region

#Region " Private Properties "

    Private ReadOnly Property TableRowText() As String
        Get
            Return String.Format("               {0}  {1}  {2}", mRowNumber.ToString.PadLeft(5), mLithoCode.PadRight(10), mErrorMessage)
        End Get
    End Property

    Private ReadOnly Property TableRowHtml() As String
        Get
            Return String.Format("<TR><TD style=""background-color: #CDE1FA; padding: 5px; White-space: nowrap"">{0}</TD><TD style=""background-color: #CDE1FA; padding: 5px; White-space: nowrap"">{1}</TD><TD style=""background-color: #CDE1FA;Width: 100%; padding: 5px; White-space: wrap"">{2}</TD></TR>", mRowNumber.ToString, mLithoCode, mErrorMessage)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal rowNumber As Integer, ByVal lithoCode As String, ByVal errorMessage As String)

        mRowNumber = rowNumber
        mLithoCode = lithoCode
        mErrorMessage = errorMessage

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Public Shared Methods "

    Public Shared Function GetErrorTableText(ByVal errorList As List(Of TranslatorError)) As String

        Dim errString As String = String.Empty

        'Determine if we need to build a table
        If errorList.Count > 0 Then
            'Add the table header
            errString = vbCrLf & vbCrLf & _
                        "               Row #  LithoCode   Error Message" & vbCrLf & _
                        "               -----  ----------  -------------------------"

            'Add each row
            For Each row As TranslatorError In errorList
                errString &= vbCrLf & row.TableRowText
            Next
        End If

        'Return the table
        Return errString

    End Function

    Public Shared Function GetErrorTableHtml(ByVal errorList As List(Of TranslatorError)) As String

        Dim errString As String = String.Empty

        'Determine if we need to build a table
        If errorList.Count > 0 Then
            'Begin the table
            errString = "<BR><BR><TABLE style=""background-color: #660099; font-family: Tahoma, Verdana, Arial; font-size:X-Small"" Width=""100%"" cellpadding=""0"" cellspacing=""1"">"

            'Add the table header
            errString &= "<TR><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Row #</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">LithoCode</TD><TD style=""background-color: #AFC8F5;White-space: nowrap; padding: 5px; font-weight: bold"">Error Message</TD></TR>"

            'Add each row
            For Each row As TranslatorError In errorList
                errString &= vbCrLf & row.TableRowHtml
            Next

            'End the table
            errString &= "</TABLE>"
        End If

        'Return the table
        Return errString

    End Function

#End Region

End Class
