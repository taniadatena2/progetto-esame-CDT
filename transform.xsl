<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="html" indent="yes" encoding="UTF-8"/> 

    <xsl:template match="/TEI">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>
                    <xsl:value-of select="teiHeader/fileDesc/titleStmt/title[@type='title']"/>
                </title>
                <link rel="stylesheet" href="style.css"/>
                <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
                <script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>

                <script src="script2.js"></script>
            </head>
            <body>
                <header>
                    <h1><a href="index.html">La Rassegna Settimanale</a></h1>
                </header>

                <!--menu-->
                <nav>
                    <ul>
                        <li><a href="#">ARTICOLI</a>
                            <ul>
                                <li><a href="art179.html" data-file="art.179.xml" class="carica_articolo">Articolo 1, fascicolo 179</a></li>
                                <li><a href="art194.html" data-file="art194.xml" class="carica_articolo">Articolo 2, fascicolo 194</a></li>
                            </ul>
                        </li>
                        <li><a href="#">BIBLIOGRAFIA</a>
                            <ul>
                                <li><a href="bibl1.html">Libro di letteratura per Fanciulli</a></li>
                                <li><a href="bibl2.html">Un bacio, Luigi Capuana</a></li>
                             </ul>
                        </li>
                        <li><a href="#">NOTIZIE</a>
                            <ul>
                                <li><a href="not1.html">Quinta notizia, fascicolo 179</a></li>
                                <li><a href="not2.html">Ultima notizia, fascicolo 194 </a></li>
                            </ul>
                        </li> 
                    </ul>
                </nav>

                <!--spazio per il contenuto-->
                <div class="main_container">
                    <div class="contenuto">
                        <button id="btnEdition">Edizione Digitale</button>
                        <div id="facsimilePages">
                            <div class="page-container">
                                <button id="prevPageFacsimile" disabled="disabled">&#8592;</button>
                                <div class="pages_wrapper">
                                    <xsl:apply-templates select="facsimile/surface"/>
                                </div>
                                <button id="nextPageFacsimile">&#8594;</button>
                            </div>
                        </div>

                        <div id="textPages" style="display: none;">
                            <div class="page-container">
                                <button id="prevPageText" disabled="disabled">&#8592;</button>
                                <div class="pages_wrapper">
                                    <xsl:apply-templates select="text/body/div[@type='articolo' or @type='bibliografia' or @type='notizia']/pb"/>
                                </div>
                                <button id="nextPageText">&#8594;</button>
                            </div>
                        </div>
                    </div>
                </div>
            </body>
            <footer id="footer">
                Il progetto è stato realizzato da Tania D'Atena per l'esame di Codifica di Testi, previsto dal corso di laurea triennale in Informatica Umanistica, nell'anno accademico 2024-2025.
            </footer>
        </html>
    </xsl:template>

    <xsl:template match="surface">
        <div class="page" style="display:none;">
            <xsl:variable name="img" select="graphic/@url"/>
            <img src="{$img}" alt="pagina"/>
        </div>
    </xsl:template>

    
    <!--template per <pb/>-->
    <xsl:template match="pb">
        <div class="page" style="display:none;">
            <div class="columns">
                <!-- Colonne contenute nella stessa pagina (fino al prossimo <pb>) -->
                <xsl:variable name="nextPb" select="following::pb[1]"/>
                <xsl:variable name="currentPageNodes" select="following-sibling::*[. &lt;&lt; $nextPb or not($nextPb)]"/>

                <!-- Colonna sinistra (cb n=1) -->
                <xsl:variable name="cb1" select="$currentPageNodes[self::cb[@n=1]][1]"/>
                <xsl:if test="$cb1">
                    <xsl:apply-templates select="$cb1/following-sibling::ab[1]">
                    <xsl:with-param name="col" select="1"/>
                    </xsl:apply-templates>
                </xsl:if>
                
                <!-- Colonna destra (cb n=2) -->
                <xsl:variable name="cb2" select="$currentPageNodes[self::cb[@n=2]][1]"/>
                <xsl:if test="$cb2">
                    <xsl:apply-templates select="$cb2/following-sibling::ab[1]">
                    <xsl:with-param name="col" select="2"/>
                    </xsl:apply-templates>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <!--template per <ab>-->
    <xsl:template match="ab">
        <xsl:param name="col"/>
        <div>
            <xsl:attribute name="class">
                <xsl:text>col </xsl:text>
                <xsl:value-of select="concat('col', $col)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--template per <p>-->
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <!--template per <head>-->
    <xsl:template match="head[@type='title']">
        <span class="headtitle">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="head[@type='subtitle']">
        <span class="headsubtitle">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--template per <lb/>-->
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <!--template per space-->
    <xsl:template match="space[@dim='horizontal']">
        <span class="indent" style="width:{translate(@extent, ',', '.')}"></span>
    </xsl:template>

    <!--template per <name>-->
    <xsl:template match="name">
        <span class="name">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--template per <persName>-->
   <xsl:template match="persName">
        <span class="person" title="{@key}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--template per <placeName>-->
    <xsl:template match="placeName">
        <span class="place" title="{@type}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--template per <hi>-->
    <xsl:template match="hi[@rend='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <!--template per <title>-->
    <xsl:template match="title">
        <span class="title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--template per <choice>-->
    <xsl:template match="choice">
        <xsl:apply-templates select="(corr | reg | expan)[1]/node()"/>
    </xsl:template>

</xsl:stylesheet>