Imports Nrc.Framework.BusinessLogic
Imports System.ComponentModel


Public Class UploadedFiles
    <Serializable()> _
    Public Class UploadedFileCollection
        Inherits BusinessListBase(Of UploadFileCollection, UploadFile)
        Implements IDisposable

        Private disposed As Boolean = False
        Private handle As IntPtr
        Private Shared NewList As New Generic.List(Of UploadFile)

        Public Sub New(ByVal handle As IntPtr)
            Me.handle = handle
        End Sub


        Public Shared Sub AddToList(ByVal value As UploadFile)
           

            NewList.Add(value)
        End Sub

        'Public Shared WriteOnly Property AddToList()
        '    Set(ByVal value)

        '        NewList.Add(value)
        '    End Set
        'End Property

        Public Shared ReadOnly Property GetList() As Generic.List(Of UploadFile)
            Get
                Return NewList
            End Get
        End Property


        Public Overloads Sub Dispose() Implements IDisposable.Dispose
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub

        Private Overloads Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposed Then
                If disposing Then
                    'managed resources 
                End If
                NewList.Clear()
                'NewList = Nothing
                CloseHandle(handle)
                handle = IntPtr.Zero
                disposed = True
            End If
        End Sub

        <System.Runtime.InteropServices.DllImport("Kernel32")> _
        Private Shared Function CloseHandle(ByVal handle As IntPtr) As [Boolean]
        End Function

        Protected Overrides Sub Finalize()
            Dispose(False)
            MyBase.Finalize()
        End Sub
    End Class


    Public Shared Sub DisposeUploadFilesCollection()
        Dim handle As IntPtr
        Dim DispObj As UploadedFileCollection = New UploadedFileCollection(handle)
        DispObj.Dispose()
    End Sub


End Class