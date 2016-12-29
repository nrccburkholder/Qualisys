Imports Nrc.Framework.Data
Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a QualiSys Mailing.  
''' </summary>
Public Class Mailing

#Region " Private Fields "

#Region " Persisted Fields "
    Private mSentMailId As Integer
    Private mLithoCode As String
    Private mStudyId As Integer
    Private mSurveyId As Integer
    Private mPopId As Integer
    Private mMethodologyStepId As Integer
    Private mMethodologyStepName As String
    Private mLanguageId As Integer
    Private mScheduledGenerationDate As Date
    Private mGenerationDate As Date
    Private mPrintDate As Date
    Private mMailDate As Date
    Private mNonDeliveryDate As Date
    Private mReturnDate As Date
    Private mExpirationDate As Date
#End Region

    Private mIsDirty As Boolean
    Private mStudy As Study
#End Region

#Region " Public Properties "

#Region " Persisted Properties "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The QualiSys SendMail_id for this mailing.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' This value will be zero if the a SentMailing record does not exist.
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    Public Property SentMailId() As Integer
        Get
            Return mSentMailId
        End Get
        Friend Set(ByVal value As Integer)
            mSentMailId = value
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The QualiSys Litho code for the mailing.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property LithoCode() As String
        Get
            Return mLithoCode
        End Get
        Friend Set(ByVal value As String)
            If mLithoCode <> value Then
                mLithoCode = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The study ID that this mailing was for
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Friend Set(ByVal value As Integer)
            If mStudyId <> value Then
                mStudyId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The survey ID that this mailing was for
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Friend Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The pop_id of the individual for whom this mailing is intended.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property PopId() As Integer
        Get
            Return mPopId
        End Get
        Friend Set(ByVal value As Integer)
            If mPopId <> value Then
                mPopId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The Methodology Step ID from QualiSys</summary>
    Public Property MethodologyStepId() As Integer
        Get
            Return mMethodologyStepId
        End Get
        Friend Set(ByVal value As Integer)
            If mMethodologyStepId <> value Then
                mMethodologyStepId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The name of the methodology step</summary>
    Public Property MethodologyStepName() As String
        Get
            Return mMethodologyStepName
        End Get
        Friend Set(ByVal value As String)
            If mMethodologyStepName <> value Then
                mMethodologyStepName = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The Language Id for this mailing
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/5/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property LanguageId() As Integer
        Get
            Return mLanguageId
        End Get
        Friend Set(ByVal value As Integer)
            If mLanguageId <> value Then
                mLanguageId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that the mailing is scheduled to be generated.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property ScheduledGenerationDate() As Date
        Get
            Return mScheduledGenerationDate
        End Get
        Friend Set(ByVal value As Date)
            If mScheduledGenerationDate <> value Then
                mScheduledGenerationDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that the mailing was generated.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property GenerationDate() As Date
        Get
            Return mGenerationDate
        End Get
        Friend Set(ByVal value As Date)
            If mGenerationDate <> value Then
                mGenerationDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that the mailing was printed
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property PrintDate() As Date
        Get
            Return mPrintDate
        End Get
        Friend Set(ByVal value As Date)
            If mPrintDate <> value Then
                mPrintDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that the mailing was mailed.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property MailDate() As Date
        Get
            Return mMailDate
        End Get
        Friend Set(ByVal value As Date)
            If mMailDate <> value Then
                mMailDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that this mailing was marked non-deliverable.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property NonDeliveryDate() As Date
        Get
            Return mNonDeliveryDate
        End Get
        Friend Set(ByVal value As Date)
            If mNonDeliveryDate <> value Then
                mNonDeliveryDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that this mailing was returned.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Property ReturnDate() As Date
        Get
            Return mReturnDate
        End Get
        Friend Set(ByVal value As Date)
            If mReturnDate <> value Then
                mReturnDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The date that this mailing was expired.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[AMnatsakanyan]	4/1/2009	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------    
    Public Property ExpirationDate() As Date
        Get
            Return mExpirationDate
        End Get
        Friend Set(ByVal value As Date)
            If mExpirationDate <> value Then
                mExpirationDate = value
                mIsDirty = True
            End If
        End Set
    End Property
#End Region

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been generated.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsGenerated() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mGenerationDate)
        End Get
    End Property
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been printed.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsPrinted() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mPrintDate)
        End Get
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been mailed.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsMailed() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mMailDate)
        End Get
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been expired.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[amnatsakanyan]	4/1/2009	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsExpired() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mExpirationDate) AndAlso ExpirationDate < Now()
        End Get
    End Property
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been marked as non-deliverable
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsNonDeliverable() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mNonDeliveryDate)
        End Get
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns True if this mailing has been returned.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property IsReturned() As Boolean
        Get
            Return Not SafeDataReader.IsNull(mReturnDate)
        End Get
    End Property

    Public ReadOnly Property ReturnLabel() As String
        Get
            If IsNonDeliverable Then
                Return "Non-deliverable on " & mNonDeliveryDate.ToString
            ElseIf IsReturned Then
                Return "Returned on " & mReturnDate.ToString
            Else
                Return ""
            End If
        End Get
    End Property

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' The Study to which this mailing belongs.
    ''' </summary>
    ''' <value></value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public ReadOnly Property Study() As Study
        Get
            If mStudy Is Nothing Then
                mStudy = Nrc.QualiSys.Library.Study.GetStudy(mStudyId)
            End If
            Return mStudy
        End Get
    End Property

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
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
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub New()
    End Sub

#End Region

#Region " DB CRUD Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Retrives a Mailing object from the data store by the litho code
    ''' </summary>
    ''' <param name="litho">The QualiSys litho code of the mailing</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetMailingByLitho(ByVal litho As String) As Mailing
        Return MailingProvider.Instance.SelectByLitho(litho)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Retrives a Mailing object from the data store by the barcode
    ''' </summary>
    ''' <param name="barcode">The barcode of the mailing</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetMailingByBarcode(ByVal barcode As String) As Mailing
        Return MailingProvider.Instance.SelectByBarcode(barcode)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Retrives a Mailing object from the data store by the web access code
    ''' </summary>
    ''' <param name="wac">The Web Access Code for the mailing</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetMailingByWac(ByVal wac As String) As Mailing
        Return MailingProvider.Instance.SelectByWac(wac)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="popId"></param>
    ''' <param name="studyId"></param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/4/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetMailingsByPopId(ByVal popId As Integer, ByVal studyId As Integer) As Collection(Of Mailing)
        Return MailingProvider.Instance.SelectByPopId(popId, studyId)
    End Function
