function importaDados() {
  // Função para obter dados de um arquivo json
  // 1 Parâmetro: Caminho do arquivo
  // 2 Parâmetro: função de tratamento dos dados
  // Requisição AJAX
  // Asynchrous JavaScript and XML
  // - Permite realizar requisições sem atualizar a página
  // - A Requisição ao servidor é feito pelo JavaScript
  $.getJSON('js/openData.json', function(dados){
    // DOM : Document Object Model - Modelo de Objetos de Documento
    /*
    * As categorias relevantes do DOM são:
    * - Documentos: Documento HTML
    * - Elementos: Todas as tegs do HTML
    * - Texto: Texto que vai entre os Elementos
    *
    *
    * Os métodos definidos no DOM permitem acessar a árvore
    * possibilitando alterações na estrutura do documento,
    * conteúdos e estilo.
    */
    //  Atribui o elemento DOM para uma variável
 var ulCarros = document.getElementById('table');

    for(var i = 0; i < dados.length; i++) {
      var carro = carros[i];
  //  -> Cria um elemento em memória
 //   -> Este elemento ainda não foi adicionado à árvore do documento atual
      var liCarro =  document.createElement('li');

      // String
      var textoCarro = 'ID: ' + carro + '; ';
      textoCarro += 'Marca: ' + carro + '; ';
      textoCarro += 'Nome: ' + carro + '; ';
      textoCarro += 'Multas: ';

      // Nó de texto do DOM
      var noTexto = document.createTextNode(textoCarro);

      liCarro.appendChild(noTexto);

      // Cria lista não-ordenada em memória



      liCarro.appendChild(olMultas);
      ulCarros.appendChild(liCarro);
    }
  });
}
