xquery version "3.1";

module namespace local = 'http://basex.org/modules/web-page';

declare %rest:path("init")
    %rest:GET
    %updating
    function local:init() {

    (update:output("Base de Dados criada!"),
    db:create("paiNataldb"))
};
