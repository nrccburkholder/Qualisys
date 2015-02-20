Imports Nrc.QualiSys.Library.DataProvider
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification

''' <summary>
''' Represents a Qualisys Methodology for collection survey data
''' </summary>
''' <remarks>A methodology is comprised of one or more MethodologyStep objects.
''' MethodologyStep objects are created/updated atomically with the Methodology
''' </remarks>
<DebuggerDisplay("{Name} ({Id})")> _
Public Class Methodology

#Region " Private Members "

    Private mId As Integer
    Private mSurveyId As Integer
    Private mName As String
    Private mStandardMethodologyId As Integer
    Private mIsActive As Boolean
    Private mIsEditable As Boolean
    Private mIsCustomizable As Boolean
    Private mDateCreated As DateTime

    'Child objects
    Private mMethodologySteps As New MethodologyStepCollection
    Private mStandardMethodology As StandardMethodology
    Private mSurvey As Survey

    Private mIsDirty As Boolean
    Private mHasActiveStateChanged As Boolean = False

#End Region

#Region " Public Properties "

    ''' <summary>The unique identifier of the methodology</summary>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>The unique identifier of the survey to which the methodology belongs</summary>
    <Logable()> _
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>The name given to the methodology by the end user</summary>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If mName <> value Then
                mName = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>The unique identifier of the StandardMethodology used to create this one</summary>
    <Logable()> _
    Public Property StandardMethodologyId() As Integer
        Get
            Return mStandardMethodologyId
        End Get
        Set(ByVal value As Integer)
            If mStandardMethodologyId <> value Then
                mStandardMethodologyId = value
                PropertyChanged()
                Dim stdMeth As StandardMethodology = Library.StandardMethodology.Get(value)
                CopyStandardProperties(stdMeth)
            End If
        End Set
    End Property

    ''' <summary>Indicates that the methodology is the currently active 
    ''' methodology for the survey.</summary>
    <Logable()> _
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If mIsActive <> value Then
                mIsActive = value
                mHasActiveStateChanged = True
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>Returns True if the methodology can be edited</summary>
    ''' <remarks>A methodology can only be edited before it has been used to field surveys</remarks>
    Public Property AllowEdit() As Boolean
        Get
            Return mIsEditable
        End Get
        Friend Set(ByVal value As Boolean)
            If mIsEditable <> value Then
                mIsEditable = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>Returns True if the methodology can be deleted</summary>
    ''' <remarks>The same rules apply to determine if a methodolgy can be edited</remarks>
    Public ReadOnly Property AllowDelete() As Boolean
        Get
            Return AllowEdit
        End Get
    End Property

    ''' <summary>The timestamp of when the methodology was created</summary>
    Public Property DateCreated() As DateTime
        Get
            Return mDateCreated
        End Get
        Friend Set(ByVal value As DateTime)
            If mDateCreated <> value Then
                mDateCreated = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>Returns True if the methodology can be customized.</summary>
    ''' <remarks>To ensure standards compliance some methodologies cannot be customized</remarks>
    Public Property IsCustomizable() As Boolean
        Get
            Return mIsCustomizable
        End Get
        Friend Set(ByVal value As Boolean)
            If mIsCustomizable <> value Then
                mIsCustomizable = value
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>The collection of MethodologyStep objects that make up this methodology</summary>
    Public ReadOnly Property MethodologySteps() As MethodologyStepCollection
        Get
            Return mMethodologySteps
        End Get
    End Property

    ''' <summary>
    ''' Returns a reference to the Standard Methodology object that was used to create this Methodology
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>This property is lazy populated</remarks>
    Public Property StandardMethodology() As StandardMethodology
        Get
            If mStandardMethodology Is Nothing Then
                mStandardMethodology = MethodologyProvider.Instance.SelectStandardMethodology(mStandardMethodologyId)
            End If

            Return mStandardMethodology
        End Get
        Set(ByVal value As StandardMethodology)
            If mStandardMethodologyId <> value.Id Then
                mStandardMethodology = value
                mStandardMethodologyId = value.Id
                CopyStandardProperties(value)
                PropertyChanged()
            End If
        End Set
    End Property

    ''' <summary>Returns True if the object has been changed since retrieved from the data store</summary>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            'Check if this or the child collection is dirty
            Return (mIsDirty OrElse mHasActiveStateChanged OrElse mMethodologySteps.IsDirty)
        End Get
    End Property

    ''' <summary>Returns True if the object has not yet been persisted to the data store.</summary>
    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (mId = 0)
        End Get
    End Property

    ''' <summary>
    ''' The Survey object associated with this methodology
    ''' </summary>
    Public ReadOnly Property Survey() As Survey
        Get
            If mSurvey Is Nothing Then
                mSurvey = Nrc.QualiSys.Library.Survey.Get(mSurveyId)
            End If

            Return mSurvey
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

    Public Sub New(ByVal standardMethodologyId As Integer)

        mStandardMethodologyId = standardMethodologyId

    End Sub

