Imports System
Imports System.ComponentModel
Imports System.IO
Imports System.Threading
Imports System.Runtime.InteropServices
Imports Microsoft.Win32
Namespace RegistryUtils
    ''' <summary>
    ''' <b>RegistryMonitor</b> allows you to monitor specific registry key.
    ''' </summary>
    ''' <remarks>
    ''' If a monitored registry key changes, an event is fired. You can subscribe to these
    ''' events by adding a delegate to "RegChanged" />.
    ''' <para>The Windows API provides a function
    ''' <a href="http://msdn.microsoft.com/library/en-us/sysinfo/base/regnotifychangekeyvalue.asp">
    ''' RegNotifyChangeKeyValue</a>, which is not covered by the
    ''' <see cref="Microsoft.Win32.RegistryKey"/> class. <see cref="RegistryMonitor"/> imports
    ''' that function and encapsulates it in a convenient manner.
    ''' </para>
    ''' </remarks>
    ''' <example>
    ''' This sample shows how to monitor <c>HKEY_CURRENT_USER\Environment</c> for changes:
    ''' <code>
    ''' public class MonitorSample
    ''' {
    ''' static void Main()
    ''' {
    ''' RegistryMonitor monitor = new RegistryMonitor(RegistryHive.CurrentUser, "Environment");
    ''' monitor.RegChanged += new EventHandler(OnRegChanged);
    ''' monitor.Start();
    '''
    ''' while(true);
    '''
    ''' monitor.Stop();
    ''' }
    '''
    ''' private void OnRegChanged(object sender, EventArgs e)
    ''' {
    ''' Console.WriteLine("registry key has changed");
    ''' }
    ''' }
    ''' </code>
    ''' </example>
    Public Class RegistryMonitor
        Implements IDisposable

#Region "P/Invoke"

        <DllImport("advapi32.dll", SetLastError:=True)> _
        Private Shared Function RegOpenKeyEx(ByVal hKey As IntPtr, ByVal subKey As String, ByVal options As UInteger, ByVal samDesired As Integer, ByRef phkResult As IntPtr) As Integer
        End Function

        <DllImport("advapi32.dll", SetLastError:=True)> _
        Private Shared Function RegNotifyChangeKeyValue(ByVal hKey As IntPtr, ByVal bWatchSubtree As Boolean, ByVal dwNotifyFilter As RegChangeNotifyFilter, ByVal hEvent As Microsoft.Win32.SafeHandles.SafeWaitHandle, ByVal fAsynchronous As Boolean) As Integer
        End Function

        <DllImport("advapi32.dll", SetLastError:=True)> _
        Private Shared Function RegCloseKey(ByVal hKey As IntPtr) As Integer
        End Function

        Private Const KEY_QUERY_VALUE As Integer = &H1
        Private Const KEY_NOTIFY As Integer = &H10
        Private Const STANDARD_RIGHTS_READ As Integer = &H20000

        Private Shared ReadOnly HKEY_CLASSES_ROOT As New IntPtr(CInt(&H80000000))
        Private Shared ReadOnly HKEY_CURRENT_USER As New IntPtr(CInt(&H80000001))
        Private Shared ReadOnly HKEY_LOCAL_MACHINE As New IntPtr(CInt(&H80000002))
        Private Shared ReadOnly HKEY_USERS As New IntPtr(CInt(&H80000003))
        Private Shared ReadOnly HKEY_PERFORMANCE_DATA As New IntPtr(CInt(&H80000004))
        Private Shared ReadOnly HKEY_CURRENT_CONFIG As New IntPtr(CInt(&H80000005))
        Private Shared ReadOnly HKEY_DYN_DATA As New IntPtr(CInt(&H80000006))

#End Region

