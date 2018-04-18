package com.example.brunovieira.exemplocomponentes;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.example.brunovieira.exemplocomponentes.models.Cliente;
import com.example.brunovieira.exemplocomponentes.models.ClienteDao;

public class CadastroClienteActivity extends AppCompatActivity {

    private ClienteDao mClienteDao;

    private TextView mTxtId;
    private Cliente mCliente;
    private Spinner mTipo_P;
    private EditText mCpf;
    private EditText mNome;
    private Spinner mRenda;
    private EditText mObs;
    private Button mbtnSalvar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate ( savedInstanceState );
        setContentView ( R.layout.activity_cadastro_cliente );


        mClienteDao = new ClienteDao ( this );

        mTxtId = (TextView) findViewById ( R.id.txtId );
        mTipo_P = (Spinner) findViewById ( R.id.spTipo_P );
        mCpf = (EditText) findViewById ( R.id.edtCpf );
        mNome = (EditText) findViewById ( R.id.edtNome );
        mRenda = (Spinner) findViewById ( R.id.spRenda );
        mObs = (EditText) findViewById ( R.id.edtObs );
        mbtnSalvar = (Button) findViewById ( R.id.btnSalvar );

        mbtnSalvar.setOnClickListener ( new View.OnClickListener () {
            @Override
            public void onClick(View view) {
                salvar ();
            }
        } );

        String[] tipo_pessoa = new String[]{
                "Pessoa Física", "Pessoa Jurídica"
        };

        // 0 = R$ 0 a R$ 1.000,00 / 1 = R$ 1.000,00 a R$ 2.500,00 / 2 = R$ 2.500,00 a R$ 3.500,00
        String[] renda = new String[]{
                "R$ 0 a R$ 1.000,00", "R$ 1.000,00 a R$ 2.500,00", "R$ 2.500,00 a R$ 3.500,00"
        };

        ArrayAdapter<String> spinnerAdapter = new ArrayAdapter<String> (
                this, android.R.layout.simple_spinner_item, tipo_pessoa
        );
                ArrayAdapter<String> spinnerAdapter2 = new ArrayAdapter<String> (
                        this, android.R.layout.simple_spinner_item, renda
        );
        mTipo_P.setAdapter ( spinnerAdapter );

        mRenda.setAdapter ( spinnerAdapter2 );

        Intent it = getIntent ();
        mCliente = (Cliente) it.getSerializableExtra ("clientes");


        if (mCliente != null) {
            mTxtId.setText ( String.valueOf ( mCliente.getId () ) );
            mObs.setText ( mCliente.getNome () );
            mCpf.setText ( String.valueOf ( mCliente.getCpf () ) );
            mTipo_P.setSelection( mCliente.getTipo () );
            mRenda.setSelection ( mCliente.getRenda () );
            mNome.setText ( mCliente.getNome () );
        }
    }

    private void salvar() {
        String obs = mObs.getText().toString();
        int cpf = Integer.valueOf(mCpf.getText().toString());
        int tipo = mTipo_P.getSelectedItemPosition();
        int renda = mRenda.getSelectedItemPosition ();
        String nome = mNome.getText().toString();

        if(mCliente == null) {
            mCliente = new Cliente (
                    obs,
                    nome,
                    tipo,
                    cpf,
                    renda
            );
        } else {
            mCliente.setObservacao(obs);
            mCliente.setNome (nome);
            mCliente.setTipo(tipo);
            mCliente.setCpf (cpf);
            mCliente.setRenda (renda);
        }

        long id = mClienteDao.salvar(mCliente);

        if (id > 0 ) {
            Toast.makeText(this, "Cliente salvo com sucesso!", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "Erro ao salvar o cliente!", Toast.LENGTH_SHORT).show();
        }
        finish();
    }

}
