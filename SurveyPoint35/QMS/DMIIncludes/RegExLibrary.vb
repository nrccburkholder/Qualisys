Public Class RegExLibrary
    Public Const VARCHAR_10_REGEX As String = "^.{1,10}$"
    Public Const VARCHAR_50_REGEX As String = "^.{1,50}$"
    Public Const VARCHAR_100_REGEX As String = "^.{1,100}$"
    Public Const VARCHAR_200_REGEX As String = "^.{1,200}$"
    Public Const VARCHAR_500_REGEX As String = "^.{1,500}$"
    Public Const VARCHAR_1000_REGEX As String = "^.{1,1000}$"
    Public Const VARCHAR_2000_REGEX As String = "^.{1,2000}$"
    Public Const INT_10_REGEX As String = "^\d{1,10}$"
    Public Const TWO_LETTERS As String = "^[A-Za-z][A-Za-z]$"
    Public Const TWO_NUMBERS As String = "^[0-9][0-9]$"
    Public Const SINGLE_CHARCATER As String = "^.$"
    Public Const DECIMAL_NUMBER As String = "(^(\d+(\.\d+)?)$)|(^\.\d+$)"
    Public Const INTEGER_NUMBER As String = "^\d+$"

    Public Const SQL_DATE_VALAIDATION_REGEX As String = "^(((0?[13578]|1[02])(\/|-|\.)31)\4|((0?[1,3-9]|1[0-2])(\/|-|\.)(29|30)\7))((1[6-9]|[2-9]\d)?\d{2})$|^(0?2(\/|-|\.)29\12(((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$|^((0?[1-9])|(1[0-2]))(\/|-|\.)(0?[1-9]|1\d|2[0-8])\22((1[6-9]|[2-9]\d)?\d{2})$"
    Public Const SSN_VALAIDATION_REGEX As String = "^\d{3}-\d{2}-\d{4}$"
    Public Const US_ZIP_VALAIDATION_REGEX As String = "^\d{5}(-\d{4})?$"
    Public Const US_TELEPHONE_VALAIDATION_REGEX As String = "^[\\(]{0,1}([0-9]){3}[\\)]{0,1}[ ]?([^0-1]){1}([0-9]){2}[- ]([0-9]){4}$"
    Public Const TIME_12_HOUR_VALIDATION_REGEX As String = "^(1[012]|[0-9]):[0-5][0-9] ?[aApP][mM]$"

    'Note: this format will also validate email addrs in the form of 'john.doe@[192.168.254.123]' as per RFC 1123 Section 5.2.17. This is called a Domain Literal email address.
    Public Const EMAIL_ADDRESS_VALIDATION_REGEX As String = "^([a-zA-Z0-9_\-])+(\.([a-zA-Z0-9_\-])+)*@((\[(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5]))\]))|((([a-zA-Z0-9])+(([\-])+([a-zA-Z0-9])+)*\.)+([a-zA-Z])+(([\-])+([a-zA-Z0-9])+)*))$"
End Class
