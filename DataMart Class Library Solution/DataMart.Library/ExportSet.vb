''' <summary>
''' The ExportSet class defines a set of data records to be exported from the DataMart.
''' </summary>
''' <remarks></remarks>
Public Class ExportSet

#Region " Private Fields "

    Private mId As Integer
    Private mName As String
    Private mExportSetType As ExportSetType
    Private mSurveyId As Integer
    Private mSampleUnitId As Integer
    Private mStartDate As Date
    Private mEndDate As Date
    Private mReportDateField As String
    Private mCreatedDate As Date
    Private mCreatedEmployeeName As String

    Private mIsDirty As Boolean

#End Region

#Region " Public Properties "

    ''' <summary>The Id of the export set</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The name of the export set</summary>
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

    Public Property ExportSetType() As ExportSetType
        Get
            Return mExportSetType
        End Get
        Friend Set(ByVal value As ExportSetType)
            mExportSetType = value
        End Set
    End Property

    ''' <summary>The survey Id that the export set belongs to</summary>
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal Value As Integer)
            If Not Value = mSurveyId Then
                mSurveyId = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The sample unit Id that the export set belongs to</summary>
    Public Property SampleUnitId() As Integer
        Get
            Return mSampleUnitId
        End Get
        Set(ByVal value As Integer)
            If Not value = mSampleUnitId Then
                mSampleUnitId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The starting date of the records included in the export</summary>
    Public Property StartDate() As Date
        Get
            Return mStartDate
        End Get
        Set(ByVal Value As Date)
            If Not Value = mStartDate Then
                mStartDate = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The ending date of the records included in the export</summary>
    Public Property EndDate() As Date
        Get
            Return mEndDate
        End Get
        Set(ByVal Value As Date)
            If Not Value = mEndDate Then
                mEndDate = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The name of the field that was used for reporting when this export was created</summary>
    Public Property ReportDateField() As String
        Get
            Return mReportDateField
        End Get
        Set(ByVal value As String)
            If Not value = mReportDateField Then
                mReportDateField = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The date that this export was created</summary>
    Public Property CreatedDate() As Date
        Get
            Return mCreatedDate
        End Get
        Friend Set(ByVal Value As Date)
            If Not Value = mCreatedDate Then
                mCreatedDate = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>The name of the employee who created the export set</summary>
    Public Property CreatedEmployeeName() As String
        Get
            Return mCreatedEmployeeName
        End Get
        Friend Set(ByVal Value As String)
            If Not Value = mCreatedEmployeeName Then
                mCreatedEmployeeName = Value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>Returns True if the object has been updated since it was retrieved from the data store</summary>
    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property

#End Region

