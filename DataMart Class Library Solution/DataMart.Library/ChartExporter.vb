Friend Class ChartExporter
    Inherits CmsExporter

    Protected Overrides Function GetRecodeReader(ByVal rdr As System.Data.IDataReader) As System.Data.IDataReader

        Return New ChartRecodeReader(rdr)

    End Function

    Protected Overrides Sub WriteXmlResponseElement(ByVal reader As System.Data.IDataReader, ByVal writer As System.Xml.XmlTextWriter)

        MyBase.WriteXmlResponseElement(reader, writer)

        Try
            writer.WriteElementString("CHTORG", reader("CHTORG").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTORG field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTORG", "M")

        End Try

        'Elements no longer used, hard coded to M
        writer.WriteElementString("CHTWAIT", "M")
        writer.WriteElementString("CHTTEST", "M")
        writer.WriteElementString("CHTCHECK", "M")

        Try
            writer.WriteElementString("CHTSAME", reader("CHTSAME").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTSAME field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTSAME", "M")

        End Try

        Try
            writer.WriteElementString("CHTMED", reader("CHTMED").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTMED field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTMED", "M")

        End Try

        Try
            writer.WriteElementString("CHTSIGN", reader("CHTSIGN").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTSIGN field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTSIGN", "M")

        End Try

        Try
            writer.WriteElementString("CHTINT", reader("CHTINT").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTINT field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTINT", "M")

        End Try

        Try
            writer.WriteElementString("CHTINTAV", reader("CHTINTAV").ToString)

        Catch ex As Exception
            'Catch ex As IndexOutOfRangeException
            mTPSReport.AddValue("The CHTINTAV field does not exist or is NULL. Recoded to missing.")
            writer.WriteElementString("CHTINTAV", "M")

        End Try

    End Sub

End Class
