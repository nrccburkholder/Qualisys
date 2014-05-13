Public Interface IOneClickType

    Property OneClickTypeId() As Integer

End Interface

Public Class OneClickType
    Implements IOneClickType

#Region " Private Fields "

    Private mOneClickTypeId As Integer
    Private mOneClickTypeName As String
    Private mOneClickDefinitions As Collection(Of OneClickDefinition)

    Protected mIsDirty As Boolean = False

#End Region

#Region " Public Properties "

    Public Property OneClickTypeId() As Integer Implements IOneClickType.OneClickTypeId
        Get
            Return mOneClickTypeId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mOneClickTypeId Then
                mOneClickTypeId = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public Property OneClickTypeName() As String
        Get
            Return mOneClickTypeName
        End Get
        Set(ByVal value As String)
            If Not value = mOneClickTypeName Then
                mOneClickTypeName = value
                mIsDirty = True
            End If
        End Set
    End Property


    Public ReadOnly Property Definitions() As Collection(Of OneClickDefinition)
        Get
            'Check to see if this is already populated
            If mOneClickDefinitions Is Nothing Then
                'Lazy populate
                mOneClickDefinitions = OneClickDefinition.GetByOneClickType(mOneClickTypeId)
            End If

            'Return the collection
            Return mOneClickDefinitions
        End Get
    End Property


    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
    End Property


    Public ReadOnly Property IsNew() As Boolean
        Get
            Return (mOneClickTypeId = 0)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

    End Sub

#End Region

#Region " DB CRUD Methods "

    Public Shared Function [Get](ByVal oneClickTypeId As Integer) As OneClickType

        Return DataProvider.Instance.SelectOneClickType(oneClickTypeId)

    End Function


    Public Shared Function GetAll() As Collection(Of OneClickType)

        Return DataProvider.Instance.SelectAllOneClickTypes()

    End Function


    Public Shared Function CreateNew(ByVal oneClickTypeName As String) As OneClickType

        Return DataProvider.Instance.InsertOneClickType(oneClickTypeName)

    End Function


    Public Sub Insert()

        'Create a new one click type
        Dim oneClickType As OneClickType = CreateNew(mOneClickTypeName)

        'Save the id
        mOneClickTypeId = oneClickType.OneClickTypeId

        'Save any definitions
        For Each definition As OneClickDefinition In Definitions
            definition.Insert()
        Next

        'Reset the dirty flag
        ResetDirtyFlag()

    End Sub


    Public Sub Update()

        'Update the type record
        DataProvider.Instance.UpdateOneClickType(Me)

        'Update the definitions
        For Each definition As OneClickDefinition In Definitions
            If definition.IsNew Then
                definition.Insert()
            ElseIf definition.IsDirty Then
                definition.Update()
            End If
        Next

        'Reset the dirty flag
        ResetDirtyFlag()

    End Sub


    Public Shared Sub Delete(ByVal oneClickTypeId As Integer)

        'Delete the definitions associated with this type
        OneClickDefinition.DeleteByOneClickType(oneClickTypeId)

        'Delete this type
        DataProvider.Instance.DeleteOneClickType(oneClickTypeId)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub ResetDirtyFlag()

        Me.mIsDirty = False

    End Sub

#End Region

End Class
