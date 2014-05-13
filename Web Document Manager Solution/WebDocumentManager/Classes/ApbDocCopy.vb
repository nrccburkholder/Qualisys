Option Explicit On 
Option Strict On

Imports System.Collections.Specialized

Public Class ApbDocCopy

#Region " Public Members"

    Public Enum DocumentExistStatus
        Unknown = 0
        Exist = 1
        NotExist = 2
    End Enum

#End Region

#Region " Private Members"

    Private mStartNodeID As Integer
    Private mSubNodeNames As New StringCollection
    Private mNodeID As Integer = 0  'the node for document to place
    Private mDocumentNodeID As Integer = 0
    Private mStartNodePath As String
    Private mSubNodePath As String      'not include document name
    Private mDocumentName As String
    Private mPosted As Boolean = False      'Flag indicates this entry is posted or not

    Private mDocumentExisting As DocumentExistStatus = DocumentExistStatus.Unknown  'Doc already exists?
    Private mExistDocumentNodeID As Integer = 0 'Document node ID for existing entry
    Private mExistDocumentID As Integer = 0 'Document ID for existing entry
    Private mReplaceExistingDocument As Boolean = False 'Flag indicates replace the existing doc or not

#End Region

    Public Property StartNodeID() As Integer
        Get
            Return mStartNodeID
        End Get
        Set(ByVal Value As Integer)
            mStartNodeID = Value
        End Set
    End Property

    Public Property SubNodeNames() As StringCollection
        Get
            Return mSubNodeNames
        End Get
        Set(ByVal Value As StringCollection)
            mSubNodeNames = Value
        End Set
    End Property

    Public Property DocumentName() As String
        Get
            Return mDocumentName
        End Get
        Set(ByVal Value As String)
            mDocumentName = Value
        End Set
    End Property

    Public Property NodeID() As Integer
        Get
            Return mNodeID
        End Get
        Set(ByVal Value As Integer)
            mNodeID = Value
        End Set
    End Property

    Public Property DocumentNodeID() As Integer
        Get
            Return mDocumentNodeID
        End Get
        Set(ByVal Value As Integer)
            mDocumentNodeID = Value
        End Set
    End Property

    Public Property StartNodePath() As String
        Get
            Return mStartNodePath
        End Get
        Set(ByVal Value As String)
            mStartNodePath = Value
        End Set
    End Property

    Public Property SubNodePath() As String
        Get
            Return mSubNodePath
        End Get
        Set(ByVal Value As String)
            mSubNodePath = Value
        End Set
    End Property

    Public ReadOnly Property FullNodePath() As String
        Get
            Return mStartNodePath + "\" + mSubNodePath
        End Get
    End Property

    Public ReadOnly Property FullPath() As String
        Get
            Return mStartNodePath + "\" + mSubNodePath + "\" + mDocumentName
        End Get
    End Property

    Public Property DocumentExisting() As DocumentExistStatus
        Get
            Return mDocumentExisting
        End Get
        Set(ByVal Value As DocumentExistStatus)
            mDocumentExisting = Value
        End Set
    End Property

    Public Property ExistDocumentNodeID() As Integer
        Get
            Return mExistDocumentNodeID
        End Get
        Set(ByVal Value As Integer)
            mExistDocumentNodeID = Value
        End Set
    End Property

    Public Property ExistNodeID() As Integer
        Get
            Return mNodeID
        End Get
        Set(ByVal Value As Integer)
            mNodeID = Value
        End Set
    End Property

    Public Property ExistDocumentID() As Integer
        Get
            Return mExistDocumentID
        End Get
        Set(ByVal Value As Integer)
            mExistDocumentID = Value
        End Set
    End Property

    Public Property ReplaceExistingDocument() As Boolean
        Get
            Return mReplaceExistingDocument
        End Get
        Set(ByVal Value As Boolean)
            mReplaceExistingDocument = Value
        End Set
    End Property

    Public Property Posted() As Boolean
        Get
            Return mPosted
        End Get
        Set(ByVal Value As Boolean)
            mPosted = Value
        End Set
    End Property

    Public Sub New()

    End Sub

    Public Sub New(ByVal startNodeID As Integer, ByVal documentName As String)
        mStartNodeID = startNodeID
        mDocumentName = documentName
    End Sub

    Public Sub New(ByVal startNodeID As Integer, ByVal documentName As String, ByVal startNodePath As String)
        mStartNodeID = startNodeID
        mDocumentName = documentName
        mStartNodePath = startNodePath
    End Sub

End Class
