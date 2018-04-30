
function newPopup(){
varWindow = window.open (
'popup.html',
'pagina',
"width=350, height=255, top=100, left=110, scrollbars=no " );
}

function abrir(URL) {

  var width = 150;
  var height = 250;

  var left = 99;
  var top = 99;

  window.open(URL,'janela', 'width='+width+', height='+height+', top='+top+', left='+left+', scrollbars=yes, status=no, toolbar=no, location=no, directories=no, menubar=no, resizable=no, fullscreen=no');

}
function ocultar(el){

document.getElementById(el).style.display = 'none';

}

function Mudarestado(el) {
        var display = document.getElementById(el).style.display;

        if(display == "none")
            document.getElementById(el).style.display = 'block';
        else
            document.getElementById(el).style.display = 'none';
    }
