Imports Nrc.QualiSys.Library.DataProvider
Imports NRC.Framework.BusinessLogic

''' <summary>
''' Represents a Study in the QualiSys system
''' </summary>
Public Class Study
    Inherits BusinessBase(Of Study)

#Region " Private Members "

#Region " Persisted Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mClientId As Integer
    Private mName As String
    Private mDescription As String
    Private mAccountDirectorEmployeeId As Integer
    Private mdatCreateDate As Date
    Private mbitProperCase As Boolean
    Private mbitAddressClean As Boolean
    Private mIsActive As Boolean

#End Region

    Private mIsDirty As Boolean
    Private mClient As Client
    Private mAccountDirector As Employee
    Private mSurveys As Collection(Of Survey)
    Private mStudyEmployees As STUDY_EMPLOYEECollection
    Private mCopyDataStructureFromStudyID As Integer = -1

#End Region

#Region " Public Properties "

#Region " Persisted Properties "

    ''' <summary>
    ''' The QualiSys Study_id for this study.
    ''' </summary>
    <Logable()> _
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The QualiSys Client_id for this study.
    ''' </summary>
    <Logable()> _
    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal Value As Integer)
            If Not Value = mClientId Then
                mClientId = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The name of this study
    ''' </summary>
    <Logable()> _
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            If Not Value = mName Then
                mName = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The description of this study.
    ''' </summary>
    <Logable()> _
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal Value As String)
            If Not Value = mDescription Then
                mDescription = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' The employee_id of the account director for this study.
    ''' </summary>
    <Logable()> _
    Public Property AccountDirectorEmployeeId() As Integer
        Get
            Return mAccountDirectorEmployeeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mAccountDirectorEmployeeId Then
                mAccountDirectorEmployeeId = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property CreateDate() As Date
        Get
            Return mdatCreateDate
        End Get
        Set(ByVal value As Date)
            If Not value = mdatCreateDate Then
                mdatCreateDate = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property UseAddressCleaning() As Boolean
        Get
            Return mbitAddressClean
        End Get
        Set(ByVal value As Boolean)
            If Not value = mbitAddressClean Then
                mbitAddressClean = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property UseProperCase() As Boolean
        Get
            Return mbitProperCase
        End Get
        Set(ByVal value As Boolean)
            If Not value = mbitProperCase Then
                mbitProperCase = value
                mIsDirty = True
            End If
        End Set
    End Property

    <Logable()> _
    Public Property IsActive() As Boolean
        Get
            Return mIsActive
        End Get
        Set(ByVal value As Boolean)
            If Not value = mIsActive Then
                mIsActive = value
                mIsDirty = True
            End If
        End Set
    End Property

#End Region

    ''' <summary>
    ''' A display label for this study
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mName, mId)
        End Get
    End Property

    ''' <summary>
    ''' Returns True if this object has been modified since it was retrived from the database.
    ''' </summary>
    Public Overrides ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty OrElse mStudyEmployees.IsDirty
        End Get
    End Property

    ''' <summary>
    ''' The Client object associated with this study.
    ''' </summary>
    Public ReadOnly Property Client() As Client
        Get
            If mClient Is Nothing Then
                mClient = Nrc.QualiSys.Library.Client.GetClient(mClientId)
            End If
            Return mClient
        End Get
    End Property

    ''' <summary>
    ''' The Employee object for the account director associated with this study.
    ''' </summary>
    Public ReadOnly Property AccountDirector() As Employee
        Get
            If mAccountDirector Is Nothing Then
                mAccountDirector = Employee.GetEmployee(mAccountDirectorEmployeeId)
            End If
            Return mAccountDirector
        End Get
    End Property

    Public ReadOnly Property Surveys() As Collection(Of Survey)
        Get
            If mSurveys Is Nothing Then
                mSurveys = Survey.GetByStudy(Me)
            End If
            Return mSurveys
        End Get
    End Property

    ''' <summary>
    ''' Returns True if the study can be deleted
    ''' </summary>
    Public ReadOnly Property AllowDelete() As Boolean
        Get
            Return StudyProvider.Instance.AllowDelete(mId)
        End Get
    End Property

    Public Property StudyEmployees() As STUDY_EMPLOYEECollection
        Get
            If mStudyEmployees Is Nothing Then
                mStudyEmployees = STUDY_EMPLOYEEProvider.Instance.SelectSTUDY_EMPLOYEEsBySTUDYId(Id)
            End If

            Return mStudyEmployees
        End Get
        Set(ByVal value As STUDY_EMPLOYEECollection)
            mStudyEmployees = value
        End Set
    End Property

    Public Property CopyDataStructureFromStudyID() As Integer
        Get
            Return mCopyDataStructureFromStudyID
        End Get
        Set(ByVal value As Integer)
            mCopyDataStructureFromStudyID = value
        End Set
    End Property

#End Region

