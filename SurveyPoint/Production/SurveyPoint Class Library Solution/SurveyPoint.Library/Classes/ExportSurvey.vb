Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface ISurvey
    Property SurveyID() As Integer
End Interface

''' <summary>This class represents a survey that may be tied to an export
''' group</summary>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>2008-03-13 - Arman Mnatsakanyan</term>
''' <description>Added event handlers to keep track of the Collection properties.
''' Refactored.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportSurvey
    Inherits BusinessBase(Of ExportSurvey)
    Implements ISurvey

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mSurveyID As Integer

    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mCreatedByUserID As Integer
    Private mCreatedOnDate As Date
    Private mActive As Byte

    Private mParentExportGroup As ExportGroup = Nothing
    Private mExportScriptAvailableCollection As ExportScriptAvailableCollection
    WithEvents mExportScriptSelectedCollection As ExportScriptSelectedCollection
    Private mExportClientAvailableCollection As ExportClientAvailableCollection
    WithEvents mExportClientSelectedCollection As ExportClientSelectedCollection

#End Region

#Region " Public Properties "
    ''' <summary>PK for a survey</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SurveyID() As Integer Implements ISurvey.SurveyID
        Get
            Return mSurveyID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mSurveyID Then
                mSurveyID = value
                PropertyHasChanged("SurveyID")
            End If
        End Set
    End Property
    ''' <summary>Data store value</summary>
    ''' <value>string</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    ''' <summary>Data store value</summary>
    ''' <value>string</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property
    ''' <summary>Data store value</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property CreatedByUserID() As Integer
        Get
            Return mCreatedByUserID
        End Get
        Set(ByVal value As Integer)
            If Not value = mCreatedByUserID Then
                mCreatedByUserID = value
                PropertyHasChanged("CreatedByUserID")
            End If
        End Set
    End Property
    ''' <summary>Data store value</summary>
    ''' <value>date</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property CreatedOnDate() As Date
        Get
            Return mCreatedOnDate
        End Get
        Set(ByVal value As Date)
            If Not value = mCreatedOnDate Then
                mCreatedOnDate = value
                PropertyHasChanged("CreatedOnDate")
            End If
        End Set
    End Property
    ''' <summary>Data store value</summary>
    ''' <value>byte</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property Active() As Byte
        Get
            Return mActive
        End Get
        Set(ByVal value As Byte)
            If Not value = mActive Then
                mActive = value
                PropertyHasChanged("Active")
            End If
        End Set
    End Property

    ''' <summary>If a survey is associated with an export group, this is the reference back to that object</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ParentExportGroup() As ExportGroup
        Get
            Return Me.mParentExportGroup
        End Get
        Set(ByVal value As ExportGroup)
            Me.mParentExportGroup = value
        End Set
    End Property

    ''' <summary>Collection of essentially read only scripts that may be selected for a given survey.</summary>
    ''' <value>ExportScriptAvailableCollection</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportScriptAvailableCollection() As ExportScriptAvailableCollection
        Get
            If mExportScriptAvailableCollection Is Nothing Then
                'Avaiable scripts are based on the selected clients.
                'TODO:  Throw error and handle if client ids string exceed max sql length.
                If Not Me.ExportClientSelectedCollection Is Nothing Then
                    If Me.ExportClientSelectedCollection.Count > 0 Then
                        Dim clientIDs As String = Me.SelectedClientIDs
                        If Not clientIDs = "" Then
                            mExportScriptAvailableCollection = ExportScriptAvailable.GetScriptsBySurveyAndClients(Me.SurveyID, clientIDs)
                        End If
                    End If
                End If
            End If
            Return mExportScriptAvailableCollection
        End Get
        Set(ByVal value As ExportScriptAvailableCollection)
            mExportScriptAvailableCollection = value
        End Set
    End Property
    ''' <summary>A collection of script objects selected for a survey.  Notice the relationship beteen the clients and avialable scripts</summary>
    ''' <value>ExportScriptSelectedCollection</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportScriptSelectedCollection() As ExportScriptSelectedCollection
        Get
            If mExportScriptSelectedCollection Is Nothing Then
                If Not Me.mParentExportGroup Is Nothing Then
                    If Not Me.mParentExportGroup.IsNew() Then
                        mExportScriptSelectedCollection = ExportScriptSelected.GetScriptsByExportGroupAndSurvey(Me.ParentExportGroup, Me)
                        ResetAvailableScripts()
                    Else
                        Me.mExportScriptSelectedCollection = Nothing 'New ExportScriptSelectedCollection
                    End If
                Else
                    Me.mExportScriptSelectedCollection = Nothing 'New ExportScriptSelectedCollection
                End If
            End If
            Return mExportScriptSelectedCollection
        End Get
        Set(ByVal value As ExportScriptSelectedCollection)
            mExportScriptSelectedCollection = value
            'Check prevents infinite loop
            If value IsNot Nothing AndAlso ExportScriptAvailableCollection IsNot Nothing Then ' Me.mExportScriptAvailableCollection IsNot Nothing Then
                ResetAvailableScripts()
            End If
            PropertyHasChanged("ExportScriptSelectedCollection")
        End Set
    End Property

    ''' <summary>Essentially, this is a read only collection of client the user may associate with an export group for this survey.</summary>
    ''' <value>ExportClientAvailableCollection</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportClientAvailableCollection() As ExportClientAvailableCollection
        Get
            If Me.mExportClientAvailableCollection Is Nothing Then
                Me.mExportClientAvailableCollection = ExportClientAvailable.GetBySurveyID(Me.mSurveyID)
            End If
            Return Me.mExportClientAvailableCollection
        End Get
        Set(ByVal value As ExportClientAvailableCollection)
            Me.mExportClientAvailableCollection = value
        End Set
    End Property

    ''' <summary>The clients available for this survey that have been selected for the parent export group</summary>
    ''' <value>ExportClientSelectedCollection</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportClientSelectedCollection() As ExportClientSelectedCollection
        Get
            If Me.mExportClientSelectedCollection Is Nothing Then
                If Not Me.mParentExportGroup Is Nothing Then
                    If Me.mParentExportGroup.IsNew Then
                        Me.mExportClientSelectedCollection = Nothing
                    Else
                        Me.mExportClientSelectedCollection = ExportClientSelected.GetSelectedClients(Me.ParentExportGroup, Me)
                        ResetAvailableClients()
                    End If
                Else
                    Me.mExportClientSelectedCollection = Nothing
                End If
            End If
            Return Me.mExportClientSelectedCollection
        End Get
        Set(ByVal value As ExportClientSelectedCollection)
            Me.mExportClientSelectedCollection = value
            ResetAvailableClients()
        End Set
    End Property
    ''' <summary>Formatted string of the survey name + ID</summary>
    ''' <value>string</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property DisplayName() As String
        Get
            Return Me.Name & " (" & Me.SurveyID.ToString() & ")"
        End Get
    End Property
    ''' <summary>This retrieves a comma delimited string of selected client ids.</summary>
    ''' <value>comma delimeted string of selected client ids.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedClientIDs() As String
        Get
            Dim retVal As String = String.Empty
            Dim clientIDs As String = String.Empty
            If Not Me.ExportClientSelectedCollection Is Nothing AndAlso Me.ExportClientSelectedCollection.Count > 0 Then
                For Each client As ExportClientSelected In Me.ExportClientSelectedCollection
                    clientIDs += client.ClientID.ToString & ","
                Next
                retVal = clientIDs.Substring(0, clientIDs.Length - 1)
            End If
            Return retVal
        End Get
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new survey</summary>
    ''' <returns>ExportSurvey</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewSurvey() As ExportSurvey
        Return New ExportSurvey
    End Function

    ''' <summary>Factory to return all surveys from the data store</summary>
    ''' <returns>ExportSurveyCollection</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As ExportSurveyCollection
        Return ExportSurveyProvider.Instance.GetAllSurveies()
    End Function
    ''' <summary>
    ''' Takes an Export Group as a parameter
    ''' </summary>
    ''' <param name="SelectedGroup"></param>
    ''' <returns>ID of the survey associated with the given Export Group ID</returns>
    ''' <remarks></remarks>
    Public Shared Function GetSelectedSurvey(ByVal SelectedGroup As ExportGroup) As ExportSurvey
        Return ExportSurveyProvider.Instance.GetSelectedSurvey(SelectedGroup)
    End Function

    ''' <summary>Factory to return a survey from the data store by its id.</summary>
    ''' <param name="surveyID"></param>
    ''' <returns>ExportSurvey</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetSurveyBySurveyID(ByVal surveyID As Integer) As ExportSurvey
        Return ExportSurveyProvider.Instance.Get(surveyID)
    End Function

#End Region

#Region " Basic Overrides "
    ''' <summary>Uniquely ID the object whether new or existing.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mSurveyID
        End If
    End Function

