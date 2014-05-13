<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- Defines the URL for the document download page -->
  <xsl:param name="DownloadDocument" />
  <!-- Defines an optional document type -->
  <xsl:param name="DocumentType" />
  <!-- Defines the URL for the email banner -->
  <xsl:param name="Banner" />
  <!-- Defines the URL for the home page -->
  <xsl:param name="HomePage" />
  <!-- Defined the the host server -->
  <xsl:param name="Host" />
  <!-- This template produces a html formatted message body-->
  <xsl:output  method="html" />
  <!-- The defination of the message body -->
  <xsl:template match="MemberResource">
    <head>
      <base href="{$Host}" />
    </head>
    <body>
      <img src="{$Banner}" alt="NRC+PICKER eToolKit" />
      <p>
        A resource entitled, <cite>
          <xsl:value-of select="Title"/>
        </cite> is now available on your <a href="{$HomePage}" >eToolKit</a> website. Below is a brief summary:
      </p>
      <blockquote>
        <xsl:apply-templates select="AbstractHtml" />
      </blockquote>
      <p>
        <strong>Categories addressed:</strong>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="Category" />
      </p>
      <p>
        <strong>Resource type:</strong>
        <xsl:text> </xsl:text>
        <xsl:value-of select="ResourceType/Description" />
      </p>
      <p>
        You can access the full resource<xsl:text> </xsl:text><a href="{$DownloadDocument}?id={@Id}{$DocumentType}" tooltip="{Title}">here</a>.
        (login required)
      </p>
      <hr />
      <P style="font:smaller">
        You have received this notification because you are an eToolkit
        subscriber. To stop receiving these updates please log-in to your eToolkit
        account <A href="{$HomePage}">here</A>. Once you have logged in, click on the preferences
        link in the support box located on the left hand side of the site. On the preferences page,
        you can change your email notification setting and then click the save preferences button.
      </P>
    </body>
  </xsl:template>
  <xsl:template match="AbstractHtml">
    <xsl:copy-of select="*|text()|@*"/>
  </xsl:template>
  <xsl:template match="Category">
    <xsl:value-of select="Description" />
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
