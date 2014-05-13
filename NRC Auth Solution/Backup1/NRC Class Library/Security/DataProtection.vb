' Uses the Data Protection API (DPAPI) to encrypt and decrypt secrets
' based on the logged in user or local machine. 

Imports System.Runtime.InteropServices
Imports System.Security
Imports System.Text

Namespace Security


    Public NotInheritable Class DataProtection

        ' use local machine or user to encrypt and decrypt the data
        Public Enum Store
            Machine
            User
        End Enum


        ' static class
        Private Sub New()
        End Sub

        ' public methods

        ' encrypt the data using DPAPI, returns a base64-encoded encrypted string
        Public Shared Function Encrypt(ByVal data As String, ByVal entropy As String, ByVal store As Store) As String
            ' holds the result string
            Dim result As String = ""

            ' blobs used in the CryptProtectData call
            Dim inBlob As New Win32.DATA_BLOB
            Dim entropyBlob As New Win32.DATA_BLOB
            Dim outBlob As New Win32.DATA_BLOB

            Try
                ' setup flags passed to the CryptProtectData call
                Dim flags As Integer = Win32.CRYPTPROTECT_UI_FORBIDDEN Or _
                CInt(IIf(store = store.Machine, Win32.CRYPTPROTECT_LOCAL_MACHINE, 0))

                ' setup input blobs, the data to be encrypted and entropy blob
                SetBlobData(inBlob, ASCIIEncoding.ASCII.GetBytes(data))
                SetBlobData(entropyBlob, ASCIIEncoding.ASCII.GetBytes(entropy))

                ' call the DPAPI function, returns true if successful and fills in the outBlob
                If Win32.CryptProtectData(inBlob, "", entropyBlob, IntPtr.Zero, IntPtr.Zero, flags, outBlob) Then
                    Dim resultBits As Byte() = GetBlobData(outBlob)
                    If Not resultBits Is Nothing Then
                        result = Convert.ToBase64String(resultBits)
                    End If
                End If
            Catch ex As Exception
                ' an error occurred, return an empty string
            Finally
                ' clean up
                If inBlob.pbData.ToInt32() <> 0 Then
                    Marshal.FreeHGlobal(inBlob.pbData)
                End If

                If entropyBlob.pbData.ToInt32() <> 0 Then
                    Marshal.FreeHGlobal(entropyBlob.pbData)
                End If
            End Try

            Return result
        End Function

        ' decrypt the data using DPAPI, data is a base64-encoded encrypted string
        Public Shared Function Decrypt(ByVal data As String, ByVal entropy As String, ByVal store As Store) As String
            ' holds the result string
            Dim result As String = ""

            ' blobs used in the CryptUnprotectData call
            Dim inBlob As New Win32.DATA_BLOB
            Dim entropyBlob As New Win32.DATA_BLOB
            Dim outBlob As New Win32.DATA_BLOB

            Try
                ' setup flags passed to the CryptUnprotectData call
                Dim flags As Integer = Win32.CRYPTPROTECT_UI_FORBIDDEN Or _
                CInt(IIf(store = store.Machine, Win32.CRYPTPROTECT_LOCAL_MACHINE, 0))

                ' the CryptUnprotectData works with a byte array, convert string data
                Dim bits As Byte() = Convert.FromBase64String(data)

                ' setup input blobs, the data to be decrypted and entropy blob
                SetBlobData(inBlob, bits)
                SetBlobData(entropyBlob, ASCIIEncoding.ASCII.GetBytes(entropy))

                ' call the DPAPI function, returns true if successful and fills in the outBlob
                If Win32.CryptUnprotectData(inBlob, Nothing, entropyBlob, IntPtr.Zero, IntPtr.Zero, flags, outBlob) Then
                    Dim resultBits As Byte() = GetBlobData(outBlob)
                    If Not resultBits Is Nothing Then
                        result = ASCIIEncoding.ASCII.GetString(resultBits)
                    End If
                End If
            Catch ex As Exception
                ' an error occurred, return an empty string
            Finally
                ' clean up
                If inBlob.pbData.ToInt32() <> 0 Then
                    Marshal.FreeHGlobal(inBlob.pbData)
                End If

                If entropyBlob.pbData.ToInt32() <> 0 Then
                    Marshal.FreeHGlobal(entropyBlob.pbData)
                End If
            End Try

            Return result
        End Function


        ' internal methods

#Region " data protection api "

        Private Class Win32
            Public Const CRYPTPROTECT_UI_FORBIDDEN As Integer = &H1
            Public Const CRYPTPROTECT_LOCAL_MACHINE As Integer = &H4

            <StructLayout(LayoutKind.Sequential)> _
            Public Structure DATA_BLOB
                Public cbData As Integer
                Public pbData As IntPtr
            End Structure

            <DllImport("crypt32", CharSet:=CharSet.Auto)> _
            Public Shared Function CryptProtectData(ByRef pDataIn As DATA_BLOB, _
            ByVal szDataDescr As String, ByRef pOptionalEntropy As DATA_BLOB, _
            ByVal pvReserved As IntPtr, ByVal pPromptStruct As IntPtr, _
            ByVal dwFlags As Integer, ByRef pDataOut As DATA_BLOB) As Boolean
            End Function

            <DllImport("crypt32", CharSet:=CharSet.Auto)> _
            Public Shared Function CryptUnprotectData(ByRef pDataIn As DATA_BLOB, _
            ByVal szDataDescr As StringBuilder, ByRef pOptionalEntropy As DATA_BLOB, _
            ByVal pvReserved As IntPtr, ByVal pPromptStruct As IntPtr, _
            ByVal dwFlags As Integer, ByRef pDataOut As DATA_BLOB) As Boolean
            End Function

            <DllImport("kernel32")> _
            Public Shared Function LocalFree(ByVal hMem As IntPtr) As IntPtr
            End Function
        End Class

#End Region

        ' helper method that fills in a  DATA_BLOB, copies 
        ' data from managed to unmanaged memory
        Private Shared Sub SetBlobData(ByRef blob As Win32.DATA_BLOB, ByVal bits As Byte())
            blob.cbData = bits.Length
            blob.pbData = Marshal.AllocHGlobal(bits.Length)
            Marshal.Copy(bits, 0, blob.pbData, bits.Length)
        End Sub

        ' helper method that gets data from a DATA_BLOB, 
        ' copies data from unmanaged memory to managed
        Private Shared Function GetBlobData(ByRef blob As Win32.DATA_BLOB) As Byte()
            ' return an empty string if the blob is empty
            If blob.pbData.ToInt32() = 0 Then Return Nothing

            ' copy information from the blob
            Dim data(blob.cbData - 1) As Byte
            Marshal.Copy(blob.pbData, data, 0, blob.cbData)
            Win32.LocalFree(blob.pbData)

            Return data
        End Function

    End Class

End Namespace