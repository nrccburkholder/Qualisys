Imports System.ComponentModel

Public MustInherit Class BusinessBase(Of T)
    Implements System.ComponentModel.INotifyPropertyChanged
    Implements IDataErrorInfo

    Public Event PropertyChanged(ByVal sender As Object, ByVal e As System.ComponentModel.PropertyChangedEventArgs) Implements System.ComponentModel.INotifyPropertyChanged.PropertyChanged

    Private mIsDirty As Boolean = False
    Private mIsNew As Boolean = True
    Private mIsDeleted As Boolean = False
    'Keeps track of whether we should raise property changed events or not
    Private mSupressEvents As Boolean = False
    Protected Sub New()
        AddBusinessRules()
        ValidationRules.CheckRules()
    End Sub

    Public ReadOnly Property IsDirty() As Boolean
        Get
            Return Me.mIsDirty
        End Get
    End Property
    Public ReadOnly Property IsNew() As Boolean
        Get
            Return Me.mIsNew
        End Get
    End Property
    Public ReadOnly Property IsDeleted() As Boolean
        Get
            Return Me.mIsDeleted
        End Get
    End Property
    Public Sub MarkDirty()
        Me.mIsDirty = True
    End Sub
    Public Sub MarkDeleted()
        Me.mIsDeleted = True
    End Sub
    Public Sub MarkOld()
        Me.mIsNew = False
    End Sub
    Public Overridable Sub BeginPopulate()
        'Don't raise events while populating
        Me.mSupressEvents = True
    End Sub
    Public Overridable Sub EndPopulate()
        'Reenable events again
        Me.mSupressEvents = False

        'Validate the object
        ValidationRules.CheckRules()

        'Mark the object as old
        Me.MarkOld()
    End Sub
    Public Overridable Sub Save()
        If Me.IsDeleted Then
            If Me.IsValid Then
                Delete()
            End If
        ElseIf Me.IsNew Then
            If Me.IsValid Then
                Insert()
            End If
        ElseIf Me.IsDirty Then
            If Me.IsValid Then
                Update()
            End If
        End If
    End Sub
    Protected MustOverride Sub Insert()
    Protected MustOverride Sub Update()
    Protected MustOverride Sub Delete()
    Public Overridable Function ToXML() As String
        Throw New NotImplementedException
    End Function
    Public Overridable Function ToDataSet() As System.Data.DataSet
        Throw New NotImplementedException
    End Function
    ''' <summary>
    ''' Performs processing required when a property
    ''' has changed.
    ''' </summary>
    ''' <remarks>
    ''' This method calls CheckRules(propertyName), MarkDirty and
    ''' OnPropertyChanged(propertyName). MarkDirty is called such
    ''' that no event is raised for IsDirty, so only the specific
    ''' property changed event for the current property is raised.
    ''' </remarks>
    Protected Sub PropertyHasChanged(ByVal propertyName As String)
        If Not Me.mSupressEvents Then
            ValidationRules.CheckRules(propertyName)
            MarkDirty()
            RaiseEvent PropertyChanged(Me, New PropertyChangedEventArgs(propertyName))
        End If
    End Sub
    Protected Overridable Sub CreateNew()

    End Sub
#Region " ValidationRules, IsValid "

    Private mValidationRules As Validation.ValidationRules

    ''' <summary>
    ''' Provides access to the broken rules functionality.
    ''' </summary>
    ''' <remarks>
    ''' This property is used within your business logic so you can
    ''' easily call the AddRule() method to associate validation
    ''' rules with your object's properties.
    ''' </remarks>
    Protected ReadOnly Property ValidationRules() _
      As Validation.ValidationRules
        Get
            If mValidationRules Is Nothing Then
                mValidationRules = New Validation.ValidationRules(Me)
            End If
            Return mValidationRules
        End Get
    End Property

    ''' <summary>
    ''' Override this method in your business class to
    ''' be notified when you need to set up business
    ''' rules.
    ''' </summary>
    ''' <remarks>
    ''' AddBusinessRules is automatically called by CSLA .NET
    ''' when your object should associate validation rules
    ''' with its properties.
    ''' </remarks>
    Protected Overridable Sub AddBusinessRules()

    End Sub

    ''' <summary>
    ''' Returns <see langword="true" /> if the object is currently valid, <see langword="false" /> if the
    ''' object has broken rules or is otherwise invalid.
    ''' </summary>
    ''' <remarks>
    ''' <para>
    ''' By default this property relies on the underling ValidationRules
    ''' object to track whether any business rules are currently broken for this object.
    ''' </para><para>
    ''' You can override this property to provide more sophisticated
    ''' implementations of the behavior. For instance, you should always override
    ''' this method if your object has child objects, since the validity of this object
    ''' is affected by the validity of all child objects.
    ''' </para>
    ''' </remarks>
    ''' <returns>A value indicating if the object is currently valid.</returns>
    <Browsable(False)> _
    Public Overridable ReadOnly Property IsValid() As Boolean
        Get
            Return ValidationRules.IsValid
        End Get
    End Property

    ''' <summary>
    ''' Provides access to the readonly collection of broken business rules
    ''' for this object.
    ''' </summary>
    ''' <returns>A Csla.Validation.RulesCollection object.</returns>
    <Browsable(False)> _
    <EditorBrowsable(EditorBrowsableState.Advanced)> _
    Public Overridable ReadOnly Property BrokenRulesCollection() _
      As Validation.BrokenRulesCollection
        Get
            Return ValidationRules.GetBrokenRules
        End Get
    End Property

#End Region
#Region "IDataError"
    Private ReadOnly Property [Error]() As String _
          Implements System.ComponentModel.IDataErrorInfo.Error
        Get
            If Not IsValid Then
                Return ValidationRules.GetBrokenRules.ToString

            Else
                Return ""
            End If
        End Get
    End Property

    Private ReadOnly Property Item(ByVal columnName As String) As String _
      Implements System.ComponentModel.IDataErrorInfo.Item
        Get
            Dim result As String = ""
            If Not IsValid Then
                Dim rule As Validation.BrokenRule = _
                  ValidationRules.GetBrokenRules.GetFirstBrokenRule(columnName)
                If rule IsNot Nothing Then
                    result = rule.Description()
                End If
            End If
            Return result
        End Get
    End Property
#End Region
End Class