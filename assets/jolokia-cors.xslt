<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output encoding="utf-8"/>

    <xsl:param name="origin"/>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="restrict/cors/allow-origin/text()">
        <xsl:value-of select="$origin"/>
    </xsl:template>

</xsl:stylesheet>