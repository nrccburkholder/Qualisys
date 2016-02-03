Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO
Imports System.Collections
Imports System.Text

Public Interface IExportWPMedicareRFileID
    Property ExportWPMedicareRFileID() As Integer
End Interface

''' <summary>This object represents a record for the answer file.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Public Class ExportWPMedicareRFile
    Inherits BusinessBase(Of ExportWPMedicareRFile)
    Implements IExportWPMedicareRFileID

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    'Respondent Answer Fields
    Private mExportWPMedicareRFileID As Integer
    Private mRespondentID As Integer
    Private mClientID As Integer
    Private mAnswerCatetoryID As Integer
    Private mResponseID As Integer
    Private mResponseText As String = String.Empty
    Private mSurveyQuestionID As Integer
    Private mUserID As Nullable(Of Integer) = Nothing
    Private mScriptID As Integer
    Private mSurveyID As Integer
    Private mAnswerCategoryTypeID As Integer
    Private mAnswerText As String = String.Empty
    Private mAnswerValue As Integer
    Private mQuestionID As Integer
    Private mItemOrder As Integer

    'Respondent Data fields
    Private mFirstName As String = String.Empty
    Private mLastName As String = String.Empty
    Private mMember_MI As String = String.Empty
    Private mAddress1 As String = String.Empty
    Private mAddress2 As String = String.Empty
    Private mCity As String = String.Empty
    Private mState As String = String.Empty
    Private mZip As String = String.Empty
    Private mGender As String = String.Empty
    Private mTelephone As String = String.Empty

    Private mDOB As Nullable(Of Date)
    Private mClientResponseID As String
    Private mSurveyInstanceID As Integer
    Private mRespondentProperties As Dictionary(Of String, String)

    'Export Group Fields
    Private mExportGroupID As Integer
    'TP 20080414 New Field
    Private mRemoveHTMLAndEncoding As Boolean
    Private mEGMiscChar1 As String = String.Empty
    Private mEGMiscChar2 As String = String.Empty
    Private mEGMiscChar3 As String = String.Empty
    Private mEGMiscChar4 As String = String.Empty
    Private mEGMiscChar5 As String = String.Empty
    Private mEGMiscChar6 As String = String.Empty
    Private mEGMiscNum1 As Nullable(Of Decimal)
    Private mEGMiscNum2 As Nullable(Of Decimal)
    Private mEGMiscNum3 As Nullable(Of Decimal)
    Private mEGMiscDate1 As Nullable(Of Date)
    Private mEGMiscDate2 As Nullable(Of Date)
    Private mEGMiscDate3 As Nullable(Of Date)

    'Client Data Fields
    Private mCLMiscChar1 As String = String.Empty
    Private mCLMiscChar2 As String = String.Empty
    Private mCLMiscChar3 As String = String.Empty
    Private mCLMiscChar4 As String = String.Empty
    Private mCLMiscChar5 As String = String.Empty
    Private mCLMiscChar6 As String = String.Empty
    Private mCLMiscNum1 As Nullable(Of Decimal)
    Private mCLMiscNum2 As Nullable(Of Decimal)
    Private mCLMiscNum3 As Nullable(Of Decimal)
    Private mCLMiscDate1 As Nullable(Of Date)
    Private mCLMiscDate2 As Nullable(Of Date)
    Private mCLMiscDate3 As Nullable(Of Date)

    'Script Data Fields
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
    'Max Event Date Fields
    Private mMaxEventDate As Nullable(Of Date) = Nothing

    'Passed In fields
    Private mTotalRecordCount As Integer

    Private mParent As ExportWPMedicareRFileController
#End Region

#Region " Public Properties "

    ''' <summary>Unique ID for a result file object</summary>
    ''' <value>Integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportWPMedicareRFileID() As Integer Implements IExportWPMedicareRFileID.ExportWPMedicareRFileID
        Get
            Return Me.mExportWPMedicareRFileID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportWPMedicareRFileID Then
                mExportWPMedicareRFileID = value
                PropertyHasChanged("ExportWPMedicareRFileID")
            End If
        End Set
    End Property

#Region " FieldPropeties "
    'Respondent Properties
    Public Property RespondentID() As Integer
        Get
            Return Me.mRespondentID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mRespondentID = value Then
                Me.mRespondentID = value
                PropertyHasChanged("RespondentID")
            End If
        End Set
    End Property
    Public Property ClientID() As Integer
        Get
            Return Me.mClientID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mClientID = value Then
                Me.mClientID = value
                PropertyHasChanged("ClientID")
            End If
        End Set
    End Property
    Public Property AnswerCategoryID() As Integer
        Get
            Return Me.mAnswerCatetoryID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mAnswerCatetoryID = value Then
                Me.mAnswerCatetoryID = value
                PropertyHasChanged("AnswerCategoryID")
            End If
        End Set
    End Property
    Public Property ResponseID() As Integer
        Get
            Return Me.mResponseID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mResponseID = value Then
                Me.mResponseID = value
                PropertyHasChanged("ResponseID")
            End If
        End Set
    End Property
    Public Property ResponseText() As String
        Get
            Return Me.mResponseText
        End Get
        Set(ByVal value As String)
            If Not Me.mResponseText = value Then
                Me.mResponseText = value
                PropertyHasChanged("ResponseText")
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
    Public Property UserID() As Nullable(Of Integer)
        Get
            Return Me.mUserID
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Me.mUserID = value
            PropertyHasChanged("UserID")
        End Set
    End Property
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
    Public Property SurveyID() As Integer
        Get
            Return Me.mSurveyID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mSurveyID = value Then
                Me.mSurveyID = value
                PropertyHasChanged("SurveyID")
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
                PropertyHasChanged("AnswerCategoryID")
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
    Public Property SurveyInstanceID() As Integer
        Get
            Return Me.mSurveyInstanceID
        End Get
        Set(ByVal value As Integer)
            If Not Me.mSurveyInstanceID = value Then
                Me.mSurveyInstanceID = value
                PropertyHasChanged("SurveyInstanceID")
            End If
        End Set
    End Property
    Public Property FirstName() As String
        Get
            Return Me.mFirstName
        End Get
        Set(ByVal value As String)
            If Not Me.mFirstName = value Then
                Me.mFirstName = value
                PropertyHasChanged("FirstName")
            End If
        End Set
    End Property
    Public Property LastName() As String
        Get
            Return Me.mLastName
        End Get
        Set(ByVal value As String)
            If Not Me.mLastName = value Then
                Me.mLastName = value
                PropertyHasChanged("LastName")
            End If
        End Set
    End Property
    Public Property Member_MI() As String
        Get
            Return Me.mMember_MI
        End Get
        Set(ByVal value As String)
            If Not Me.mMember_MI = value Then
                Me.mMember_MI = value
                PropertyHasChanged("Member_MI")
            End If
        End Set
    End Property
    Public Property Address1() As String
        Get
            Return Me.mAddress1
        End Get
        Set(ByVal value As String)
            If Not Me.mAddress1 = value Then
                Me.mAddress1 = value
                PropertyHasChanged("Address1")
            End If
        End Set
    End Property
    Public Property Address2() As String
        Get
            Return Me.mAddress2
        End Get
        Set(ByVal value As String)
            If Not Me.mAddress2 = value Then
                Me.mAddress2 = value
                PropertyHasChanged("Address2")
            End If
        End Set
    End Property
    Public Property City() As String
        Get
            Return Me.mCity
        End Get
        Set(ByVal value As String)
            If Not Me.mCity = value Then
                Me.mCity = value
                PropertyHasChanged("City")
            End If
        End Set
    End Property
    Public Property State() As String
        Get
            Return Me.mState
        End Get
        Set(ByVal value As String)
            If Not Me.mState = value Then
                Me.mState = value
                PropertyHasChanged("State")
            End If
        End Set
    End Property
    Public Property Zip() As String
        Get
            Return Me.mZip
        End Get
        Set(ByVal value As String)
            If Not Me.mZip = value Then
                Me.mZip = value
                PropertyHasChanged("Zip")
            End If
        End Set
    End Property
    Public Property Gender() As String
        Get
            Return Me.mGender
        End Get
        Set(ByVal value As String)
            If Not Me.mGender = value Then
                Me.mGender = value
                PropertyHasChanged("Gender")
            End If
        End Set
    End Property
    Public Property Telephone() As String
        Get
            Return Me.mTelephone
        End Get
        Set(ByVal value As String)
            If Not Me.mTelephone = value Then
                Me.mTelephone = value
                PropertyHasChanged("Telephone")
            End If
        End Set
    End Property
    Public Property DOB() As Nullable(Of Date)
        Get
            Return (Me.mDOB)
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mDOB = value
            PropertyHasChanged("DOB")
        End Set
    End Property
    Public Property ClientResponseID() As String
        Get
            Return Me.mClientResponseID
        End Get
        Set(ByVal value As String)
            If Not Me.mClientResponseID = value Then
                Me.mClientResponseID = value
                PropertyHasChanged("ClientResponseID")
            End If
        End Set
    End Property
    Public Property RespondentProperties() As Dictionary(Of String, String)
        Get
            Return Me.mRespondentProperties
        End Get
        Set(ByVal value As Dictionary(Of String, String))
            Me.mRespondentProperties = value
            PropertyHasChanged("RespondentProperties")
        End Set
    End Property
    'EG Properties
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
    Public Property EGMiscChar1() As String
        Get
            Return Me.mEGMiscChar1
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar1 = value Then
                Me.mEGMiscChar1 = value
                PropertyHasChanged("EGMiscChar1")
            End If
        End Set
    End Property
    Public Property EGMiscChar2() As String
        Get
            Return Me.mEGMiscChar2
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar2 = value Then
                Me.mEGMiscChar2 = value
                PropertyHasChanged("EGMiscChar2")
            End If
        End Set
    End Property
    Public Property EGMiscChar3() As String
        Get
            Return Me.mEGMiscChar3
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar3 = value Then
                Me.mEGMiscChar3 = value
                PropertyHasChanged("EGMiscChar3")
            End If
        End Set
    End Property
    Public Property EGMiscChar4() As String
        Get
            Return Me.mEGMiscChar4
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar4 = value Then
                Me.mEGMiscChar4 = value
                PropertyHasChanged("EGMiscChar4")
            End If
        End Set
    End Property
    Public Property EGMiscChar5() As String
        Get
            Return Me.mEGMiscChar5
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar5 = value Then
                Me.mEGMiscChar5 = value
                PropertyHasChanged("EGMiscChar")
            End If
        End Set
    End Property
    Public Property EGMiscChar6() As String
        Get
            Return Me.mEGMiscChar6
        End Get
        Set(ByVal value As String)
            If Not Me.mEGMiscChar6 = value Then
                Me.mEGMiscChar6 = value
                PropertyHasChanged("EGMiscChar6")
            End If
        End Set
    End Property
    Public Property EGMiscNum1() As Nullable(Of Decimal)
        Get
            Return Me.mEGMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mEGMiscNum1 = value
            PropertyHasChanged("EGMiscNum1")
        End Set
    End Property
    Public Property EGMiscNum2() As Nullable(Of Decimal)
        Get
            Return Me.mEGMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mEGMiscNum2 = value
            PropertyHasChanged("EGMiscNum2")
        End Set
    End Property
    Public Property EGMiscNum3() As Nullable(Of Decimal)
        Get
            Return Me.mEGMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mEGMiscNum3 = value
            PropertyHasChanged("EGMiscNum3")
        End Set
    End Property
    Public Property EGMiscDate1() As Nullable(Of Date)
        Get
            Return Me.mEGMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mEGMiscDate1 = value
            PropertyHasChanged("EGMiscDate1")
        End Set
    End Property
    Public Property EGMiscDate2() As Nullable(Of Date)
        Get
            Return Me.mEGMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mEGMiscDate2 = value
            PropertyHasChanged("EGMiscDate2")
        End Set
    End Property
    Public Property EGMiscDate3() As Nullable(Of Date)
        Get
            Return Me.mEGMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mEGMiscDate3 = value
            PropertyHasChanged("EGMiscDate3")
        End Set
    End Property
    'Client Properties   
    Public Property CLMiscChar1() As String
        Get
            Return Me.mCLMiscChar1
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar1 = value Then
                Me.mCLMiscChar1 = value
                PropertyHasChanged("CLMiscChar1")
            End If
        End Set
    End Property
    Public Property CLMiscChar2() As String
        Get
            Return Me.mCLMiscChar2
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar2 = value Then
                Me.mCLMiscChar2 = value
                PropertyHasChanged("CLMiscChar2")
            End If
        End Set
    End Property
    Public Property CLMiscChar3() As String
        Get
            Return Me.mCLMiscChar3
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar3 = value Then
                Me.mCLMiscChar3 = value
                PropertyHasChanged("CLMiscChar3")
            End If
        End Set
    End Property
    Public Property CLMiscChar4() As String
        Get
            Return Me.mCLMiscChar4
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar4 = value Then
                Me.mCLMiscChar4 = value
                PropertyHasChanged("CLMiscChar4")
            End If
        End Set
    End Property
    Public Property CLMiscChar5() As String
        Get
            Return Me.mCLMiscChar5
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar5 = value Then
                Me.mCLMiscChar5 = value
                PropertyHasChanged("CLMiscChar5")
            End If
        End Set
    End Property
    Public Property CLMiscChar6() As String
        Get
            Return Me.mCLMiscChar6
        End Get
        Set(ByVal value As String)
            If Not Me.mCLMiscChar6 = value Then
                Me.mCLMiscChar6 = value
                PropertyHasChanged("CLMiscChar6")
            End If
        End Set
    End Property
    Public Property CLMiscNum1() As Nullable(Of Decimal)
        Get
            Return Me.mCLMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mCLMiscNum1 = value
            PropertyHasChanged("CLMiscNum1")
        End Set
    End Property
    Public Property CLMiscNum2() As Nullable(Of Decimal)
        Get
            Return Me.mCLMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mCLMiscNum2 = value
            PropertyHasChanged("CLMiscNum2")
        End Set
    End Property
    Public Property CLMiscNum3() As Nullable(Of Decimal)
        Get
            Return Me.mCLMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mCLMiscNum3 = value
            PropertyHasChanged("CLMiscNum3")
        End Set
    End Property
    Public Property CLMiscDate1() As Nullable(Of Date)
        Get
            Return Me.mCLMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mCLMiscDate1 = value
            PropertyHasChanged("CLMiscDate1")
        End Set
    End Property
    Public Property CLMiscDate2() As Nullable(Of Date)
        Get
            Return Me.mCLMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mCLMiscDate2 = value
            PropertyHasChanged("CLMiscDate2")
        End Set
    End Property
    Public Property CLMiscDate3() As Nullable(Of Date)
        Get
            Return Me.mCLMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mCLMiscDate3 = value
            PropertyHasChanged("CLMiscDate3")
        End Set
    End Property
    'Script Properties
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
            Return (Me.mSCMiscNum1)
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mSCMiscNum1 = value
            PropertyHasChanged("SCMiscNum1")
        End Set
    End Property
    Public Property SCMiscNum2() As Nullable(Of Decimal)
        Get
            Return (Me.mSCMiscNum2)
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            Me.mSCMiscNum2 = value
            PropertyHasChanged("SCMiscNum2")
        End Set
    End Property
    Public Property SCMiscNum3() As Nullable(Of Decimal)
        Get
            Return (Me.mSCMiscNum3)
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
    'Max Event Date properties
    Public Property MaxEventDate() As Nullable(Of Date)
        Get
            Return Me.mMaxEventDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mMaxEventDate = value
            PropertyHasChanged("MaxEventDate")
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

    ''' <summary>reference to parent object used to bubble message and progress events back to the ui.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ParentController() As ExportWPMedicareRFileController
        Get
            Return Me.mParent
        End Get
    End Property
