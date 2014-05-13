Imports System.Reflection
Imports System.ComponentModel
Imports System.Runtime.Serialization

Namespace Core

    ''' <summary>
    ''' This is the non-generic base class from which most
    ''' business objects will be derived.
    ''' </summary>
    ''' <remarks>
    ''' See Chapter 3 for details.
    ''' </remarks>
    <Serializable()> _
    Public MustInherit Class BusinessBase
        Inherits UndoableBase

        Implements IEditableBusinessObject
        'Implements System.ComponentModel.IEditableObject
        Implements ICloneable
        Implements IDataErrorInfo

#Region " Constructors "

        Protected Sub New()

            Initialize()
            AddBusinessRules()

        End Sub

#End Region

#Region " Initialize "

        ''' <summary>
        ''' Override this method to set up event handlers so user
        ''' code in a partial class can respond to events raised by
        ''' generated code.
        ''' </summary>
        Protected Overridable Sub Initialize()
            ' allows a generated class to set up events to be
            ' handled by a partial class containing user code
        End Sub

#End Region

#Region " IsNew, IsDeleted, IsDirty "

        'Keeps track of whether we should raise property changed events or not
        Private mSupressEvents As Boolean = False

        ' keep track of whether we are new, deleted or dirty
        Private mIsNew As Boolean = True
        Private mIsDeleted As Boolean
        Private mIsDirty As Boolean = True

        ''' <summary>
        ''' Returns <see langword="true" /> if this is a new object, 
        ''' <see langword="false" /> if it is a pre-existing object.
        ''' </summary>
        ''' <remarks>
        ''' An object is considered to be new if its primary identifying (key) value 
        ''' doesn't correspond to data in the database. In other words, 
        ''' if the data values in this particular
        ''' object have not yet been saved to the database the object is considered to
        ''' be new. Likewise, if the object's data has been deleted from the database
        ''' then the object is considered to be new.
        ''' </remarks>
        ''' <returns>A value indicating if this object is new.</returns>
        <Browsable(False)> _
        Public ReadOnly Property IsNew() As Boolean Implements IEditableBusinessObject.IsNew
            Get
                Return mIsNew
            End Get
        End Property

        ''' <summary>
        ''' Returns <see langword="true" /> if this object is marked for deletion.
        ''' </summary>
        ''' <remarks>
        ''' CSLA .NET supports both immediate and deferred deletion of objects. This
        ''' property is part of the support for deferred deletion, where an object
        ''' can be marked for deletion, but isn't actually deleted until the object
        ''' is saved to the database. This property indicates whether or not the
        ''' current object has been marked for deletion. If it is <see langword="true" />
        ''' , the object will
        ''' be deleted when it is saved to the database, otherwise it will be inserted
        ''' or updated by the save operation.
        ''' </remarks>
        ''' <returns>A value indicating if this object is marked for deletion.</returns>
        <Browsable(False)> _
        Public ReadOnly Property IsDeleted() As Boolean Implements IEditableBusinessObject.IsDeleted
            Get
                Return mIsDeleted
            End Get
        End Property

        ''' <summary>
        ''' Returns <see langword="true" /> if this object's data has been changed.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' When an object's data is changed, CSLA .NET makes note of that change
        ''' and considers the object to be 'dirty' or changed. This value is used to
        ''' optimize data updates, since an unchanged object does not need to be
        ''' updated into the database. All new objects are considered dirty. All objects
        ''' marked for deletion are considered dirty.
        ''' </para><para>
        ''' Once an object's data has been saved to the database (inserted or updated)
        ''' the dirty flag is cleared and the object is considered unchanged. Objects
        ''' newly loaded from the database are also considered unchanged.
        ''' </para>
        ''' </remarks>
        ''' <returns>A value indicating if this object's data has been changed.</returns>
        <Browsable(False)> _
        Public Overridable ReadOnly Property IsDirty() As Boolean Implements IEditableBusinessObject.IsDirty
            Get
                Return mIsDirty
            End Get
        End Property

        ''' <summary>
        ''' Marks the object as being a new object. This also marks the object
        ''' as being dirty and ensures that it is not marked for deletion.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' Newly created objects are marked new by default. You should call
        ''' this method in the implementation of DataPortal_Update when the
        ''' object is deleted (due to being marked for deletion) to indicate
        ''' that the object no longer reflects data in the database.
        ''' </para><para>
        ''' If you override this method, make sure to call the base
        ''' implementation after executing your new code.
        ''' </para>
        ''' </remarks>
        Protected Overridable Sub MarkNew()
            mIsNew = True
            mIsDeleted = False
            MarkDirty()
        End Sub

        ''' <summary>
        ''' Marks the object as being an old (not new) object. This also
        ''' marks the object as being unchanged (not dirty).
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' You should call this method in the implementation of
        ''' DataPortal_Fetch to indicate that an existing object has been
        ''' successfully retrieved from the database.
        ''' </para><para>
        ''' You should call this method in the implementation of 
        ''' DataPortal_Update to indicate that a new object has been successfully
        ''' inserted into the database.
        ''' </para><para>
        ''' If you override this method, make sure to call the base
        ''' implementation after executing your new code.
        ''' </para>
        ''' </remarks>
        Protected Overridable Sub MarkOld()
            mIsNew = False
            MarkClean()
        End Sub

        ''' <summary>
        ''' Marks an object for deletion. This also marks the object
        ''' as being dirty.
        ''' </summary>
        ''' <remarks>
        ''' You should call this method in your business logic in the
        ''' case that you want to have the object deleted when it is
        ''' saved to the database.
        ''' </remarks>
        Protected Sub MarkDeleted()
            mIsDeleted = True
            MarkDirty()
        End Sub

        ''' <summary>
        ''' Marks an object as being dirty, or changed.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' You should call this method in your business logic any time
        ''' the object's internal data changes. Any time any instance
        ''' variable changes within the object, this method should be called
        ''' to tell CSLA .NET that the object's data has been changed.
        ''' </para><para>
        ''' Marking an object as dirty does two things. First it ensures
        ''' that CSLA .NET will properly save the object as appropriate. Second,
        ''' it causes CSLA .NET to tell Windows Forms data binding that the
        ''' object's data has changed so any bound controls will update to
        ''' reflect the new values.
        ''' </para>
        ''' </remarks>
        Protected Sub MarkDirty()
            MarkDirty(False)
        End Sub

        ''' <summary>
        ''' Marks an object as being dirty, or changed.
        ''' </summary>
        ''' <param name="supressEvent">
        ''' <see langword="true" /> to supress the PropertyChanged event that is otherwise
        ''' raised to indicate that the object's state has changed.
        ''' </param>
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Protected Sub MarkDirty(ByVal supressEvent As Boolean)
            mIsDirty = True
            If Not supressEvent Then
                OnUnknownPropertyChanged()
            End If
        End Sub

        ''' <summary>
        ''' Performs processing required when the current
        ''' property has changed.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' This method calls CheckRules(propertyName), MarkDirty and
        ''' OnPropertyChanged(propertyName). MarkDirty is called such
        ''' that no event is raised for IsDirty, so only the specific
        ''' property changed event for the current property is raised.
        ''' </para><para>
        ''' This implementation uses System.Diagnostics.StackTrace to
        ''' determine the name of the current property, and so must be called
        ''' directly from the property to be checked.
        ''' </para>
        ''' </remarks>
        <System.Runtime.CompilerServices.MethodImpl( _
          System.Runtime.CompilerServices.MethodImplOptions.NoInlining)> _
        Protected Sub PropertyHasChanged()
            If Not Me.mSupressEvents Then
                Dim propertyName As String = New System.Diagnostics.StackTrace().GetFrame(1).GetMethod.Name.Substring(4)
                PropertyHasChanged(propertyName)
            End If
        End Sub

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
                MarkDirty(True)
                OnPropertyChanged(propertyName)
            End If
        End Sub

        ''' <summary>
        ''' Forces the object's IsDirty flag to <see langword="false" />.
        ''' </summary>
        ''' <remarks>
        ''' This method is normally called automatically and is
        ''' not intended to be called manually.
        ''' </remarks>
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Protected Sub MarkClean()

            mIsDirty = False
            OnUnknownPropertyChanged()

        End Sub

        ''' <summary>
        ''' Returns <see langword="true" /> if this object is both dirty and valid.
        ''' </summary>
        ''' <remarks>
        ''' An object is considered dirty (changed) if 
        ''' <see cref="P:Csla.BusinessBase.IsDirty" /> returns <see langword="true" />. It is
        ''' considered valid if IsValid
        ''' returns <see langword="true" />. The IsSavable property is
        ''' a combination of these two properties. 
        ''' </remarks>
        ''' <returns>A value indicating if this object is both dirty and valid.</returns>
        <Browsable(False)> _
        Public Overridable ReadOnly Property IsSavable() As Boolean Implements IEditableBusinessObject.IsSavable
            Get
                Return IsDirty AndAlso IsValid
            End Get
        End Property

