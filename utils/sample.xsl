<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 <xsl:template match="/">
	 <echantillons>
		<xsl:for-each select="samples/sample">
			<echantillon>
				<id><xsl:value-of select="uid"/></id>
				<uuid><xsl:value-of select="uuid" /></uuid>
				<identifiant><xsl:value-of select="identifier" /></identifiant>
				<localisation>
					<xsl:attribute name="x"><xsl:value-of select="wgs84_x" /></xsl:attribute>
					<xsl:attribute name="y"><xsl:value-of select="wgs84_y" /></xsl:attribute>
				</localisation>
			<referent><xsl:value-of select="referent_name" /></referent>
			<date_echantillonnage><xsl:value-of select="sampling_date" /></date_echantillonnage>
			</echantillon>
		</xsl:for-each>
	 </echantillons>
 </xsl:template>
 </xsl:stylesheet>
