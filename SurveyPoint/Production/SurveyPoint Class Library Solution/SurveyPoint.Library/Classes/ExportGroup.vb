Imports Nrc.Framework.BusinessLogic
Imports Nrc.Framework.BusinessLogic.Validation
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.IO

Public Interface IExportGroup
    Property ExportGroupID() As Integer
End Interface

''' <summary>This is the primary business object for an export group.</summary>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>March 13 2008 - Arman Mnatsakanyan</term>
''' <description>Added Event handlers for collection members to keep track of
''' IsDirty of ExportGroup.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class ExportGroup
    Inherits BusinessBase(Of ExportGroup)
    Implements IExportGroup

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid

    WithEvents mExportGroupExtensionCollection As ExportGroupExtensionCollection
    WithEvents mExportSelectedSurvey As ExportSurvey
    WithEvents mExportIncludedEvents As ExportEventSelectedCollection
    WithEvents mExportExcludedEvents As ExportEventSelectedCollection
    Private mExportFileLayout As ExportFileLayout
    Private mExportAvailableEvents As ExportEventAvailableCollection

    Private mExportGroupID As Integer
    Private mName As String = String.Empty

    Private mFileLayoutID As Nullable(Of Integer)

    Private mQuestionFileName As String = String.Empty
    Private mResultFileName As String = String.Empty

    Private mRerunCodeStartDate As Nullable(Of Date)
    Private mRerunCodeEndDate As Nullable(Of Date)
    'TP 20080414 New Field.
    Private mRemoveHTMLAndEncoding As Boolean

    Private mMiscChar1 As String = String.Empty
    Private mMiscChar1Name As String = String.Empty
    Private mMiscChar2 As String = String.Empty
    Private mMiscChar2Name As String = String.Empty
    Private mMiscChar3 As String = String.Empty
    Private mMiscChar3Name As String = String.Empty
    Private mMiscChar4 As String = String.Empty
    Private mMiscChar4Name As String = String.Empty
    Private mMiscChar5 As String = String.Empty
    Private mMiscChar5Name As String = String.Empty
    Private mMiscChar6 As String = String.Empty
    Private mMiscChar6Name As String = String.Empty

    Private mMiscNum1 As Nullable(Of Decimal)
    Private mMiscNum1Name As String = String.Empty
    Private mMiscNum2 As Nullable(Of Decimal)
    Private mMiscNum2Name As String = String.Empty
    Private mMiscNum3 As Nullable(Of Decimal)
    Private mMiscNum3Name As String = String.Empty

    Private mMiscDate1 As Nullable(Of Date)
    Private mMiscDate1Name As String = String.Empty
    Private mMiscDate2 As Nullable(Of Date)
    Private mMiscDate2Name As String = String.Empty
    Private mMiscDate3 As Nullable(Of Date)
    Private mMiscDate3Name As String = String.Empty
#End Region
    'Public Sub SetDirty()
    '    Me.MarkDirty()
    'End Sub
#Region " Public Properties "

    ''' <summary>Each export group (to be valid) contains one survey object.  Note that the survey object (to be valid) needs reference back to its parent.</summary>
    ''' <value>The ExportSurvey instance associated with this object.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportSelectedSurvey() As ExportSurvey
        Get
            If Me.mExportSelectedSurvey Is Nothing Then
                If Me.IsNew() Then
                    Return Nothing
                Else
                    Me.mExportSelectedSurvey = ExportSurvey.GetSelectedSurvey(Me)
                    If Me.mExportSelectedSurvey IsNot Nothing Then
                        Me.mExportSelectedSurvey.ParentExportGroup = Me
                    End If
                    Return Me.mExportSelectedSurvey
                End If
            Else
                Return Me.mExportSelectedSurvey
            End If
        End Get
        Set(ByVal value As ExportSurvey)
            Me.mExportSelectedSurvey = value
            If Not Me.mExportSelectedSurvey Is Nothing Then
                Me.mExportSelectedSurvey.ParentExportGroup = Me
                Me.mExportSelectedSurvey.ExportScriptAvailableCollection = Nothing
                Me.mExportSelectedSurvey.ExportScriptSelectedCollection = Nothing
                Me.mExportSelectedSurvey.ExportClientAvailableCollection = Nothing
                Me.mExportSelectedSurvey.ExportClientSelectedCollection = Nothing
            End If
            PropertyHasChanged("ExportSelectedSurvey")
        End Set
    End Property

    ''' <summary>This is a read only collection of available events.  They are encapsulated under this object so that the export group can move events between available, included and excluded.</summary>
    ''' <value>Collection of read only events.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportAvailableEventCollection() As ExportEventAvailableCollection
        Get
            If Me.mExportAvailableEvents Is Nothing Then
                Me.mExportAvailableEvents = ExportEventAvailable.GetAll
            End If
            Return mExportAvailableEvents
        End Get
        Set(ByVal value As ExportEventAvailableCollection)
            Me.mExportAvailableEvents = value
            PropertyHasChanged("ExportAvailableEvents")
        End Set
    End Property

    ''' <summary>This is a collection of events a user selected to be included in an export group.</summary>
    ''' <value>collection of ExportEventSelected objects</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportIncludeEventCollection() As ExportEventSelectedCollection
        Get
            If Me.mExportIncludedEvents Is Nothing Then
                If Me.ExportGroupID <= 0 Then
                    PopulateDefaultIncludedEvents()
                Else
                    Me.mExportIncludedEvents = ExportEventSelected.GetIncludedEvents(Me.ExportGroupID)
                    'PropertyHasChanged("ExportIncludedEvents")
                    ResetAvailableEvents()
                End If
            Else
                Return (Me.mExportIncludedEvents) 'PopulateDefaultIncludedEvents()
            End If

            Return mExportIncludedEvents
        End Get
        Set(ByVal value As ExportEventSelectedCollection)
            Me.mExportIncludedEvents = value
            PropertyHasChanged("ExportIncludedEvents")
            ResetAvailableEvents()
        End Set
    End Property
    ''' <summary>This is a collection of events a user has selected to be excluded from the export group.</summary>
    ''' <value>collection of ExportEventSelected objects</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportExcludeEventCollection() As ExportEventSelectedCollection
        Get
            If Me.mExportExcludedEvents Is Nothing Then
                If Me.ExportGroupID <= 0 Then
                    PopulateDefaultExcludedEvents()
                Else
                    Me.mExportExcludedEvents = ExportEventSelected.GetExcludedEvents(Me.ExportGroupID)
                    ResetAvailableEvents()
                End If
            Else
                Return Me.mExportExcludedEvents 'PopulateDefaultExcludedEvents()
            End If
            Return mExportExcludedEvents
        End Get
        Set(ByVal value As ExportEventSelectedCollection)
            Me.mExportExcludedEvents = value
            PropertyHasChanged("ExportExcludedEvents")
            ResetAvailableEvents()
        End Set
    End Property

    ''' <summary>Represents the file layout associated with an export group.</summary>
    ''' <value>ExportFileLayout object.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportFileLayout() As ExportFileLayout
        Get
            Return Me.mExportFileLayout
        End Get
        Set(ByVal value As ExportFileLayout)
            If Me.mExportFileLayout Is Nothing OrElse value.FileLayoutID <> Me.mExportFileLayout.FileLayoutID Then
                Me.mExportFileLayout = value
                PropertyHasChanged("ExportFileLayout")
            End If
        End Set
    End Property

    ''' <summary>This property is used to force validation of itself and its child objects.</summary>
    ''' <value>true only if itself and all child object are valid.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property ValidateAll() As Boolean
        Get
            Dim retVal As Boolean = False
            ValidationRules.CheckRules()
            retVal = Me.IsValid()
            Me.ExportSelectedSurvey.ValidateAll()
            If Not Me.ExportSelectedSurvey.IsValid() Then
                retVal = Me.IsValid()
            End If
            Return retVal
        End Get
    End Property


    ''' <summary>PK for the SPU_ExportGroup table</summary>
    ''' <value>int</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportGroupID() As Integer Implements IExportGroup.ExportGroupID
        Get
            Return mExportGroupID
        End Get
        Protected Set(ByVal value As Integer)
            If Not value = mExportGroupID Then
                mExportGroupID = value
                PropertyHasChanged("ExportGroupID")
            End If
        End Set
    End Property

    ''' <summary>New Field from the Export group table used to tell whether or not to filter HTML from the question file.</summary>
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

    ''' <summary>Name for the export group.</summary>
    ''' <value>export group name.</value>
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





    ''' <summary>The path and file name for the question file that will be created by this export group.</summary>
    ''' <value>The file name and path.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property QuestionFileName() As String
        Get
            Return Me.mQuestionFileName
        End Get
        Set(ByVal value As String)
            If value <> Me.mQuestionFileName Then
                Me.mQuestionFileName = value
                PropertyHasChanged("QuestionFileName")
            End If
        End Set
    End Property
    ''' <summary>The path and file name for the answer file that will be created by this export group.</summary>
    ''' <value>This file name and path.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ResultFileName() As String
        Get
            Return Me.mResultFileName
        End Get
        Set(ByVal value As String)
            If value <> Me.mResultFileName Then
                Me.mResultFileName = value
                PropertyHasChanged("ResultFileName")
            End If
        End Set
    End Property
    ''' <summary>Field from data store used for 2401 reruns.</summary>
    ''' <value>date or null</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property RerunCodeStartDate() As Nullable(Of Date)
        Get
            Return Me.mRerunCodeStartDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mRerunCodeStartDate = value
        End Set
    End Property
    ''' <summary>Field from data store used for 2401 reruns.</summary>
    ''' <value>date or null</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property RerunCodeEndDate() As Nullable(Of Date)
        Get
            Return Me.mRerunCodeEndDate
        End Get
        Set(ByVal value As Nullable(Of Date))
            Me.mRerunCodeEndDate = value
        End Set
    End Property