#End Region

#Region " Base Class Overrides "

    Public Overrides Function ToString() As String

        Return Name

    End Function

#End Region

#Region " Public Methods "

#Region "DB CRUD Methods "

    ''' <summary>
    ''' Returns a specific Methodology object from the data store
    ''' </summary>
    ''' <param name="methodologyId">The unique identifier of the Methodology to retrieve</param>
    Public Shared Function [Get](ByVal methodologyId As Integer) As Methodology

        Return MethodologyProvider.Instance.Select(methodologyId)

    End Function

    ''' <summary>
    ''' Retrieves all the methodologies for the survey specified
    ''' </summary>
    ''' <param name="surveyId">The unique identifier of the survey</param>
    ''' <returns>Returns a collection of Methodology objects</returns>
    Public Shared Function GetBySurveyId(ByVal surveyId As Integer) As Collection(Of Methodology)

        Return MethodologyProvider.Instance.SelectBySurveyId(surveyId)

    End Function

    ''' <summary>
    ''' Creates a new unpersisted Methodology instance based on the specified StandardMethodology
    ''' </summary>
    ''' <param name="surveyId">The unique identifier of the survey that this Methodology will belong to</param>
    ''' <param name="name">The name of the methodology</param>
    ''' <param name="standardMeth">The Standard Methodology that this Methodology conforms to</param>
    ''' <returns>Returns a new unsaved Methodology object</returns>
    ''' <remarks></remarks>
    Public Shared Function CreateFromStandard(ByVal surveyId As Integer, ByVal name As String, ByVal standardMeth As StandardMethodology) As Methodology

        If standardMeth Is Nothing Then
            Throw New NullReferenceException("standardMeth")
        End If

        Dim meth As New Methodology
        meth.mSurveyId = surveyId
        meth.mName = name
        meth.mIsEditable = True
        meth.mDateCreated = DateTime.Now
        meth.StandardMethodologyId = standardMeth.Id
        meth.CopyStandardProperties(standardMeth)

        Return meth

    End Function

    ''' <summary>
    ''' Saves the Methodology to the data store.
    ''' </summary>
    ''' <remarks>If the Methodology is "New" it will insert a new Methodology.  If 
    ''' the Methodology has already been inserted it will just be updated</remarks>
    Public Sub Update()

        Dim needsActiveStateSave As Boolean = mHasActiveStateChanged

        'If it is editable then do a normal save
        If mIsEditable Then
            'Flag the first survey
            IdentifyFirstSurvey()

            'Validate that the object is in a safe state
            Validate()

            'If this is a new (unsaved) methodology then we need to perform an insert
            If IsNew Then
                mId = MethodologyProvider.Instance.Insert(Me)

                'Log the changes
                LogChanges()

                'Send methodology change notification for those modified with non-mail steps
                If HasNonMailStep(Me) Then SendChangeNotification()
            Else
                'If this is an updated methodology that already exists in data store then update
                If IsDirty Then
                    'Get original object for logging
                    Dim original As Methodology = Methodology.Get(mId)

                    'Update
                    MethodologyProvider.Instance.Update(Me)

                    'Log the changes
                    LogChanges(original)

                    'Send methodology change notification for those modified with non-mail steps
                    'The original check is to handle non-mail steps the have been removed
                    If HasNonMailStep(Me) OrElse HasNonMailStep(original) Then SendChangeNotification()
                End If
            End If
        End If

        'If it has changed active/inactive then save that
        If needsActiveStateSave Then
            SaveActiveState()
        End If

        'Refresh the object to ensure consistancy
        Refresh()

    End Sub

    Public Sub UpdateVendor()

        'Update
        MethodologyProvider.Instance.UpdateVendor(Me)

    End Sub

    ''' <summary>
    ''' Deletes a Methodology from the data store
    ''' </summary>
    ''' <param name="methodologyId">The unique identifier of the Methodology to delete</param>
    ''' <remarks></remarks>
    Public Shared Sub Delete(ByVal methodologyId As Integer)

        MethodologyProvider.Instance.Delete(methodologyId)

    End Sub

#End Region

    ''' <summary>
    ''' Adds a new MethodologyStep to this Methodology based on the MethodologyStepType specified
    ''' </summary>
    ''' <param name="stepType">The MethodologyStepType to use as a template for the new step</param>
    ''' <returns>Returns a reference to the newly created MethodologyStep</returns>
    ''' <remarks></remarks>
    Public Function AddNewMethodologyStep(ByVal stepType As MethodologyStepType) As MethodologyStep

        If Not mIsCustomizable Then
            Throw New InvalidOperationException("You cannot add methodolgy steps to a methodology that is not customizable.")
        End If

        If stepType Is Nothing Then
            Throw New NullReferenceException("stepType")
        End If

        'Create the new step instance
        Dim methStep As New MethodologyStep
        methStep.CopyStepTypeProperties(stepType)

        'Add it to the collection
        mMethodologySteps.Add(methStep)

        'Flag the first survey
        IdentifyFirstSurvey()

        Return methStep

    End Function

    ''' <summary>
    ''' Marks the object not dirty
    ''' </summary>
    ''' <remarks></remarks>
    Public Sub ResetDirtyFlag()

        mIsDirty = False
        mHasActiveStateChanged = False

    End Sub

    ''' <summary>
    ''' Repopulates the object from the data store.  A new collection of MethodologyStep objects will be created.
    ''' </summary>
    ''' <remarks>The user should understand that existing references to the MethodologySteps will need to be updated</remarks>
    Public Sub Refresh()

        If IsNew Then
            Throw New InvalidOperationException("Cannot refresh a Methodology that has not yet been saved.")
        End If

        Dim freshMeth As Methodology = Methodology.Get(mId)

        mIsActive = freshMeth.mIsActive
        mIsCustomizable = freshMeth.mIsCustomizable
        mIsEditable = freshMeth.mIsEditable
        mName = freshMeth.mName
        mStandardMethodologyId = freshMeth.mStandardMethodologyId
        mStandardMethodology = Nothing
        mSurveyId = freshMeth.mSurveyId
        mDateCreated = freshMeth.mDateCreated
        mHasActiveStateChanged = False
        mSurveyId = freshMeth.mSurveyId

        mMethodologySteps = freshMeth.mMethodologySteps

        ResetDirtyFlag()

    End Sub

    ''' <summary>
    ''' Repopulates the methodology steps from the data store.  A new collection of MethodologyStep objects will be created.
    ''' </summary>
    ''' <remarks>The user should understand that existing references to the MethodologySteps will need to be updated</remarks>
    Public Sub RefreshSteps()

        If IsNew Then
            If IsCustomizable Then
                mMethodologySteps.Clear()
            Else
                Dim stdMeth As StandardMethodology = Library.StandardMethodology.Get(mStandardMethodologyId)
                CopyStandardProperties(stdMeth)
            End If
        Else
            Dim freshMeth As Methodology = Methodology.Get(mId)
            mMethodologySteps = freshMeth.mMethodologySteps
        End If
        mMethodologySteps.ResetDirtyFlag()

    End Sub

    ''' <summary>
    ''' Resets the methodology type to the first customizable type for the specified survey type without changing the currently configured steps.
    ''' </summary>
    ''' <remarks>The user should understand that existing references to the MethodologySteps will remain unchanged</remarks>
    Public Sub ResetMethodologyTypeToCustom(ByVal surveyType As Nrc.QualiSys.Library.SurveyTypes, ByVal subTypes As SubTypeList)

        'Get a the available types
        Dim stdMeths As Collection(Of StandardMethodology) = Library.StandardMethodology.GetBySurveyType(surveyType, subTypes)

        'Find the first custom type
        Dim customMeth As StandardMethodology = Nothing
        For Each stdMeth As StandardMethodology In stdMeths
            If stdMeth.IsCustomizable Then
                customMeth = stdMeth
                Exit For
            End If
        Next

        'Set the new methodology type
        If customMeth IsNot Nothing Then
            'A customizable type was found so us it
            mStandardMethodology = customMeth
            mStandardMethodologyId = customMeth.Id
            PropertyChanged()
        End If

    End Sub

#End Region

#Region " Private Methods "

    ''' <summary>
    ''' Sets this Methodology as the currently active Methodology for the survey.  All other methodologies are set to inactive.
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub SaveActiveState()

        MethodologyProvider.Instance.UpdateActiveState(mId, mIsActive)

    End Sub

    Private Sub CopyStandardProperties(ByVal standardMeth As StandardMethodology)

        mIsCustomizable = standardMeth.IsCustomizable
        mMethodologySteps = standardMeth.GetMethodologySteps
        mIsDirty = True

    End Sub

    ''' <summary>
    ''' Is fired when a property changes
    ''' </summary>
    Private Sub PropertyChanged()

        mIsDirty = True

    End Sub

    ''' <summary>
    ''' Sets the sequence number to be the order in which the steps appear in 
    ''' the collection and also sets which is the first survey
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub IdentifyFirstSurvey()

        Dim firstSurvey As Boolean = True

        For Each methStep As MethodologyStep In MethodologySteps
            methStep.MethodologyId = mId
            methStep.SurveyId = mSurveyId

            'Flag the first survey
            If methStep.IsSurvey AndAlso firstSurvey Then
                methStep.IsFirstSurvey = True
                firstSurvey = False
            Else
                methStep.IsFirstSurvey = False
            End If
        Next

    End Sub

    ''' <summary>
    ''' Throws an exception if the object is found to be in a unsafe state
    ''' </summary>
    Private Sub Validate()

        For Each methStep As MethodologyStep In mMethodologySteps
            'All steps must at least be linked to themselves
            If methStep.LinkedStep Is Nothing Then
                Throw New NullReferenceException("The LinkedStep property of each MethodologyStep must be set to a MethodologyStep instance.")
            End If

            'All steps must at least expire from themselves
            If methStep.ExpireFromStep Is Nothing Then
                Throw New NullReferenceException("The ExpireFromStep property of each MethodologyStep must be set to a MethodologyStep instance.")
            End If

            'Cannot be linked to a later step
            If methStep.LinkedStep.SequenceNumber > methStep.SequenceNumber Then
                Throw New InvalidMethodologyException("A methodology step cannot be linked to a subsequent step.")
            End If

            'Cannot expire from a later step
            If methStep.ExpireFromStep.SequenceNumber > methStep.SequenceNumber Then
                Throw New InvalidMethodologyException("A methodology step cannot be set to expire from a subsequent step.")
            End If
        Next

    End Sub

    Private Sub LogChanges()

        LogChanges(Nothing)

    End Sub

    Private Sub LogChanges(ByVal original As Methodology)

        Dim changes As New List(Of AuditLogChange)

        'Get the changes for the methodology object
        changes.AddRange(AuditLog.CompareObjects(Of Methodology)(original, Me, "Id", AuditLogObject.Methodology))

        'When updating, we delete all methodology steps and re-add new ones to replace them
        'If this is an update then get the changes for the deleted methodology steps
        If original IsNot Nothing Then
            For Each methStep As MethodologyStep In original.MethodologySteps
                changes.AddRange(AuditLog.CompareObjects(Of MethodologyStep)(methStep, Nothing, "Id", AuditLogObject.MethodologyStep))
                'Log changes for the email blast records
                For Each emailBlast As EmailBlast In methStep.EmailBlastList
                    changes.AddRange(AuditLog.CompareObjects(Of EmailBlast)(emailBlast, Nothing, "Id", AuditLogObject.EmailBlast))
                Next
            Next
        End If

        'Get the changes for all the methodology steps that are newly created
        For Each methStep As MethodologyStep In mMethodologySteps
            changes.AddRange(AuditLog.CompareObjects(Of MethodologyStep)(Nothing, methStep, "Id", AuditLogObject.MethodologyStep))
            'Get the changes for all the email blast records that are newly created
            For Each emailBlast As EmailBlast In methStep.EmailBlastList
                changes.AddRange(AuditLog.CompareObjects(Of EmailBlast)(Nothing, emailBlast, "Id", AuditLogObject.EmailBlast))
            Next
        Next

        AuditLog.LogChanges(changes)

    End Sub

    Private Function HasNonMailStep(ByVal meth As Methodology) As Boolean

        For Each methStep As MethodologyStep In meth.MethodologySteps
            Select Case methStep.StepMethodId
                Case MailingStepMethodCodes.Phone, MailingStepMethodCodes.Web, MailingStepMethodCodes.MailWeb, MailingStepMethodCodes.LetterWeb, MailingStepMethodCodes.IVR
                    Return True
            End Select
        Next

        Return False

    End Function

    Private Sub SendChangeNotification()

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim environmentName As String = String.Empty

        'Add toList group
        toList.Add("nonmailgen@nationalresearch.com")

        'Add ccList individual
        Dim myEmployee As Employee = Employee.GetEmployee(Survey.Study.AccountDirectorEmployeeId)
        If myEmployee.Email.Trim <> String.Empty Then ccList.Add(myEmployee.Email)

        'Determine recipients bases on the environment
        If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
            'We are not in production
            'Clear the lists
            toList.Clear()
            ccList.Clear()
            bccList.Clear()

            'Populate the toList with the Testing group only
            toList.Add("Testing@NRCPicker.com")

            'Set the environment string
            environmentName = String.Format("({0})", AppConfig.EnvironmentName)
        End If

        'Create the message object
        Dim msg As Message = New Message("MethodologyChangeNotice", AppConfig.SMTPServer)

        'Set the message properties
        With msg
            'To recipient
            For Each email As String In toList
                .To.Add(email)
            Next

            'Cc recipient
            For Each email As String In ccList
                .Cc.Add(email)
            Next

            'Bcc recipient
            For Each email As String In bccList
                .Bcc.Add(email)
            Next

            'Add the replacement values
            With .ReplacementValues
                .Add("Environment", environmentName)
                .Add("Client", Survey.Study.Client.Name)
                .Add("ClientID", Survey.Study.Client.Id.ToString)
                .Add("Study", Survey.Study.Name)
                .Add("StudyID", Survey.Study.Id.ToString)
                .Add("Survey", Survey.Name)
                .Add("SurveyID", SurveyId.ToString)
                .Add("Methodology", Name)
                If IsActive Then
                    .Add("MethStatus", "Active")
                Else
                    .Add("MethStatus", "Not Active")
                End If
                .Add("ReportLink", String.Empty)
            End With

            'Merge the template
            .MergeTemplate()

            'Send the message
            Try
                .Send()

            Catch ex As Exception
                MsgBox("Unable to send Methodology Change email.  Please notify eDD Team that this methodology has changed.", MsgBoxStyle.OkOnly Or MsgBoxStyle.Critical, "Error Sending Email")

            End Try
        End With

    End Sub

#End Region

End Class
