Option Strict Off

Imports Nrc.Qualisys.QualisysDataEntry.Library.DbHelper
Imports System.Data.SqlClient

''' <summary>
''' Represents a form containing one or more comments.
''' </summary>
''' <remarks>
''' Also represents a record from the QDEDataEntry table.
''' </remarks>
''' <history>
''' 	[JCamp]	7/30/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class QDEForm

#Region " Private Members "
    'DB Fields
    Private mFormID As Integer
    Private mQuestionFormID As Integer
    Private mSentMailID As Integer
    Private mLithoCode As String
    Private mSurveyID As Integer
    Private mTemplateCode As String
    Private mLangID As Integer
    Private mTemplateName As String
    Private mIsLocked As Boolean

    'Child objects
    Private mComments As New CommentCollection

#End Region

#Region " Enumerations "
    Public Enum WorkStage
        ToBeKeyed = 1
        ToBeKeyVerified = 2
        ToBeCoded = 3
        ToBeCodeVerified = 4
        ToBeHandEntered = 5
        ToBeHandEntryVerified = 6
    End Enum

#End Region

#Region " Public Properties "
    '''<summary>The FormID of the form.</summary>
    Public ReadOnly Property FormID() As Integer
        Get
            Return mFormID
        End Get
    End Property

    '''<summary>The lithocode of the form.</summary>
    Public Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
        Set(ByVal value As String)
            mLithoCode = value
        End Set
    End Property

    '''<summary>The collection of comments on this form.</summary>
    Public ReadOnly Property Comments() As CommentCollection
        Get
            Return mComments
        End Get
    End Property
#End Region

#Region " Constructors "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Default constructor.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub New()

    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Constructor to initialize the object for the database
    ''' </summary>
    ''' <param name="dbData">The datarow object that represents the record for this instance.</param>
    ''' <param name="tblComments">The datatable that contains all the comment records for this form.</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub New(ByVal dbData As DataRow, ByVal tblComments As DataTable)
        'Populate the field from the DataRow
        If Not dbData Is Nothing Then
            mFormID = CType(dbData("Form_id"), Integer)
            mLithoCode = dbData("strLithoCode").ToString
            mSentMailID = CType(dbData("SentMail_id"), Integer)
            mQuestionFormID = CType(dbData("QuestionForm_id"), Integer)
            mSurveyID = CType(dbData("Survey_id"), Integer)
            mTemplateCode = dbData("strTemplateCode").ToString
            mLangID = CType(dbData("LangID"), Integer)
            mIsLocked = CType(dbData("bitLocked"), Boolean)
            mTemplateName = dbData("strTemplateName").ToString
        End If

        Dim row As DataRow
        Dim cmnt As Comment
        If Not tblComments Is Nothing Then
            'Now for each Comment record, create a Comment object and add it to this collection
            For Each row In tblComments.Rows
                cmnt = New Comment(row)
                mComments.Add(cmnt)
            Next
        End If

    End Sub

#End Region

#Region " Public Methods "

#Region " Database CRUD Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Updates the database with the data from all the comments on this form.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub UpdateCommentRecords()
        Dim cmnt As Comment
        For Each cmnt In mComments
            cmnt.UpdateDB()
        Next
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Removes the lock flag on this record in the database.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub UnlockForm()
        If mIsLocked Then
            ExecuteNonQuery("SP_QDE_UnLockForm", mFormID)
            mIsLocked = False
        End If
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Creates an instance of QuestionForm that represents the next QuestionForm that has
    ''' work to be done in the specified stage from the specified template.
    ''' </summary>
    ''' <param name="batchID">The BatchID of the batch we are working on</param>
    ''' <param name="templateName">The template to search in for work</param>
    ''' <param name="stage">The stage of work being sought.</param>
    ''' <returns>An instance of QuestionForm representing the next form that needs work.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetNextForm(ByVal batchID As Integer, ByVal templateName As String, ByVal stage As WorkStage, ByVal userName As String) As QDEForm
        Dim ds As DataSet
        Dim row As DataRow
        Dim qf As QDEForm = Nothing

        'Table 0 = QDEDataEntry record
        'Table 1 = QDEComments record(s)
        ds = ExecuteDataset("SP_QDE_SelectNextForm", batchID, templateName, stage, userName)

        'Return NOTHING if no work was found
        If ds.Tables.Count < 2 Then Return Nothing

        row = ds.Tables(0).Rows(0)

        'Load the QuestionForm object
        If Not row Is Nothing Then
            qf = New QDEForm(row, ds.Tables(1))
        End If

        Return qf
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Loads a QDEForm object for the specified FormID from the database.
    ''' </summary>
    ''' <param name="FormID">The ID of the form to load.</param>
    ''' <returns>A QDEForm instance representing the form.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LoadFromDB(ByVal FormID As Integer) As QDEForm
        Dim ds As DataSet
        Dim row As DataRow
        Dim qf As QDEForm = Nothing

        'Table 0 = QDEDataEntry record
        'Table 1 = QDEComments record(s)
        ds = ExecuteDataset("SP_QDE_SelectFormData", FormID)

        'Return NOTHING if no work was found
        If ds.Tables.Count < 2 Then Return Nothing

        row = ds.Tables(0).Rows(0)

        'Load the QuestionForm object
        If Not row Is Nothing Then
            qf = New QDEForm(row, ds.Tables(1))
        End If

        Return qf
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a list of all Forms that belong to a certain batch.
    ''' </summary>
    ''' <param name="batchID">The batch ID.</param>
    ''' <returns>A DataTable containing all the forms that are a part of the batch</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetFormList(ByVal batchID As Integer) As DataTable
        Return ExecuteDataset("SP_QDE_SelectBatchForms", batchID).Tables(0)
    End Function

    Public Shared Function GetLithoStatus(ByVal lithoCode As String) As IDataReader
        Return ExecuteReader("SP_QDE_LithoStatus", lithoCode)
    End Function