#End Region

#Region " Public Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and also cancels any scheduled mailings.
    ''' </summary>
    ''' <param name="dispositionId">The disposition ID to store for the mailing.</param>
    ''' <param name="receiptTypeId"></param>
    ''' <param name="userName">The name of the user to initiate this action.</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub CancelFutureMailings(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        MailingProvider.Instance.DeleteFutureMailings(Me.mLithoCode, dispositionId, receiptTypeId, userName)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and changes the respondent's address.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub ChangeRespondentAddress(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal address1 As String, ByVal address2 As String, ByVal city As String, ByVal delpt As String, ByVal state As String, ByVal zip5 As String, ByVal zip4 As String, ByVal addrStat As String, ByVal addrErr As String)
        MailingProvider.Instance.ChangeRespondentAddress(Me.mLithoCode, dispositionId, receiptTypeId, userName, address1, address2, city, delpt, CountryCode.UnitedStates, state, "", zip5, zip4, "", addrStat, addrErr)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and changes the respondent's address.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub ChangeRespondentAddress(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal address1 As String, ByVal address2 As String, ByVal city As String, ByVal delpt As String, ByVal province As String, ByVal postalCode As String, ByVal addrStat As String, ByVal addrErr As String)
        MailingProvider.Instance.ChangeRespondentAddress(Me.mLithoCode, dispositionId, receiptTypeId, userName, address1, address2, city, delpt, CountryCode.Canada, "", province, "", "", postalCode, addrStat, addrErr)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and schedules a re-generation.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub RegenerateMailing(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        MailingProvider.Instance.RegenerateMailing(Me.mLithoCode, dispositionId, receiptTypeId, userName, 0)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and schedules a re-generation in a different language
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub RegenerateMailing(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal languageId As Integer)
        MailingProvider.Instance.RegenerateMailing(Me.mLithoCode, dispositionId, receiptTypeId, userName, languageId)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and then adds the respondant to the Study's Take Off Call List
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub TakeOffCallList(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        MailingProvider.Instance.TakeOffCallList(Me.mLithoCode, dispositionId, receiptTypeId, userName)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and then logs that the respondent wished to be contacted.
    ''' </summary>
    ''' <param name="dispositionId"></param>
    ''' <param name="receiptTypeId"></param>
    ''' <param name="userName"></param>
    ''' <param name="emailText"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub LogContactRequest(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String, ByVal emailText As String)
        MailingProvider.Instance.LogContactRequest(Me.mLithoCode, dispositionId, receiptTypeId, userName, emailText)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a collection of languages that are available for this mailing.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function GetAvailableLanguages() As Collection(Of Language)
        Return Language.GetLanguagesAvailableForSurvey(Me.mSurveyId)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Sets the disposition for this mailing and then adds the respondant to the Study's Take Off Call List
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub LogDispositionByLitho(ByVal dispositionId As Integer, ByVal receiptTypeId As Integer, ByVal userName As String)
        MailingProvider.Instance.LogDispositionByLitho(Me.mLithoCode, dispositionId, receiptTypeId, userName)
    End Sub

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub
#End Region

End Class
