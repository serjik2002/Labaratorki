<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head>
                <title>Smartphone List</title>
                <style>
                    table {
                        border-collapse: collapse;
                        width: 100%;
                        font-family: Arial, sans-serif;
                    }
                    th, td {
                        border: 1px solid #ddd;
                        padding: 8px;
                        text-align: left;
                    }
                    th {
                        background-color: #f2f2f2;
                        
                    }
                </style>
            </head>
            <body>
                <h1>Smartphone List</h1>
                <table>
                    <tr>
                        <th>Model</th>
                        <th>Brand</th>
                        <th>Operating System</th>
                        <th>Release Year</th>
                        <th>Rating</th>
                    </tr>
                    <xsl:for-each select="smartphones/smartphone">
                        <tr>
                            <td><xsl:value-of select="model"/></td>
                            <td><xsl:value-of select="brand"/></td>
                            <td><xsl:value-of select="os"/></td>
                            <td><xsl:value-of select="release_year"/></td>
                            <td><xsl:value-of select="rating"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>