Imports System.IO
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ImageCollection
    Inherits System.Collections.CollectionBase

#Region " Private Members "

#End Region

#Region " Events "

    Public Event ProcessImageBegin As EventHandler(Of ProcessImageBeginEventArgs)
    Public Event ProcessImageComplete As EventHandler(Of ProcessImageCompleteEventArgs)

    Public Event CreateDLVBegin As EventHandler
    Public Event CreateDLVUpdate As EventHandler(Of CreateDLVUpdateEventArgs)
    Public Event CreateDLVComplete As EventHandler

#End Region

#Region " Public Properties "

    Default Public ReadOnly Property Item(ByVal index As Integer) As Image
        Get
            Return DirectCast(MyBase.List(index), Image)
        End Get
    End Property

    Public ReadOnly Property BadImages() As ImageCollection
        Get
            Dim images As New ImageCollection

            For Each badImage As Image In MyBase.List
                If Not badImage.IsBarcodeValid Then
                    images.Add(badImage)
                End If
            Next

            Return images
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Function Add(ByVal newImage As Image) As Integer

        Return MyBase.List.Add(newImage)

    End Function

    Public Sub Populate(ByVal imageList As FileInfo())

        Dim barcodeReader As SoftekBarcodeLib.BarcodeReader
        Dim curImage As Image
        Dim barcodeQuantity As Integer
        Dim barcode As String

        'Clear the list
        MyBase.List.Clear()

        'Setup the barcode reader
        barcodeReader = New SoftekBarcodeLib.BarcodeReader
        With barcodeReader
            'Barcode might be in any direction
            .ScanDirection = 15
            .SkewTolerance = 0

            'Only look for Code39 barcodes
            .ReadCode39 = 1
            .ReadCodabar = 0
            .ReadCode128 = 0
            .ReadCode25 = 0
            .ReadCode25ni = 0
            .ReadEAN13 = 0
            .ReadEAN8 = 0
            .ReadPatchCodes = 0
            .ReadUPCA = 0
            .ReadUPCE = 0

            'Only get the barcode if it is 8 characters long
            .MinLength = 8
            .MaxLength = 8

            'Scan every 9th line of the image 
            .LineJump = 9
        End With

        'Loop through all of the images and read the barcodes
        Dim currentImageNumber As Integer = 0
        For Each imageFile As FileInfo In imageList
            'Notify the interface that we are beginning
            currentImageNumber += 1
            Dim beginEventArgs As New ProcessImageBeginEventArgs(currentImageNumber)
            RaiseEvent ProcessImageBegin(Me, beginEventArgs)

            'Check to see if the user has canceled
            If beginEventArgs.Cancel Then
                MyBase.List.Clear()
                Exit Sub
            End If

            'Get the barcode from this image
            barcodeQuantity = barcodeReader.ScanBarCode(imageFile.FullName)
            If (barcodeQuantity < 1) Then
                barcode = ""
            Else
                barcode = barcodeReader.GetBarString(1)
            End If

            'Add this image to the collection
            curImage = New Image(barcode, imageFile)
            Add(curImage)

            'Notify the interface that we have finished
            Dim completeEventArgs As New ProcessImageCompleteEventArgs(curImage)
            RaiseEvent ProcessImageComplete(Me, completeEventArgs)

            'Check to see if the user has canceled
            If completeEventArgs.Cancel Then
                MyBase.List.Clear()
                Exit Sub
            End If
        Next

    End Sub

    Public Function GetLithoList() As String

        Return GetLithoList("," & vbCrLf, "'")

    End Function

    Public Function GetLithoList(ByVal itemSeparator As String, ByVal itemDelimiter As String) As String

        Dim lithoList As String = ""
        Dim lastLitho As String = ""
        Dim lithos As New ArrayList

        'Put all the lithos into an arraylist
        For Each curImage As Image In MyBase.List
            If curImage.IsBarcodeValid Then
                lithos.Add(curImage.LithoCode)
            End If
        Next

        'Sort the arraylist
        lithos.Sort()

        'Collect the unique lithocodes
        For Each curLitho As String In lithos
            'Make sure this is not a duplicate LithoCode
            If curLitho <> lastLitho Then
                'Save this as the last litho
                lastLitho = curLitho

                'Add this litho to the list
                If lithoList.Length = 0 Then
                    lithoList = itemDelimiter & curLitho & itemDelimiter
                Else
                    lithoList &= itemSeparator & itemDelimiter & curLitho & itemDelimiter
                End If
            End If
        Next

        'Return the list
        Return lithoList

    End Function

    Public Function GetBarcodeList() As String

        Return GetBarcodeList(vbCrLf, "")

    End Function

    Public Function GetBarcodeList(ByVal itemSeparator As String, ByVal itemDelimiter As String) As String

        Dim barcodeList As String = ""

        For Each curImage As Image In MyBase.List
            If curImage.IsBarcodeValid Then
                If barcodeList.Length = 0 Then
                    barcodeList = itemDelimiter & curImage.Barcode & itemDelimiter
                Else
                    barcodeList &= itemSeparator & itemDelimiter & curImage.Barcode & itemDelimiter
                End If
            End If
        Next

        Return barcodeList

    End Function

    Public Sub CreateDLVFile()

        Dim dlvPath As String = ""
        Dim imagePath As String = ""

        'Update the status
        RaiseEvent CreateDLVBegin(Me, New EventArgs)

        'Determine where we are located
        Dim countryIDCode As CountryIDs = AppConfig.CountryID

        'Get the appropriate paths
        Select Case countryIDCode
            Case CountryIDs.US
                dlvPath = AppConfig.Params("ScanExportUnProc").StringValue
                imagePath = AppConfig.Params("ScanExportImageLocUS").StringValue

            Case CountryIDs.Canada
                dlvPath = AppConfig.Params("ScanExportUnProc").StringValue
                imagePath = AppConfig.Params("ScanExportImageLocCA").StringValue

        End Select

        'Create the DLV file
        Dim dlvFileInfo As FileInfo = GetFileInfo(dlvPath)
        Dim dlvFile As TextWriter = dlvFileInfo.CreateText
        Dim completeImages As New ArrayList
        Dim copyToName As String

        Try
            'Loop through all of the images
            Dim currentImageNumber As Integer = 0
            For Each curImage As Image In MyBase.List
                'Update the status
                currentImageNumber += 1
                RaiseEvent CreateDLVUpdate(Me, New CreateDLVUpdateEventArgs(currentImageNumber))

                'Check to see if the barcode is valid
                If curImage.IsBarcodeValid Then
                    'Add this image to the DLV file
                    dlvFile.WriteLine(curImage.Barcode)

                    'Copy this image file
                    copyToName = imagePath & curImage.Barcode.Substring(0, 7) & curImage.ImageFile.Extension
                    curImage.ImageFile.CopyTo(copyToName, True)

                    'If we made it to here then this image copied successfully
                    completeImages.Add(New FileInfo(copyToName))
                End If
            Next

            'Cleanup
            dlvFile.Flush()
            dlvFile.Close()

            'Update the status
            RaiseEvent CreateDLVComplete(Me, New EventArgs)

        Catch ex As Exception
            'We have encountered an error so we need to clean up anything that was already copied
            'Delete the DLV file
            dlvFile.Flush()
            dlvFile.Close()
            dlvFileInfo.Delete()

            'Delete all of the image files
            For Each killFile As FileInfo In completeImages
                If killFile.Exists Then
                    killFile.Delete()
                End If
            Next

            'Recast the error
            Throw

        End Try

    End Sub

    Private Function GetFileInfo(ByVal filePath As String) As FileInfo

        Dim cnt As Integer
        Dim fileName As String = "BarCod"

        'Get the first valid barcode
        For Each curImage As Image In MyBase.List
            If curImage.IsBarcodeValid Then
                fileName = curImage.Barcode.Substring(0, 6)
                Exit For
            End If
        Next

        'Check to make sure the filename is unique
        Dim dlvFileInfo As FileInfo = New FileInfo(filePath & fileName & ".dlv")
        Do Until Not dlvFileInfo.Exists
            'This file name exists so lets tweek it just a bit
            cnt += 1
            dlvFileInfo = New FileInfo(filePath & fileName & cnt.ToString("00") & ".dlv")
        Loop

        'Return the filename
        Return dlvFileInfo

    End Function

#End Region

End Class