#Region " Constructors "

    ''' <summary>Initializes an instance of the ExportSet class</summary>
    Public Sub New()

    End Sub

#End Region

#Region " DB CRUD Methods "

    ''' <summary>
    ''' Returns an ExportSet object for the ID specified
    ''' </summary>
    ''' <param name="exportSetId">The ID of the ExportSet object to return</param>
    Public Shared Function GetExportSet(ByVal exportSetId As Integer) As ExportSet

        Return DataProvider.Instance.SelectExportSet(exportSetId)

    End Function

    ''' <summary>
    ''' Creates a new ExportSet object and adds it to the data store
    ''' </summary>
    ''' <param name="name">The name of the export set</param>
    ''' <param name="surveyId">The ID of the survey to which the export set belongs</param>
    ''' <param name="startDate">The starting date of records in the export</param>
    ''' <param name="endDate">The ending date of records in the export</param>
    ''' <param name="exportType">Specifies the type of export set to create</param>
    ''' <param name="createdEmployeeName">The name of the user creating the export</param>
    ''' <returns>Returns the newly created ExportSet object</returns>
    Public Shared Function CreateNewExportSet(ByVal name As String, ByVal surveyId As Integer, ByVal startDate As Date, ByVal endDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As ExportSet

        Return CreateNewExportSet(name, surveyId, 0, startDate, endDate, exportType, createdEmployeeName)

    End Function

    ''' <summary>
    ''' Creates a new ExportSet object and adds it to the data store
    ''' </summary>
    ''' <param name="name">The name of the export set</param>
    ''' <param name="surveyId">The ID of the survey to which the export set belongs</param>
    ''' <param name="sampleUnitId">The ID of the sample unit to which the export set belongs</param>
    ''' <param name="startDate">The starting date of records in the export</param>
    ''' <param name="endDate">The ending date of records in the export</param>
    ''' <param name="exportType">Specifies the type of export set to create</param>
    ''' <param name="createdEmployeeName">The name of the user creating the export</param>
    ''' <returns>Returns the newly created ExportSet object</returns>
    Public Shared Function CreateNewExportSet(ByVal name As String, ByVal surveyId As Integer, ByVal sampleUnitId As Integer, ByVal startDate As Date, ByVal endDate As Date, ByVal exportType As ExportSetType, ByVal createdEmployeeName As String) As ExportSet

        Dim newId As Integer = DataProvider.Instance.InsertExportSet(name, surveyId, sampleUnitId, startDate, endDate, exportType, createdEmployeeName)
        Return DataProvider.Instance.SelectExportSet(newId)

    End Function

    ''' <summary>
    ''' Deletes an ExportSet object from the data store
    ''' </summary>
    ''' <param name="deletionEmployeeName">The name of the user deleting the export</param>
    Public Function Delete(ByVal deletionEmployeeName As String, ByRef errorMessage As String) As Boolean

        Return DataProvider.Instance.DeleteExportSet(mId, deletionEmployeeName, errorMessage)

    End Function

#End Region