#Region "Event handling"

        ''' <summary>
        ''' Occurs when the specified registry key has changed.
        ''' </summary>
        Public Event RegChanged As EventHandler

        ''' <summary>
        ''' Raises the <see cref="RegChanged"/> event.
        ''' </summary>
        ''' <remarks>
        ''' <p>
        ''' <b>OnRegChanged</b> is called when the specified registry key has changed.
        ''' </p>
        ''' <note type="inheritinfo">
        ''' When overriding <see cref="OnRegChanged"/> in a derived class, be sure to call
        ''' the base class's <see cref="OnRegChanged"/> method.
        ''' </note>
        ''' </remarks>
        Protected Overridable Sub OnRegChanged()
            RaiseEvent RegChanged(Me, Nothing)
        End Sub

        ''' <summary>
        ''' Occurs when the access to the registry fails.
        ''' </summary>
        Public Event ErrEvent As ErrorEventHandler

        ''' <summary>
        ''' Raises the "Error" event.
        ''' </summary>
        ''' <param name="e">The <see cref="Exception"/> which occured while watching the registry.</param>
        ''' <remarks>
        ''' <p>
        ''' <b>OnError</b> is called when an exception occurs while watching the registry.
        ''' </p>
        ''' <note type="inheritinfo">
        ''' When overriding <see cref="OnError"/> in a derived class, be sure to call
        ''' the base class's <see cref="OnError"/> method.
        ''' </note>
        ''' </remarks>
        Protected Overridable Sub OnError(ByVal e As Exception)
            RaiseEvent ErrEvent(Me, New ErrorEventArgs(e))
        End Sub

#End Region

#Region "Private member variables"

        Private _registryHive As IntPtr
        Private _registrySubName As String
        Private _threadLock As New Object()
        Private _thread As Thread
        Private _disposed As Boolean
        Private _eventTerminate As New ManualResetEvent(False)

        Private _regFilter As RegChangeNotifyFilter = RegChangeNotifyFilter.Key Or RegChangeNotifyFilter.Attribute Or RegChangeNotifyFilter.Value Or RegChangeNotifyFilter.Security

#End Region

        ''' <summary>
        ''' Initializes a new instance of the <see cref="RegistryMonitor"/> class.
        ''' </summary>
        ''' <param name="registryKey">The registry key to monitor.</param>
        Public Sub New(ByVal registryKey As RegistryKey)
            InitRegistryKey(registryKey.Name)
        End Sub

        ''' <summary>
        ''' Initializes a new instance of the <see cref="RegistryMonitor"/> class.
        ''' </summary>
        ''' <param name="name">The name.</param>
        Public Sub New(ByVal name As String)
            If name Is Nothing OrElse name.Length = 0 Then
                Throw New ArgumentNullException("name")
            End If

            InitRegistryKey(name)
        End Sub

        ''' <summary>
        ''' Initializes a new instance of the <see cref="RegistryMonitor"/> class.
        ''' </summary>
        ''' <param name="registryHive">The registry hive.</param>
        ''' <param name="subKey">The sub key.</param>
        Public Sub New(ByVal registryHive As RegistryHive, ByVal subKey As String)
            InitRegistryKey(registryHive, subKey)
        End Sub

        ''' <summary>
        ''' Disposes this object.
        ''' </summary>
        Public Sub Dispose()
            [Stop]()
            _disposed = True
            GC.SuppressFinalize(Me)
        End Sub

        ''' <summary>
        ''' Gets or sets the <see cref="RegChangeNotifyFilter">RegChangeNotifyFilter</see>.
        ''' </summary>
        Public Property RegChangeNotifyFilter() As RegChangeNotifyFilter
            Get
                Return _regFilter
            End Get
            Set(ByVal value As RegChangeNotifyFilter)
                SyncLock _threadLock
                    If IsMonitoring Then
                        Throw New InvalidOperationException("Monitoring thread is already running")
                    End If

                    _regFilter = value
                End SyncLock
            End Set
        End Property

