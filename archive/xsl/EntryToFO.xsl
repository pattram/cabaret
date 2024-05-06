<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:param name="link" />
    
    
    <xsl:attribute-set name="Überschrift">
        <xsl:attribute name="space-before">24pt</xsl:attribute>
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="Fließtext">
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
    </xsl:attribute-set>
  
    <xsl:attribute-set name="Fußzeile">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="font-family">serif</xsl:attribute>
    </xsl:attribute-set>

    <xsl:template match="tei:TEI">

        <xsl:variable name="cabaretist" select="//tei:listPerson[@xml:id='persons']/tei:person[@xml:id = substring(//tei:msContents/@ana,2)]"/>        
        <xsl:variable name="gender" select="$cabaretist/tei:persName/@ana"/>
        <xsl:variable name="image" select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:figure"/>
        
        <fo:root>
            
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A1" page-height="29.7cm" page-width="21cm"
                    margin-top="2cm" margin-bottom="3cm" margin-left="2cm" margin-right="3cm">
                    <fo:region-body/>
                    <fo:region-after/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A1">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block xsl:use-attribute-sets="Fußzeile" text-align="left">
                        <fo:inline>Österreischische Kararettarchiv, Elisabethstr. 30 / II. Stock, A-8010 Graz</fo:inline>
                    </fo:block>
                    <fo:block xsl:use-attribute-sets="Fußzeile" text-align="right">
                        <fo:inline><fo:page-number/></fo:inline>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    
                    <fo:block xsl:use-attribute-sets="Überschrift" font-size="18pt">
                        <xsl:value-of select="$cabaretist/tei:persName/tei:forename"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$cabaretist/tei:persName/tei:surname"/>
                    </fo:block>

                    <fo:block text-align="center" line-height="40pt" start-indent="10.0cm">
                        <fo:external-graphic height="auto" width="auto" content-height="auto"
                            content-width="auto" src="url('qualtinger.jpg')"> </fo:external-graphic>
                        <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt">
                            <xsl:value-of select="$image/tei:head"/>
                        </fo:block>
                    </fo:block>

                    <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt">
                        <xsl:if test="$cabaretist/tei:birth">
                            <xsl:text>* </xsl:text>
                            <xsl:value-of select="$cabaretist/tei:birth/tei:date"/>
                            <xsl:if test="$cabaretist/tei:birth/tei:name[@type = 'place']">
                                <xsl:text> in </xsl:text>
                                <xsl:value-of select="$cabaretist/tei:birth/tei:name[@type = 'place']"/>
                            </xsl:if>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:if test="$cabaretist/tei:death">
                            <xsl:text>† </xsl:text>
                            <xsl:value-of select="$cabaretist/tei:death/tei:date"/>
                            <xsl:if test="$cabaretist/tei:death/tei:name[@type = 'place']">
                                <xsl:text> in </xsl:text>
                                <xsl:value-of select="$cabaretist/tei:death/tei:name[@type = 'place']"/>
                            </xsl:if>
                        </xsl:if>
                    </fo:block>

                    <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt" font-weight="bold">
                        <xsl:for-each select="$cabaretist/tei:interpGrp[@type='roles']/tei:interp">
                            <xsl:variable name="role" select="substring(@ana, 2)"/>
                            <xsl:value-of select="//tei:taxonomy[@xml:id = 'roles']/tei:category[@xml:id = $role]/tei:catDesc/tei:name[@type = $gender]"/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </fo:block>

                    <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt">
                        <xsl:value-of select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:ab[contains(@xml:id, 'general')]"/>
                    </fo:block>

                    <fo:table space-after="10pt">
                        <fo:table-column column-width="1cm"/>
                        <fo:table-column/>
                        <fo:table-body>
                            <xsl:for-each
                                select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:ab[not(contains(@xml:id, 'general'))]">
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block xsl:use-attribute-sets="Fließtext">
                                            <xsl:value-of select="tei:date/@when"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block xsl:use-attribute-sets="Fließtext">
                                            <xsl:apply-templates/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <xsl:if test ="tei:text/tei:body/tei:div[@xml:id = 'video']">                  
                       <fo:block xsl:use-attribute-sets="Überschrift" font-size="12pt">Videos und Filme</fo:block>
                       <fo:list-block start-indent="10mm" provisional-distance-between-starts="5mm" provisional-label-separation="5mm">
                            <xsl:for-each select="tei:text/tei:body/tei:div[@xml:id = 'video']/tei:listBibl/tei:bibl">
                                <xsl:call-template name="listBibl">
                                    <xsl:with-param name="counter" select="position()"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </fo:list-block>
                    </xsl:if>
                    
                    <xsl:if test ="tei:text/tei:body/tei:div[@xml:id = 'audio']">                  
                        <fo:block xsl:use-attribute-sets="Überschrift" font-size="12pt">Audiomaterial</fo:block>
                        <fo:list-block start-indent="10mm" provisional-distance-between-starts="5mm" provisional-label-separation="5mm">
                            <xsl:for-each select="tei:text/tei:body/tei:div[@xml:id = 'audio']/tei:listBibl/tei:bibl">
                                <xsl:call-template name="listBibl">
                                    <xsl:with-param name="counter" select="position()"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </fo:list-block>
                    </xsl:if>
                    
               </fo:flow>
            </fo:page-sequence>
            
        </fo:root>
    </xsl:template>


    <xsl:template name="listBibl">
        <xsl:param name="counter"/>
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt">
                    <xsl:value-of select="$counter"/>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block xsl:use-attribute-sets="Fließtext" font-size="10pt">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>

    </xsl:template>

    <xsl:template match="tei:persName">
        <fo:inline font-style="italic"> 
             <xsl:variable name="ref" select="@type"/>
            <xsl:variable name="person" select="//tei:listPerson/tei:person[@xml:id = substring($ref, 2)]"/>
            <xsl:if test="$link='yes' and @ana = '#gnd' and $person/tei:persName/tei:ref[@type='GND']/@target">
                <fo:basic-link external-destination="{$person/tei:persName/tei:ref[@type='GND']/@target}">
                    <fo:inline color="blue"> GND </fo:inline>
                </fo:basic-link>
            </xsl:if>
            
            <xsl:choose>
                <xsl:when test="$link='yes' and $person/tei:persName/@ref">
                    <fo:basic-link external-destination="{$person/tei:persName/@ref}"><xsl:value-of select="concat($person/tei:persName/tei:forename,  ' ', $person/tei:persName/tei:surname)"/></fo:basic-link>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($person/tei:persName/tei:forename,  ' ', $person/tei:persName/tei:surname)"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:inline>
    </xsl:template>

    <xsl:template match="tei:rs">
        <fo:inline> 
            &#x201C;<xsl:value-of select="."/>&#x201D;
        </fo:inline>
    </xsl:template>
    
</xsl:stylesheet>
