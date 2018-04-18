package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class ClienteActivity extends AppCompatActivity {



    public void chamaTela(View view) {
        Intent it = new Intent(this, CadastroClienteActivity.class);
        startActivity(it);
    }
}
