xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("export_xml")
%rest:GET
function local:export_xml(){
<Reservas>
{
db:open("paiNataldb")//Reserva
}
</Reservas>
};