Public Interface IOneClickReport

    Property Id() As Integer

End Interface

Public Class OneClickReport
    Implements IOneClickReport

#Region " Private Fields "

    Private mId As Integer = 0
    Private mClientuserId As Integer
    Private mCategoryName As String
    Private mName As String
    Private mDescription As String
    Private mReportId As Integer
    Private mOrder As Integer

    Protected mIsDirty As Boolean = False

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IOneClickReport.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property ClientuserId() As Integer
        Get
            Return mClientuserId
        End Get
        Set(ByVal value As Integer)
            If Not value = mClientuserId Then
                mClientuserId = value
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


    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If Not value = mName Then
                mName = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If Not value = mDescription Then
                mDescription = value
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
            Return (mId = 0)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub


    Public Sub New(ByVal clientUserId As Integer)

        Me.ClientuserId = clientUserId

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function [Get](ByVal id As Integer) As OneClickReport

        Return DataProvider.Instance.SelectOneClickReport(id)

    End Function


    Public Shared Function GetAll() As Collection(Of OneClickReport)

        Return DataProvider.Instance.SelectAllOneClickReports()

    End Function


    Public Shared Function GetByClientUserId(ByVal clientUserId As Integer) As Collection(Of OneClickReport)

        Return DataProvider.Instance.SelectOneClickReportsByClientUserId(clientUserId)

    End Function


    Public Shared Function CreateNew(ByVal clientuserId As Integer, ByVal categoryName As String, ByVal name As String, _
                                     ByVal description As String, ByVal reportId As Integer, ByVal order As Integer) As OneClickReport

        Return DataProvider.Instance.InsertOneClickReport(clientuserId, categoryName, name, description, reportId, order)

    End Function


    Public Sub Insert()

        Dim oneClick As OneClickReport = CreateNew(mClientuserId, mCategoryName, mName, mDescription, mReportId, mOrder)
        mId = oneClick.Id
        ResetDirtyFlag()

    End Sub


    Public Sub Update()

        DataProvider.Instance.UpdateOneClickReport(Me)
        ResetDirtyFlag()

    End Sub


    Public Shared Sub Delete(ByVal id As Integer)

        DataProvider.Instance.DeleteOneClickReport(id)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub ResetDirtyFlag()

        Me.mIsDirty = False

    End Sub

#End Region

End Class