#End Region

#Region " Parent/Child link "

        <NotUndoable()> _
        <NonSerialized()> _
        Private mParent As Core.IEditableCollection

        ''' <summary>
        ''' Provide access to the parent reference for use
        ''' in child object code.
        ''' </summary>
        ''' <remarks>
        ''' This value will be Nothing for root objects.
        ''' </remarks>
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Protected ReadOnly Property Parent() As Core.IEditableCollection
            Get
                Return mParent
            End Get
        End Property

        ''' <summary>
        ''' Used by BusinessListBase as a child object is 
        ''' created to tell the child object about its
        ''' parent.
        ''' </summary>
        ''' <param name="parent">A reference to the parent collection object.</param>
        Friend Sub SetParent(ByVal parent As Core.IEditableCollection) Implements IEditableBusinessObject.SetParent
            'If Not IsChild Then
            '    Throw New InvalidOperationException(My.Resources.ParentSetException)
            'End If
            MarkAsChild()
            mParent = parent

            'If an object has previously been removed from a different collection
            'Then mark it as NOT deleted because it has now been added to a different collection
            'Thus the object has changed parents but is not deleted
            If Me.IsDeleted Then
                mIsDeleted = False
            End If
        End Sub

#End Region

#Region " IEditableObject "

        <NotUndoable()> _
        Private mBindingEdit As Boolean
        Private mNeverCommitted As Boolean = True

        '''' <summary>
        '''' Allow data binding to start a nested edit on the object.
        '''' </summary>
        '''' <remarks>
        '''' Data binding may call this method many times. Only the first
        '''' call should be honored, so we have extra code to detect this
        '''' and do nothing for subsquent calls.
        '''' </remarks>
        'Private Sub IEditableObject_BeginEdit() _
        '  Implements System.ComponentModel.IEditableObject.BeginEdit

        '  If Not mBindingEdit Then
        '    BeginEdit()
        '  End If

        'End Sub

        '''' <summary>
        '''' Allow data binding to cancel the current edit.
        '''' </summary>
        '''' <remarks>
        '''' Data binding may call this method many times. Only the first
        '''' call to either IEditableObject.CancelEdit or 
        '''' IEditableObject.EndEdit
        '''' should be honored. We include extra code to detect this and do
        '''' nothing for subsequent calls.
        '''' </remarks>
        'Private Sub IEditableObject_CancelEdit() _
        '  Implements System.ComponentModel.IEditableObject.CancelEdit

        '  If mBindingEdit Then
        '    CancelEdit()
        '    If IsNew AndAlso mNeverCommitted AndAlso _
        '      EditLevel <= EditLevelAdded Then
        '      ' we're new and no EndEdit or ApplyEdit has ever been
        '      ' called on us, and now we've been canceled back to 
        '      ' where we were added so we should have ourselves  
        '      ' removed from the parent collection
        '      If Not Parent Is Nothing Then
        '        Parent.RemoveChild(Me)
        '      End If
        '    End If
        '  End If

        'End Sub

        '''' <summary>
        '''' Allow data binding to apply the current edit.
        '''' </summary>
        '''' <remarks>
        '''' Data binding may call this method many times. Only the first
        '''' call to either IEditableObject.EndEdit or 
        '''' IEditableObject.CancelEdit
        '''' should be honored. We include extra code to detect this and do
        '''' nothing for subsequent calls.
        '''' </remarks>
        '<System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")> _
        'Private Sub IEditableObject_EndEdit() _
        '  Implements System.ComponentModel.IEditableObject.EndEdit

        '  If mBindingEdit Then
        '    ApplyEdit()
        '  End If

        'End Sub

#End Region

#Region " Begin/Cancel/ApplyEdit "

        ''' <summary>
        ''' Starts a nested edit on the object.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' When this method is called the object takes a snapshot of
        ''' its current state (the values of its variables). This snapshot
        ''' can be restored by calling CancelEdit
        ''' or committed by calling ApplyEdit.
        ''' </para><para>
        ''' This is a nested operation. Each call to BeginEdit adds a new
        ''' snapshot of the object's state to a stack. You should ensure that 
        ''' for each call to BeginEdit there is a corresponding call to either 
        ''' CancelEdit or ApplyEdit to remove that snapshot from the stack.
        ''' </para><para>
        ''' See Chapters 2 and 3 for details on n-level undo and state stacking.
        ''' </para>
        ''' </remarks>
        Public Sub BeginEdit()
            mBindingEdit = True
            CopyState()
        End Sub

        ''' <summary>
        ''' Cancels the current edit process, restoring the object's state to
        ''' its previous values.
        ''' </summary>
        ''' <remarks>
        ''' Calling this method causes the most recently taken snapshot of the 
        ''' object's state to be restored. This resets the object's values
        ''' to the point of the last BeginEdit call.
        ''' </remarks>
        Public Sub CancelEdit()
            UndoChanges()
        End Sub

        ''' <summary>
        ''' Called when an undo operation has completed.
        ''' </summary>
        ''' <remarks>
        ''' This method resets the object as a result of
        ''' deserialization and raises PropertyChanged events
        ''' to notify data binding that the object has changed.
        ''' </remarks>
        Protected Overrides Sub UndoChangesComplete()

            mBindingEdit = False
            ValidationRules.SetTarget(Me)
            AddBusinessRules()
            OnUnknownPropertyChanged()
            MyBase.UndoChangesComplete()

        End Sub

        ''' <summary>
        ''' Commits the current edit process.
        ''' </summary>
        ''' <remarks>
        ''' Calling this method causes the most recently taken snapshot of the 
        ''' object's state to be discarded, thus committing any changes made
        ''' to the object's state since the last BeginEdit call.
        ''' </remarks>
        Public Sub ApplyEdit()
            mBindingEdit = False
            mNeverCommitted = False
            AcceptChanges()
        End Sub