#End Region

#Region " Read Only Display Properties "
    ''' <summary>Displays MiscChar1 from export group as a formatted string.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property VendorCode() As String
        Get
            Return Me.mEGMiscChar1
        End Get
    End Property
    ''' <summary>Displays the current date is a specific format</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Batch_Date() As String
        Get
            Dim dte As Date = Date.Now
            Dim dteString As String = Format(dte, "yyyyMMdd")
            Return dteString
        End Get
    End Property
    ''' <summary>RespondentID displayed is a specific format.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Hra_Number() As String
        Get
            Return Me.mRespondentID.ToString
        End Get
    End Property
    ''' <summary>Script ID displayed is a specific format.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Hra_Version() As String
        Get
            Return Me.mScriptID.ToString
        End Get
    End Property
    ''' <summary>The Max event date (exclude 2401 event date) given.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Hra_Begin_Date() As String
        Get
            If Me.mMaxEventDate.HasValue Then
                Dim dteString As String = Format(Me.mMaxEventDate.Value, "yyyyMMdd")
                Return charString(dteString, 8)
            Else
                Return charString("", 8)
            End If
        End Get
    End Property
    ''' <summary>The Max event date (exclude 2401 event date) given.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Hra_EndDate() As String
        Get
            If Me.mMaxEventDate.HasValue Then
                Dim dteString As String = Format(Me.mMaxEventDate.Value, "yyyyMMdd")
                Return charString(dteString, 8)
            Else
                Return charString("", 8)
            End If
        End Get
    End Property
    ''' <summary>Client says leave blank for now.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property RiskScore() As String
        Get
            Return charString("", 5)
        End Get
    End Property
    ''' <summary>Client says leave blank for now.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Vendor_Internal_Num() As String
        Get
            Return charString("", 25)
        End Get
    End Property
    ''' <summary>Misc Char 1 from the Select Client of the export group.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Plan_Cd() As String
        Get
            Return charString(Me.mCLMiscChar1, 10)
        End Get
    End Property
    Public ReadOnly Property Product_Family() As String
        Get
            If Me.mRespondentProperties.ContainsKey("PRODUCTFAMILY") Then
                Return CStr(Me.mRespondentProperties("PRODUCTFAMILY"))
            Else
                Return ""
            End If
        End Get
    End Property
    Public ReadOnly Property Product_Code() As String
        Get
            If Me.mRespondentProperties.ContainsKey("PRODUCTCODE") Then
                Return CStr(Me.mRespondentProperties("PRODUCTCODE"))
            Else
                Return ""
            End If
        End Get
    End Property
    Public ReadOnly Property Product_Long_Desc() As String
        Get
            If Me.mRespondentProperties.ContainsKey("PRODUCTLONGDESCRIPTION") Then
                Return CStr(Me.mRespondentProperties("PRODUCTLONGDESCRIPTION"))
            Else
                Return ""
            End If
        End Get
    End Property
    Public ReadOnly Property Company_Code() As String
        Get
            If Me.mRespondentProperties.ContainsKey("COMPANYCODE") Then
                Return CStr(Me.mRespondentProperties("COMPANYCODE"))
            Else
                Return ""
            End If
        End Get
    End Property
    Public ReadOnly Property County_Name() As String
        Get
            If Me.mRespondentProperties.ContainsKey("COUNTY") Then
                Return CStr(Me.mRespondentProperties("COUNTY"))
            Else
                Return ""
            End If
        End Get
    End Property
    ''' <summary>Client Says leave blank for now.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>MempatID may now have a value from the respondent
    ''' properties.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property Mempat_Id() As String
        Get
            If Me.mRespondentProperties.ContainsKey("PROPERTY_USER1") Then
                Dim memPat As String = CStr(Me.mRespondentProperties("PROPERTY_USER1"))
                If memPat.Length > 10 Then
                    memPat = memPat.Substring(memPat.Length - 10)
                End If
                Return PadCharString(memPat, 10, "0"c, PadDirection.Right)
            Else
                Return charString("", 10)
            End If
        End Get
    End Property
    ''' <summary>Client Says leave blank for now.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>MemberID may now contain a respondent properties
    ''' value.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property Mem_Id() As String
        Get
            If Me.mClientResponseID Is Nothing Then
                Return ""
            Else
                Return mClientResponseID.ToString
            End If
        End Get
    End Property
    ''' <summary>Client Says leave blank for now.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Contract Num may now contain a value from respondent
    ''' properties.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public ReadOnly Property Contract_Num() As String
        Get
            If Me.mRespondentProperties.ContainsKey("CONTRACT") Then
                Dim contract As String = CStr(Me.mRespondentProperties("CONTRACT"))
                If contract.Length > 10 Then
                    contract = contract.Substring(contract.Length - 10)
                End If
                Return PadCharString(contract.ToString, 10, "0"c, PadDirection.Right)
            Else
                Return charString("", 10)
            End If
        End Get
    End Property
    ''' <summary>ClientResponseID is the respondent SSN minus any non numeric chars</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Member_SSN() As String
        Get
            Return charString(Me.mClientResponseID.ToString, 9)
        End Get
    End Property
    ''' <summary>Last name of the respondent</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Member_Last_Nm() As String
        Get
            Return Me.mLastName
        End Get
    End Property
    ''' <summary>First Name of the respondent</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Member_First_Nm() As String
        Get
            Return Me.mFirstName
        End Get
    End Property
    ''' <summary>DOB of the respondent</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Member_Birth_Dt() As String
        Get
            If Me.mDOB.HasValue Then
                Dim dteString As String = Format(Me.mDOB.Value, "yyyyMMdd")
                Return dteString
            Else
                Return ""
            End If
        End Get
    End Property
    ''' <summary>Formatted string of the QuestionID</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Question_Num() As String
        Get
            Return Me.mQuestionID.ToString
        End Get
    End Property
    ''' <summary>Display text based off of the answercattypeid.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Type() As String
        Get
            Dim retVal As String = ""
            Select Case Me.mAnswerCategoryTypeID
                Case 1, 4, 7
                    retVal = "CHOICE"
                Case 3, 5, 6, 8, 2
                    retVal = "OPENEND"                
                Case Else
                    'TODO:  Find out if validation needed.
            End Select
            Return retVal
        End Get
    End Property
    ''' <summary>Display answre value if a certain answreCatTypeID is used.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Cd() As String
        Get
            Dim retVal As String = ""
            'TP 9/9/2008
            Return Me.mAnswerValue.ToString
            'Select Case Me.mAnswerCategoryTypeID
            '    Case 1, 4, 7
            '        retVal = Me.mAnswerValue.ToString
            '    Case Else
            '        retVal = ""
            'End Select
            'Return retVal
        End Get
    End Property
    ''' <summary>Display response text if answer Cat Type ID match is met.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Value() As String
        Get
            Dim retVal As String = ""
            Select Case Me.mAnswerCategoryTypeID
                Case 2, 3, 5, 6, 8
                    retVal = Me.mResponseText
                Case Else
                    retVal = ""
            End Select
            Return Replace(retVal, vbCrLf, "")
        End Get
    End Property
    ''' <summary>Display Value from Script MiscChar1 value</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Answer_Source() As String
        Get
            Return charString(Me.mSCMiscChar1, 10)
        End Get
    End Property
    ''' <summary>Display from respondent propreties.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Pra_Risk_Score() As String
        Get
            'TODO:  Check logic
            Dim riskScore As String = CStr(Me.mRespondentProperties("PRA_SCORE"))
            If riskScore Is Nothing Then riskScore = String.Empty
            Return riskScore
        End Get
    End Property
    Public ReadOnly Property Pra_Risk_Percent() As String
        Get
            Dim riskPercent As String = CStr(Me.mRespondentProperties("PRA_PERCENTILE"))
            If riskPercent Is Nothing Then riskPercent = String.Empty
            Return riskPercent
        End Get
    End Property
    ''' <summary>Display from respondent propreties.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Frailty_Risk_Score() As String
        Get
            'TODO:  Check logic
            Dim frailtyScore As String = CStr(Me.mRespondentProperties("FRAILTY_SCORE"))
            If frailtyScore Is Nothing Then frailtyScore = String.Empty
            Return frailtyScore
        End Get
    End Property
    Public ReadOnly Property Frailty_Risk_Percent() As String
        Get
            Dim frailtyPercent As String = CStr(Me.mRespondentProperties("FRAILTY_PERCENTILE"))
            If frailtyPercent Is Nothing Then frailtyPercent = String.Empty
            Return frailtyPercent
        End Get
    End Property

    ''' <summary>Display from respondent propreties.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Depression_Risk_Score() As String
        Get
            'TODO:  Check logic
            Dim depressionScore As String = CStr(Me.mRespondentProperties("DEPRESSION_SCORE"))
            If depressionScore Is Nothing Then depressionScore = String.Empty
            Return depressionScore
        End Get
    End Property
    Public ReadOnly Property Depression_Risk_Percent() As String
        Get
            Dim depPercent As String = CStr(Me.mRespondentProperties("DEPRESSION_PERCENTILE"))
            If depPercent Is Nothing Then depPercent = String.Empty
            Return depPercent
        End Get
    End Property
    Public ReadOnly Property Senior_Health_Report() As String
        Get
            Dim seniorRpt As String = CStr(Me.mRespondentProperties("SENIOR_HEALTH_REPORT"))
            If seniorRpt Is Nothing Then seniorRpt = String.Empty
            Return seniorRpt
        End Get
    End Property
    ''' <summary>Display property for MiscChar3 of the export group.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Trailer_Id() As String
        Get
            Return Me.mEGMiscChar3
        End Get
    End Property
    ''' <summary>Displays the total record count (collection which this object belongs to) as a formatted string.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Total_Record_Cnt() As String
        Get
            Dim recCnt As String = Me.TotalRecordCount.ToString
            Return recCnt            
        End Get
    End Property
    ''' <summary>Filler space needed for the trailer record so that its length matches that of the date records.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property Filler() As String
        Get
            Return charString("", 1247)
        End Get
    End Property
