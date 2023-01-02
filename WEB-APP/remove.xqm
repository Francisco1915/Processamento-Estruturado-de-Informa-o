xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("remove")
  %rest:query-param("id", "{$id}")
  %rest:DELETE
  updating
  function local:cancel($id as xs:integer) {

     if (not(db:exists("paiNataldb"))) then (
        fn:error(xs:QName("Info"), "Base de dados não existe!")
     ) else (
        
     let $database := db:open("paiNataldb")
      
     return (
       if ($database/Reserva[Id=$id][Cancelamento = fn:false()]) then (
        replace value of node $database/Reserva[Id=$id]/Cancelamento with fn:true(),
        update:output("Removida com sucesso!")
      ) else (
        update:output("A reserva com este id não existe ou já foi removido!")
      )
      )
    )   
};