#End Region

#Region " IsChild "

        <NotUndoable()> _
        Private mIsChild As Boolean

        ''' <summary>
        ''' Returns <see langword="true" /> if this is a child (non-root) object.
        ''' </summary>
        Protected Friend ReadOnly Property IsChild() As Boolean
            Get
                Return mIsChild
            End Get
        End Property

        ''' <summary>
        ''' Marks the object as being a child object.
        ''' </summary>
        Protected Sub MarkAsChild()
            mIsChild = True
        End Sub

#End Region

#Region " Edit Level Tracking (child only) "

        ' we need to keep track of the edit
        ' level when we were added so if the user
        ' cancels below that level we can be destroyed
        Private mEditLevelAdded As Integer

        ''' <summary>
        ''' Gets or sets the current edit level of the
        ''' object.
        ''' </summary>
        ''' <remarks>
        ''' Allow the collection object to use the
        ''' edit level as needed.
        ''' </remarks>
        Friend Property EditLevelAdded() As Integer Implements IEditableBusinessObject.EditLevelAdded
            Get
                Return mEditLevelAdded
            End Get
            Set(ByVal Value As Integer)
                mEditLevelAdded = Value
            End Set
        End Property

#End Region

#Region " ICloneable "

        Private Function Clone() As Object Implements ICloneable.Clone

            Return GetClone()

        End Function

        ''' <summary>
        ''' Creates a clone of the object.
        ''' </summary>
        ''' <returns>
        ''' A new object containing the exact data of the original object.
        ''' </returns>
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Protected Overridable Function GetClone() As Object

            Return ObjectCloner.Clone(Me)

        End Function

