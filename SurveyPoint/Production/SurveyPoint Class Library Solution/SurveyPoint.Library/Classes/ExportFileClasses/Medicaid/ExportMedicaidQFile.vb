Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO
Imports System.Collections
Imports System.Text

Public Interface IExportMedicaidQFileID
    Property ExportMedicaidQFileID() As Integer
End Interface

''' <summary>This object represents a record for the answer file.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportMedicaidQFile
    Inherits BusinessBase(Of ExportMedicaidQFile)
    Implements IExportMedicaidQFileID

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    'Respondent Answer Fields
    Private mExportMedicaidQFileID As Integer
    Private mScriptID As Integer
    Private mSurveyQuestionID As Integer
    Private mQuestionID As Integer
    Private mTodayDate As Date
    Private mCalculationTypeID As Integer
    Private mItemOrder As Integer
    Private mText As String = String.Empty
    Private mAnswerCategoryTypeID As Integer
    Private mAnswerValue As Integer
    Private mAnswerText As String = String.Empty
    Private mExportGroupID As Integer
    Private mName As String = String.Empty
    Private mMiscChar1 As String = String.Empty
    Private mMiscChar2 As String = String.Empty
    Private mMiscChar3 As String = String.Empty
    Private mMiscChar4 As String = String.Empty
    Private mMiscChar5 As String = String.Empty
    Private mMiscChar6 As String = String.Empty
    Private mMiscNum1 As Nullable(Of Decimal)
    Private mMiscNum2 As Nullable(Of Decimal)
    Private mMiscNum3 As Nullable(Of Decimal)
    Private mMiscDate1 As Nullable(Of Date)
    Private mMiscDate2 As Nullable(Of Date)
    Private mMiscDate3 As Nullable(Of Date)
    'TP 20080414 Question file need the script extensions as well.
    Private mSCMiscChar1 As String = String.Empty
    Private mSCMiscChar2 As String = String.Empty
    Private mSCMiscChar3 As String = String.Empty
    Private mSCMiscChar4 As String = String.Empty
    Private mSCMiscChar5 As String = String.Empty
    Private mSCMiscChar6 As String = String.Empty
    Private mSCMiscNum1 As Nullable(Of Decimal)
    Private mSCMiscNum2 As Nullable(Of Decimal)
    Private mSCMiscNum3 As Nullable(Of Decimal)
    Private mSCMiscDate1 As Nullable(Of Date)
    Private mSCMiscDate2 As Nullable(Of Date)
    Private mSCMiscDate3 As Nullable(Of Date)
    'TP 20080414 New Export Group Extension Field.
    Private mRemoveHTMLAndEncoding As Boolean
    'Passed In fields
    Private mTotalRecordCount As Integer

    Private mParent As ExportMedicaidQFileController
#End Region

#Region " Public Properties "

    ''' <summary>Unique ID for a result file object</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportMedicaidQFileID() As Integer Implements IExportMedicaidQFileID.ExportMedicaidQFileID
        Get
            Return Me.mExportMedicaidQFileID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportMedicaidQFileID Then
                mExportMedicaidQFileID = value
                PropertyHasChanged("ExportMedicaidQFileID")
            End If
        End Set
    End Property

