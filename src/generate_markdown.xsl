<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="count(.//error) != 0">
                <xsl:value-of select=".//error/text()"/>
            </xsl:when>
            <xsl:otherwise>
                # Drivers for <xsl:value-of select=".//serie_type/text()"/> for <xsl:value-of select=".//year/text()"/> season

                ---
                ___
                <xsl:apply-templates select=".//driver"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="driver">
        ### <xsl:value-of select=".//full_name/text()"/>
        1. Country: <xsl:value-of select=".//country/text()"/>
        2. Birth date: <xsl:value-of select=".//birth_date/text()"/>
        3. Birthplace: <xsl:value-of select=".//birth_place/text()"/>
        4. Car manufacturer: <xsl:choose><xsl:when test="count(.//car) != 0"><xsl:value-of select=".//car/text()"/></xsl:when><xsl:otherwise>-</xsl:otherwise></xsl:choose>
        5. Rank: <xsl:choose><xsl:when test="empty(.//rank/text())">-</xsl:when><xsl:otherwise><xsl:value-of select=".//rank/text()"/></xsl:otherwise></xsl:choose>
        <!-- Pongo las statistics si el rank tiene un '-' o si el rank esta vacio -->
        <xsl:if test="not(contains(.//rank/text(), '-')) and not(empty(.//rank/text()))" >
            <xsl:apply-templates select=".//statistics"/>
        </xsl:if>
        ---
    </xsl:template>


    <xsl:template match="statistics">
        ##### Statistics
        - Season points: <xsl:value-of select=".//season_points/text()"/>
        - Wins: <xsl:value-of select=".//wins/text()"/>
        - Poles: <xsl:value-of select=".//poles/text()"/>
        - Races not finished: <xsl:value-of select=".//races_not_finished/text()"/>
        - Laps completed: <xsl:value-of select=".//laps_completed/text()"/>
    </xsl:template>

</xsl:stylesheet>