#End Region

#Region " Validation "
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf ValidateSelectedScriptsExist, "ExportScriptSelectedCollection")
        ValidationRules.AddRule(AddressOf ValidateSelectedClientsExist, "ExportClientSelectedCollection")
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub

    ''' <summary>data updates are done by the parent object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        Throw New NotImplementedException("Cannot insert a row. Survey business object doesn't represent a physical table or view")
        'SurveyID = SurveyProvider.Instance.InsertTEMP_SPU_GetAllSurvey(Me)
    End Sub
    ''' <summary>data updates are done by the parent object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        Throw New NotImplementedException("Cannot Update a row. Survey business object doesn't represent a physical table or view")
        'SurveyProvider.Instance.UpdateTEMP_SPU_GetAllSurvey(Me)
    End Sub
    ''' <summary>data updates are done by the parent object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        Throw New NotImplementedException("Cannot delete a row. Survey business object doesn't represent a physical table or view")
        'SurveyProvider.Instance.DeleteTEMP_SPU_GetAllSurvey(mSurveyID)
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>Validates the survey properties</summary>
    ''' <returns>true if all survey properties are value, else false</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Friend Function ValidateAll() As Boolean
        Me.ValidationRules.CheckRules()
        Return Me.IsValid()
    End Function

    ''' <summary>This validates that their is at least one selecte script and that that script exists in the data store.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns>bool</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateSelectedScriptsExist(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim retMsg As String = "Selected Scripts have not been set for export group."
        Dim retVal As Boolean = False
        'Check that the survey object exists
        If Not Me.mExportScriptSelectedCollection Is Nothing Then
            If Me.mExportScriptSelectedCollection.Count > 0 Then
                Dim scriptInvalid As Boolean = False
                Dim scriptMsg As String = ""
                For Each script As ExportScriptSelected In Me.mExportScriptSelectedCollection
                    Dim tempScript As ExportScriptAvailable = ExportScriptAvailable.GetScriptByScriptID(script.ScriptID)
                    If Not tempScript Is Nothing Then
                        If script.ScriptID <> tempScript.ScriptID Then
                            scriptInvalid = True
                            scriptMsg += "The selected script (" & script.ScriptID.ToString & ") was not returned from the database." & vbCrLf
                        End If
                    Else
                        scriptInvalid = True
                        scriptMsg += "The selected script (" & script.ScriptID.ToString & ") was not returned from the database." & vbCrLf
                    End If
                Next
                If scriptInvalid Then
                    retMsg = scriptMsg
                    retVal = False
                Else
                    Return True
                End If
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>This validates that at least one client was selected and that it exists in the data store.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateSelectedClientsExist(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim retMsg As String = "Selected Clients have not been set for export group."
        Dim retVal As Boolean = False
        'Check that the survey object exists
        If Not Me.mExportClientSelectedCollection Is Nothing Then
            If Me.mExportClientSelectedCollection.Count > 0 Then
                Dim clientInvalid As Boolean = False
                Dim clientMsg As String = ""
                For Each client As ExportClientSelected In Me.mExportClientSelectedCollection
                    Dim tempClient As ExportClientAvailable = ExportClientAvailable.GetClientByClientID(client.ClientID)
                    If Not tempClient Is Nothing Then
                        If client.ClientID <> tempClient.ClientID Then
                            clientInvalid = True
                            clientMsg += "The selected client (" & client.ClientID.ToString & ") was not returned from the database." & vbCrLf
                        End If
                    Else
                        clientInvalid = True
                        clientMsg += "The selected client (" & client.ClientID.ToString & ") was not returned from the database." & vbCrLf
                    End If
                Next
                If clientInvalid Then
                    retMsg = clientMsg
                    retVal = False
                Else
                    Return True
                End If
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>This checks that the scripts available and selected are associated with a selected client and will report back any inconstitencies.  Optionally, you can remove any invalid scripts.</summary>
    ''' <param name="returnMessage"></param>
    ''' <param name="resetInvalidScripts"></param>
    ''' <returns>bool return plus refernced message string.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function VaildateClientsAndScripts(ByRef returnMessage As String, ByVal resetInvalidScripts As Boolean) As Boolean
        Dim retVal As Boolean = True
        Dim clientIDs As String = Me.SelectedClientIDs
        Dim tempScripts As ExportScriptAvailableCollection
        Dim counter As Integer
        'TODO:  Refactor.  Right now it's using two methods to reset the scripts.!!!!!
        If clientIDs.Length > 0 Then
            tempScripts = ExportScriptAvailable.GetScriptsBySurveyAndClients(Me.SurveyID, clientIDs)
            If Not tempScripts Is Nothing AndAlso tempScripts.Count > 0 Then
                'Check against the available scripts.
                Dim avalScript As ExportScriptAvailable
                For counter = Me.ExportScriptAvailableCollection.Count - 1 To 0 Step -1
                    avalScript = Me.mExportScriptAvailableCollection(counter)
                    Dim blnFound As Boolean = False
                    For Each tempscript As ExportScriptAvailable In tempScripts
                        If avalScript.ScriptID = tempscript.ScriptID Then
                            blnFound = True
                            Exit For
                        End If
                    Next
                    If Not blnFound Then
                        returnMessage += "Script " & avalScript.ScriptID.ToString & " is no longer available for the selected clients." & vbCrLf
                        retVal = False
                        If resetInvalidScripts Then
                            Me.mExportScriptAvailableCollection.Remove(avalScript)
                        End If
                    End If
                Next
                'Check against the selected scripts.
                If Not Me.ExportScriptSelectedCollection Is Nothing AndAlso Me.mExportScriptSelectedCollection.Count > 0 Then
                    Dim selectedScript As ExportScriptSelected
                    For counter = Me.mExportScriptSelectedCollection.Count - 1 To 0 Step -1
                        selectedScript = Me.mExportScriptSelectedCollection(counter)
                        Dim blnFound As Boolean = False
                        For Each tempscript As ExportScriptAvailable In tempScripts
                            If selectedScript.ScriptID = tempscript.ScriptID Then
                                blnFound = True
                                Exit For
                            End If
                        Next
                        If Not blnFound Then
                            returnMessage += "Script " & selectedScript.ScriptID.ToString & " is no longer selected for the selected clients." & vbCrLf
                            retVal = False
                            If resetInvalidScripts Then
                                Me.mExportScriptSelectedCollection.Remove(selectedScript)
                            End If
                        End If
                    Next
                Else
                    retVal = False
                    returnMessage = "You have no selected scripts."
                End If
            Else
                retVal = False
                returnMessage = "You have no selected scripts."
            End If
        Else
            If resetInvalidScripts Then
                If Not Me.mExportScriptAvailableCollection Is Nothing Then Me.mExportScriptAvailableCollection.Clear()
                If Not Me.mExportScriptSelectedCollection Is Nothing Then Me.mExportScriptSelectedCollection.Clear()
            End If
            retVal = False
        End If
        Return retVal
    End Function
    ''' <summary>Remove clients from available list if they have been selected.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ResetAvailableClients()
        Dim counter As Integer
        If Not Me.mExportClientSelectedCollection Is Nothing AndAlso Me.mExportClientSelectedCollection.Count > 0 Then
            For Each selClient As ExportClientSelected In Me.mExportClientSelectedCollection
                If Not Me.ExportClientAvailableCollection Is Nothing AndAlso Me.mExportClientAvailableCollection.Count > 0 Then
                    Dim avalClient As ExportClientAvailable
                    For counter = Me.mExportClientAvailableCollection.Count - 1 To 0 Step -1
                        avalClient = Me.mExportClientAvailableCollection(counter)
                        If avalClient.ClientID = selClient.ClientID Then
                            Me.mExportClientAvailableCollection.Remove(avalClient)
                        End If
                    Next
                End If
            Next
        End If
    End Sub
    ''' <summary>Scripts are available based on the selected clients.  this resets what scripts you can have based on the clients that are selected.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ResetAvailableScripts()
        Dim clientIDs As String = Me.SelectedClientIDs
        Dim tempScripts As ExportScriptAvailableCollection
        If clientIDs.Length > 0 Then
            tempScripts = ExportScriptAvailable.GetScriptsBySurveyAndClients(Me.SurveyID, clientIDs)
            If Not tempScripts Is Nothing Then
                For Each tempscript As ExportScriptAvailable In tempScripts
                    Dim blnExists As Boolean = False
                    If Not Me.mExportScriptSelectedCollection Is Nothing AndAlso Me.mExportScriptSelectedCollection.Count > 0 Then
                        For Each selScript As ExportScriptSelected In Me.mExportScriptSelectedCollection
                            If selScript.ScriptID = tempscript.ScriptID Then
                                blnExists = True
                                Exit For
                            End If
                        Next
                    End If
                    If Not Me.mExportScriptAvailableCollection Is Nothing AndAlso Me.mExportScriptAvailableCollection.Count > 0 Then
                        For Each avalScript As ExportScriptAvailable In Me.mExportScriptAvailableCollection
                            If avalScript.ScriptID = tempscript.ScriptID Then
                                blnExists = True
                                Exit For
                            End If
                        Next
                    End If
                    If Not blnExists Then
                        Me.mExportScriptAvailableCollection.Add(tempscript)
                    End If
                Next
            End If
        Else
            If Not Me.mExportScriptAvailableCollection Is Nothing Then Me.mExportScriptAvailableCollection.Clear()
            If Not Me.mExportScriptSelectedCollection Is Nothing Then Me.mExportScriptSelectedCollection.Clear()
        End If
        Dim counter As Integer
        If Not Me.mExportScriptSelectedCollection Is Nothing AndAlso Me.mExportScriptSelectedCollection.Count > 0 Then
            For Each selScript As ExportScriptSelected In Me.mExportScriptSelectedCollection
                If Not Me.mExportScriptAvailableCollection Is Nothing AndAlso Me.mExportScriptAvailableCollection.Count > 0 Then
                    Dim avalScript As ExportScriptAvailable
                    For counter = Me.mExportScriptAvailableCollection.Count - 1 To 0 Step -1
                        avalScript = Me.mExportScriptAvailableCollection(counter)
                        If avalScript.ScriptID = selScript.ScriptID Then
                            Me.mExportScriptAvailableCollection.Remove(avalScript)
                        End If
                    Next
                End If
            Next
        End If
    End Sub
    ''' <summary>This moves the script objects between the available scripts and the selected scripts.</summary>
    ''' <param name="scriptIDs"></param>
    ''' <param name="direction"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveScripts(ByVal scriptIDs As List(Of Integer), ByVal direction As ExportGroupMoveDirection)
        If direction = ExportGroupMoveDirection.AddSelected Then
            For Each scriptID As Integer In scriptIDs
                Dim avalScript As ExportScriptAvailable = Nothing
                Dim counter As Integer
                For counter = Me.mExportScriptAvailableCollection.Count - 1 To 0 Step -1
                    avalScript = Me.mExportScriptAvailableCollection(counter)
                    If avalScript.ScriptID = scriptID Then
                        'found, so exit loop and remove
                        Exit For
                    End If
                Next
                If Not avalScript Is Nothing Then
                    Me.mExportScriptAvailableCollection.Remove(avalScript)
                End If
                'TP 20080225 check selected rather than avaiable.
                If Me.mExportScriptSelectedCollection Is Nothing Then Me.mExportScriptSelectedCollection = New ExportScriptSelectedCollection
                Me.ExportScriptSelectedCollection.Add(ExportScriptSelected.Get(scriptID))
            Next
        Else
            For Each scriptID As Integer In scriptIDs
                Dim selectedScript As ExportScriptSelected = Nothing
                Dim counter As Integer
                For counter = Me.mExportScriptSelectedCollection.Count - 1 To 0 Step -1
                    selectedScript = Me.mExportScriptSelectedCollection(counter)
                    If selectedScript.ScriptID = scriptID Then
                        'found, so exit loop and remove
                        Exit For
                    End If
                Next
                If Not selectedScript Is Nothing Then
                    Me.mExportScriptSelectedCollection.Remove(selectedScript)
                End If
                Me.mExportScriptAvailableCollection.Add(ExportScriptAvailable.GetScriptByScriptID(scriptID))
            Next
        End If
    End Sub
    ''' <summary>This moves clients between the available clients and the selected client collections.</summary>
    ''' <param name="clientIDs"></param>
    ''' <param name="direction"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveClients(ByVal clientIDs As List(Of Integer), ByVal direction As ExportGroupMoveDirection)
        If direction = ExportGroupMoveDirection.AddSelected Then
            For Each clientID As Integer In clientIDs
                Dim avalClient As ExportClientAvailable = Nothing
                Dim counter As Integer
                For counter = Me.ExportClientAvailableCollection.Count - 1 To 0 Step -1
                    avalClient = Me.ExportClientAvailableCollection(counter)
                    If avalClient.ClientID = clientID Then
                        'found, so exit loop and remove
                        Exit For
                    End If
                Next
                If Not avalClient Is Nothing Then
                    Me.ExportClientAvailableCollection.Remove(avalClient)
                End If
                If Me.ExportClientSelectedCollection Is Nothing Then Me.ExportClientSelectedCollection = New ExportClientSelectedCollection
                Me.ExportClientSelectedCollection.Add(ExportClientSelected.Get(clientID))
            Next
        Else
            For Each clientID As Integer In clientIDs
                Dim selectedClient As ExportClientSelected = Nothing
                Dim counter As Integer
                For counter = Me.ExportClientSelectedCollection.Count - 1 To 0 Step -1
                    selectedClient = Me.ExportClientSelectedCollection(counter)
                    If selectedClient.ClientID = clientID Then
                        'found, so exit loop and remove
                        Exit For
                    End If
                Next
                If Not selectedClient Is Nothing Then
                    Me.ExportClientSelectedCollection.Remove(selectedClient)
                End If
                If Me.ExportClientAvailableCollection Is Nothing Then Me.ExportClientAvailableCollection = New ExportClientAvailableCollection
                Me.ExportClientAvailableCollection.Add(ExportClientAvailable.GetClientByClientID(clientID))
            Next
        End If
        Dim tempString As String = String.Empty
        Me.VaildateClientsAndScripts(tempString, True)
        ResetAvailableClients()
        ResetAvailableScripts()
    End Sub
#End Region
#Region " Private Methods "

#End Region

#Region "Event Handlers"
    Private Sub ExportClientSelectedCollection_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mExportClientSelectedCollection.ListChanged
        Me.PropertyHasChanged("ExportClientSelectedCollection")
    End Sub
    Private Sub mExportScriptSelectedCollection_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mExportScriptSelectedCollection.ListChanged
        Me.PropertyHasChanged("ExportScriptSelectedCollection")
    End Sub
#End Region
End Class

