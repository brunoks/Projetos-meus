package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import com.example.brunovieira.exemplocomponentes.adapters.ClientesAdapter;
import com.example.brunovieira.exemplocomponentes.models.Cliente;
import com.example.brunovieira.exemplocomponentes.models.ClienteDao;

import java.util.List;

public class ListaCliente extends AppCompatActivity {

    List<Cliente> clientes;
    ClientesAdapter adapter;
    ListView lista;

    private ClienteDao mClienteDao;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_lista_cliente);

        mClienteDao = new ClienteDao (this);

        lista = (ListView) findViewById(R.id.listaCliente);
        lista.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Cliente cliente = (Cliente) adapterView.getItemAtPosition(i);

                Intent it = new Intent(ListaCliente.this, CadastroClienteActivity.class);
                it.putExtra("clientes", cliente);
                startActivity (it);
            }
        });

        lista.setOnItemLongClickListener (new AdapterView.OnItemLongClickListener () {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {

                Cliente cliente = (Cliente) adapterView.getItemAtPosition (i);

                mClienteDao.excluir(cliente);

                atualizarLista();

                Toast.makeText(ListaCliente.this, "Cliente excluído com sucesso", Toast.LENGTH_SHORT).show ();
                return false;
            }
        });
    }





//    @Override
//    protected void onStart() {
//        super.onStart();
//        clientes = mClienteDao.all();
//        adapter = new ClientesAdapter(this, clientes);
//
//        lista.setAdapter(adapter);
//    }

    private void atualizarLista() {
        clientes = mClienteDao.all();
        adapter.notifyDataSetChanged();
    }

    public void cadastroCliente(View view) {
        Intent it = new Intent(this, CadastroClienteActivity.class);
        startActivity(it);
    }
}
