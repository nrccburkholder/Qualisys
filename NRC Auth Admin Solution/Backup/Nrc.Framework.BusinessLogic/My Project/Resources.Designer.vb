﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:2.0.50727.42
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On

Imports System

Namespace My.Resources
    
    'This class was auto-generated by the StronglyTypedResourceBuilder
    'class via a tool like ResGen or Visual Studio.
    'To add or remove a member, edit your .ResX file then rerun ResGen
    'with the /str option, or rebuild your VS project.
    '''<summary>
    '''  A strongly-typed resource class, for looking up localized strings, etc.
    '''</summary>
    <Global.System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "2.0.0.0"),  _
     Global.System.Diagnostics.DebuggerNonUserCodeAttribute(),  _
     Global.System.Runtime.CompilerServices.CompilerGeneratedAttribute(),  _
     Global.Microsoft.VisualBasic.HideModuleNameAttribute()>  _
    Friend Module Resources
        
        Private resourceMan As Global.System.Resources.ResourceManager
        
        Private resourceCulture As Global.System.Globalization.CultureInfo
        
        '''<summary>
        '''  Returns the cached ResourceManager instance used by this class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend ReadOnly Property ResourceManager() As Global.System.Resources.ResourceManager
            Get
                If Object.ReferenceEquals(resourceMan, Nothing) Then
                    Dim temp As Global.System.Resources.ResourceManager = New Global.System.Resources.ResourceManager("Nrc.Framework.BusinessLogic.Resources", GetType(Resources).Assembly)
                    resourceMan = temp
                End If
                Return resourceMan
            End Get
        End Property
        
        '''<summary>
        '''  Overrides the current thread's CurrentUICulture property for all
        '''  resource lookups using this strongly typed resource class.
        '''</summary>
        <Global.System.ComponentModel.EditorBrowsableAttribute(Global.System.ComponentModel.EditorBrowsableState.Advanced)>  _
        Friend Property Culture() As Global.System.Globalization.CultureInfo
            Get
                Return resourceCulture
            End Get
            Set
                resourceCulture = value
            End Set
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Changing an element is an invalid operation.
        '''</summary>
        Friend ReadOnly Property ChangeInvalidException() As String
            Get
                Return ResourceManager.GetString("ChangeInvalidException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Can not directly mark a child object for deletion - use its parent collection.
        '''</summary>
        Friend ReadOnly Property ChildDeleteException() As String
            Get
                Return ResourceManager.GetString("ChildDeleteException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Clear is an invalid operation.
        '''</summary>
        Friend ReadOnly Property ClearInvalidException() As String
            Get
                Return ResourceManager.GetString("ClearInvalidException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to GetIdValue must not return Nothing.
        '''</summary>
        Friend ReadOnly Property GetIdValueCantBeNull() As String
            Get
                Return ResourceManager.GetString("GetIdValueCantBeNull", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Insert is an invalid operation.
        '''</summary>
        Friend ReadOnly Property InsertInvalidException() As String
            Get
                Return ResourceManager.GetString("InsertInvalidException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to {0} can not exceed {1}.
        '''</summary>
        Friend ReadOnly Property MaxValueRule() As String
            Get
                Return ResourceManager.GetString("MaxValueRule", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to {0} can not be less than {1}.
        '''</summary>
        Friend ReadOnly Property MinValueRule() As String
            Get
                Return ResourceManager.GetString("MinValueRule", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to ApplyEdit is not valid on a child object.
        '''</summary>
        Friend ReadOnly Property NoApplyEditChildException() As String
            Get
                Return ResourceManager.GetString("NoApplyEditChildException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to BeginEdit is not valid on a child object.
        '''</summary>
        Friend ReadOnly Property NoBeginEditChildException() As String
            Get
                Return ResourceManager.GetString("NoBeginEditChildException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to CancelEdit is not valid on a child object.
        '''</summary>
        Friend ReadOnly Property NoCancelEditChildException() As String
            Get
                Return ResourceManager.GetString("NoCancelEditChildException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Invalid for root objects - use Delete instead.
        '''</summary>
        Friend ReadOnly Property NoDeleteRootException() As String
            Get
                Return ResourceManager.GetString("NoDeleteRootException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Can not directly save a child object.
        '''</summary>
        Friend ReadOnly Property NoSaveChildException() As String
            Get
                Return ResourceManager.GetString("NoSaveChildException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Object is still being edited and can not be saved.
        '''</summary>
        Friend ReadOnly Property NoSaveEditingException() As String
            Get
                Return ResourceManager.GetString("NoSaveEditingException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Object is not valid and can not be saved.
        '''</summary>
        Friend ReadOnly Property NoSaveInvalidException() As String
            Get
                Return ResourceManager.GetString("NoSaveInvalidException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Parent value can only be set for child objects.
        '''</summary>
        Friend ReadOnly Property ParentSetException() As String
            Get
                Return ResourceManager.GetString("ParentSetException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to {0} does not match regular expression.
        '''</summary>
        Friend ReadOnly Property RegExMatchRule() As String
            Get
                Return ResourceManager.GetString("RegExMatchRule", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Remove is an invalid operation.
        '''</summary>
        Friend ReadOnly Property RemoveInvalidException() As String
            Get
                Return ResourceManager.GetString("RemoveInvalidException", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to {0} can not exceed {1} characters.
        '''</summary>
        Friend ReadOnly Property StringMaxLengthRule() As String
            Get
                Return ResourceManager.GetString("StringMaxLengthRule", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to {0} required.
        '''</summary>
        Friend ReadOnly Property StringRequiredRule() As String
            Get
                Return ResourceManager.GetString("StringRequiredRule", resourceCulture)
            End Get
        End Property
        
        '''<summary>
        '''  Looks up a localized string similar to Invalid operation - update not allowed.
        '''</summary>
        Friend ReadOnly Property UpdateNotSupportedException() As String
            Get
                Return ResourceManager.GetString("UpdateNotSupportedException", resourceCulture)
            End Get
        End Property
    End Module
End Namespace
