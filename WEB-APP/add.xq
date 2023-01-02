xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("add")
  %rest:POST("{$xml}")
  %rest:consumes("application/xml", "text/xml")
  updating
  function local:add($xml as document-node()) {


    if (not(db:exists("paiNataldb"))) then (
       fn:error(xs:QName("Info"), "Base de dados não existe!")
     ) else (
       
    let $xsd := "../PEITrabalho/PEI/xmlxsd/reservaTypes.xsd"
    
    return (
      if (validate:xsd($xml, $xsd)) then (
        fn:error(xs:QName("Info"), "Xml não é válido!")
      ) else (
  
      let $database := db:open("paiNataldb")
 
      let $id := count($database/Reserva) + 1
      let $familia := $xml/*/*[name(.) = "familia"]
      let $datasPrevistas := $xml/*/*[name(.) = "preferencias"]/*[name(.) = "dataPrevista"]
      let $dataReserva := local:find_disponibilidade($datasPrevistas)
         
      let $Reserva := document {
        element Reserva {
          element Id {$id},
          element Familia {$familia},
          element Data {$dataReserva},
          element Cancelamento {fn:false()}  
        }
      }
         
      return(
        if (not($dataReserva)) then (
           fn:error(xs:QName("Info"), "Datas previstas cheias!")
         ),
        db:add("paiNataldb", $Reserva, "reserva.xml"),
        update:output("Adicionada com sucesso!")
      )
     )
    )
  )    
};

declare function local:find_disponibilidade($data as item()*) {
    let $database := db:open("paiNataldb")
    let $Reservas := $database/Reserva[Cancelamento = fn:false()]
   
    let $date_availability1 := count($Reservas[Data = $data[@prioridade="1"]])
    let $date_availability2 := count($Reservas[Data = $data[@prioridade="2"]])
    let $date_availability3 := count($Reservas[Data = $data[@prioridade="3"]])
    let $date_availability4 := count($Reservas[Data = $data[@prioridade="4"]])
    let $date_availability5 := count($Reservas[Data = $data[@prioridade="5"]])
    
    return (
      if (xs:integer($date_availability1) < 50 or not($date_availability1)) then(
         if ($data[@prioridade="1"]) then (
           $data[@prioridade="1"]/text()
         )
    ) else (
      if (xs:integer($date_availability2) < 50 or not($date_availability2)) then (
         if ($data[@prioridade="2"]) then (
           $data[@prioridade="2"]/text()
         )
      ) else (
      if (xs:integer($date_availability3) < 50 or not($date_availability3)) then (
          if ($data[@prioridade="3"]) then (
           $data[@prioridade="3"]/text()
         )
      ) else (
      if (xs:integer($date_availability4) < 50 or not($date_availability4)) then (
          if ($data[@prioridade="4"]) then (
           $data[@prioridade="4"]/text()
         )
      ) else (
      if (xs:integer($date_availability5) < 50 or not($date_availability5)) then (
          if ($data[@prioridade="5"]) then (
           $data[@prioridade="5"]/text()
         )
        ) else (
           
        )
      )
    )
  )
)
)
};