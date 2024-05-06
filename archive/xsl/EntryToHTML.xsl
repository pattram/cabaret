<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

    <xsl:template match="tei:TEI">
  
        <xsl:variable name="cabaretist" select="//tei:listPerson[@xml:id='persons']/tei:person[@xml:id = substring(//tei:msContents/@ana,2)]"/>        
        <xsl:variable name="gender" select="$cabaretist/tei:persName/@ana"/>
        <xsl:variable name="image" select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:figure"/>
        
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <title>Kabarettarchiv</title>
            </head>
            <body>
              
                <h2>
                    <a href="{$cabaretist/tei:persName/tei:ref[@type='GND']/@target}"><img src="icons/gnd.png" alt="GND" height="18"/></a>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$cabaretist/tei:persName/tei:forename"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$cabaretist/tei:persName/tei:surname"/>    
                    <xsl:if test="$cabaretist/tei:persName/tei:ref[@type='ABOUT']">
                        <a href="{$cabaretist/tei:persName/tei:ref[@type='ABOUT']/@target}"><img src="icons/youtube.png" alt="GND" height="30"/></a>
                    </xsl:if>
                </h2>
                
                <img src="{$image/tei:graphic/@url}" height="200" />
                <p><xsl:value-of select="$image/tei:head"/></p>
   
                <p>
                    <xsl:for-each select="//tei:respStmt[not(@ana='#status.hidden')]">
                        <b><xsl:value-of select="tei:resp"/></b><xsl:value-of select="concat(': ', tei:persName/tei:forename, ' ', tei:persName/tei:surname)"/><br/>
                    </xsl:for-each>
                </p>
                
   
                <p>
                    <xsl:if test="$cabaretist/tei:birth">
                        <xsl:text>* </xsl:text> <xsl:value-of select="$cabaretist/tei:birth/tei:date"/>
                        <xsl:if test="$cabaretist/tei:birth/tei:name[@type='place']">
                            <xsl:text> in </xsl:text><xsl:value-of select="$cabaretist/tei:birth/tei:name[@type='place']"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:if test="$cabaretist/tei:death">
                        <xsl:text>† </xsl:text><xsl:value-of select="$cabaretist/tei:death/tei:date"/>
                        <xsl:if test="$cabaretist/tei:death/tei:name[@type='place']">
                            <xsl:text> in </xsl:text><xsl:value-of select="$cabaretist/tei:death/tei:name[@type='place']"/>
                        </xsl:if>
                        
                    </xsl:if>
                </p>
                
                <p>
                    <xsl:for-each select="$cabaretist/tei:interpGrp[@type='roles']/tei:interp">
                        <xsl:variable name="role" select="substring(@ana,2)"/>
                        <xsl:value-of select="//tei:taxonomy[@xml:id='roles']/tei:category[@xml:id=$role]/tei:catDesc/tei:name[@type=$gender]"/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </p>
                
                
   
                <p>
                    <xsl:value-of select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:ab[contains(@xml:id,'general')]"/>
                </p>
    
                <table>
                    <xsl:for-each select="tei:text/tei:body/tei:div[@xml:id = 'biography']/tei:ab[not(contains(@xml:id,'general'))]">
                        <tr>
                            <td style="width: 50px; vertical-align:top"><xsl:value-of select="tei:date/@when"/></td>
                            <td><xsl:apply-templates/></td>
                        </tr>                   
                    </xsl:for-each>
                </table>

                    
                <xsl:if test ="tei:text/tei:body/tei:div[@xml:id = 'video']">
                    <h4>Videos und Filme</h4>
                    <ol>
                        <xsl:for-each select="tei:text/tei:body/tei:div[@xml:id = 'video']/tei:listBibl/tei:bibl">
                            <xsl:call-template name="listBibl"/>
                        </xsl:for-each>
                    </ol>
                </xsl:if>    

                <xsl:if test ="tei:text/tei:body/tei:div[@xml:id = 'audio']">
                    <h4>Audiomaterial</h4>
                    <ol>
                        <xsl:for-each select="tei:text/tei:body/tei:div[@xml:id = 'audio']/tei:listBibl/tei:bibl">
                            <xsl:call-template name="listBibl"/>
                        </xsl:for-each>
                    </ol>
                </xsl:if>    
                

            </body>
        </html> 
    </xsl:template>
    
    <xsl:template name="listBibl">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:persName">  
        <xsl:variable name="ref" select="@type"/>
        <xsl:variable name="person" select="//tei:listPerson/tei:person[@xml:id=substring($ref,2)]"/>
        <xsl:if test="@ana = '#gnd' and $person/tei:persName/tei:ref[@type='GND']/@target">
            <a href="{$person/tei:persName/tei:ref[@type='GND']/@target}"><img src="icons/gnd.png" alt="GND" height="16"/></a> 
            <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$person/tei:persName/@ref">
                <a href="{$person/tei:persName/@ref}"><xsl:value-of select="concat($person/tei:persName/tei:forename,  ' ', $person/tei:persName/tei:surname)"/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($person/tei:persName/tei:forename,  ' ', $person/tei:persName/tei:surname)"/>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>

    <xsl:template match="tei:rs">
         <q><xsl:value-of select="."/></q>
    </xsl:template>

</xsl:stylesheet>
