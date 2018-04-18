package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.example.brunovieira.exemplocomponentes.models.Carro;
import com.example.brunovieira.exemplocomponentes.models.CarroDao;

public class adicionarCarroActivity extends AppCompatActivity {

    private CarroDao mCarroDao;

    private Carro mCarro;
    private TextView mTxtId;
    private EditText mEdtModelo;
    private EditText mEdtAno;
    private Spinner mSpnFabricante;
    private CheckBox mChkGasolina;
    private CheckBox mChkEtanol;
    private EditText mEdtPreco;
    private Button mBtnSalvar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adicionar_carro);


        mCarroDao = new CarroDao(this);

        mTxtId = (TextView) findViewById(R.id.txtId);
        mEdtModelo = (EditText) findViewById(R.id.edtModelo);
        mEdtAno = (EditText) findViewById(R.id.edtAno);
        mSpnFabricante = (Spinner) findViewById(R.id.spnFabricante);
        mChkGasolina = (CheckBox) findViewById(R.id.chkGasolina);
        mChkEtanol = (CheckBox) findViewById(R.id.chkEtanol);
        mBtnSalvar = (Button) findViewById(R.id.btnSalvar);
        mEdtPreco = (EditText) findViewById(R.id.edtPreco);

        mBtnSalvar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                salvar();
            }
        });

        String[] fabricantes = new String[] {
          "VW", "GM", "Fiat", "Ford"
        };
        ArrayAdapter<String> spinnerAdapter = new ArrayAdapter<String>(
                this, android.R.layout.simple_spinner_item, fabricantes
        );
        mSpnFabricante.setAdapter(spinnerAdapter);

        Intent it = getIntent();
        mCarro = (Carro) it.getSerializableExtra("carro");



        if (mCarro != null) {
            mTxtId.setText(String.valueOf(mCarro.getId()));
            mEdtModelo.setText(mCarro.getModelo());
            mEdtAno.setText(String.valueOf(mCarro.getAno()));
            mSpnFabricante.setSelection(mCarro.getFabricante());
            mChkEtanol.setChecked(mCarro.isEtanol());
            mChkGasolina.setChecked(mCarro.isGasolina());
            mEdtPreco.setText(String.valueOf(mCarro.getPreco()));
        }
    }

        private void salvar() {
            String modelo = mEdtModelo.getText().toString();
            int ano = Integer.valueOf(mEdtAno.getText().toString());
            int fabricante = mSpnFabricante.getSelectedItemPosition();
            boolean gasolina = mChkGasolina.isChecked();
            boolean etanol = mChkEtanol.isChecked();
            double preco = Double.valueOf(mEdtPreco.getText().toString());

            if(mCarro == null) {
                mCarro = new Carro(

                        modelo,
                        ano,
                        fabricante,
                        gasolina,
                        etanol,
                        preco
                );
            } else {
                mCarro.setModelo(modelo);
                mCarro.setAno(ano);
                mCarro.setFabricante(fabricante);
                mCarro.setGasolina(gasolina);
                mCarro.setEtanol(etanol);
                mCarro.setPreco(preco);
            }

            long id = mCarroDao.salvar(mCarro);

            if (id > 0 ) {
                Toast.makeText(this, "Carro salvo com sucesso!", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(this, "Erro ao salvar o carro!", Toast.LENGTH_SHORT).show();
            }
            finish();
    }
}


