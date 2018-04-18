package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

public class Main2Activity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);

    }

    public void telaCarro(View view) {

        Intent intent = new Intent(this, MainActivity.class);
        startActivity(intent);
    }

    public void telaCliente(View view) {
        Intent it = new Intent(this, ListaCliente.class);
        startActivity(it);
    }

    public void telaCustos(View view) {
        Intent it = new Intent(this, CustosActivity.class);
        startActivity(it);
    }

}
