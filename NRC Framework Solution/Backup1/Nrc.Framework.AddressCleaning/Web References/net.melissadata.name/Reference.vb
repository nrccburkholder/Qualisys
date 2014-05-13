﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated by a tool.
'     Runtime Version:2.0.50727.4927
'
'     Changes to this file may cause incorrect behavior and will be lost if
'     the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Option Strict Off
Option Explicit On

Imports System
Imports System.ComponentModel
Imports System.Diagnostics
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml.Serialization

'
'This source code was auto-generated by Microsoft.VSDesigner, Version 2.0.50727.4927.
'
Namespace dqwsNameCheck

    'CODEGEN: The optional WSDL extension element 'PolicyReference' from namespace 'http://schemas.xmlsoap.org/ws/2004/09/policy' was not handled.
    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.4927"), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Web.Services.WebServiceBindingAttribute(name:="BasicHttpBinding_IService", [Namespace]:="urn:MelissaDataNameCheckService")> _
    Partial Public Class Service
        Inherits System.Web.Services.Protocols.SoapHttpClientProtocol

        Private doNameCheckOperationCompleted As System.Threading.SendOrPostCallback

        Private useDefaultCredentialsSetExplicitly As Boolean

        '''<remarks/>
        Public Sub New()
            MyBase.New()
            Me.Url = "https://name.melissadata.net/v2/soap/service.svc"
            If (Me.IsLocalFileSystemWebService(Me.Url) = True) Then
                Me.UseDefaultCredentials = True
                Me.useDefaultCredentialsSetExplicitly = False
            Else
                Me.useDefaultCredentialsSetExplicitly = True
            End If
        End Sub

        Public Shadows Property Url() As String
            Get
                Return MyBase.Url
            End Get
            Set(ByVal value As String)
                If (((Me.IsLocalFileSystemWebService(MyBase.Url) = True) _
                            AndAlso (Me.useDefaultCredentialsSetExplicitly = False)) _
                            AndAlso (Me.IsLocalFileSystemWebService(Value) = False)) Then
                    MyBase.UseDefaultCredentials = False
                End If
                MyBase.Url = Value
            End Set
        End Property

        Public Shadows Property UseDefaultCredentials() As Boolean
            Get
                Return MyBase.UseDefaultCredentials
            End Get
            Set(ByVal value As Boolean)
                MyBase.UseDefaultCredentials = Value
                Me.useDefaultCredentialsSetExplicitly = True
            End Set
        End Property

        '''<remarks/>
        Public Event doNameCheckCompleted As doNameCheckCompletedEventHandler

        '''<remarks/>
        <System.Web.Services.Protocols.SoapDocumentMethodAttribute("urn:MelissaDataNameCheckService/IService/doNameCheck", RequestNamespace:="urn:MelissaDataNameCheckService", ResponseNamespace:="urn:MelissaDataNameCheckService", Use:=System.Web.Services.Description.SoapBindingUse.Literal, ParameterStyle:=System.Web.Services.Protocols.SoapParameterStyle.Wrapped)> _
        Public Function doNameCheck(ByVal Request As RequestArray) As ResponseArray
            Dim results() As Object = Me.Invoke("doNameCheck", New Object() {Request})
            Return CType(results(0), ResponseArray)
        End Function

        '''<remarks/>
        Public Overloads Sub doNameCheckAsync(ByVal Request As RequestArray)
            Me.doNameCheckAsync(Request, Nothing)
        End Sub

        '''<remarks/>
        Public Overloads Sub doNameCheckAsync(ByVal Request As RequestArray, ByVal userState As Object)
            If (Me.doNameCheckOperationCompleted Is Nothing) Then
                Me.doNameCheckOperationCompleted = AddressOf Me.OndoNameCheckOperationCompleted
            End If
            Me.InvokeAsync("doNameCheck", New Object() {Request}, Me.doNameCheckOperationCompleted, userState)
        End Sub

        Private Sub OndoNameCheckOperationCompleted(ByVal arg As Object)
            If (Not (Me.doNameCheckCompletedEvent) Is Nothing) Then
                Dim invokeArgs As System.Web.Services.Protocols.InvokeCompletedEventArgs = CType(arg, System.Web.Services.Protocols.InvokeCompletedEventArgs)
                RaiseEvent doNameCheckCompleted(Me, New doNameCheckCompletedEventArgs(invokeArgs.Results, invokeArgs.Error, invokeArgs.Cancelled, invokeArgs.UserState))
            End If
        End Sub

        '''<remarks/>
        Public Shadows Sub CancelAsync(ByVal userState As Object)
            MyBase.CancelAsync(userState)
        End Sub

        Private Function IsLocalFileSystemWebService(ByVal url As String) As Boolean
            If ((url Is Nothing) _
                        OrElse (url Is String.Empty)) Then
                Return False
            End If
            Dim wsUri As System.Uri = New System.Uri(url)
            If ((wsUri.Port >= 1024) _
                        AndAlso (String.Compare(wsUri.Host, "localHost", System.StringComparison.OrdinalIgnoreCase) = 0)) Then
                Return True
            End If
            Return False
        End Function
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927"), _
     System.SerializableAttribute(), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="urn:mdWebServiceName")> _
    Partial Public Class RequestArray

        Private transmissionReferenceField As String

        Private customerIDField As String

        Private optCorrectSpellingField As String

        Private optNameHintField As String

        Private optGenderAggressionField As String

        Private optGenderPopulationField As String

        Private optSalutationPrefixField As String

        Private optSalutationSuffixField As String

        Private optSalutationSlugField As String

        Private recordField() As RequestArrayRecord

        '''<remarks/>
        Public Property TransmissionReference() As String
            Get
                Return Me.transmissionReferenceField
            End Get
            Set(ByVal value As String)
                Me.transmissionReferenceField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property CustomerID() As String
            Get
                Return Me.customerIDField
            End Get
            Set(ByVal value As String)
                Me.customerIDField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptCorrectSpelling() As String
            Get
                Return Me.optCorrectSpellingField
            End Get
            Set(ByVal value As String)
                Me.optCorrectSpellingField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptNameHint() As String
            Get
                Return Me.optNameHintField
            End Get
            Set(ByVal value As String)
                Me.optNameHintField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptGenderAggression() As String
            Get
                Return Me.optGenderAggressionField
            End Get
            Set(ByVal value As String)
                Me.optGenderAggressionField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptGenderPopulation() As String
            Get
                Return Me.optGenderPopulationField
            End Get
            Set(ByVal value As String)
                Me.optGenderPopulationField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptSalutationPrefix() As String
            Get
                Return Me.optSalutationPrefixField
            End Get
            Set(ByVal value As String)
                Me.optSalutationPrefixField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptSalutationSuffix() As String
            Get
                Return Me.optSalutationSuffixField
            End Get
            Set(ByVal value As String)
                Me.optSalutationSuffixField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property OptSalutationSlug() As String
            Get
                Return Me.optSalutationSlugField
            End Get
            Set(ByVal value As String)
                Me.optSalutationSlugField = Value
            End Set
        End Property

        '''<remarks/>
        <System.Xml.Serialization.XmlElementAttribute("Record")> _
        Public Property Record() As RequestArrayRecord()
            Get
                Return Me.recordField
            End Get
            Set(ByVal value As RequestArrayRecord())
                Me.recordField = Value
            End Set
        End Property
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927"), _
     System.SerializableAttribute(), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True, [Namespace]:="urn:mdWebServiceName")> _
    Partial Public Class RequestArrayRecord

        Private recordIDField As String

        Private fullNameField As String

        '''<remarks/>
        Public Property RecordID() As String
            Get
                Return Me.recordIDField
            End Get
            Set(ByVal value As String)
                Me.recordIDField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property FullName() As String
            Get
                Return Me.fullNameField
            End Get
            Set(ByVal value As String)
                Me.fullNameField = Value
            End Set
        End Property
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927"), _
     System.SerializableAttribute(), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Xml.Serialization.XmlTypeAttribute([Namespace]:="urn:mdWebServiceName")> _
    Partial Public Class ResponseArray

        Private versionField As String

        Private transmissionReferenceField As String

        Private resultsField As String

        Private totalRecordsField As String

        Private recordField() As ResponseArrayRecord

        '''<remarks/>
        Public Property Version() As String
            Get
                Return Me.versionField
            End Get
            Set(ByVal value As String)
                Me.versionField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property TransmissionReference() As String
            Get
                Return Me.transmissionReferenceField
            End Get
            Set(ByVal value As String)
                Me.transmissionReferenceField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Results() As String
            Get
                Return Me.resultsField
            End Get
            Set(ByVal value As String)
                Me.resultsField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property TotalRecords() As String
            Get
                Return Me.totalRecordsField
            End Get
            Set(ByVal value As String)
                Me.totalRecordsField = Value
            End Set
        End Property

        '''<remarks/>
        <System.Xml.Serialization.XmlElementAttribute("Record")> _
        Public Property Record() As ResponseArrayRecord()
            Get
                Return Me.recordField
            End Get
            Set(ByVal value As ResponseArrayRecord())
                Me.recordField = Value
            End Set
        End Property
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927"), _
     System.SerializableAttribute(), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True, [Namespace]:="urn:mdWebServiceName")> _
    Partial Public Class ResponseArrayRecord

        Private recordIDField As String

        Private resultsField As String

        Private nameField As ResponseArrayRecordName

        '''<remarks/>
        Public Property RecordID() As String
            Get
                Return Me.recordIDField
            End Get
            Set(ByVal value As String)
                Me.recordIDField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Results() As String
            Get
                Return Me.resultsField
            End Get
            Set(ByVal value As String)
                Me.resultsField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Name() As ResponseArrayRecordName
            Get
                Return Me.nameField
            End Get
            Set(ByVal value As ResponseArrayRecordName)
                Me.nameField = Value
            End Set
        End Property
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.4927"), _
     System.SerializableAttribute(), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code"), _
     System.Xml.Serialization.XmlTypeAttribute(AnonymousType:=True, [Namespace]:="urn:mdWebServiceName")> _
    Partial Public Class ResponseArrayRecordName

        Private prefixField As String

        Private prefix2Field As String

        Private firstField As String

        Private first2Field As String

        Private middleField As String

        Private middle2Field As String

        Private lastField As String

        Private last2Field As String

        Private suffixField As String

        Private suffix2Field As String

        Private genderField As String

        Private gender2Field As String

        Private salutationField As String

        '''<remarks/>
        Public Property Prefix() As String
            Get
                Return Me.prefixField
            End Get
            Set(ByVal value As String)
                Me.prefixField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Prefix2() As String
            Get
                Return Me.prefix2Field
            End Get
            Set(ByVal value As String)
                Me.prefix2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property First() As String
            Get
                Return Me.firstField
            End Get
            Set(ByVal value As String)
                Me.firstField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property First2() As String
            Get
                Return Me.first2Field
            End Get
            Set(ByVal value As String)
                Me.first2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Middle() As String
            Get
                Return Me.middleField
            End Get
            Set(ByVal value As String)
                Me.middleField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Middle2() As String
            Get
                Return Me.middle2Field
            End Get
            Set(ByVal value As String)
                Me.middle2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Last() As String
            Get
                Return Me.lastField
            End Get
            Set(ByVal value As String)
                Me.lastField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Last2() As String
            Get
                Return Me.last2Field
            End Get
            Set(ByVal value As String)
                Me.last2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Suffix() As String
            Get
                Return Me.suffixField
            End Get
            Set(ByVal value As String)
                Me.suffixField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Suffix2() As String
            Get
                Return Me.suffix2Field
            End Get
            Set(ByVal value As String)
                Me.suffix2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Gender() As String
            Get
                Return Me.genderField
            End Get
            Set(ByVal value As String)
                Me.genderField = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Gender2() As String
            Get
                Return Me.gender2Field
            End Get
            Set(ByVal value As String)
                Me.gender2Field = Value
            End Set
        End Property

        '''<remarks/>
        Public Property Salutation() As String
            Get
                Return Me.salutationField
            End Get
            Set(ByVal value As String)
                Me.salutationField = Value
            End Set
        End Property
    End Class

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.4927")> _
    Public Delegate Sub doNameCheckCompletedEventHandler(ByVal sender As Object, ByVal e As doNameCheckCompletedEventArgs)

    '''<remarks/>
    <System.CodeDom.Compiler.GeneratedCodeAttribute("System.Web.Services", "2.0.50727.4927"), _
     System.Diagnostics.DebuggerStepThroughAttribute(), _
     System.ComponentModel.DesignerCategoryAttribute("code")> _
    Partial Public Class doNameCheckCompletedEventArgs
        Inherits System.ComponentModel.AsyncCompletedEventArgs

        Private results() As Object

        Friend Sub New(ByVal results() As Object, ByVal exception As System.Exception, ByVal cancelled As Boolean, ByVal userState As Object)
            MyBase.New(exception, cancelled, userState)
            Me.results = results
        End Sub

        '''<remarks/>
        Public ReadOnly Property Result() As ResponseArray
            Get
                Me.RaiseExceptionIfNecessary()
                Return CType(Me.results(0), ResponseArray)
            End Get
        End Property
    End Class
End Namespace
