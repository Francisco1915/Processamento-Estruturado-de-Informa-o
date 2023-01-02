xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare
%rest:path("disponibilidade")
%rest:query-param("from","{$from}")
%rest:query-param("to","{$to}")
%rest:GET
function local:disponibilidade($from as xs:string?, $to as xs:string?) {

    if (not(db:exists("paiNataldb"))) then (
       fn:error(xs:QName("Info"), "Base de dados não existe!")
     ) else (

    let $database := db:open("paiNataldb")
    let $Reservas := $database/Reserva[Cancelamento = fn:false()]
    
    return (
        if (not($from) and not($to)) then (
            for $x in $Reservas
            let $dataPrevista := xs:date($x/Data)
            group by $dataPrevista
            let $count := count($x[Data = $dataPrevista])
            return (
                <ReservaData>
                    <Data>{$dataPrevista}</Data>
                    <Disponibilidade>{50 - $count}</Disponibilidade>
                </ReservaData>
            )
        ) else (
            if(xs:date($from) > xs:date($to)) then (
                fn:error(xs:QName("Info"), "Verificar datas inseridas")
            ) else (
                for $x in $Reservas
                let $dataPrevista := xs:date($x/Data)
                where $dataPrevista >= xs:date($from) and $dataPrevista <= xs:date($to)
                group by $dataPrevista
                let $count := count($x[Data = $dataPrevista])
                return (
                    <ReservaData>
                        <Data>{$dataPrevista}</Data>
                        <Disponibilidade>{50 - $count}</Disponibilidade>
                    </ReservaData>
                 )
              )
            )
        ,<Info>O resto das datas estão disponiveis!</Info>
    )
  )
};