#Region " FieldPropeties "
    Public Property ScriptID() As Integer
        Get
            Return Me.mScriptID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mScriptID = value Then
                Me.mScriptID = value
                PropertyHasChanged("ScriptID")
            End If
        End Set
    End Property
    Public Property SurveyQuestionID() As Integer
        Get
            Return Me.mSurveyQuestionID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mSurveyQuestionID = value Then
                Me.mSurveyQuestionID = value
                PropertyHasChanged("SurveyQuestionID")
            End If
        End Set
    End Property
    Public Property QuestionID() As Integer
        Get
            Return Me.mQuestionID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mQuestionID = value Then
                Me.mQuestionID = value
                PropertyHasChanged("QuestionID")
            End If
        End Set
    End Property
    Public Property TodayDate() As Date
        Get
            Return Me.mTodayDate
        End Get
        Set(ByVal value As Date)
            If Not Me.mTodayDate = value Then
                Me.mTodayDate = value
                PropertyHasChanged("TodayDate")
            End If
        End Set
    End Property
    Public Property CaculationTypeID() As Integer
        Get
            Return Me.mCalculationTypeID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mCalculationTypeID = value Then
                Me.mCalculationTypeID = value
                PropertyHasChanged("CalculationTypeID")
            End If
        End Set
    End Property
    Public Property ItemOrder() As Integer
        Get
            Return Me.mItemOrder
        End Get
        Set(ByVal value As Integer)
            If Not Me.mItemOrder = value Then
                Me.mItemOrder = value
                PropertyHasChanged("ItemOrder")
            End If
        End Set
    End Property
    Public Property QText() As String
        Get
            Return Me.mText
        End Get
        Set(ByVal value As String)
            If Not Me.mText = value Then
                Me.mText = value
                PropertyHasChanged("QText")
            End If
        End Set
    End Property
    Public Property AnswerCategoryTypeID() As Integer
        Get
            Return Me.mAnswerCategoryTypeID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mAnswerCategoryTypeID = value Then
                Me.mAnswerCategoryTypeID = value
                PropertyHasChanged("AnswerCategoryTypeID")
            End If
        End Set
    End Property
    Public Property AnswerValue() As Integer
        Get
            Return Me.mAnswerValue
        End Get
        Set(ByVal value As Integer)
            If Not Me.mAnswerValue = value Then
                Me.mAnswerValue = value
                PropertyHasChanged("AnswerValue")
            End If
        End Set
    End Property
    Public Property AnswerText() As String
        Get
            Return Me.mAnswerText
        End Get
        Set(ByVal value As String)
            If Not Me.mAnswerText = value Then
                Me.mAnswerText = value
                PropertyHasChanged("AnswerText")
            End If
        End Set
    End Property
    Public Property ExportGroupID() As Integer
        Get
            Return Me.mExportGroupID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mExportGroupID = value Then
                Me.mExportGroupID = value
                PropertyHasChanged("ExportGroupID")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return Me.mName
        End Get
        Set(ByVal value As String)
            If Not Me.mName = value Then
                Me.mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
#Region " Export Group Extensions "
    Public Property MiscChar1() As String
        Get
            Return Me.mMiscChar1
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar1 = value Then
                Me.mMiscChar1 = value
                PropertyHasChanged("MiscChar1")
            End If
        End Set
    End Property
    Public Property MiscChar2() As String
        Get
            Return Me.mMiscChar2
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar2 = value Then
                Me.mMiscChar2 = value
                PropertyHasChanged("MiscChar2")
            End If
        End Set
    End Property
    Public Property MiscChar3() As String
        Get
            Return Me.mMiscChar3
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar3 = value Then
                Me.mMiscChar3 = value
                PropertyHasChanged("MiscChar3")
            End If
        End Set
    End Property
    Public Property MiscChar4() As String
        Get
            Return Me.mMiscChar4
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar4 = value Then
                Me.mMiscChar4 = value
                PropertyHasChanged("MiscChar4")
            End If
        End Set
    End Property
    Public Property MiscChar5() As String
        Get
            Return Me.mMiscChar5
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar5 = value Then
                Me.mMiscChar5 = value
                PropertyHasChanged("MiscChar5")
            End If
        End Set
    End Property
    Public Property MiscChar6() As String
        Get
            Return Me.mMiscChar6
        End Get
        Set(ByVal value As String)
            If Not Me.mMiscChar6 = value Then
                Me.mMiscChar6 = value
                PropertyHasChanged("MiscChar6")
            End If
        End Set
    End Property
    Public Property MiscNum1() As Nullable(Of Decimal)
        Get
            Return Me.mMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mMiscNum1 = value
            PropertyHasChanged("MiscNum1")
        End Set
    End Property
    Public Property MiscNum2() As Nullable(Of Decimal)
        Get
            Return Me.mMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mMiscNum2 = value
            PropertyHasChanged("MiscNum2")
        End Set
    End Property
    Public Property MiscNum3() As Nullable(Of Decimal)
        Get
            Return Me.mMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mMiscNum3 = value
            PropertyHasChanged("MiscNum3")
        End Set
    End Property
    Public Property MiscDate1() As Nullable(Of Date)
        Get
            Return Me.mMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMiscDate1 = value
            PropertyHasChanged("MiscDate1")
        End Set
    End Property
    Public Property MiscDate2() As Nullable(Of Date)
        Get
            Return Me.mMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMiscDate2 = value
            PropertyHasChanged("MiscDate2")
        End Set
    End Property
    Public Property MiscDate3() As Nullable(Of Date)
        Get
            Return Me.mMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMiscDate3 = value
            PropertyHasChanged("MiscDate3")
        End Set
    End Property
