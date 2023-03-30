(: Funcion para saber si el driver posee rank :)
declare function local:hasRank ($driver as element(driver), $p as element(series)) as xs:integer {
    let $id := $p/season/driver
    let $s := count($id[./@id = $driver/@id])
    return $s
};

(: Funcion para obtener las statistics de un driver :)
declare function local:getStatistics ($driver as element(driver), $p as element(series)) as node() {
    let $id := $p/season/driver[./@id = $driver/@id]
    return  <statistics>        {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
                <season_points> {xs:string($id/@points)} </season_points>   {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
                <wins> {xs:string($id/@wins)}</wins>                        {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
                <poles> {xs:string($id/@poles)}</poles>                     {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
                <races_not_finished> {xs:string($id/@dnf)}</races_not_finished>         {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
                <laps_completed> {xs:string($id/@laps_completed)}</laps_completed>      {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
            </statistics>
};

(: Funcion que devuelve todas las statistics vacias :)
declare function local:getEmptyStatistics () as node() {
    <statistics>        {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
        <season_points> {xs:string("")} </season_points>    {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
        <wins> {xs:string("")}</wins>                       {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
        <poles> {xs:string("")}</poles>                     {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
        <races_not_finished> {xs:string("")}</races_not_finished>       {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}{"&#9;"}
        <laps_completed> {xs:string("")}</laps_completed>               {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
    </statistics>
};

(: ------------------------------------------------------------------------------------------------------------:)

let $p := doc("drivers_standings.xml")//series
return
    <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation= "nascar_data.xsd">   {"&#10;"}{"&#9;"}
        <year> {xs:int($p/season/@year)} </year>            {"&#10;"}{"&#9;"}
        <serie_type> {xs:string($p/@name)} </serie_type>    {"&#10;"}{"&#9;"}
        <drivers>       {"&#10;"}{"&#9;"}{"&#9;"}
        {
            for $driver in doc("drivers_list.xml")//series/season/driver
            order by $driver/@full_name
            return <driver>        {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     <full_name> {xs:string($driver/@full_name)} </full_name>           {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     <country> {xs:string($driver/@country)} </country>                 {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     <birth_date> {xs:string($driver/@birthday)} </birth_date>          {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     <birth_place> {xs:string($driver/@birth_place)} </birth_place>     {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     {
                        if (local:hasRank($driver, $p) > 0)
                        then <rank> {xs:string($p//driver[./@id = $driver/@id]/@rank)} </rank>
                        else <rank/>
                     }      {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     {
                        if (fn:count($driver/car) != 0)
                        then <car> {xs:string($driver/car[position() = 1]/manufacturer/@name)} </car>
                        else ""
                     }      {"&#10;"}{"&#9;"}{"&#9;"}{"&#9;"}
                     {
                        if (local:hasRank($driver, $p) > 0)
                        then local:getStatistics($driver, $p)
                        else local:getEmptyStatistics()
                     }      {"&#10;"}{"&#9;"}{"&#9;"}
                  </driver>
        } {"&#10;"}
        </drivers>
    </nascar_data>