#Region " Extension Properties "
    ''' <summary>This object allows us to pivot the extension fields of the export group for display in a grid.</summary>
    ''' <value>ExportGroupExtensionCollection</value>


    Public Property ExportGroupExtensionCollection() As ExportGroupExtensionCollection
        Get
            ''this condition should never be true, but just in case...
            'If mExportGroupExtensionCollection Is Nothing Then
            '    mExportGroupExtensionCollection = ExportGroupProvider.Instance.PopulateExportGroupExtensionCollection(Me)
            'End If

            Return mExportGroupExtensionCollection

        End Get
        Set(ByVal value As ExportGroupExtensionCollection)
            mExportGroupExtensionCollection = value
        End Set
    End Property

    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar1() As String
        Get
            Return mMiscChar1
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar1 Then
                mMiscChar1 = value
                PropertyHasChanged("MiscChar1")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar1Name() As String
        Get
            Return mMiscChar1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar1Name Then
                mMiscChar1Name = value
                PropertyHasChanged("MiscChar1Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar2() As String
        Get
            Return mMiscChar2
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar2 Then
                mMiscChar2 = value
                PropertyHasChanged("MiscChar2")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar2Name() As String
        Get
            Return mMiscChar2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar2Name Then
                mMiscChar2Name = value
                PropertyHasChanged("MiscChar2Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar3() As String
        Get
            Return mMiscChar3
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar3 Then
                mMiscChar3 = value
                PropertyHasChanged("MiscChar3")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar3Name() As String
        Get
            Return mMiscChar3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar3Name Then
                mMiscChar3Name = value
                PropertyHasChanged("MiscChar3Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar4() As String
        Get
            Return mMiscChar4
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar4 Then
                mMiscChar4 = value
                PropertyHasChanged("MiscChar4")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar4Name() As String
        Get
            Return mMiscChar4Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar4Name Then
                mMiscChar4Name = value
                PropertyHasChanged("MiscChar4Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar5() As String
        Get
            Return mMiscChar5
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar5 Then
                mMiscChar5 = value
                PropertyHasChanged("MiscChar5")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar5Name() As String
        Get
            Return mMiscChar5Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar5Name Then
                mMiscChar5Name = value
                PropertyHasChanged("MiscChar5Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar6() As String
        Get
            Return mMiscChar6
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar6 Then
                mMiscChar6 = value
                PropertyHasChanged("MiscChar6")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscChar6Name() As String
        Get
            Return mMiscChar6Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscChar6Name Then
                mMiscChar6Name = value
                PropertyHasChanged("MiscChar6Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum1() As Nullable(Of Decimal)
        Get
            Return mMiscNum1
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum1 = value
            PropertyHasChanged("MiscNum1")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum1Name() As String
        Get
            Return mMiscNum1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum1Name Then
                mMiscNum1Name = value
                PropertyHasChanged("MiscNum1Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum2() As Nullable(Of Decimal)
        Get
            Return mMiscNum2
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum2 = value
            PropertyHasChanged("MiscNum2")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum2Name() As String
        Get
            Return mMiscNum2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum2Name Then
                mMiscNum2Name = value
                PropertyHasChanged("MiscNum2Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum3() As Nullable(Of Decimal)
        Get
            Return mMiscNum3
        End Get
        Set(ByVal value As Nullable(Of Decimal))
            mMiscNum3 = value
            PropertyHasChanged("MiscNum3")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscNum3Name() As String
        Get
            Return mMiscNum3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscNum3Name Then
                mMiscNum3Name = value
                PropertyHasChanged("MiscNum3Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate1() As Nullable(Of Date)
        Get
            Return mMiscDate1
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate1 = value
            PropertyHasChanged("MiscDate1")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate1Name() As String
        Get
            Return mMiscDate1Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate1Name Then
                mMiscDate1Name = value
                PropertyHasChanged("MiscDate1Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate2() As Nullable(Of Date)
        Get
            Return mMiscDate2
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate2 = value
            PropertyHasChanged("MiscDate2")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate2Name() As String
        Get
            Return mMiscDate2Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate2Name Then
                mMiscDate2Name = value
                PropertyHasChanged("MiscDate2Name")
            End If
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate3() As Nullable(Of Date)
        Get
            Return mMiscDate3
        End Get
        Set(ByVal value As Nullable(Of Date))
            mMiscDate3 = value
            PropertyHasChanged("MiscDate3")
        End Set
    End Property
    ''' <summary>Export Group extension field</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property MiscDate3Name() As String
        Get
            Return mMiscDate3Name
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mMiscDate3Name Then
                mMiscDate3Name = value
                PropertyHasChanged("MiscDate3Name")
            End If
        End Set
    End Property
#End Region

#End Region

#Region " Constructors "
    Protected Sub New()        
        Me.CreateNew()
        Me.MarkNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new empty export group.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>03/11/2008 - Arman Mnatsakanyan</term>
    ''' <description>The method now populates a collection of empty
    ''' extensions</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Shared Function NewExportGroup() As ExportGroup        
        Dim group As ExportGroup = New ExportGroup
        System.Diagnostics.Debug.Print(group.IsNew.ToString)
        group.ExportGroupExtensionCollection = ExportGroupProvider.Instance.PopulateExportGroupExtensionCollection(group)
        System.Diagnostics.Debug.Print(group.IsNew.ToString)
        Return group
    End Function

    ''' <summary>Factory to retrieve an export group from the Data store.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal exportGroupID As Integer) As ExportGroup
        Return ExportGroupProvider.Instance.SelectExportGroup(exportGroupID)
    End Function

    ''' <summary>Factory to retrieve a collection of export group objects from the data store.</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetAll() As ExportGroupCollection
        Return ExportGroupProvider.Instance.SelectAllExportGroups()
    End Function

    ''' <summary>Checks for the existance of an export group in the data store by export group name.</summary>
    ''' <param name="pstrExportGroupName"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CheckExportGroupByName(ByVal pstrExportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        Return ExportGroupProvider.Instance.CheckExportGroupByName(pstrExportGroupName, ExportGroupID)
    End Function

    ''' <summary>Makes a copy of an existing export group in the data store.</summary>
    ''' <param name="oldExportID"></param>
    ''' <param name="newExportName"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CopyExport(ByVal oldExportID As Integer, ByVal newExportName As String) As Integer
        Try
            Return ExportGroupProvider.Instance.CopyExport(oldExportID, newExportName)
        Catch ex As System.Exception
            Throw New ExportGroupException(ex.Message)
        End Try
    End Function

    ''' <summary>Deletes an export group, including all of its child relations from the data store.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Sub DeleteExportGroupAll(ByVal exportGroupID As Integer)
        Try
            ExportGroupProvider.Instance.DeleteExportGroupAll(exportGroupID)
        Catch ex As Exception
            Throw New ExportGroupException(ex.Message)
        End Try
    End Sub

    ''' <summary>You should not be able to save or run an export if one is currently running.  This method check if a export is currently running.</summary>
    ''' <returns>True if an export is running, false if not.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function CheckForRunningExport() As Boolean
        Return ExportGroupProvider.Instance.CheckForRunningExport()
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
            Return mExportGroupID
        End If
    End Function

#End Region

#Region " Validation "
    ''' <summary>Wires validation rules to the properties of the business object.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
        ValidationRules.AddRule(AddressOf ValidateSurveyExists, "ExportSelectedSurvey")
        ValidationRules.AddRule(AddressOf ValidateIncludedEvents, "ExportIncludedEvents")
        ValidationRules.AddRule(AddressOf ValidateExcludedEvents, "ExportExcludedEvents")
        ValidationRules.AddRule(AddressOf ValidateExportFileLayoutExists, "ExportFileLayout")
        ValidationRules.AddRule(AddressOf ValidateExportName, "Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar1Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar2Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar3Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar4")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar4Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar5")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar5Name")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar6")
        ValidationRules.AddRule(AddressOf StringRule, "MiscChar6Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum1Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum2Name")
        ValidationRules.AddRule(AddressOf NumericRule, "MiscNum3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscNum3Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate1")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate1Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate2")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate2Name")
        ValidationRules.AddRule(AddressOf DateRule, "MiscDate3")
        ValidationRules.AddRule(AddressOf StringRule, "MiscDate3Name")
        ValidationRules.AddRule(AddressOf CheckFileNameRule, "QuestionFileName")
        ValidationRules.AddRule(AddressOf CheckFileNameRule, "ResultFileName")

    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        'ValidationRules.CheckRules()        
    End Sub

    ''' <summary>Insert a new export group.  Then has its child objects insert their values into the data store.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Insert()
        Try
            'TODO:  Wrap in client tran.  Check with Jeff on where to declare tran object.
            Me.ExportGroupID = ExportGroupProvider.Instance.InsertExportGroup(Me)
            'Me.ExportGroupID = ExportGroupID
            Me.ExportSelectedSurvey.ParentExportGroup = Me
            For Each client As ExportClientSelected In Me.ExportSelectedSurvey.ExportClientSelectedCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportClientSelectedProvider.Instance.InsertClient(client, Me.ExportSelectedSurvey.SurveyID, Me.ExportGroupID)
            Next
            For Each script As ExportScriptSelected In Me.ExportSelectedSurvey.ExportScriptSelectedCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportScriptSelectedProvider.Instance.InsertScript(script, Me.ExportSelectedSurvey.SurveyID, Me.ExportGroupID)
            Next
            For Each exportEvent As ExportEventSelected In Me.ExportExcludeEventCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportEventSelectedProvider.Instance.InsertExcludeEvent(exportEvent.EventID, Me.ExportGroupID)
            Next
            For Each exportevent As ExportEventSelected In Me.ExportIncludeEventCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportEventSelectedProvider.Instance.InsertIncludeEvent(exportevent.EventID, Me.ExportGroupID)
            Next

        Catch ex As System.Exception
            Throw New ExportGroupException(ex.Message)
        End Try
    End Sub

    ''' <summary>Updates and existing export group, then deletes its child objects in the data store, and inserts them back in.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub Update()
        Try
            'TODO:  Wrap in client tran.  Check with Jeff on where to declare tran object.
            'This statement must come before the export group update to prevent export to survey has deletion.
            ExportGroupProvider.Instance.DeleteExportGroupChildren(Me.ExportGroupID)
            ExportGroupProvider.Instance.UpdateExportGroup(Me)
            'Me.ExportGroupID = ExportGroupID
            Me.ExportSelectedSurvey.ParentExportGroup = Me
            For Each client As ExportClientSelected In Me.ExportSelectedSurvey.ExportClientSelectedCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportClientSelectedProvider.Instance.InsertClient(client, Me.ExportSelectedSurvey.SurveyID, Me.ExportGroupID)
            Next
            For Each script As ExportScriptSelected In Me.ExportSelectedSurvey.ExportScriptSelectedCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportScriptSelectedProvider.Instance.InsertScript(script, Me.ExportSelectedSurvey.SurveyID, Me.ExportGroupID)
            Next
            For Each exportEvent As ExportEventSelected In Me.ExportExcludeEventCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportEventSelectedProvider.Instance.InsertExcludeEvent(exportEvent.EventID, Me.ExportGroupID)
            Next
            For Each exportevent As ExportEventSelected In Me.ExportIncludeEventCollection
                Nrc.SurveyPoint.Library.DataProviders.ExportEventSelectedProvider.Instance.InsertIncludeEvent(exportevent.EventID, Me.ExportGroupID)
            Next

        Catch ex As System.Exception
            Throw New ExportGroupException(ex.Message)
        End Try
    End Sub

    ''' <summary>This method is not implemented.  Use the Factory delete method instead.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub DeleteImmediate()
        'TODO:  Exception this out, you should never hit it.
        'ExportGroupProvider.Instance.DeleteExportGroup(mExportGroupID)
        ExportGroupProvider.Instance.DeleteExportGroupAll(mExportGroupID)
    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>Checks that the survey associated with the export group exists both in the object and in the data store.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateSurveyExists(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim retMsg As String = ""
        Dim retVal As Boolean = False
        'Check that the survey object exists
        If Me.ExportSelectedSurvey Is Nothing OrElse Me.ExportSelectedSurvey.SurveyID <= 0 Then
            e.Description = "Survey has not been set for export group."
            Return False
        Else
            Dim tempSurvey As ExportSurvey = ExportSurvey.GetSurveyBySurveyID(Me.ExportSelectedSurvey.SurveyID)
            If tempSurvey Is Nothing OrElse tempSurvey.SurveyID <> Me.ExportSelectedSurvey.SurveyID Then
                e.Description = "The survey associated with this export group could not be retrieved from the database."
                Return False
            Else
                Return True
            End If
        End If
    End Function
    ''' <summary>Checks that the selected events exist in the data store.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateIncludedEvents(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        'This validation only need to check if the event still exists in the database.
        Dim retMsg As String = ""
        If Me.ExportIncludeEventCollection Is Nothing OrElse Me.ExportIncludeEventCollection.Count = 0 Then
            Return True

            'TODO: Steve Kennedy - comment this code
        ElseIf Me.ExportIncludeEventCollection.Contains(ExportEventSelected.Get(2401)) And Me.ExportIncludeEventCollection.Count > 1 Then
            retMsg += "If the event '2401' is included in the Included Events, then no other event codes may appear in the Included Events list." & vbCrLf
            e.Description = retMsg
            Return False

        Else
            Dim eventsValid As Boolean = True
            For Each incEvent As ExportEventSelected In Me.ExportIncludeEventCollection
                Dim tempEvent As ExportEventSelected = ExportEventSelected.Get(incEvent.EventID)
                If tempEvent Is Nothing OrElse tempEvent.EventID <> incEvent.EventID Then
                    eventsValid = False
                    retMsg += "Selected event " & incEvent.EventID.ToString & " no longer exists." & vbCrLf
                End If
            Next
            If Not eventsValid Then
                e.Description = retMsg
                Return False
            Else
                Return True
            End If
        End If
    End Function
    ''' <summary>Checks that the events exist in the data store</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateExcludedEvents(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        'This validation only need to check if the event still exists in the database.
        Dim retMsg As String = ""
        If Me.ExportExcludeEventCollection Is Nothing OrElse Me.ExportExcludeEventCollection.Count = 0 Then
            Return True
        Else
            Dim eventsValid As Boolean = True
            For Each exclEvent As ExportEventSelected In Me.ExportExcludeEventCollection
                Dim tempEvent As ExportEventSelected = ExportEventSelected.Get(exclEvent.EventID)
                If tempEvent Is Nothing OrElse tempEvent.EventID <> exclEvent.EventID Then
                    eventsValid = False
                    retMsg += "Excluded event " & exclEvent.EventID.ToString & " no longer exists." & vbCrLf
                End If
            Next
            If Not eventsValid Then
                e.Description = retMsg
                Return False
            Else
                Return True
            End If
        End If
    End Function
    ''' <summary>Checks that an export file layout has been selected for the export group.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateExportFileLayoutExists(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim exportFileLayout As ExportFileLayout = TryCast(CallByName(target, e.PropertyName, CallType.Get), ExportFileLayout)
        Dim retVal As Boolean = False
        Dim retMsg As String = "No File Layout was given."
        If exportFileLayout IsNot Nothing AndAlso exportFileLayout.FileLayoutID > 0 Then
            Return True
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>validates the export group name.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ValidateExportName(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim exName As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        If exName Is Nothing OrElse exName = "" OrElse Trim(exName) = "" Then
            e.Description = "No export name was given."
            Return False
        ElseIf exName.Length > 100 Then
            e.Description = "Export name can not be greater than 100 characters."
            Return False
            'TODO:  Uncomment once SP is in the DB.
        ElseIf ExportGroup.CheckExportGroupByName(exName, Me.ExportGroupID) Then
            e.Description = "Export Name: " & exName & " already exists in the database."
            Return False


        Else
            Return True
        End If
    End Function
    ''' <summary>Checks that the question-file name have valid paths and characters.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function CheckFileNameRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim filePath As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given"
        Dim propDisplayName As String = ""
        If e.PropertyName = "QuestionFileName" Then
            propDisplayName = "Question File Name"
        ElseIf e.PropertyName = "ResultFileName" Then
            propDisplayName = "Result File Name"
        End If
        If filePath Is Nothing OrElse filePath = "" Then
            retVal = False
            retMsg = propDisplayName & " path is empty."
        Else
            Dim Path As String = String.Empty
            Dim fileName As String = String.Empty
            Path = filePath.Substring(0, filePath.LastIndexOf("\"c))
            fileName = filePath.Substring(filePath.LastIndexOf("\"c) + 1)
            fileName = ConvertFileName(fileName)
            Dim invalidFileChars As Char() = System.IO.Path.GetInvalidFileNameChars()
            Dim invalidFolderChars As Char() = System.IO.Path.GetInvalidPathChars()
            Dim lblnInvalidFileName As Boolean = False
            Dim lblnInvlalidFolderName As Boolean = False
            For Each c As Char In invalidFolderChars
                If Path.IndexOf(c) >= 0 Then
                    lblnInvlalidFolderName = True
                    Exit For
                End If
            Next
            For Each c As Char In invalidFileChars
                If fileName.IndexOf(c) >= 0 Then
                    lblnInvalidFileName = True
                End If
            Next
            If lblnInvlalidFolderName Then
                retMsg = propDisplayName & " contains an invalid path."
                retVal = False
            ElseIf lblnInvalidFileName Then
                retMsg = propDisplayName & " contains an invalid characters in the file name."
                retVal = False
            Else
                Dim dir As System.IO.DirectoryInfo = New System.IO.DirectoryInfo(Path)
                If dir.Exists Then
                    Return True
                Else
                    retMsg = propDisplayName & " does not have a valid directory."
                    retVal = False
                End If
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>Helper method to convert (in memory) the file names special charaters %d%t.</summary>
    ''' <param name="name"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function ConvertFileName(ByVal name As String) As String
        Dim retVal As String
        'TODO:  Get business requirements and implment.
        retVal = name
        Dim dteDate As Date = Date.Now()
        Dim strDate As String = dteDate.Year.ToString() & dteDate.Month.ToString & dteDate.Day.ToString
        Dim strTime As String = dteDate.Hour.ToString() & dteDate.Minute.ToString & dteDate.Second.ToString
        retVal = retVal.Replace("%d", strDate)
        retVal = retVal.Replace("%D", strDate)
        retVal = retVal.Replace("%t", strTime)
        retVal = retVal.Replace("%T", strTime)
        Return retVal
    End Function
    ''' <summary>validates string extensions </summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function StringRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given"
        If val IsNot Nothing Then
            If val.Length > 100 Then
                retVal = False
                retMsg = "Export Group Property " & e.PropertyName & ": string length must be under 100 characters."
            Else
                Return True
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>Validate numeric extensions as decimals or nulls.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function NumericRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim decVal As Decimal = 0
        If val IsNot Nothing Then
            If Decimal.TryParse(val, decVal) Then
                Return True
            Else
                e.Description = "Export Group Property " & e.PropertyName & " was given a non numeric value was given."
            End If
        Else
            Return True
        End If
    End Function
    ''' <summary>Validates Date Extensions as data > 1901 or nulls.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function DateRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given"
        If val IsNot Nothing Then
            Dim tempDate As DateTime
            Dim isDate As Boolean = DateTime.TryParse(val, tempDate)
            If isDate = False Then
                retMsg = "Export Group Property " & e.PropertyName & ": A non-date value was given."
                retVal = False
            ElseIf tempDate.Year < 1901 Then
                retMsg = "Export Group Property " & e.PropertyName & ": Date value out of range."
                retVal = False
            Else
                Return True
            End If
        Else
            'Date is nullable.
            Return True
        End If
        e.Description = retMsg
        Return retVal
    End Function


    ''' <summary>This procedure will go through the list of selected events (both included and excluded)
    ''' and remove them from the available list. Events listed in either included or 
    ''' excluded should not be in the available list.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub ResetAvailableEvents()

        For Each IncludedEvent As ExportEventSelected In Me.ExportIncludeEventCollection
            Me.ExportAvailableEventCollection.Remove(ExportEventAvailable.Get(IncludedEvent.EventID))
        Next
        For Each ExcludedEvent As ExportEventSelected In Me.ExportExcludeEventCollection
            Me.ExportAvailableEventCollection.Remove(ExportEventAvailable.Get(ExcludedEvent.EventID))
        Next

    End Sub

    ''' <summary>This procedure populates a collection of export events that will
    ''' populate the excluded export events grid, if the export group is newly
    ''' created.</summary>
    ''' <revision>2008-12-21 Initial Creation</revision>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList>&lt;revision&gt;2008-12-21 Initial Creation&lt;/revision&gt;
    ''' <para> &lt;revision&gt;20080312 - TP - Removed begin and end populate.  This
    ''' invalidates the IsNew flag.&lt;/revision&gt;</para></RevisionList>
    Public Sub PopulateDefaultExcludedEvents()
        'Me.BeginPopulate()
        Me.mExportExcludedEvents = New ExportEventSelectedCollection()
        Me.mExportExcludedEvents.Add(ExportEventSelected.Get(2401))
        ResetAvailableEvents() 'Steve Kennedy - 3/3/08- Removes Them From Available List of Events
        'Me.EndPopulate()
    End Sub

    ''' <summary>This procedure populates a collection of export events that will
    ''' populate the included export events grid, if the export group is newly
    ''' created.</summary>
    ''' <revision>2008-12-21 Initial Creation</revision>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList>&lt;revision&gt;2008-12-21 Initial Creation&lt;/revision&gt;
    ''' <para>20080312 - TP - Removed the begin and end populate because it invalidates
    ''' isnew checks.</para></RevisionList>
    Public Sub PopulateDefaultIncludedEvents()
        'Me.BeginPopulate()
        Me.mExportIncludedEvents = New ExportEventSelectedCollection()
        Me.mExportIncludedEvents.Add(ExportEventSelected.Get(3012))
        Me.mExportIncludedEvents.Add(ExportEventSelected.Get(3022))
        Me.mExportIncludedEvents.Add(ExportEventSelected.Get(3035))
        Me.mExportIncludedEvents.Add(ExportEventSelected.Get(3038))
        ResetAvailableEvents() 'Steve Kennedy - 3/3/08- Removes Them From Available List of Events
        'Me.EndPopulate()
    End Sub

    ''' <summary>Moves the given collection of SelectedEvents to ExportIncludeEventCollection</summary>
    ''' <param name="SelectedEvents"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveToIncludedEvents(ByVal SelectedEvents As ExportEventAvailableCollection)
        MoveEvents(SelectedEvents, Me.ExportIncludeEventCollection)
        PropertyHasChanged("ExportAvailableEventCollection")
        PropertyHasChanged("ExportIncludeEventCollection")
    End Sub
    ''' <summary>Removes the given collection of SelectedEvents to ExportIncludeEventCollection
    ''' and adds them back to the available events collection</summary>
    ''' <param name="SelectedEvents"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveFromIncludedEvents(ByVal SelectedEvents As ExportEventSelectedCollection)
        MoveEvents(SelectedEvents, ExportMoveEventsFromEnum.RemoveFromIncludes)
        PropertyHasChanged("ExportAvailableEventCollection")
        PropertyHasChanged("ExportIncludeEventCollection")
    End Sub
    ''' <summary>Moves the given collection of SelectedEvents to ExportExcludeEventCollection</summary>
    ''' <param name="SelectedEvents"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveToExcludedEvents(ByVal SelectedEvents As ExportEventAvailableCollection)
        MoveEvents(SelectedEvents, Me.ExportExcludeEventCollection)
        PropertyHasChanged("ExportAvailableEventCollection")
        PropertyHasChanged("ExportExcludeEventCollection")
    End Sub
    ''' <summary>Removes the given collection of SelectedEvents to ExportIncludeEventCollection
    ''' and adds them back to the available events collection</summary>
    ''' <param name="SelectedEvents"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub MoveFromExcludedEvents(ByVal SelectedEvents As ExportEventSelectedCollection)
        MoveEvents(SelectedEvents, ExportMoveEventsFromEnum.RemoveFromExcludes)
        PropertyHasChanged("ExportAvailableEventCollection")
        PropertyHasChanged("ExportExcludeEventCollection")
    End Sub

    ''' <summary>Takes in a list of available events and adds them directly to a selected events collection by ref</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Overloads Sub MoveEvents(ByVal availableEvents As ExportEventAvailableCollection, ByRef selectedEvents As ExportEventSelectedCollection)
        For Each sourceEvent As ExportEventAvailable In availableEvents
            selectedEvents.Add(ExportEventSelected.Get(sourceEvent.EventID))
            Me.ExportAvailableEventCollection.Remove(sourceEvent)
        Next
    End Sub

    ''' <summary>Removes the given selectedevents from Excludes or includes</summary>
    ''' <param name="selectedEvents">the collection of SelectedEvents to remove from the target collection</param>
    ''' <param name="removeFromCollection">Enum defining the target collection to remove the SelectedEvents from</param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Overloads Sub MoveEvents(ByVal selectedEvents As ExportEventSelectedCollection, ByVal removeFromCollection As ExportMoveEventsFromEnum)
        'TODO: SK - Comment This Code
        'From Selected To Available
        For Each sourceEvent As ExportEventSelected In selectedEvents
            AddToAvailableEvents(sourceEvent)
            If removeFromCollection = ExportMoveEventsFromEnum.RemoveFromIncludes Then
                RemoveFromIncludedEvents(sourceEvent)
            End If
            If removeFromCollection = ExportMoveEventsFromEnum.RemoveFromExcludes Then
                RemoveFromExcludedEvents(sourceEvent)
            End If
        Next
    End Sub
    Private Sub AddToAvailableEvents(ByVal sourceEvent As ExportEventSelected)
        Me.ExportAvailableEventCollection.Add(ExportEventAvailable.Get(sourceEvent.EventID))
    End Sub
    Private Sub RemoveFromIncludedEvents(ByVal sourceEvent As ExportEventSelected)
        Me.ExportIncludeEventCollection.Remove(sourceEvent)
    End Sub
    Private Sub RemoveFromExcludedEvents(ByVal sourceEvent As ExportEventSelected)
        Me.ExportExcludeEventCollection.Remove(sourceEvent)
    End Sub



#End Region
#Region "Event Handlers"


    ''' <summary>Notifies the parent ExportGroup that Excluded Events list changed</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mExportExcludedEvents_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mExportExcludedEvents.ListChanged
        Me.PropertyHasChanged("ExportExcludedEvents")
    End Sub

    ''' <summary>Notifies the parent ExportGroup that Included Events list changed</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mExportIncludedEvents_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mExportIncludedEvents.ListChanged
        Me.PropertyHasChanged("ExportIncludedEvents")
    End Sub

    ''' <summary>Notifies the parent ExportGroup that the associated Survey object's property has changed.
    ''' The purpose is to keep track of SelectedClients and SelectedScripts collections since the current
    ''' CSLA implementation won't do that for us.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mExportSelectedSurvey_PropertyChanged(ByVal sender As Object, ByVal e As System.ComponentModel.PropertyChangedEventArgs) Handles mExportSelectedSurvey.PropertyChanged
        Me.PropertyHasChanged("ExportSelectedSurvey")
    End Sub

    ''' <summary>Notifies the ExportGroup objec that ExportGroupExtensions changed</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub mExportGroupExtensionCollection_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles mExportGroupExtensionCollection.ListChanged
        Me.PropertyHasChanged("ExportGroupExtensionCollection")
    End Sub
#End Region
End Class