#End Region
#Region " Script Extensions "
    Public Property SCMiscChar1() As String
        Get
            Return Me.mSCMiscChar1
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar1 = value Then
                Me.mSCMiscChar1 = value
                PropertyHasChanged("SCMiscChar1")
            End If
        End Set
    End Property
    Public Property SCMiscChar2() As String
        Get
            Return Me.mSCMiscChar2
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar2 = value Then
                Me.mSCMiscChar2 = value
                PropertyHasChanged("SCMiscChar2")
            End If
        End Set
    End Property
    Public Property SCMiscChar3() As String
        Get
            Return Me.mSCMiscChar3
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar3 = value Then
                Me.mSCMiscChar3 = value
                PropertyHasChanged("SCMiscChar3")
            End If
        End Set
    End Property
    Public Property SCMiscChar4() As String
        Get
            Return Me.mSCMiscChar4
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar4 = value Then
                Me.mSCMiscChar4 = value
                PropertyHasChanged("SCMiscChar4")
            End If
        End Set
    End Property
    Public Property SCMiscChar5() As String
        Get
            Return Me.mSCMiscChar5
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar5 = value Then
                Me.mSCMiscChar5 = value
                PropertyHasChanged("SCMiscChar5")
            End If
        End Set
    End Property
    Public Property SCMiscChar6() As String
        Get
            Return Me.mSCMiscChar6
        End Get
        Set(ByVal value As String)
            If Not Me.mSCMiscChar6 = value Then
                Me.mSCMiscChar6 = value
                PropertyHasChanged("SCMiscChar6")
            End If
        End Set
    End Property
    Public Property SCMiscNum1() As Nullable(Of Decimal)
        Get
            Return Me.mSCMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mSCMiscNum1 = value
            PropertyHasChanged("SCMiscNum1")
        End Set
    End Property
    Public Property SCMiscNum2() As Nullable(Of Decimal)
        Get
            Return Me.mSCMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mSCMiscNum2 = value
            PropertyHasChanged("SCMiscNum2")
        End Set
    End Property
    Public Property SCMiscNum3() As Nullable(Of Decimal)
        Get
            Return Me.mSCMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mSCMiscNum3 = value
            PropertyHasChanged("SCMiscNum3")
        End Set
    End Property
    Public Property SCMiscDate1() As Nullable(Of Date)
        Get
            Return Me.mSCMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mSCMiscDate1 = value
            PropertyHasChanged("SCMiscDate1")
        End Set
    End Property
    Public Property SCMiscDate2() As Nullable(Of Date)
        Get
            Return Me.mSCMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mSCMiscDate2 = value
            PropertyHasChanged("SCMiscDate2")
        End Set
    End Property
    Public Property SCMiscDate3() As Nullable(Of Date)
        Get
            Return Me.mSCMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mSCMiscDate3 = value
            PropertyHasChanged("SCMiscDate3")
        End Set
    End Property
