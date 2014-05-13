Public Interface IOneClickDefinition

    Property OneClickDefinitionId() As Integer

End Interface

Public Class OneClickDefinition
    Implements IOneClickDefinition

#Region " Private Fields "

    Private mOneClickDefinitionId As Integer
    Private mOneClickTypeId As Integer
    Private mCategoryName As String
    Private mOneClickReportName As String
    Private mOneClickReportDescription As String
    Private mReportId As Integer
    Private mOrder As Integer

    Protected mIsDirty As Boolean = False

#End Region

#Region " Public Properties "

    Public Property OneClickDefinitionId() As Integer Implements IOneClickDefinition.OneClickDefinitionId
        Get
            Return mOneClickDefinitionId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mOneClickDefinitionId Then
                mOneClickDefinitionId = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property OneClickTypeId() As Integer
        Get
            Return mOneClickTypeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mOneClickTypeId Then
                mOneClickTypeId = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property CategoryName() As String
        Get
            Return mCategoryName
        End Get
        Set(ByVal value As String)
            If Not value = mCategoryName Then
                mCategoryName = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property OneClickReportName() As String
        Get
            Return mOneClickReportName
        End Get
        Set(ByVal value As String)
            If Not value = mOneClickReportName Then
                mOneClickReportName = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property OneClickReportDescription() As String
        Get
            Return mOneClickReportDescription
        End Get
        Set(ByVal value As String)
            If Not value = mOneClickReportDescription Then
                mOneClickReportDescription = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property ReportId() As Integer
        Get
            Return mReportId
        End Get
        Set(ByVal value As Integer)
            If Not value = mReportId Then
                mReportId = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal value As Integer)
            If Not value = mOrder Then
                mOrder = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property


    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (mOneClickDefinitionId = 0)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub


    Public Sub New(ByVal oneClickTypeId As Integer)

        Me.OneClickTypeId = oneClickTypeId

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function [Get](ByVal oneClickDefinitionId As Integer) As OneClickDefinition

        Return DataProvider.Instance.SelectOneClickDefinition(oneClickDefinitionId)

    End Function


    Public Shared Function GetByOneClickType(ByVal oneClickTypeId As Integer) As Collection(Of OneClickDefinition)

        Return DataProvider.Instance.SelectOneClickDefinitionsByOneClickType(oneClickTypeId)

    End Function


    Public Shared Function GetAll() As Collection(Of OneClickDefinition)

        Return DataProvider.Instance.SelectAllOneClickDefinitions()

    End Function


    Public Shared Function CreateNew(ByVal oneClickTypeId As Integer, ByVal categoryName As String, _
                                     ByVal oneClickReportName As String, ByVal oneClickReportDescription As String, _
                                     ByVal reportId As Integer, ByVal order As Integer) As OneClickDefinition

        Return DataProvider.Instance.InsertOneClickDefinition(oneClickTypeId, categoryName, oneClickReportName, _
                                                              oneClickReportDescription, reportId, order)

    End Function


    Public Sub Insert()

        Dim oneClickDef As OneClickDefinition = CreateNew(mOneClickTypeId, mCategoryName, mOneClickReportName, mOneClickReportDescription, mReportId, mOrder)
        mOneClickDefinitionId = oneClickDef.OneClickDefinitionId
        ResetDirtyFlag()

    End Sub


    Public Sub Update()

        DataProvider.Instance.UpdateOneClickDefinition(Me)
        ResetDirtyFlag()

    End Sub


    Public Shared Sub Delete(ByVal oneClickDefinitionId As Integer)

        DataProvider.Instance.DeleteOneClickDefinition(oneClickDefinitionId)

    End Sub


    Public Shared Sub DeleteByOneClickType(ByVal oneClickTypeId As Integer)

        DataProvider.Instance.DeleteOneClickDefinitionsByOneClickType(oneClickTypeId)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub ResetDirtyFlag()

        Me.mIsDirty = False

    End Sub

#End Region

End Class
