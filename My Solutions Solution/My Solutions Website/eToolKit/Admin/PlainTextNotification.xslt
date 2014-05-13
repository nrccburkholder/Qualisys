<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Defines the URL for the document download page -->
  <xsl:param name="DownloadDocument" />
  <!-- Defines the URL for the document download page -->
  <xsl:param name="DocumentType" />
  <!-- Defines the URL for the email banner - N/A -->
  <xsl:param name="Banner" />
  <!-- Defines the URL for the home page - N/A -->
  <xsl:param name="HomePage" />
  <!-- Defined the the host server - N/A -->
  <xsl:param name="Host" />
  <!-- This template produces a plain text message body-->
  <xsl:output  method="text"/>
  <!-- The defination of the message body -->
  <xsl:template match="MemberResource">
    NRC+PICKER eToolKit

    A resource entitled, "<xsl:value-of select="Title"/>" is now available on your eToolKit website. Below is a brief summary:

    <xsl:value-of select="normalize-space(AbstractPlainText)"/>


    Categories addressed: <xsl:apply-templates select="Category" />

    Resource type: <xsl:value-of select="ResourceType/Description" />

    You can access the full resource here: <xsl:value-of select="$DownloadDocument" />?id=<xsl:value-of select="@Id"/><xsl:value-of select="$DocumentType" /> (login required)

    ---

    You have received this notification because you are an eToolkit subscriber.
    To stop receiving these updates please log-in to your eToolkit
    account <xsl:value-of select="$HomePage" />. Once you have logged in, click on the preferences
    link in the support box located on the left hand side of the site. On the preferences page,
    you can change your email notification setting and then click the save preferences button.


  </xsl:template>
  <!--<xsl:template match="Question">
    <xsl:apply-templates select="ServiceType" />
    <xsl:apply-templates select="View" />
    <xsl:apply-templates select="Theme" />
    <xsl:apply-templates select="QuestionContent" />
  </xsl:template>
  <xsl:template match="ServiceType|View|Theme|QuestionContent|OtherType">
    <xsl:value-of select="Description" />
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>-->
  <xsl:template match="Category">
    <xsl:value-of select="Description" />
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
