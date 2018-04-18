package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.brunovieira.exemplocomponentes.adapters.CustosAdapter;
import com.example.brunovieira.exemplocomponentes.models.Custo;
import com.example.brunovieira.exemplocomponentes.models.CustosDao;

import java.util.List;

public class CustosActivity extends AppCompatActivity {

    List<Custo> custos;
    CustosAdapter adapter;
    ListView list;

    private CustosDao mCustosDao;

    private TextView mTxtId;
    private Custo mCusto;
    private EditText mEdtDescricao;
    private EditText mEdtData;
    private EditText mEdtValor;
    private Button mBtnSalvar;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_custos);


     mCustosDao = new CustosDao(this);
       ListView lista = (ListView) findViewById(R.id.listaCusto);


        lista.setOnItemLongClickListener (new AdapterView.OnItemLongClickListener () {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {

                Custo custo = (Custo) adapterView.getItemAtPosition (i);

                mCustosDao.excluir(custo);

                atualizarLista();

                Toast.makeText(CustosActivity.this, "Carro excluído com sucesso", Toast.LENGTH_SHORT).show ();
                return false;
            }
        });
        lista.setOnItemLongClickListener (new AdapterView.OnItemLongClickListener () {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int i, long l) {

                Custo custo = (Custo) adapterView.getItemAtPosition (i);

                mCustosDao.excluir (custo);

                atualizarLista();

                Toast.makeText(CustosActivity.this, "Carro excluído com sucesso", Toast.LENGTH_SHORT).show ();
                return false;
            }
        });
    mTxtId = (TextView) findViewById(R.id.txtId);
    mEdtDescricao = (EditText) findViewById(R.id.edtDescricao);
    mEdtValor = (EditText) findViewById(R.id.edtValor);
    mEdtData = (EditText) findViewById (R.id.edtData);
    mBtnSalvar = (Button) findViewById (R.id.btnSalvar);

        mBtnSalvar.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            salvar();
        }
    });


        if (mCusto != null) {
        mTxtId.setText(String.valueOf(mCusto.getId()));
        mEdtDescricao.setText(mCusto.getDescricao());
        mEdtValor.setText(String.valueOf(mCusto.getValor()));
        mEdtData.setText(mCusto.getData());
    }
}

    private void salvar() {
        String descricao = mEdtDescricao.getText().toString();
        double valor = Double.valueOf(mEdtValor.getText().toString());
        String data = mEdtData.getText().toString();

        if(mCusto == null) {
            mCusto = new Custo (

                    descricao,
                    valor,
                    data

            );
        } else {
            mCusto.setDescricao(descricao);
            mCusto.setValor(valor);
            mCusto.setData(data);
        }

        long id = mCustosDao.salvar(mCusto);

        if (id > 0 ) {
            Toast.makeText(this, "Custo salvo com sucesso!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Erro ao salvar o custo!", Toast.LENGTH_SHORT).show();
        }
        finish();
    }

//    @Override
//    protected void onStart() {
//        super.onStart();
//
//        custos = mCustosDao.all();
//        adapter = new CustosAdapter (this, custos);
//
//        list.setAdapter(adapter);
//
//    }
    private void atualizarLista() {
        custos = mCustosDao.all();
        adapter.notifyDataSetChanged();
    }

    public void cadastroCarro (View view) {
        Intent it = new Intent(this, adicionarCarroActivity.class);
        startActivity(it);
    }
}
