<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oaidc_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" exclude-result-prefixes="xs xd"
    version="1.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>




    <xsl:template match="oaidc_dc:dc">

        <resource xmlns="http://datacite.org/schema/kernel-2.2"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd"
            lastMetadataUpdate="2006-05-04" metadataVersionNumber="1">

            <identifier identifierType="DOI">%%DOI%%</identifier>


            <xsl:if test="dc:creator">
                <creators>
                    <xsl:for-each select="dc:creator">
                        <creator>
                            <creatorName>
                                <xsl:value-of select="."/>
                            </creatorName>
                        </creator>
                    </xsl:for-each>
                </creators>
            </xsl:if>

            <xsl:if test="dc:title">
                <titles>
                    <xsl:for-each select="dc:title">
		    <xsl:variable name="title" select="."/>
                    <xsl:if test="$title !=''">
			<title>
                            <xsl:value-of select="."/>
                        </title>
                    </xsl:if>    
                    </xsl:for-each>
                </titles>
            </xsl:if>

            <xsl:if test="dc:publisher">
                <publisher>
                    <xsl:for-each select="dc:publisher">
                            <xsl:value-of select="."/>
                    </xsl:for-each>
                </publisher>
            </xsl:if>

	   <xsl:if test="dc:date">
                <xsl:for-each select="dc:date">
                    <xsl:variable name="date" select="."/>
                    <xsl:if test="not(starts-with($date, 'info:eu-repo'))">
                        <publicationYear>
                            <xsl:value-of select="substring($date, 0, 5)"/>
                        </publicationYear>
                    </xsl:if>    
                </xsl:for-each>
            </xsl:if>

            <xsl:if test="dc:subject">
                <subjects>
                    <xsl:for-each select="dc:subject">
                        <subject>
                            <xsl:value-of select="."/>
                        </subject>
                    </xsl:for-each>
                </subjects>
            </xsl:if>

            <xsl:if test="dc:contributor != ''">
                <contributors>
                    <xsl:for-each select="dc:contributor">
                        <contributor contributorType="Supervisor">
                            <contributorName><xsl:value-of select="."/></contributorName>
                        </contributor>
                    </xsl:for-each>
                </contributors>
            </xsl:if>
            
            <resourceType resourceTypeGeneral="Text">PDF Document</resourceType>

            
            <xsl:if test="dc:format">
                <formats>
                    <format><xsl:value-of select="dc:format"/></format>
                </formats>
                
            </xsl:if>
            
            <xsl:if test="dc:rights">
                <rights>
                    <xsl:value-of select="dc:rights"/>
                </rights>
            </xsl:if>
            
            <xsl:if test="dc:description !=''">
                <descriptions>
                    <xsl:for-each select="dc:description">
		    <xsl:variable name="description" select="."/>
                    <xsl:if test="$description !=''">
                        <description descriptionType="Abstract">
                            <xsl:value-of select="."/>
                        </description>
                    </xsl:if>    
                    </xsl:for-each>
                </descriptions>
            </xsl:if>

            

        </resource>
    </xsl:template>
</xsl:stylesheet>