#End Region
    ''' <summary>The value is derived form the export group.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property RemoveHTMLAndEncoding() As Boolean
        Get
            Return Me.mRemoveHTMLAndEncoding
        End Get
        Set(ByVal value As Boolean)
            If Not Me.mRemoveHTMLAndEncoding = value Then
                Me.mRemoveHTMLAndEncoding = value
                PropertyHasChanged("RemoveHTMLAndEncoding")
            End If
        End Set
    End Property
    'Passed in properties
    Public Property TotalRecordCount() As Integer
        Get
            Return Me.mTotalRecordCount
        End Get
        Set(ByVal value As Integer)
            If Not Me.mTotalRecordCount = value Then
                Me.mTotalRecordCount = value
                PropertyHasChanged("TotalRecordCount")
            End If
        End Set
    End Property
    Public Property ParentQuestionFileController() As ExportMedicaidQFileController
        Get
            Return Me.mParent
        End Get
        Set(ByVal value As ExportMedicaidQFileController)
            Me.mParent = value
            PropertyHasChanged("ParentQuestionFileController")
        End Set
    End Property
#End Region

#Region " Read Only Display Properties "
    ''' <summary>Extracted from MiscChar1 value of the export group.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Vendor_Code() As String
        Get
            Return charString(Me.mMiscChar1, 10)
        End Get
    End Property
    ''' <summary>A padded string containing the script ID.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Hra_Version() As String
        Get
            Return charString(Me.mScriptID.ToString, 25)
        End Get
    End Property
    ''' <summary>A padded string containing the question ID.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Question_Num() As String
        Get
            Return charString(Me.mQuestionID.ToString, 10)
        End Get
    End Property
    ''' <summary>The date (today) that the file is being created.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Batch_Date() As String
        Get
            Dim dte As Date = Date.Now
            Dim dteString As String = Format(dte, "yyyyMMdd")
            Return charString(dteString, 8)
        End Get
    End Property
    ''' <summary>Formatted string based off the calculation type ID</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Req_Field_Flag() As String
        Get
            Dim retVal As String = ""
            If Me.mCalculationTypeID = 1 Then
                retVal = "Y"
            ElseIf Me.mCalculationTypeID = 2 OrElse Me.mCalculationTypeID = 3 Then
                retVal = "N"
            Else
                'TODO:  Should this generated a validation error?
            End If
            Return charString(retVal, 1)
        End Get
    End Property
    ''' <summary>Extracted from MiscDate1 of the export Group.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - TP </term>
    ''' <description>HRADate now by script extension rather than export group
    ''' extension.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property Hra_Version_Date() As String
        Get
            If Me.mSCMiscDate1.HasValue Then
                Dim dtestring As String = Format(Me.mSCMiscDate1.Value, "yyyyMMdd")
                Return charString(dtestring, 8)
            Else
                'TODO:  Should this generate a validation error if no date?
                Return charString("", 8)
            End If
        End Get
    End Property
    ''' <summary>Formatted string based off of the item order.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Question_Order() As String
        Get
            Return charString(Me.mItemOrder.ToString, 10)
        End Get
    End Property
    ''' <summary>Formatted string based off the item order and question text.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>200800414 - TP</term>
    ''' <description>Decode url and html value optionally.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property Question_Description() As String
        Get
            'TP 20080326 Remove the Item order from the display text. and remove HTML Characters.
            Dim retVal As String = Me.mText
            'Dim retVal As String = "(" & Me.mItemOrder.ToString() & ")" & Me.mText            
            If Me.mRemoveHTMLAndEncoding Then
                retVal = RemoveHTMLXMLTags(retVal)
                retVal = System.Web.HttpUtility.UrlDecode(retVal)
                retVal = System.Web.HttpUtility.HtmlDecode(retVal)
                retVal = Replace(retVal, "&nbsp;", "")
                retVal = Replace(retVal, "nbsp;", "")
                retVal = Replace(retVal, vbCrLf, "")
                retVal = Replace(retVal, Chr(194), "")
                retVal = Replace(retVal, Chr(160), Chr(32))
            End If
            Return charString(retVal, 1000)
        End Get
    End Property
    ''' <summary>Formatted string based on the answercategorytypeid.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Type() As String
        Get
            Dim retVal As String = ""
            If Me.mQuestionID = 2156 Or Me.mQuestionID = 2157 Then
                retVal = "VALUE"
            Else
                Select Case Me.mAnswerCategoryTypeID
                    Case 1, 4, 7
                        retVal = "CHOICE"
                    Case 3, 5, 6, 8
                        retVal = "VALUE"
                    Case 2
                        retVal = "OPENEND"
                    Case Else
                        'TODO:  Should this generate a validation error?
                End Select
            End If
            Return charString(retVal, 10)
        End Get
    End Property
    ''' <summary>Formatted string representing the answer value.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Code() As String
        Get
            'TP 20080326  Dont show the answer code for Value cat types..
            Dim retVal As String = ""
            If Me.mQuestionID = 2156 Or Me.mQuestionID = 2157 Then
                retVal = ""
            Else
                Select Case Me.mAnswerCategoryTypeID
                    Case 3, 5, 6, 8
                        retVal = ""
                    Case Else
                        retVal = Me.mAnswerValue.ToString()
                End Select
            End If
            Return charString(retVal, 10)
        End Get
    End Property
    ''' <summary>Formated string representing the answer text.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Desc() As String
        Get
            Return charString(Replace(Me.mAnswerText, vbCrLf, ""), 1000)
        End Get
    End Property
    ''' <summary>Client says to leave empty for now.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Question_Type() As String
        Get
            Return charString("", 100)
        End Get
    End Property
    ''' <summary>Represents MiscChar2 from the export group</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property LOB_CD() As String
        Get
            Return charString(Me.mMiscChar2, 25)
        End Get
    End Property
    ''' <summary>Represents MiscChar3 from the export Group</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Trailer_ID() As String
        Get
            Return charString(Me.mMiscChar3, 3)
        End Get
    End Property
    ''' <summary>Padding so that the trailer record is that same length as the data records.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Filler() As String
        Get
            Return charString("", 2186)
        End Get
    End Property
    Public ReadOnly Property RecordCount() As String
        Get
            Dim recCnt As String = Me.TotalRecordCount.ToString
            Dim padlength As Integer = 10 - recCnt.Length
            If recCnt.Length < 10 Then
                Dim zeros As String = String.Empty
                For i As Integer = 1 To padlength
                    zeros += "0"
                Next
                Return zeros & recCnt
            Else
                Return charString(recCnt, 10)
            End If
        End Get
    End Property

#End Region

#End Region

#Region " Constructors "
    Protected Sub New()
        Me.CreateNew()
    End Sub
    Protected Overrides Sub CreateNew()
        'MyBase.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new empty export File object.</summary>
    ''' <returns>ExportFile</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportMedicaidQFile() As ExportMedicaidQFile
        'TODO:  Overload constructor.
        Return New ExportMedicaidQFile()
    End Function
    Public Shared Function CreateQuestionFileCollection(ByVal questionController As ExportMedicaidQFileController, ByVal exportGroupID As Integer) As ExportMedicaidQFileCollection
        Return ExportMedicaidQFileProvider.Instance.CreateQuestionFileCollection(questionController, exportGroupID)
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Set-gets the key identifier for the business object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mExportMedicaidQFileID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wires validation rules to the properties of the business object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...

    End Sub
