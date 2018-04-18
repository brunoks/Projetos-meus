package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.example.brunovieira.exemplocomponentes.adapters.CarrosAdapter;
import com.example.brunovieira.exemplocomponentes.models.Carro;
import com.example.brunovieira.exemplocomponentes.models.CarroDao;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {


      List<Carro> carros;
      CarrosAdapter adapter;
      ListView lista;


    private ArrayList mNomes;
    private ArrayAdapter<String> mAdapter;
    private CarroDao mCarroDao;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        mCarroDao = new CarroDao(this);



        lista = (ListView) findViewById(R.id.listaCarro);
        lista.setOnItemClickListener(new AdapterView.OnItemClickListener() {
             @Override
             public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                 Carro carro = (Carro) adapterView.getItemAtPosition(i);

                 Intent it = new Intent(MainActivity.this, adicionarCarroActivity.class);
                 it.putExtra("carro", carro);
                 startActivity (it);
             }
         });

        lista.setOnItemLongClickListener (new AdapterView.OnItemLongClickListener () {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {

                Carro carro = (Carro) adapterView.getItemAtPosition (i);

                mCarroDao.excluir (carro);

                atualizarLista();

                Toast.makeText(MainActivity.this, "Carro excluído com sucesso", Toast.LENGTH_SHORT).show ();
                return false;
            }
        });

    }

    @Override
    protected void onStart() {
        super.onStart();

        carros = mCarroDao.all();
        adapter = new CarrosAdapter(this, carros);

        lista.setAdapter(adapter);

    }
    private void atualizarLista() {
        carros = mCarroDao.all();
        adapter.notifyDataSetChanged();
    }

    public void cadastroCarro (View view) {
        Intent it = new Intent(this, adicionarCarroActivity.class);
        startActivity(it);
    }



}