#Region " Constructors "

    ''' <summary>
    ''' Default constructor.
    ''' </summary>
    Public Sub New()

    End Sub

    ''' <summary>
    ''' Constructor to initialize the private instance data for this object.
    ''' </summary>
    ''' <param name="parentClient">The client object to which this study belongs</param>
    Public Sub New(ByVal parentClient As Client)

        Me.New()
        mClient = parentClient

    End Sub

    Public Sub New(ByVal parentClient As Client, ByVal surveys As Collection(Of Survey))

        Me.New(parentClient)
        mSurveys = surveys

    End Sub

#End Region

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Retrieves and populates a study object from the database
    ''' </summary>
    ''' <param name="studyId">The ID of the study to retrieve.</param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[jcamp]	10/12/2005	Created
    ''' </history>
    Public Shared Function GetStudy(ByVal studyId As Integer) As Study

        Return StudyProvider.Instance.[Select](studyId)

    End Function

    ''' <summary>
    ''' Retrieves a collection of study objects that belong to the specified client
    ''' </summary>
    ''' <param name="client">The Client</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetStudiesByClientId(ByVal client As Client) As Collection(Of Study)

        Return StudyProvider.Instance.SelectByClientId(client)

    End Function

    Public Shared Shadows Sub Delete(ByVal studyId As Integer)

        StudyProvider.Instance.Delete(studyId)

    End Sub

    Protected Overrides Sub Insert()

        Id = StudyProvider.Instance.InsertStudy(Me)

        'Log the changes
        LogChanges()

    End Sub

    Protected Overrides Sub Update()

        'Get original object for logging
        Dim original As Study = Study.GetStudy(mId)

        StudyProvider.Instance.UpdateStudy(Me)

        'Log the changes
        LogChanges(original)

    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' Returns a collection of StudyTable objects belonging to this study.
    ''' </summary>
    Public Function GetStudyTables() As Collection(Of StudyTable)

        Return StudyTable.GetAllStudyTables(mId)

    End Function

    Public Function GetStudyDatasets() As Collection(Of StudyDataset)

        Return StudyDatasetProvider.Instance.SelectByStudyId(mId, Nothing, Nothing)

    End Function

    Public Function GetStudyDatasets(ByVal startDate As Date, ByVal endDate As Date) As Collection(Of StudyDataset)

        Return StudyDatasetProvider.Instance.SelectByStudyId(mId, startDate, endDate)

    End Function

    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    Public Function GetSampleEncounterDateFields() As List(Of ListItem(Of CutoffDateField))

        Dim items As New List(Of ListItem(Of CutoffDateField))

        'Not applicable
        Dim item As CutoffDateField = New CutoffDateField(CutoffFieldType.NotApplicable)
        items.Add(New ListItem(Of CutoffDateField)(item.ToString, item))

        'Other date field
        For Each table As StudyTable In GetStudyTables()
            If table.Id = 0 Then Continue For 'Table ID = 0 means a view
            For Each column As StudyTableColumn In table.Columns
                If (column.DataType = StudyTableColumnDataTypes.DateTime AndAlso column.IsUserField) Then
                    item = New Library.CutoffDateField(table, column)
                    items.Add(New ListItem(Of CutoffDateField)(item.ToString, item))
                End If
            Next
        Next

        Return items

    End Function

    Public Function GetCutoffDateFields() As List(Of ListItem(Of CutoffDateField))

        Dim items As New List(Of ListItem(Of CutoffDateField))

        'Sample create date
        Dim item As CutoffDateField = New CutoffDateField(CutoffFieldType.SampleCreate)
        items.Add(New ListItem(Of CutoffDateField)(item.ToString, item))

        'Return date
        item = New CutoffDateField(CutoffFieldType.ReturnDate)
        items.Add(New ListItem(Of CutoffDateField)(item.ToString, item))

        'Other date field
        For Each table As StudyTable In GetStudyTables()
            If table.Id = 0 Then Continue For 'Table ID = 0 means a view
            For Each column As StudyTableColumn In table.Columns
                If (column.DataType = StudyTableColumnDataTypes.DateTime AndAlso column.IsUserField) Then
                    item = New Library.CutoffDateField(table, column)
                    items.Add(New ListItem(Of CutoffDateField)(item.ToString, item))
                End If
            Next
        Next

        Return items

    End Function

    Public Sub Refresh()

        Dim current As Study = Study.GetStudy(Id)

        mAccountDirector = Nothing
        mAccountDirectorEmployeeId = current.mAccountDirectorEmployeeId
        mDescription = current.mDescription
        mId = current.mId
        mName = current.mName
        mbitAddressClean = current.mbitAddressClean
        mbitProperCase = current.mbitProperCase
        mdatCreateDate = current.mdatCreateDate
        mIsActive = current.mIsActive
        'Don't update the survey and client objects because there may be references to existing objects in memory. 
        'mSurveys = current.mSurveys
        'mClient = current.mClient
        'mClientId = current.mClientId
        mIsDirty = False

    End Sub

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
        End If

    End Function

#End Region

#Region " Private Methods "

    Private Sub LogChanges()

        LogChanges(Nothing)

    End Sub

    Private Sub LogChanges(ByVal original As Study)

        Dim changes As New List(Of AuditLogChange)

        'Get the changes for the study object
        changes.AddRange(AuditLog.CompareObjects(Of Study)(original, Me, "Id", AuditLogObject.Study))

        AuditLog.LogChanges(changes)

    End Sub

#End Region

End Class

