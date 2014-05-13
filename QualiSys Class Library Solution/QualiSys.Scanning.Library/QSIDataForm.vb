Imports NRC.Framework.BusinessLogic

Public Interface IQSIDataForm

    Property FormId() As Integer
    Property TemplateName() As String

End Interface

<Serializable()> _
Public Class QSIDataForm
	Inherits BusinessBase(Of QSIDataForm)
	Implements IQSIDataForm

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mFormId As Integer
    Private mBatchId As Integer
    Private mLithoCode As String = String.Empty
    Private mSentMailId As Integer
    Private mQuestionFormId As Integer
    Private mSurveyId As Integer
    Private mTemplateCode As String = String.Empty
    Private mLangID As Integer
    Private mTemplateName As String = String.Empty
    Private mDateKeyed As Date
    Private mKeyedBy As String = String.Empty
    Private mDateVerified As Date
    Private mVerifiedBy As String = String.Empty

    Private mResults As QSIDataResultCollection
    Private mQuestions As Collection(Of QSIDataFormQuestion)

#End Region

#Region " Public Properties "

    Public Property FormId() As Integer Implements IQSIDataForm.FormId
        Get
            Return mFormId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mFormId Then
                mFormId = value
                PropertyHasChanged("FormId")
            End If
        End Set
    End Property

    Public Property TemplateName() As String Implements IQSIDataForm.TemplateName
        Get
            Return mTemplateName
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTemplateName Then
                mTemplateName = value
                PropertyHasChanged("TemplateName")
            End If
        End Set
    End Property

    Public Property BatchId() As Integer
        Get
            Return mBatchId
        End Get
        Set(ByVal value As Integer)
            If Not value = mBatchId Then
                mBatchId = value
                PropertyHasChanged("BatchId")
            End If
        End Set
    End Property

    Public Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLithoCode Then
                mLithoCode = value
                PropertyHasChanged("LithoCode")
            End If
        End Set
    End Property

    Public Property SentMailId() As Integer
        Get
            Return mSentMailId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSentMailId Then
                mSentMailId = value
                PropertyHasChanged("SentMailId")
            End If
        End Set
    End Property

    Public Property QuestionFormId() As Integer
        Get
            Return mQuestionFormId
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuestionFormId Then
                mQuestionFormId = value
                PropertyHasChanged("QuestionFormId")
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyId Then
                mSurveyId = value
                PropertyHasChanged("SurveyId")
            End If
        End Set
    End Property

    Public Property TemplateCode() As String
        Get
            Return mTemplateCode
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTemplateCode Then
                mTemplateCode = value
                PropertyHasChanged("TemplateCode")
            End If
        End Set
    End Property

    Public Property LangID() As Integer
        Get
            Return mLangID
        End Get
        Set(ByVal value As Integer)
            If Not value = mLangID Then
                mLangID = value
                PropertyHasChanged("LangID")
            End If
        End Set
    End Property

    Public Property DateKeyed() As Date
        Get
            Return mDateKeyed
        End Get
        Set(ByVal value As Date)
            If Not value = mDateKeyed Then
                mDateKeyed = value
                PropertyHasChanged("DateKeyed")
            End If
        End Set
    End Property

    Public Property KeyedBy() As String
        Get
            Return mKeyedBy
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mKeyedBy Then
                mKeyedBy = value
                PropertyHasChanged("KeyedBy")
            End If
        End Set
    End Property

    Public Property DateVerified() As Date
        Get
            Return mDateVerified
        End Get
        Set(ByVal value As Date)
            If Not value = mDateVerified Then
                mDateVerified = value
                PropertyHasChanged("DateVerified")
            End If
        End Set
    End Property

    Public Property VerifiedBy() As String
        Get
            Return mVerifiedBy
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mVerifiedBy Then
                mVerifiedBy = value
                PropertyHasChanged("VerifiedBy")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property Results() As QSIDataResultCollection
        Get
            If mResults Is Nothing Then
                mResults = QSIDataResult.GetByFormId(mFormId)
            End If

            Return mResults
        End Get
    End Property

    Public ReadOnly Property Questions() As Collection(Of QSIDataFormQuestion)
        Get
            If mQuestions Is Nothing Then
                mQuestions = QSIDataFormProvider.Instance.SelectQSIDataFormQuestions(QuestionFormId, SurveyId, LangID)
            End If

            Return mQuestions
        End Get
    End Property

    Public ReadOnly Property Barcode() As String
        Get
            Return Litho.LithoToBarcode(CInt(mLithoCode), True, 1)
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewQSIDataForm() As QSIDataForm

        Return New QSIDataForm

    End Function

    Public Shared Function [Get](ByVal formId As Integer) As QSIDataForm

        Return QSIDataFormProvider.Instance.SelectQSIDataForm(formId)

    End Function

    Public Shared Function GetByBatchId(ByVal batchId As Integer) As QSIDataFormCollection

        Return QSIDataFormProvider.Instance.SelectQSIDataFormsByBatchId(batchId)

    End Function

    Public Shared Function GetByTemplateName(ByVal batchId As Integer, ByVal templateName As String, ByVal dataEntryMode As DataEntryModes) As QSIDataFormCollection

        Return QSIDataFormProvider.Instance.SelectQSIDataFormsByTemplateName(batchId, templateName, dataEntryMode)

    End Function

    Public Shared Function ValidateLithoCode(ByVal lithoCode As String) As String

        Return QSIDataFormProvider.Instance.ValidateLithoCode(lithoCode)

    End Function

    Public Shared Function Create(ByVal batchId As Integer, ByVal lithoCode As String) As QSIDataForm

        Return QSIDataFormProvider.Instance.CreateQSIDataForm(batchId, lithoCode)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mFormId
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        'Create the new form
        FormId = QSIDataFormProvider.Instance.InsertQSIDataForm(Me)

        'Get the TemplateName
        Dim form As QSIDataForm = QSIDataForm.Get(FormId)
        TemplateName = form.TemplateName

    End Sub

    Protected Overrides Sub Update()

        QSIDataFormProvider.Instance.UpdateQSIDataForm(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        QSIDataFormProvider.Instance.DeleteQSIDataForm(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub DeleteResults()

        QSIDataResult.DeleteByFormId(mFormId)
        mResults = QSIDataResult.GetByFormId(mFormId)

    End Sub

    Public Sub DeleteResultsByQstnCore(ByVal qstnCore As Integer)

        QSIDataResult.DeleteByQstnCore(mFormId, qstnCore)
        mResults = QSIDataResult.GetByFormId(mFormId)

    End Sub

    Public Function FinalizeForm() As String

        Dim length As Integer
        Dim location As Integer
        Dim strLine As String = String.Empty
        Dim strResult As String = String.Empty

        'Get the string length
        For Each question As QSIDataFormQuestion In Questions
            location = question.BeginColumn + question.ResponseWidth - 1
            If length < location Then
                length = location
            End If
        Next

        'Add the date and barcode
        strLine = String.Format("{0}{1}", Date.Now.ToString("yyyyMMdd"), Barcode)

        'Make the string the total length required
        strLine = strLine.PadRight(length, " "c)

        'Loop through all of the questions and add the responses to the line
        For Each question As QSIDataFormQuestion In Questions
            'Get the responses for this question
            strResult = Results.STRResult(question.QstnCore, question.ResponseWidth, question.ReadMethodId)

            'Place the response into the string
            strLine = strLine.Substring(0, question.BeginColumn - 1) & strResult & strLine.Substring(question.BeginColumn + question.ResponseWidth - 1)
        Next

        'Return the STR file line
        Return strLine

    End Function

#End Region

End Class


