#!bin/bash

YEAR=$1
TYPE=$2

function putError() {
    echo '<?xml version="1.0" encoding="UTF-8"?>' > nascar_data.xml
    echo '<nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">' >> nascar_data.xml
    echo -e '\t''<error>' $1 '</error>' >> nascar_data.xml
    echo '</nascar_data>' >> nascar_data.xml
}

function generateDocuments() {
    # Comprobamos que valide con el XSD nascar_data.xsd
    java dom.Writer -v -n -s -f nascar_data.xml
    # Generamos la pagina Markdown nascar_page.md
    java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_markdown.xsl -o:nascar_page.md
}

if [ $# -ne 2 ]
then
    putError "There must be 2 arguments (year, serie_type)"
    generateDocuments

elif ! [ $YEAR -ge 2013 -a $YEAR -le 2021 ]
then
    putError "First parameter 'Year' must be an integer between 2013 and 2021"
    generateDocuments

elif [ $TYPE != "sc" -a $TYPE != "xf" -a $TYPE != "cw" -a $TYPE != "go" -a $TYPE != "mc" -a $TYPE != "enas" ]
then
    putError "Second parameter 'Serie_Type' must be only one of the following: 'sc', 'xf', 'cw', 'go', 'mc' or 'enas'"
    generateDocuments

elif [ $TYPE = "enas" -a $YEAR != 2020 ]
then
    putError "Serie_Type 'enas' (eNASCAR) is only supported with 2020 season"
    generateDocuments

else
    # Obtenemos los xmls.
    curl http://api.sportradar.us/nascar-ot3/$TYPE/$YEAR/drivers/list.xml?api_key=${SPORTRADAR_API} -o drivers_list.xml
    curl http://api.sportradar.us/nascar-ot3/$TYPE/$YEAR/standings/drivers.xml?api_key=${SPORTRADAR_API} -o drivers_standings.xml

    # Borramos los namespaces
    sed -i 's/xmlns=\"http:\/\/feed.elasticstats.com\/schema\/nascar\/series-v2.0.xsd\" //' drivers_list.xml
    sed -i 's/xmlns=\"http:\/\/feed.elasticstats.com\/schema\/nascar\/standings-v2.0.xsd\" //' drivers_standings.xml

    # Generamos el XML nascar_data.xml
    java net.sf.saxon.Query extract_nascar_data.xq > nascar_data.xml

    generateDocuments
fi