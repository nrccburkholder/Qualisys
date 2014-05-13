Imports System.Data

Public Class FixedColumn

    Private mName As String = String.Empty
    Private mNRCName As String = String.Empty
    Private mDataType As String = String.Empty
    Private mQuantity As Integer
    Private mMappingID As Integer
    Private mRecodes As Dictionary(Of String, String)

    Public ReadOnly Property Name() As String
        Get
            Return mName
        End Get
    End Property

    Public ReadOnly Property NRCName() As String
        Get
            Return mNRCName
        End Get
    End Property

    Public ReadOnly Property DataType() As String
        Get
            Return mDataType
        End Get
    End Property

    Public ReadOnly Property Recodes() As Dictionary(Of String, String)
        Get
            If mRecodes Is Nothing Then
                mRecodes = New Dictionary(Of String, String)
                If mMappingID > 0 Then
                    Dim recodeTable As DataTable = TranslatorProvider.Instance.SelectTranslationModuleMappingRecodes(mMappingID)

                    'Populate the recode dictionary
                    For Each recode As DataRow In recodeTable.Rows
                        mRecodes.Add(recode.Item("OrigValue").ToString, recode.Item("NewValue").ToString)
                    Next
                End If
            End If

            Return mRecodes
        End Get
    End Property

    Public Property Quantity() As Integer
        Get
            Return mQuantity
        End Get
        Set(ByVal value As Integer)
            mQuantity = value
        End Set
    End Property

    Public Sub New(ByVal name As String, ByVal dataType As String)

        mName = name
        mNRCName = String.Empty
        mDataType = dataType
        mQuantity = 0
        mMappingID = -1

    End Sub

    Public Sub New(ByVal name As String, ByVal nrcName As String, ByVal dataType As String)

        mName = name
        mNRCName = nrcName
        mDataType = dataType
        mQuantity = 0
        mMappingID = -1

    End Sub

    Public Sub New(ByVal mappingID As Integer, ByVal name As String, ByVal dataType As String)

        mName = name
        mNRCName = String.Empty
        mDataType = dataType
        mQuantity = 0
        mMappingID = mappingID

    End Sub

    Public Sub New(ByVal mappingID As Integer, ByVal name As String, ByVal nrcName As String, ByVal dataType As String)

        mName = name
        mNRCName = nrcName
        mDataType = dataType
        mQuantity = 0
        mMappingID = mappingID

    End Sub

End Class
