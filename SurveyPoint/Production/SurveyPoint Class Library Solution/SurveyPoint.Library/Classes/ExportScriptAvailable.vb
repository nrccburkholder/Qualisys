Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportScriptAvailable
    Property ScriptID() As Integer
End Interface

''' <summary>This class allows for a non-editable collection of scripts avaiable for an export group - survey and client.</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportScriptAvailable
    Inherits BusinessBase(Of ExportScriptAvailable)
    Implements IExportScriptAvailable

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mScriptID As Integer
    Private mSurveyID As Integer
    Private mScriptTypeID As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mCompletenessLevel As Decimal
    Private mFollowSkips As Boolean
    Private mCalcCompleteness As Boolean
    Private mDefaultScript As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>Script PK</summary>
    ''' <value>Script ID as integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ScriptID() As Integer Implements IExportScriptAvailable.ScriptID
        Get
            Return mScriptID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mScriptID Then
                mScriptID = value
                PropertyHasChanged("ScriptID")
            End If
        End Set
    End Property
    ''' <summary>data store value</summary>
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
    ''' <summary>data store value</summary>
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
    ''' <summary>ID of the survey associated with this script</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property SurveyID() As Integer
        Get
            Return mSurveyID
        End Get
        Set(ByVal value As Integer)
            If Not value = mSurveyID Then
                mSurveyID = value
                PropertyHasChanged("SurveyID")
            End If
        End Set
    End Property
    ''' <summary>ID for the type of script.</summary>
    ''' <value>int</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ScriptTypeID() As Integer
        Get
            Return mScriptTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mScriptTypeID Then
                mScriptTypeID = value
                PropertyHasChanged("ScriptTypeID")
            End If
        End Set
    End Property
    ''' <summary>Data store property</summary>
    ''' <value>dec</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property CompletenessLevel() As Decimal
        Get
            Return mCompletenessLevel
        End Get
        Set(ByVal value As Decimal)
            If Not value = mCompletenessLevel Then
                mCompletenessLevel = value
                PropertyHasChanged("CompletenessLevel")
            End If
        End Set
    End Property
    ''' <summary>Data store property</summary>
    ''' <value>bit flag</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property FollowSkips() As Boolean
        Get
            Return mFollowSkips
        End Get
        Set(ByVal value As Boolean)
            If Not value = mFollowSkips Then
                mFollowSkips = value
                PropertyHasChanged("FollowSkips")
            End If
        End Set
    End Property
    ''' <summary>Data store property</summary>
    ''' <value>bit flag</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property CalcCompleteness() As Boolean
        Get
            Return mCalcCompleteness
        End Get
        Set(ByVal value As Boolean)
            If Not value = mCalcCompleteness Then
                mCalcCompleteness = value
                PropertyHasChanged("CalcCompleteness")
            End If
        End Set
    End Property
    ''' <summary>Data store property</summary>
    ''' <value>bit flag</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property DefaultScript() As Boolean
        Get
            Return mDefaultScript
        End Get
        Set(ByVal value As Boolean)
            If Not value = mDefaultScript Then
                mDefaultScript = value
                PropertyHasChanged("DefaultScript")
            End If
        End Set
    End Property

    ''' <summary>Used to concat the script name and ID into a formatted string.</summary>
    ''' <value>string</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property DisplayName() As String
        Get
            Return Me.Name & " (" & Me.ScriptID.ToString() & ")"
        End Get
    End Property
#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new script object.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportScriptAvailable() As ExportScriptAvailable
        Return New ExportScriptAvailable
    End Function


    ''' <summary>Factory to retrieve a collection of scripts based on the survey and clients selected</summary>
    ''' <param name="surveyID"></param>
    ''' <param name="clientIDs"></param>
    ''' <returns>ExportScriptAvailableCollection</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetScriptsBySurveyAndClients(ByVal surveyID As Integer, ByVal clientIDs As String) As ExportScriptAvailableCollection
        Return ExportScriptAvailableProvider.Instance.SelectAllScriptsBySurveyAndClients(surveyID, clientIDs)
    End Function

    ''' <summary>Retrieves a script by its ID</summary>
    ''' <param name="scriptID"></param>
    ''' <returns>ExportScriptAvailable</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetScriptByScriptID(ByVal scriptID As Integer) As ExportScriptAvailable
        Return ExportScriptAvailableProvider.Instance.SelectScriptByScriptID(scriptID)
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
            Return mScriptID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wire business rule methods to properties here.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
    End Sub
    ''' <summary>Save is not implemented on this object</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()
        'MyBase.Save()        
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub


#End Region

#Region " Public Methods "

#End Region

End Class
