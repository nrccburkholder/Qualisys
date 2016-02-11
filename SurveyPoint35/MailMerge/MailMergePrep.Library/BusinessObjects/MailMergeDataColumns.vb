Imports PS.Framework.BusinessLogic
Imports System.Data
Imports System.IO

#Region " Key Interface "
Public Interface IMailMergeDataColumn
    Property MailMergeDataColumnID() As Integer
End Interface
#End Region
#Region " MailMergeDataColumn Class "
Public Class MailMergeDataColumn
    Inherits BusinessBase(Of MailMergeDataColumn)
    Implements IMailMergeDataColumn

#Region " Field Definitions "
    Private mInstanceGuid As Guid = Guid.NewGuid()
    Private mMailMergeDataColumnID As Integer
    Private mFileColumnName As String = String.Empty
    Private mTemplateColumnName As String = String.Empty
    Private mWidth As Nullable(Of Integer) = Nothing
    Private mSchemaType As String = String.Empty
    Private mIsRequired As Boolean = False
    Private mMinValue As Nullable(Of Integer) = Nothing
    Private mMaxValue As Nullable(Of Integer) = Nothing
    Private mDefaultOrdinal As Integer

#End Region

#Region " Properties "
    Public Property MailMergeDataColumnID() As Integer Implements IMailMergeDataColumn.MailMergeDataColumnID
        Get
            Return Me.mMailMergeDataColumnID
        End Get
        Set(ByVal value As Integer)
            Me.mMailMergeDataColumnID = value
        End Set
    End Property
    Public Property FileColumnName() As String
        Get
            Return Me.mFileColumnName
        End Get
        Set(ByVal value As String)
            If Not (Me.mFileColumnName = value) Then
                Me.mFileColumnName = value
                PropertyHasChanged("FileColumnName")
            End If
        End Set
    End Property
    Public Property TemplateColumnName() As String
        Get
            Return Me.mTemplateColumnName
        End Get
        Set(ByVal value As String)
            If Not (Me.mTemplateColumnName = value) Then
                Me.mTemplateColumnName = value
                PropertyHasChanged("TemplateColumnName")
            End If
        End Set
    End Property
    Public Property Width() As Nullable(Of Integer)
        Get
            Return Me.mWidth
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Me.mWidth = value
            PropertyHasChanged("Width")
        End Set
    End Property
    Public Property SchemaType() As String
        Get
            Return Me.mSchemaType
        End Get
        Set(ByVal value As String)
            If Not (Me.mSchemaType = value) Then
                Me.mSchemaType = value
                PropertyHasChanged("SchemaType")
            End If
        End Set
    End Property
    Public Property IsRequired() As Boolean
        Get
            Return Me.mIsRequired
        End Get
        Set(ByVal value As Boolean)
            If Not (Me.IsRequired = value) Then
                Me.mIsRequired = value
                PropertyHasChanged("IsRequired")
            End If
        End Set
    End Property
    Public Property MinValue() As Nullable(Of Integer)
        Get
            Return Me.mMinValue
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Me.mMinValue = value
            PropertyHasChanged("MinValue")
        End Set
    End Property
    Public Property MaxValue() As Nullable(Of Integer)
        Get
            Return Me.mMaxValue
        End Get
        Set(ByVal value As Nullable(Of Integer))
            Me.mMaxValue = value
            PropertyHasChanged("MaxValue")
        End Set
    End Property
    Public Property DefaultOrdinal() As Integer
        Get
            Return Me.mDefaultOrdinal
        End Get
        Set(ByVal value As Integer)
            If Not (Me.mDefaultOrdinal = value) Then
                Me.mDefaultOrdinal = value
                PropertyHasChanged("DefaultOrdinal")
            End If
        End Set
    End Property
#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

#Region " Factory Calls "
    Public Shared Function NewMailMergeDataColumn() As MailMergeDataColumn
        Return New MailMergeDataColumn
    End Function
    Public Shared Function GetMailMergeDataColumns() As MailMergeDataColumns
        Return MailMergeDataColumnProvider.Instance.GetMailMergeDataColumns
    End Function
#End Region

#Region " Overrides "
    Protected Overrides Sub Delete()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Insert()
        Throw New NotImplementedException()
    End Sub
    Protected Overrides Sub Update()
        Throw New NotImplementedException()
    End Sub
#End Region

#Region " Validation Rules "
    Protected Overrides Sub AddBusinessRules()
        'This object with do object level validation rather than property based.
    End Sub
#End Region

#Region " Execution Methods "

#End Region

#Region " Helper Methods "

#End Region
End Class
#End Region


#Region " MailMergeDataColumns Collection Class "
Public Class MailMergeDataColumns
    Inherits BusinessListBase(Of MailMergeDataColumn)
    Public Function FindColumn(ByVal columnName As String) As MailMergeDataColumn
        For Each col As MailMergeDataColumn In Me
            If (columnName = col.FileColumnName) Then
                Return col
            End If
        Next
        Return Nothing
    End Function
    Public Function FindTemplateColumn(ByVal columnName As String) As MailMergeDataColumn
        For Each col As MailMergeDataColumn In Me
            If (columnName = col.TemplateColumnName) Then
                Return col
            End If
        Next
        Return Nothing
    End Function
End Class
#End Region


#Region " Data Base Class "
Public MustInherit Class MailMergeDataColumnProvider
#Region " Singleton Implementation "
    Private Shared mInstance As MailMergeDataColumnProvider
    Private Const mProviderName As String = "MailMergeDataColumnProvider"
    ''' <summary>Retrieves the instance of the Data provider class that will implement the abstract methods.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property Instance() As MailMergeDataColumnProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of MailMergeDataColumnProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region
#Region " Constructors "
    Protected Sub New()
    End Sub
#End Region
#Region " Abstract Methods "
    Public MustOverride Function GetMailMergeDataColumns() As MailMergeDataColumns
#End Region
End Class
#End Region
