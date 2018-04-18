<htmml>
  <head><title>Produtos</title>
  </head>

  <body>
    <form action="{{ route('tons.store') }}" method="POST">

       <input type="hidden" name="_token" value="{{ csrf_token() }}">
       Tom: <input type="text" name="nome"><br>
       <input type="submit">
     </form>
   </body>
  </htmml>