Namespace Configuration

    Public Interface IParam

        Property ParamID() As Integer

    End Interface

    <Serializable()> _
    Public Class Param
        Inherits BusinessBase(Of Param)
        Implements IParam

#Region " Private Fields "

        <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
        Private mParamID As Integer
        Private mName As String = String.Empty
        Private mType As ParamTypes
        Private mGroup As String = String.Empty
        Private mStringValue As String = String.Empty
        Private mIntegerValue As Integer
        Private mDateValue As Date
        Private mComment As String = String.Empty

#End Region

#Region " Public Properties "

        Public Property ParamID() As Integer Implements IParam.ParamID
            Get
                Return mParamID
            End Get
            Private Set(ByVal value As Integer)
                If Not value = mParamID Then
                    mParamID = value
                    PropertyHasChanged("ParamID")
                End If
            End Set
        End Property

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

        Public Property Type() As ParamTypes
            Get
                Return mType
            End Get
            Set(ByVal value As ParamTypes)
                If Not value = mType Then
                    mType = value
                    PropertyHasChanged("Type")
                End If
            End Set
        End Property

        Public Property Group() As String
            Get
                Return mGroup
            End Get
            Set(ByVal value As String)
                If value Is Nothing Then value = String.Empty
                If Not value = mGroup Then
                    mGroup = value
                    PropertyHasChanged("Group")
                End If
            End Set
        End Property

        Public Property StringValue() As String
            Get
                Return mStringValue
            End Get
            Set(ByVal value As String)
                If value Is Nothing Then value = String.Empty
                If Not value = mStringValue Then
                    mStringValue = value
                    PropertyHasChanged("StringValue")
                End If
            End Set
        End Property

        Public Property IntegerValue() As Integer
            Get
                Return mIntegerValue
            End Get
            Set(ByVal value As Integer)
                If Not value = mIntegerValue Then
                    mIntegerValue = value
                    PropertyHasChanged("IntegerValue")
                End If
            End Set
        End Property

        Public Property DateValue() As Date
            Get
                Return mDateValue
            End Get
            Set(ByVal value As Date)
                If Not value = mDateValue Then
                    mDateValue = value
                    PropertyHasChanged("DateValue")
                End If
            End Set
        End Property

        Public Property Comment() As String
            Get
                Return mComment
            End Get
            Set(ByVal value As String)
                If value Is Nothing Then value = String.Empty
                If Not value = mComment Then
                    mComment = value
                    PropertyHasChanged("Comment")
                End If
            End Set
        End Property

#End Region

#Region " Constructors "

        Private Sub New()

            Me.CreateNew()

        End Sub

#End Region

#Region " Factory Methods "

        Public Shared Function NewParam() As Param

            Return New Param

        End Function

        Public Shared Function [Get](ByVal paramID As Integer) As Param

            Return ParamProvider.Instance.Select(paramID)

        End Function

        Public Shared Function GetAll() As ParamCollection

            Return ParamProvider.Instance.SelectAll()

        End Function

#End Region

#Region " Basic Overrides "

        Protected Overrides Function GetIdValue() As Object

            If Me.IsNew Then
                Return mInstanceGuid
            Else
                Return mParamID
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

#End Region

    End Class

End Namespace
