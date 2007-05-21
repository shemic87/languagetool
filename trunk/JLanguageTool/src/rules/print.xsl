<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<!-- XSLT stylesheet to pretty print grammar.xml
		
		usage:
		
		java -jar saxon8.jar grammar.xml print.xsl
		
	-->
	<xsl:output method="html" encoding="UTF-8" indent="no" />

	<xsl:template match="text()" />

	<xsl:template match="*">	
			<xsl:apply-templates select="*">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="//category">		
		<xsl:variable name="category_name" select="@name"/>
		<xsl:variable name="cat_id" select="generate-id()"/>
		<xsl:element name="div">
		<xsl:attribute name="id"><xsl:copy-of select="$cat_id"/></xsl:attribute>
		<xsl:attribute name="style">display:none</xsl:attribute>			
		<h4>		
		<xsl:element name="a">
		<xsl:attribute name="href">javascript:;</xsl:attribute>
		<xsl:attribute name="onmousedown">toggleDiv('<xsl:copy-of select="$cat_id"/>');</xsl:attribute>
		<xsl:value-of select="$category_name"/>
		</xsl:element>
		</h4>
		<ol>			
			<xsl:apply-templates select="*">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
		</ol>
		</xsl:element>
		<h4>		
		<xsl:element name="a">
		<xsl:attribute name="href">javascript:;</xsl:attribute>
		<xsl:attribute name="onmousedown">toggleDiv('<xsl:copy-of select="$cat_id"/>');</xsl:attribute>
		<xsl:value-of select="$category_name"/>
		</xsl:element>
		</h4>
	</xsl:template>


	<xsl:template match="//rule[@id!='']">
		<li>
			<xsl:value-of select="@name" />			
		</li>
		<ul>
			<xsl:apply-templates select="*" />
		</ul>
	</xsl:template>

	<xsl:template match="//rulegroup">
		<li>
			<xsl:value-of select="@name" />
		</li>
		<ul>
			<xsl:apply-templates select="*" />
		</ul>
	</xsl:template>


	<xsl:template match="//rule/example[@type='incorrect']">
		<li>
			<xsl:apply-templates select="*|text()" /> <br/>
			<xsl:if test="@correction !=''">
			<xsl:choose>
			<xsl:when test="//rules[@lang='pl']">Poprawnie: 
			<!--  two problems: parse correction, i.e., split it on "|" 
			and replace \1 with ../pattern/token[1]/text() 
			<xsl:copy-of select="../pattern/token[2]/text()"/>

			<xsl:choose>
			<xsl:when test="contains(@correction, '|')">			
			<xsl:variable name="message_cnt" select="1"/>
			<xsl:copy-of select="../message/text()[$message_cnt]"/>
			<xsl:variable name="cor_text" select="substring-before(@correction, '|')"/>
			<strong style="color: #339900;">
				<xsl:value-of select="$cor_text"/>
			</strong>
			<xsl:variable name="cor_text" select="substring-after($cor_text,'|')"/>
			aaaa <xsl:value-of select="$cor_text"/>
			<xsl:if test="contains($cor_text, '|')">
				<xsl:variable name="message_cnt" select="$message_cnt + 1"/>
				aas
				<xsl:copy-of select="../message/text()[$message_cnt]"/>
				<xsl:variable name="cor_text" select="substring-before(@correction, '|')"/>
				<strong style="color: #339900;">
					<xsl:value-of select="$cor_text"/>
				</strong>
				<xsl:variable name="message_cnt" select="$message_cnt + 1"/>
				<xsl:copy-of select="../message/text()[$message_cnt]"/>
			</xsl:if>			
			</xsl:when>
			<xsl:otherwise>
			<xsl:copy-of select="../message/text()[1]"/>
			</xsl:otherwise>
			</xsl:choose>
						-->
			</xsl:when>
			<xsl:when test="//rules[@lang='en']">Correctly: </xsl:when>
			<xsl:when test="//rules[@lang='de']">Korrekt: </xsl:when>
			<xsl:when test="//rules[@lang='fr']">Correctement : </xsl:when>
			<xsl:when test="//rules[@lang='nl']">Correct: </xsl:when>
			<xsl:when test="//rules[@lang='es']">Correctamente: </xsl:when>
			</xsl:choose>
				<strong style="color: #339900;">
					<xsl:value-of select="@correction"/>
				</strong>
			<!-- 
			<xsl:variable name="text_count" select="count(../message/text())"/>
			<xsl:value-of select="../message/text()[$text_count]"/>			
			 -->
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="//rule/example[@type='incorrect']/text()">
		<xsl:copy-of select="." />
	</xsl:template>

	<xsl:template match="//rule/example[@type='incorrect']/marker">
		<strong style="color: rgb(255, 0, 0);">
			<xsl:value-of select="./text()" />
		</strong>
	</xsl:template>
	
	<xsl:template match="//rules">	
	<html>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<header>
	<script language="javascript">
	<xsl:text>
	  function toggleDiv(divid){
    	if(document.getElementById(divid).style.display == 'none'){
	      document.getElementById(divid).style.display = 'block';
    	}else{
	      document.getElementById(divid).style.display = 'none';
    	}
	  }
	 </xsl:text>
	</script>
	</header>
	<body>
		<xsl:choose>
		<xsl:when test="//rules[@lang='pl']">Liczba reguł: </xsl:when>
		<xsl:when test="//rules[@lang='en']">Number of rules: </xsl:when>
		<xsl:when test="//rules[@lang='de']">Regeln: </xsl:when>
		<xsl:otherwise>Number of rules: </xsl:otherwise>
		</xsl:choose>
		<strong>
			<xsl:value-of select="count(//rule)"/>
		</strong>
		<br/>
		<xsl:choose>
		<xsl:when test="//rules[@lang='pl']">W tym z podpowiedziami: </xsl:when>
		<xsl:when test="//rules[@lang='en']">Rules with suggestions: </xsl:when>
		<xsl:otherwise>Rules with suggestions: </xsl:otherwise>
		</xsl:choose>
		<strong>
			<xsl:value-of select="count(//message[suggestion!=''])"/>
		</strong>
			<xsl:apply-templates select="*">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
	</body>
	</html>
	</xsl:template>	
	
</xsl:stylesheet>