<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<eml:eml 
			xmlns:eml="eml://ecoinformatics.org/eml-2.1.1" 
			xmlns:stmml="http://www.xml-cml.org/schema/stmml-1.1" 
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
			packageId="doi:10.xxxx/eml.1.1" system="https://doi.org"
			xsi:schemaLocation="eml://ecoinformatics.org/eml-2.1.1 eml.xsd">
			<xsl:for-each select="collection">
				<dataset>
					<title><xsl:value-of select="collection_name" /></title>
					<creator id="https://orcid.org/0000-0003-4207-4107">
						<individualName><xsl:value-of select="referent_firstname" />&#160;<xsl:value-of select="referent_name" />
						</individualName>
						<electronicMailAddress><xsl:value-of select="referent_email" /></electronicMailAddress>
						<xsl:element name="userId">
							<xsl:attribute name="directory">
								<xsl:value-of select="academical_directory" />
							</xsl:attribute>
							<xsl:value-of select="academical_link" />
						</xsl:element>
					</creator>
					<keywordSet>
						 <xsl:for-each select="collection_keywords/keyword">
						<keyword><xsl:value-of select="." /></keyword>
						  </xsl:for-each>
					</keywordSet>
					<contact>
						<references><xsl:value-of select="academical_link" /></references>
					</contact>
				</dataset>
			</xsl:for-each>
		</eml:eml>
	</xsl:template>
</xsl:stylesheet>