#Region "Initialization"

        Private Sub InitRegistryKey(ByVal hive As RegistryHive, ByVal name As String)
            Select Case hive
                Case RegistryHive.ClassesRoot
                    _registryHive = HKEY_CLASSES_ROOT
                    Exit Select

                Case RegistryHive.CurrentConfig
                    _registryHive = HKEY_CURRENT_CONFIG
                    Exit Select

                Case RegistryHive.CurrentUser
                    _registryHive = HKEY_CURRENT_USER
                    Exit Select

                Case RegistryHive.DynData
                    _registryHive = HKEY_DYN_DATA
                    Exit Select

                Case RegistryHive.LocalMachine
                    _registryHive = HKEY_LOCAL_MACHINE
                    Exit Select

                Case RegistryHive.PerformanceData
                    _registryHive = HKEY_PERFORMANCE_DATA
                    Exit Select

                Case RegistryHive.Users
                    _registryHive = HKEY_USERS
                    Exit Select
                Case Else

                    Throw New InvalidEnumArgumentException("hive", CInt(hive), GetType(RegistryHive))
            End Select
            _registrySubName = name
        End Sub

        Private Sub InitRegistryKey(ByVal name As String)
            Dim nameParts As String() = name.Split("\"c)

            Select Case nameParts(0)
                Case "HKEY_CLASSES_ROOT", "HKCR"
                    _registryHive = HKEY_CLASSES_ROOT
                    Exit Select

                Case "HKEY_CURRENT_USER", "HKCU"
                    _registryHive = HKEY_CURRENT_USER
                    Exit Select

                Case "HKEY_LOCAL_MACHINE", "HKLM"
                    _registryHive = HKEY_LOCAL_MACHINE
                    Exit Select

                Case "HKEY_USERS"
                    _registryHive = HKEY_USERS
                    Exit Select

                Case "HKEY_CURRENT_CONFIG"
                    _registryHive = HKEY_CURRENT_CONFIG
                    Exit Select
                Case Else

                    _registryHive = IntPtr.Zero
                    Throw New ArgumentException("The registry hive '" & nameParts(0) & "' is not supported", "value")
            End Select

            _registrySubName = [String].Join("\", nameParts, 1, nameParts.Length - 1)
        End Sub

#End Region

        ''' <summary>
        ''' <b>true</b> if this <see cref="RegistryMonitor"/> object is currently monitoring;
        ''' otherwise, <b>false</b>.
        ''' </summary>
        Public ReadOnly Property IsMonitoring() As Boolean
            Get
                Return _thread IsNot Nothing
            End Get
        End Property

        ''' <summary>
        ''' Start monitoring.
        ''' </summary>
        Public Sub Start()
            If _disposed Then
                Throw New ObjectDisposedException(Nothing, "This instance is already disposed")
            End If

            SyncLock _threadLock
                If Not IsMonitoring Then
                    _eventTerminate.Reset()
                    _thread = New Thread(New ThreadStart(AddressOf MonitorThread))
                    _thread.IsBackground = True
                    _thread.Start()
                End If
            End SyncLock
        End Sub

        ''' <summary>
        ''' Stops the monitoring thread.
        ''' </summary>
        Public Sub [Stop]()
            If _disposed Then
                Throw New ObjectDisposedException(Nothing, "This instance is already disposed")
            End If

            SyncLock _threadLock
                Dim thread As Thread = _thread
                If thread IsNot Nothing Then
                    _eventTerminate.[Set]()
                    thread.Join()
                End If
            End SyncLock
        End Sub

        Private Sub MonitorThread()
            Try
                ThreadLoop()
            Catch e As Exception
                OnError(e)
            End Try
            _thread = Nothing
        End Sub

        Private Sub ThreadLoop()
            Dim registryKey As IntPtr
            Dim result As Integer = RegOpenKeyEx(_registryHive, _registrySubName, 0, STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_NOTIFY, registryKey)
            If result <> 0 Then
                Throw New Win32Exception(result)
            End If

            Try
                Dim _eventNotify As New AutoResetEvent(False)
                Dim waitHandles As WaitHandle() = New WaitHandle() {_eventNotify, _eventTerminate}
                While Not _eventTerminate.WaitOne(0, True)
                    result = RegNotifyChangeKeyValue(registryKey, True, _regFilter, _eventNotify.SafeWaitHandle, True)
                    If result <> 0 Then
                        Throw New Win32Exception(result)
                    End If

                    If WaitHandle.WaitAny(waitHandles) = 0 Then
                        OnRegChanged()
                    End If
                End While
            Finally
                If registryKey <> IntPtr.Zero Then
                    RegCloseKey(registryKey)
                End If
            End Try
        End Sub

        Public Sub Dispose1() Implements System.IDisposable.Dispose
            Me.Stop()
        End Sub
    End Class

    ''' <summary>
    ''' Filter for notifications reported by <see cref="RegistryMonitor"/>.
    ''' </summary>
    <Flags()> _
    Public Enum RegChangeNotifyFilter
        ''' <summary>Notify the caller if a subkey is added or deleted.</summary>
        Key = 1
        ''' <summary>Notify the caller of changes to the attributes of the key,
        ''' such as the security descriptor information.</summary>
        Attribute = 2
        ''' <summary>Notify the caller of changes to a value of the key. This can
        ''' include adding or deleting a value, or changing an existing value.</summary>
        Value = 4
        ''' <summary>Notify the caller of changes to the security descriptor
        ''' of the key.</summary>
        Security = 8
    End Enum
End Namespace

