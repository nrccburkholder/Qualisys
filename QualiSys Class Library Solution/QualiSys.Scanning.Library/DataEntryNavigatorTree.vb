Imports NRC.Framework.BusinessLogic

Public Interface IDataEntryNavigatorTree

    Property BatchID() As Integer

End Interface

<Serializable()> _
Public Class DataEntryNavigatorTree
    Inherits BusinessBase(Of DataEntryNavigatorTree)
    Implements IDataEntryNavigatorTree

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mBatchID As Integer
    Private mBatchName As String = String.Empty
    Private mTemplateName As String = String.Empty
    Private mQuantity As Integer
    Private mQuantityKeyed As Integer
    Private mQuantityVerified As Integer
    Private mDataEntryMode As DataEntryModes
    Private mLocked As Boolean

#End Region

#Region " Public Properties "

    Public Property BatchID() As Integer Implements IDataEntryNavigatorTree.BatchID
        Get
            Return mBatchID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mBatchID Then
                mBatchID = value
                PropertyHasChanged("BatchID")
            End If
        End Set
    End Property

    Public Property BatchName() As String
        Get
            Return mBatchName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mBatchName Then
                mBatchName = value
                PropertyHasChanged("BatchName")
            End If
        End Set
    End Property

    Public Property TemplateName() As String
        Get
            Return mTemplateName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTemplateName Then
                mTemplateName = value
                PropertyHasChanged("TemplateName")
            End If
        End Set
    End Property

    Public Property Quantity() As Integer
        Get
            Return mQuantity
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuantity Then
                mQuantity = value
                PropertyHasChanged("Quantity")
            End If
        End Set
    End Property

    Public Property QuantityKeyed() As Integer
        Get
            Return mQuantityKeyed
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuantityKeyed Then
                mQuantityKeyed = value
                PropertyHasChanged("QuantityKeyed")
            End If
        End Set
    End Property

    Public Property QuantityVerified() As Integer
        Get
            Return mQuantityVerified
        End Get
        Set(ByVal value As Integer)
            If Not value = mQuantityVerified Then
                mQuantityVerified = value
                PropertyHasChanged("QuantityVerified")
            End If
        End Set
    End Property

    Public Property DataEntryMode() As DataEntryModes
        Get
            Return mDataEntryMode
        End Get
        Set(ByVal value As DataEntryModes)
            If Not value = mDataEntryMode Then
                mDataEntryMode = value
                PropertyHasChanged("DataEntryMode")
            End If
        End Set
    End Property

    Public Property Locked() As Boolean
        Get
            Return mLocked
        End Get
        Set(ByVal value As Boolean)
            If Not value = mLocked Then
                mLocked = value
                PropertyHasChanged("Locked")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property QuantityRemaining() As Integer
        Get
            If mDataEntryMode = DataEntryModes.Entry Then
                Return mQuantity - mQuantityKeyed
            Else
                Return mQuantity - mQuantityVerified
            End If
        End Get
    End Property

    Public ReadOnly Property TemplateLabel() As String
        Get
            Return String.Format("{0} ({1})", mTemplateName, QuantityRemaining)
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewDataEntryNavigatorTree() As DataEntryNavigatorTree

        Return New DataEntryNavigatorTree

    End Function

    Public Shared Function GetAll(ByVal userName As String) As DataEntryNavigatorTreeCollection

        Return DataEntryNavigatorTreeProvider.Instance.SelectDataEntryNavigatorTree(userName)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mBatchID
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

#End Region

#Region " Public Methods "

    Public Sub IncrementQuantity()

        If mDataEntryMode = DataEntryModes.Entry Then
            mQuantityKeyed += 1
        Else
            mQuantityVerified += 1
        End If

    End Sub

#End Region

End Class