#Region " Public Methods "

    ''' <summary>Marks the object as being up-to-date with the data store</summary>
    Public Sub ResetDirtyFlag()

        mIsDirty = False

    End Sub

    ''' <summary>
    ''' Returns a collection of ExportSets that have been created for any of the supplied 
    ''' client IDs, study IDs or survey IDs 
    ''' </summary>
    ''' <param name="clients">The collection of clients</param>
    ''' <param name="studies">The collection of studies</param>
    ''' <param name="surveys">The collection of surveys</param>
    ''' <returns>Returns a collection of ExportSet objects</returns>
    Public Shared Function GetExportSets(ByVal clients As Collection(Of Client), ByVal studies As Collection(Of Study), ByVal surveys As Collection(Of Survey), ByVal units As Collection(Of SampleUnit), ByVal exportType As ExportSetType) As Collection(Of ExportSet)

        Return GetExportSets(clients, studies, surveys, units, Nothing, Nothing, exportType)

    End Function

    ''' <summary>
    ''' Returns a collection of ExportSets that have been created for any of the supplied 
    ''' client IDs, study IDs or survey IDs during the time frame specified
    ''' </summary>
    ''' <param name="clients">The collection of clients</param>
    ''' <param name="studies">The collection of studies</param>
    ''' <param name="surveys">The collection of surveys</param>
    ''' <param name="creationFilterStartDate">The starting date used to filter the results</param>
    ''' <param name="creationFilterEndDate">The ending date used to filter the results</param>
    ''' <returns>Returns a collection of ExportSet objects that meet the specified criteria</returns>
    Public Shared Function GetExportSets(ByVal clients As Collection(Of Client), ByVal studies As Collection(Of Study), ByVal surveys As Collection(Of Survey), ByVal units As Collection(Of SampleUnit), ByVal creationFilterStartDate As Nullable(Of Date), ByVal creationFilterEndDate As Nullable(Of Date), ByVal exportType As ExportSetType) As Collection(Of ExportSet)

        Dim exportIds As New List(Of Integer)
        Dim masterList As New Collection(Of ExportSet)
        Dim exportList As Collection(Of ExportSet)

        'Get the exports for each client
        For Each clnt As Client In clients
            exportList = clnt.GetExportSets(creationFilterStartDate, creationFilterEndDate, exportType)
            UnionExportList(masterList, exportIds, exportList)
        Next

        'Get the exports for each study
        For Each stdy As Study In studies
            exportList = stdy.GetExportSets(creationFilterStartDate, creationFilterEndDate, exportType)
            UnionExportList(masterList, exportIds, exportList)
        Next

        'Get the exports for each survey
        For Each srvy As Survey In surveys
            exportList = srvy.GetExportSets(creationFilterStartDate, creationFilterEndDate, exportType)
            UnionExportList(masterList, exportIds, exportList)
        Next

        'Get the exports for each unit
        For Each unit As SampleUnit In units
            exportList = unit.GetExportSets(creationFilterStartDate, creationFilterEndDate, exportType)
            UnionExportList(masterList, exportIds, exportList)
        Next

        'Return the complete list of export sets
        Return masterList

    End Function

    ''' <summary>
    ''' Rebuilds the members of the export set using the originally defined start and end date but 
    ''' including all records that are eligible at the current time.
    ''' </summary>
    ''' <remarks>This is used to "refresh" an export set so that new records that were not previously included can now be included</remarks>
    Public Sub RebuildExportSet()

        DataProvider.Instance.RebuildExportSet(mId)

    End Sub

    ''' <summary>
    ''' Returns a collection of ExportFile objects that have been created from the ExportSet
    ''' </summary>
    Public Function GetExportFiles() As Collection(Of ExportFile)

        Return DataProvider.Instance.SelectExportFilesByExportSetId(mId)

    End Function

    Public Shared Function AllowCombinedExport(ByVal exports As Collection(Of ExportSet), ByRef errorMessage As String) As Boolean

        If exports Is Nothing OrElse exports.Count = 0 Then
            Throw New ArgumentException("The collection of ExportSets must contain at least one ExportSet object.")
        End If

        Dim type As ExportSetType = exports(0).ExportSetType

        'If these are CMS exports then verify that all are for sample units with the same medicare number
        If type = Library.ExportSetType.CmsHcahps OrElse type = Library.ExportSetType.CmsChart Then
            Dim medicareNumber As String = String.Empty
            Dim isFirst As Boolean = True
            Dim startDate As Date
            Dim endDate As Date

            'Check each export being combined
            For Each export As ExportSet In exports
                If isFirst Then
                    startDate = export.StartDate
                    endDate = export.EndDate
                Else
                    If startDate <> export.StartDate OrElse endDate <> export.EndDate Then
                        errorMessage = "You cannot combine export definitions for HCAHPS units for different encounter months."
                        Return False
                    End If
                End If

                'Get the sampleunit object
                Dim su As SampleUnit = SampleUnit.Get(export.SampleUnitId)

                If su Is Nothing Then Throw New NullReferenceException("Unable to load SampleUnit object for the ExportSet.")

                'Store the medicare number from the first one
                If isFirst Then
                    medicareNumber = su.MedicareNumber
                    isFirst = False
                Else
                    'If subsequent sample units do not match medicare number then return false
                    If medicareNumber <> su.MedicareNumber Then
                        errorMessage = "You cannot combine export definitions for HCAHPS units with different medicare numbers."
                        Return False
                    End If
                End If
            Next

            'checking that all units with the same medicare id has been selected
            Dim allUnits As Collection(Of SampleUnit) = SampleUnit.GetByMedicareNumber(medicareNumber)

            'Create a collection that contains all HCAHPS units for the medicareNumber
            Dim allHcahpsUnits As New Collection(Of SampleUnit)
            For Each unit As SampleUnit In allUnits
                If unit.IsHcahps Then allHcahpsUnits.Add(unit)
            Next

            'Delete units from the all HCAHPS units collection that are selected units
            For i As Integer = allHcahpsUnits.Count - 1 To 0 Step -1
                For Each selectedExport As ExportSet In exports
                    If allHcahpsUnits(i).Id = selectedExport.SampleUnitId Then
                        allHcahpsUnits.RemoveAt(i)
                        Exit For
                    End If
                Next
            Next

            'If any units remain in the all HCAHPS units collection, then we want to let the user 
            'know that they didn't pick all of the units for the medicare number.
            For Each unit As SampleUnit In allHcahpsUnits
                If String.IsNullOrEmpty(errorMessage) Then errorMessage = String.Format(" The medicare number '{0}' assigned to the selected units is also assigned to HCAHPS units. ", medicareNumber)

                Dim unitSurvey As Survey = Survey.GetSurvey(unit.SurveyId)
                If unitSurvey Is Nothing Then Throw New NullReferenceException(String.Format("Unable to load SurveyID {0} while checking HCAHPS units for Medicare Number {1}.{2}{2}Please ensure that the Methodology is setup for this survey in QualiSys.", unit.SurveyId, medicareNumber, vbCrLf))

                Dim unitStudy As Study = unitSurvey.Study
                Dim unitClient As Client = unitStudy.Client

                errorMessage &= String.Format("{0}Client:{1} Study:{2} Survey:{3} Unit:{4}", vbCrLf, unitClient.DisplayLabel, unitStudy.DisplayLabel, unitSurvey.DisplayLabel, unit.DisplayLabel)
            Next

            If Not String.IsNullOrEmpty(errorMessage) Then
                errorMessage &= String.Format("{0}{0}Please select export definitions from all units.", vbCrLf)
                Return False
            End If
        End If

        errorMessage = String.Empty
        Return True

    End Function

    Public Function AllowIndividualExport(ByRef errorMessage As String) As Boolean

        Return ExportSet.AllowIndividualExport(mSampleUnitId, mExportSetType, errorMessage)

    End Function

    Public Shared Function AllowIndividualExport(ByVal sampleUnitID As Integer, ByVal exportSetType As Library.ExportSetType, _
                                                 ByRef errorMessage As String) As Boolean

        errorMessage = String.Empty

        If exportSetType = Library.ExportSetType.CmsHcahps OrElse exportSetType = Library.ExportSetType.CmsChart Then
            Dim su As SampleUnit = SampleUnit.Get(sampleUnitID)
            If su Is Nothing Then Throw New NullReferenceException("Unable to load SampleUnit object for the ExportSet.")

            Dim allUnits As Collection(Of SampleUnit) = SampleUnit.GetByMedicareNumber(su.MedicareNumber)
            For Each unit As SampleUnit In allUnits
                If unit.IsHcahps AndAlso unit.Id <> su.Id Then
                    If String.IsNullOrEmpty(errorMessage) Then errorMessage = String.Format("The medicare number '{0}' assigned to sample unit {1} is also assigned to other HCAHPS units.", su.MedicareNumber, su.DisplayLabel)

                    Dim unitSurvey As Survey = Survey.GetSurvey(unit.SurveyId)
                    If unitSurvey Is Nothing Then Throw New NullReferenceException(String.Format("Unable to load SurveyID {0} while checking HCAHPS units for Medicare Number {1}.{2}{2}Please ensure that the Methodology is setup for this survey in QualiSys.", unit.SurveyId, su.MedicareNumber, vbCrLf))

                    Dim unitStudy As Study = unitSurvey.Study
                    Dim unitClient As Client = unitStudy.Client

                    errorMessage &= String.Format("{0}{1}{2}; {3}; {4}; {5}", vbCrLf, vbTab, unitClient.DisplayLabel, unitStudy.DisplayLabel, unitSurvey.DisplayLabel, unit.DisplayLabel)
                End If
            Next

        End If

        If Not String.IsNullOrEmpty(errorMessage) Then
            Return False
        End If

        Return True

    End Function

#End Region

#Region " Private Methods "

    ''' <summary>
    ''' Merges a collection of ExportSet object into a master list that contains to duplicates
    ''' </summary>
    ''' <param name="masterList"></param>
    ''' <param name="exportIds"></param>
    ''' <param name="exportList"></param>
    ''' <remarks>
    ''' This method is used by the GetExportSetsByIds method.  Since the exports defined for a 
    ''' survey may overlap the exports defined at a client or study level, it is necessary to de-dup 
    ''' the lists and create one set of distinct ExportSet objects
    ''' </remarks>
    Private Shared Sub UnionExportList(ByVal masterList As Collection(Of ExportSet), ByVal exportIds As List(Of Integer), ByVal exportList As Collection(Of ExportSet))

        For Each export As ExportSet In exportList
            If Not exportIds.Contains(export.Id) Then
                exportIds.Add(export.Id)
                masterList.Add(export)
            End If
        Next

    End Sub

#End Region

End Class