#End Region

#End Region

#Region " Constructors "
    Protected Sub New(ByVal parent As ExportWPMedicareRFileController, ByVal totalRecordCount As Integer)
        Me.CreateNew()
        Me.mParent = parent
        Me.mTotalRecordCount = totalRecordCount
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
    Public Shared Function NewExportWPMedicareRFile(ByVal parent As ExportWPMedicareRFileController, ByVal totalRecordCount As Integer) As ExportWPMedicareRFile
        'TODO:  Overload constructor.
        Return New ExportWPMedicareRFile(parent, totalRecordCount)
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
            Return mExportWPMedicareRFileID
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
    Public Function PrintHeaderLine() As String
        Return "vendor_code|batch_date|hra_number|hra_version|product_family|product_code|product_long_desc|company_code|Member_ID|county_name|member_last_nm|member_first_nm|member_middle_initial|member_birth_dt|Address_1|Address_2|City|State|Zip|Telephone|Gender|question_id|answer_type|answer_cd|answer_value|pra_risk_score|pra_percentile|frailty_risk_score|frailty_percentile|depression_risk_score|depression_percentile|senior_health_report"
    End Function
    Public Function PrintTrailFileHeaderLine() As String
        Return "trailer_id|vendor_code|batch_date|total_record_cnt"
    End Function
    ''' <summary>This is used to return a trailer record from for a result file.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintTrailerLine() As StringBuilder
        Dim sb As StringBuilder = New StringBuilder(1300)
        sb.Append(Me.Trailer_Id & "|")
        sb.Append(Me.VendorCode & "|")
        sb.Append(Me.Batch_Date & "|")
        sb.Append(Me.Total_Record_Cnt)        
        Return sb
    End Function
    ''' <summary>This method takes the display properties and returns a stringB representing one line.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function PrintLine() As StringBuilder
        Dim sb As StringBuilder = New StringBuilder(1300)
        sb.Append(Me.VendorCode & "|")
        sb.Append(Me.Batch_Date & "|")
        sb.Append(Me.Hra_Number & "|")
        sb.Append(Me.Hra_Version & "|")
        sb.Append(Product_Family & "|")
        sb.Append(Product_Code & "|")
        sb.Append(Product_Long_Desc & "|")
        sb.Append(Company_Code & "|")
        'sb.Append(Me.Hra_Begin_Date)
        'sb.Append(Me.Hra_EndDate)
        'sb.Append(Me.RiskScore)
        'sb.Append(Me.Vendor_Internal_Num)
        'sb.Append(Me.Plan_Cd)
        'sb.Append(Me.Mempat_Id)
        sb.Append(Me.Mem_Id & "|")
        sb.Append(County_Name & "|")
        'sb.Append(Me.Contract_Num)
        'sb.Append(Me.Member_SSN)
        sb.Append(Me.Member_Last_Nm & "|")
        sb.Append(Me.Member_First_Nm & "|")
        sb.Append(Me.Member_MI & "|")
        sb.Append(Me.Member_Birth_Dt & "|")
        sb.Append(Me.Address1 & "|")
        sb.Append(Me.Address2 & "|")
        sb.Append(Me.City & "|")
        sb.Append(Me.State & "|")
        sb.Append(Me.Zip & "|")
        sb.Append(Me.Telephone & "|")
        sb.Append(Me.Gender & "|")
        sb.Append(Me.Question_Num & "|")
        sb.Append(Me.Answer_Type & "|")
        sb.Append(Me.Answer_Cd & "|")
        sb.Append(Me.Answer_Value & "|")
        'sb.Append(Me.Answer_Source)
        sb.Append(Me.Pra_Risk_Score & "|")
        sb.Append(Me.Pra_Risk_Percent & "|")
        sb.Append(Me.Frailty_Risk_Score & "|")
        sb.Append(Me.Frailty_Risk_Percent & "|")
        sb.Append(Me.Depression_Risk_Score & "|")
        sb.Append(Me.Depression_Risk_Percent & "|")
        sb.Append(Me.Senior_Health_Report)
        Return sb
    End Function
#End Region
#Region " Private and Protected Methods "
    ''' <summary>Method needed to pad characters to a fixed length string.</summary>
    ''' <param name="strVal"></param>
    ''' <param name="length"></param>
    ''' <param name="padChar"></param>
    ''' <param name="direction"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PadCharString(ByVal strVal As String, ByVal length As Integer, ByVal padChar As Char, ByVal direction As PadDirection) As String
        Dim retVal As String = String.Empty
        If strVal.Length >= length Then
            retVal = strVal.Substring(0, length)
        Else
            Dim charsNeeded As Integer = length - strVal.Length
            Dim padString As String = String.Empty
            For i As Integer = 1 To charsNeeded
                padString += padChar
            Next
            If direction = PadDirection.Left Then
                retVal = strVal & padString
            Else
                'pad Right
                retVal = padString & strVal
            End If
        End If
        Return retVal
    End Function
    ''' <summary>Helper to padd strings for fixed length file creation.</summary>
    ''' <param name="strVal"></param>
    ''' <param name="length"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function charString(ByVal strVal As String, ByVal length As Integer) As String
        Dim retVal As String = strVal
        If retVal Is Nothing Then retVal = ""
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
#End Region

End Class