#End Region

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a string representing the finalized output string for all comments
    ''' on this form
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function GetFinalizeString() As String
        Dim result As New Text.StringBuilder
        Dim cmnt As Comment
        Dim litho As Integer = CType(mLithoCode, Integer)

        For Each cmnt In mComments
            If cmnt.CommentText.Length > 0 Then
                If result.Length > 0 Then result.Append(vbCrLf)
                'LINE 1 (Comment Codes)
                result.Append(LithoToBarcode(litho))
                result.Append(" C")
                result.Append((cmnt.QstnCore + 500000).ToString)
                result.Append(":")
                result.Append(cmnt.CommentTypeID.ToString)
                result.Append(",")
                result.Append(cmnt.CommentValenceID.ToString)
                If cmnt.Codes.Count > 0 Then
                    result.Append(",")
                    result.Append(cmnt.CodeList)
                End If

                result.Append(vbCrLf)

                'LINE 2 (Comment Text)
                result.Append(LithoToBarcode(litho))
                result.Append(" K")
                result.Append((cmnt.QstnCore + 500000).ToString)
                result.Append(":")
                result.Append(cmnt.CommentText.Replace(vbCrLf, " "))
            End If
        Next

        Return result.ToString
    End Function

#Region " Litho Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a lithocode into a barcode
    ''' </summary>
    ''' <param name="lithoCode">The lithocode to convert</param>
    ''' <returns>The barcode string for this lithocode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LithoToBarcode(ByVal lithoCode As Integer) As String
        Return LithoToBarcode(lithoCode, True, 1)
    End Function
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a lithocode into a barcode.
    ''' </summary>
    ''' <param name="lithoCode">The lithocode to be converted.</param>
    ''' <param name="includeCheckDigit">Indicates whether or not to include a 
    ''' check digit in the returned barcode.  
    ''' </param>
    ''' <param name="pageNumber">The page number to be included</param>
    ''' <returns>The barcode string for this lithocode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]     7/30/2004	Converted to .NET
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LithoToBarcode(ByVal lithoCode As Integer, _
                                        ByVal includeCheckDigit As Boolean, _
                                        ByVal pageNumber As Integer) As String

        Dim sTemp As String = ""
        Dim lOrigLithoCode As Long
        Dim lCnt As Long
        Dim lTemp As Long
        Dim sBarCode As String

        Const knDigits As Integer = 6
        Const ksLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        If lithoCode < 0 Then
            Return "-1"
        End If

        lOrigLithoCode = lithoCode


        For lCnt = knDigits To 0 Step -1
            lTemp = Int(lithoCode / (Len(ksLookUpTable) ^ lCnt))
            sTemp = sTemp & ksLookUpTable.Substring(lTemp, 1)
            lithoCode = lithoCode - (lTemp * (Len(ksLookUpTable) ^ lCnt))
        Next lCnt

        If lOrigLithoCode <> CType(BarcodeToLitho(sTemp), Long) Then
            sBarCode = "-1"
        Else
            sTemp = sTemp.PadLeft(7, Convert.ToChar("0"))
            sBarCode = sTemp.Substring(sTemp.Length - 6)
            If includeCheckDigit Then
                sBarCode = sBarCode & pageNumber
                sBarCode = sBarCode & GetCheckDigit(sBarCode)
            End If
        End If

        Return sBarCode
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function calculates the barcode check digit.
    ''' </summary>
    ''' <param name="barCode">The barcode to calculate the checkdigit for.</param>
    ''' <returns>The check digit for the supplied barcode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    '''     [JFleming]  8/17/2004   Corrected substring index calculations.
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetCheckDigit(ByVal barCode As String) As String

        Dim sTempCheckDigit As String
        Dim sCheckCode As String
        Dim nCheckCnt As Integer
        Dim nStrPos As Integer

        Const ksBarcodeDigits As String = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%"

        'Divide the string into it's component parts
        sCheckCode = barCode.ToUpper

        'Accumulate the checksum of all of the digits
        nCheckCnt = 0
        For nStrPos = 1 To sCheckCode.Length
            'Get the current digit to be checksummed
            sTempCheckDigit = sCheckCode.Substring(nStrPos - 1, 1)

            'If this digit is a space then set it to an exclamation point
            If sTempCheckDigit = " " Then sTempCheckDigit = "!"

            'Add the checksum value
            '** Modified 08-17-04 JJF
            'nCheckCnt = nCheckCnt + ksBarcodeDigits.IndexOf(sTempCheckDigit)
            nCheckCnt = nCheckCnt + ksBarcodeDigits.IndexOf(sTempCheckDigit) + 1
            '** End of modification 08-17-04 JJF
        Next nStrPos

        'Determine the check digit
        If (nCheckCnt Mod (ksBarcodeDigits.Length + 1)) = 0 Then
            sTempCheckDigit = "0"
        Else
            sTempCheckDigit = ksBarcodeDigits.Substring((nCheckCnt Mod (ksBarcodeDigits.Length + 1)) - 1, 1)
        End If

        'Determine the return value
        GetCheckDigit = sTempCheckDigit

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function validates the barcode check digit.
    ''' </summary>
    ''' <param name="barCode">The original barcode to be checked.</param>
    ''' <returns>True if the check digit is valid, otherwise False.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    '''     [JFleming]  8/17/2004   Corrected substring index calculations.
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function IsCheckDigitValid(ByVal barCode As String) As Boolean

        Dim sOrigCheckDigit As String
        Dim sCheckCode As String

        'Divide the string into it's component parts
        barCode = barCode.ToUpper
        '** Modified 08-17-04 JJF
        'sOrigCheckDigit = barCode.Substring(barCode.Length - 2)
        'sCheckCode = barCode.Substring(0, barCode.Length - 2)
        sOrigCheckDigit = barCode.Substring(barCode.Length - 1)
        sCheckCode = barCode.Substring(0, barCode.Length - 1)
        '** End of modification 08-17-04 JJF

        'If the original check digit is a space then set it to an exclamation point
        If sOrigCheckDigit = " " Then sOrigCheckDigit = "!"

        'Determine the return value
        IsCheckDigitValid = ((GetCheckDigit(sCheckCode)) = sOrigCheckDigit)

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' This function converts a barcode into a lithocode.
    ''' </summary>
    ''' <param name="barCode">The original barcode to be converted.</param>
    ''' <returns>The LithoCode for the supplied BarCode.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    '''     [JFleming]  4/5/2000    Created
    ''' 	[JCamp]	    7/30/2004	Converted to .NET
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function BarcodeToLitho(ByVal barCode As String) As String

        Dim sCurrentDigit As Char
        Dim lTemp As Integer
        Dim lConvertedDigit As Integer
        Dim lCurrentDecimal As Integer
        Dim lBase10 As Integer
        Dim lCnt As Integer

        Const ksLookUpTable As String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        lCurrentDecimal = barCode.Length - 2
        For lCnt = 1 To barCode.Length
            sCurrentDigit = barCode.Substring(lCnt - 1, 1)
            lBase10 = ksLookUpTable.IndexOf(sCurrentDigit)
            lConvertedDigit = lBase10 * ksLookUpTable.Length
            lTemp = lTemp + lConvertedDigit * (ksLookUpTable.Length ^ lCurrentDecimal)
            lCurrentDecimal = lCurrentDecimal - 1
        Next lCnt
        BarcodeToLitho = lTemp.ToString.Trim

    End Function

#End Region

#End Region

#Region " Overrides from base class"
    Protected Overrides Sub Finalize()
        MyBase.Finalize()

        'If the record for this object is still locked then unlock it.
        If mIsLocked Then
            Me.UnlockForm()
            mIsLocked = False
        End If
    End Sub
#End Region

End Class
