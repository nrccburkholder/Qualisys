Imports System.Xml
Imports System.Xml.Serialization
Imports System.io
Imports Nrc.Framework.Configuration
Public Class EditXMLForm

    Private mConfigDataset As DataSet
    Private Sub LoadConfigXML()
        mConfigDataset = New DataSet("file")
        mConfigDataset.ReadXml(Config.SerializedConfigFileName)
        BindingSource1.DataSource = mConfigDataset
        BindingSource1.DataMember = "environmentSettings"

        GridControl1.DataSource = BindingSource1
        Me.RichTextBox1.LoadFile(Config.SerializedConfigFileName, RichTextBoxStreamType.PlainText)
    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        mConfigDataset.WriteXml(Config.SerializedConfigFileName, XmlWriteMode.IgnoreSchema)
        Config.ResetEnvironmentSettings()
        Me.RichTextBox1.LoadFile(Config.SerializedConfigFileName, RichTextBoxStreamType.PlainText)
    End Sub

    Private Sub TestXMLSerializiation_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        LoadConfigXML()
    End Sub
End Class
