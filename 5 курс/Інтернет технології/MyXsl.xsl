<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <head>
        <title>XML XSL Example</title>
        <style type="text/css">
          table {
            border-collapse: collapse; /* Отображать двойные линии как одинарные */
          }
          tr {
            text-align: left; /* Выравнивание по левому краю */
          }
          td, th {
            border: 1px solid #800; /* Параметры границы */
            padding: 2px; /* Поля в ячейках */
          }
        </style>
      </head>
      <body>
        <h2>Объявления: продажа автомобилей</h2>
        <table bgcolor="#CCCCCC">
          <tr>
            <th align="center" width="150">Фото</th>
            <th align="center" width="150">Марка</th>
            <th align="center" width="70">Год выпуска</th>
            <th align="center" width="100">Объем двигателя</th>
            <th align="center" width="100">Пробег</th>
            <th align="center" width="100">Цвет</th>
            <th align="center" width="200">Комплектация</th>
            <th align="center" width="80">Тип кузова</th>
            <th align="center" width="200">Состояние</th>
            <th align="center" width="80">Цена</th>
            <th align="center" width="100">Телефон</th>
          </tr>
          <xsl:for-each select="Mybody/avto">
            <tr>
              <td width="150">
                <img src="{img}" alt="Фото автомобиля"/>
              </td>
              <td width="150">
                <xsl:value-of select="marc"/>
              </td>
              <td width="70">
                <xsl:value-of select="year"/>
              </td>
              <td width="100">
                <xsl:value-of select="volume"/>
              </td>
              <td width="100">
                <xsl:value-of select="mileage"/>
              </td>
              <td width="100">
                <xsl:value-of select="color"/>
              </td>
              <td width="200">
                <xsl:value-of select="equipment"/>
              </td>
              <td width="80">
                <xsl:value-of select="type"/>
              </td>
              <td width="200">
                <xsl:value-of select="state"/>
              </td>
              <td width="80">
                <xsl:value-of select="price"/>
              </td>
              <td width="100">
                <xsl:value-of select="tel"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
