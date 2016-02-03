Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportScriptSelected
    Property ScriptID() As Integer
End Interface

''' <summary>This class contains a selectable script.  For the most part a
''' selectable script is one that has extensions.</summary>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>2008-03-13 - Arman Mnatsakanyan</term>
''' <description>Moved the population of the script extensions to the provider
''' class.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class ExportScriptSelected
    Inherits BusinessBase(Of ExportScriptSelected)
    Implements IExportScriptSelected

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
    Private mScriptExtensionID As Integer
    Private mExportGroupID As Integer
    Private mExportScriptExtensionCollection As ExportScriptExtensionCollection

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

#Region " Public Properties "
    ''' <summary>PK for a script</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ScriptID() As Integer Implements IExportScriptSelected.ScriptID
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

    ''' <summary>Key to its parent survey object</summary>
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
    ''' <summary>The type of script it is.</summary>
    ''' <value>integer</value>
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
    ''' <summary>Data store value</summary>
    ''' <value>bit flag</value>
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
    ''' <summary>Data store value</summary>
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
    ''' <summary>Data store value</summary>
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
    ''' <summary>Data store value</summary>
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
    ''' <summary>Data store value</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ScriptExtensionID() As Integer
        Get
            Return mScriptExtensionID
        End Get
        Set(ByVal value As Integer)
            If Not value = mScriptExtensionID Then
                mScriptExtensionID = value
                PropertyHasChanged("ScriptExtensionID")
            End If
        End Set
    End Property
    ''' <summary>ID to the export group this script is tied to.</summary>
    ''' <value>integer</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportGroupID() As Integer
        Get
            Return mExportGroupID
        End Get
        Set(ByVal value As Integer)
            If Not value = mExportGroupID Then
                mExportGroupID = value
                PropertyHasChanged("ExportGroupID")
            End If
        End Set
    End Property


    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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

    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>string script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Decimal script exension property</summary>
    ''' <value>value for a decimal script extension.</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Decimal script exension property</summary>
    ''' <value>value for a decimal script extension.</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Decimal script exension property</summary>
    ''' <value>value for a decimal script extension.</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Date value for a script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Date value for a script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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
    ''' <summary>Date value for a script extension</summary>
    ''' <value>a value for a script extension column</value>
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
    ''' <summary>string script extension friendly column name</summary>
    ''' <value>a value for a script extension column name</value>
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



    ''' <summary>Prop to retrieve the script exention object which is a pivot of the extension properties.</summary>
    ''' <value>ExportScriptExtensionCollection</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property ExportScriptExtensionCollection() As ExportScriptExtensionCollection
        Get
            Return mExportScriptExtensionCollection
        End Get
        Set(ByVal value As ExportScriptExtensionCollection)
            mExportScriptExtensionCollection = value
        End Set
    End Property

#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    ''' <summary>Factory to create a new selected script</summary>
    ''' <returns>ExportScriptSelected</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function NewExportScriptSelected() As ExportScriptSelected
        Return New ExportScriptSelected
    End Function


    ''' <summary>Factory to retrieve a script from the db tied to export group and survey</summary>
    ''' <param name="exportGroup"></param>
    ''' <param name="survey"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function GetScriptsByExportGroupAndSurvey(ByVal exportGroup As ExportGroup, ByVal survey As ExportSurvey) As ExportScriptSelectedCollection
        'TODO: Implement
        Return ExportScriptSelectedProvider.Instance.SelectSelectedExportScripts(exportGroup, survey)
        Return Nothing
    End Function

    ''' <summary>Factory to retrieve a script from the db by its ID.</summary>
    ''' <param name="scriptID"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared Function [Get](ByVal scriptID As Integer) As ExportScriptSelected
        Return ExportScriptSelectedProvider.Instance.GetScriptByScriptID(scriptID)
    End Function
#End Region

#Region " Basic Overrides "
    ''' <summary>Uniquely IDs the object whether new or existing.</summary>
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
    ''' <summary>Wires the validation methods to properties of the object</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Overrides Sub AddBusinessRules()
        'Add validation rules here...
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
    End Sub
#End Region

#Region " Data Access "
    Protected Overrides Sub CreateNew()
        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()
    End Sub
    ''' <summary>Saves will be done by the parent object, so this is not implemented.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Cannot save.  Business object doesn't represent a table of view")
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>Validates that the script extension is a string or null</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function StringRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given for script property."
        If val IsNot Nothing Then
            If val.Length > 100 Then
                retVal = False
                retMsg = "Script Property " & e.PropertyName & ": string length must be under 100 characters."
            Else
                Return True
            End If
        End If
        e.Description = retMsg
        Return retVal
    End Function
    ''' <summary>Decimal validation for a script extension.</summary>
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
                e.Description = "Script Property " & e.PropertyName & " was given a non numeric value was given."
                Return False
            End If
        Else
            'Null values are allowed.
            Return True
        End If
    End Function
    ''' <summary>data validation for a script extension.</summary>
    ''' <param name="target"></param>
    ''' <param name="e"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Function DateRule(ByVal target As Object, ByVal e As RuleArgs) As Boolean
        Dim val As String = TryCast(CallByName(target, e.PropertyName, CallType.Get), System.String)
        Dim retVal As Boolean = False
        Dim retMsg As String = "Invalid value given for script property"
        If val IsNot Nothing Then
            Dim tempDate As DateTime
            Dim isDate As Boolean = DateTime.TryParse(val, tempDate)
            If isDate = False Then
                retMsg = "Script Property " & e.PropertyName & ": A non-date value was given."
                retVal = False
            ElseIf tempDate.Year < 1901 Then
                retMsg = "Script Property " & e.PropertyName & ": Date value out of range."
                retVal = False
            Else
                Return True
            End If
        Else
            'Nulls are allowed.
            Return True
        End If
        e.Description = retMsg
        Return retVal
    End Function
#End Region

End Class
