<?xml version="1.0" encoding="UTF-8"?>
<!-- 
	wadl2json.xsl
	
	An XSL style-sheet for converting WADLs to JSON.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:wadl="http://wadl.dev.java.net/2009/02" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="text" encoding="utf-8"/>

	<xsl:template match="/wadl:application">{
	"endpoints": [<xsl:apply-templates/>
	]
}</xsl:template>

	<xsl:template match="wadl:resources">
	<xsl:for-each select="wadl:resource"><xsl:call-template name="resource"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>
	</xsl:template>
	
	<xsl:template name="resource">
		{
			"name": "<xsl:value-of select="wadl:method/@id"/>",
			"methods": [<xsl:for-each select="wadl:method"><xsl:call-template name="method"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>
			]
		}</xsl:template>
	
	<xsl:template name="method">
				{
					"MethodName":"<xsl:value-of select="substring(parent::node()/@path, 2)" />",
					"Synopsis":"<xsl:value-of select="translate(wadl:doc[@xml:lang='en']/@title, '&quot;', &quot;'&quot;)" disable-output-escaping="yes"/>",
					"HTTPMethod":"GET",
					"URI": "<xsl:value-of select="parent::node()/@path" />",
					"RequiresOAuth": "N",<xsl:apply-templates/>
				}</xsl:template>

	<xsl:template match="wadl:request">
					"parameters":[<xsl:for-each select="wadl:param"><xsl:call-template name="parameter"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>
					]</xsl:template>
	
	<xsl:template name="parameter">
						{
							"Name":"<xsl:value-of select="@name" />",
							"Repeating":"<xsl:choose><xsl:when test="@repeating='true'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",
							"Required":"<xsl:choose><xsl:when test="@required='true'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose>",
							"Default":"<xsl:value-of select="@default" />",
							"Type": "<xsl:choose><xsl:when test="wadl:option[last() > 0]">enumerated</xsl:when><xsl:otherwise><xsl:value-of select="substring-after(@type,':')" /></xsl:otherwise></xsl:choose>",
							"Description": "<xsl:value-of select="translate(wadl:doc[@xml:lang='en']/@title, '&quot;', &quot;'&quot;)" disable-output-escaping="yes"/>"<xsl:if test="wadl:option[last() > 0]">,
							"EnumeratedList": [<xsl:for-each select="wadl:option">
					  			"<xsl:value-of select="@value"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>
							]</xsl:if>
						}</xsl:template>

</xsl:stylesheet>