#End Region

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
        Public Overridable ReadOnly Property IsValid() As Boolean Implements IEditableBusinessObject.IsValid
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

#Region " IDataErrorInfo "

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

#Region " Data Access "

        ''' <summary>
        ''' Marks the object for deletion. The object will be deleted as part of the
        ''' next save operation.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' CSLA .NET supports both immediate and deferred deletion of objects. This
        ''' method is part of the support for deferred deletion, where an object
        ''' can be marked for deletion, but isn't actually deleted until the object
        ''' is saved to the database. This method is called by the UI developer to
        ''' mark the object for deletion.
        ''' </para><para>
        ''' To 'undelete' an object, use n-level undo as discussed in Chapters 2 and 3.
        ''' </para>
        ''' </remarks>
        Public Overridable Sub Delete()
            If Me.IsChild Then
                Throw New NotSupportedException(My.Resources.ChildDeleteException)
            End If

            MarkDeleted()
        End Sub

        ''' <summary>
        ''' Called by a parent object to mark the child
        ''' for deferred deletion.
        ''' </summary>
        Friend Sub DeleteChild() Implements IEditableBusinessObject.DeleteChild
            If Not Me.IsChild Then
                Throw New NotSupportedException(My.Resources.NoDeleteRootException)
            End If

            MarkDeleted()
        End Sub

        ''' <summary>
        ''' Saves the object to the database.
        ''' </summary>
        ''' <remarks>
        ''' <para>
        ''' Calling this method starts the save operation, causing the object
        ''' to be inserted, updated or deleted within the database based on the
        ''' object's current state.
        ''' </para><para>
        ''' If <see cref="Core.BusinessBase.IsDeleted" /> is <see langword="true"/>
        ''' the object will be deleted. Otherwise, if <see cref="Core.BusinessBase.IsNew" /> 
        ''' is <see langword="true"/> the object will be inserted. 
        ''' Otherwise the object's data will be updated in the database.
        ''' </para><para>
        ''' All this is contingent on <see cref="Core.BusinessBase.IsDirty" />. If
        ''' this value is <see langword="false"/>, no data operation occurs. 
        ''' It is also contingent on <see cref="Core.BusinessBase.IsValid" />. 
        ''' If this value is <see langword="false"/> an
        ''' exception will be thrown to indicate that the UI attempted to save an
        ''' invalid object.
        ''' </para><para>
        ''' It is important to note that this method returns a new version of the
        ''' business object that contains any data updated during the save operation.
        ''' You MUST update all object references to use this new version of the
        ''' business object in order to have access to the correct object data.
        ''' </para><para>
        ''' You can override this method to add your own custom behaviors to the save
        ''' operation. For instance, you may add some security checks to make sure
        ''' the user can save the object. If all security checks pass, you would then
        ''' invoke the base Save method via <c>MyBase.Save()</c>.
        ''' </para>
        ''' </remarks>
        Public Overridable Sub Save() Implements IEditableBusinessObject.Save
            If EditLevel > 0 Then
                Throw New Validation.ValidationException(My.Resources.NoSaveEditingException)
            End If

            If IsDeleted Then
                Me.DeleteImmediate()
                Me.MarkNew()
            ElseIf Not IsValid Then
                Throw New Validation.ValidationException(My.Resources.NoSaveInvalidException)
            ElseIf IsNew Then
                Me.Insert()
                Me.MarkOld()
            ElseIf IsDirty Then
                Me.Update()
                Me.MarkClean()
            End If

        End Sub

        ''' <summary>
        ''' Saves the object to the database, forcing
        ''' IsNew to <see langword="false"/> and IsDirty to True.
        ''' </summary>
        ''' <param name="forceUpdate">
        ''' If <see langword="true"/>, triggers overriding IsNew and IsDirty. 
        ''' If <see langword="false"/> then it is the same as calling Save().
        ''' </param>
        ''' <remarks>
        ''' This overload is designed for use in web applications
        ''' when implementing the Update method in your 
        ''' data wrapper object.
        ''' </remarks>
        Public Sub Save(ByVal forceUpdate As Boolean)

            If forceUpdate AndAlso IsNew Then
                ' mark the object as old - which makes it
                ' not dirty
                MarkOld()
                ' now mark the object as dirty so it can save
                MarkDirty(True)
            End If

            Me.Save()

        End Sub

        Protected Overridable Sub Update()
            Throw New NotImplementedException
        End Sub

        Protected Overridable Sub Insert()
            Throw New NotImplementedException
        End Sub

        Protected Overridable Sub DeleteImmediate()
            Throw New NotImplementedException
        End Sub

        Protected Overridable Sub CreateNew()
            Throw New NotImplementedException
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

#End Region

#Region " Serialization Notification "

        <OnDeserialized()> _
        Private Sub OnDeserializedHandler(ByVal context As StreamingContext)

            ValidationRules.SetTarget(Me)
            AddBusinessRules()
            OnDeserialized(context)

        End Sub

        ''' <summary>
        ''' This method is called on a newly deserialized object
        ''' after deserialization is complete.
        ''' </summary>
        <EditorBrowsable(EditorBrowsableState.Advanced)> _
        Protected Overridable Sub OnDeserialized( _
          ByVal context As StreamingContext)

            ' do nothing - this is here so a subclass
            ' could override if needed

        End Sub

#End Region

    End Class

End Namespace