#End Region

#Region " Data Access "
    Public Overrides Sub Save()
        Throw New NotImplementedException("Export Result File object does not implement a save.")
    End Sub
#End Region

#Region " Public Methods "
    ''' <summary>This is used to return a trailer record from for a question file.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintTrailerLine() As StringBuilder
        Dim sb As StringBuilder = New StringBuilder(1300)
        sb.Append(Me.Trailer_ID)
        sb.Append(Me.Vendor_Code)
        sb.Append(Me.Batch_Date)
        sb.Append(Me.RecordCount)
        sb.Append(Me.Filler)
        Return sb
    End Function
    ''' <summary>This method takes the display properties and returns a stringB representing one line.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintLine() As StringBuilder
        Dim sb As StringBuilder = New StringBuilder(1300)
        sb.Append(Me.Vendor_Code)
        sb.Append(Me.Hra_Version)
        sb.Append(Me.Question_Num)
        sb.Append(Me.Batch_Date)
        sb.Append(Me.Req_Field_Flag)
        sb.Append(Me.Hra_Version_Date)
        sb.Append(Me.Question_Order)
        sb.Append(Me.Question_Description)
        sb.Append(Me.Answer_Type)
        sb.Append(Me.Answer_Code)
        sb.Append(Me.Answer_Desc)
        sb.Append(Me.Question_Type)
        sb.Append(Me.LOB_CD)
        Return sb
    End Function
#End Region
#Region " Private and Protected Methods "
    ''' <summary>Helper to padd strings for fixed length file creation.</summary>
    ''' <param name="strVal"></param>
    ''' <param name="length"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function charString(ByVal strVal As String, ByVal length As Integer) As String
        Dim retVal As String = strVal
        If Not retVal = "" Then
            If retVal.Length > length Then
                retVal = retVal.Substring(0, length)
            Else
                retVal = retVal.PadRight(retVal.Length + (length - retVal.Length))
            End If
        Else
            retVal = retVal.PadRight(length)
        End If
        Return retVal
    End Function
    ''' <summary>Helper method to remove html and xml characters from a given string.</summary>
    ''' <param name="strVal"></param>
    ''' <returns>The original value less the html or xml tags.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function RemoveHTMLXMLTags(ByVal strVal As String) As String
        If strVal.IndexOf("<"c) >= 0 AndAlso strVal.IndexOf(">"c) >= 0 Then
            Dim charArray As Char() = strVal.ToCharArray()
            Dim htmlCharStart As Integer
            Dim htmlCharEnd As Integer
            Dim blnFound As Boolean = False
            For i As Integer = 0 To charArray.Length - 1
                If charArray(i) = "<"c Then
                    htmlCharStart = i
                End If
                If charArray(i) = ">"c Then
                    htmlCharEnd = i
                    blnFound = True
                    Exit For
                End If
            Next
            If blnFound Then
                strVal = strVal.Substring(0, htmlCharStart) & strVal.Substring(htmlCharEnd + 1)
                Return RemoveHTMLXMLTags(strVal)
            Else
                Return strVal
            End If
        Else
            Return strVal
        End If
    End Function
#End Region

End Class
