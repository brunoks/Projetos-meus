package com.example.brunovieira.exemplocomponentes.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.example.brunovieira.exemplocomponentes.R;
import com.example.brunovieira.exemplocomponentes.models.Cliente;

import java.util.List;

/**
 * Created by brunovieira on 23/10/17.
 */

public class ClientesAdapter extends BaseAdapter{
    Context ctx;
    List<Cliente> clientes;

    public ClientesAdapter(Context ctx, List<Cliente> cliente) {
        this.ctx = ctx;
        this.clientes = cliente;
    }

    @Override
    public int getCount() {
        return clientes.size();
    }

    @Override
    public Object getItem(int i) {
        return clientes.get(i);
    }

    @Override
    public long getItemId(int i) {

        return clientes.get(i).getId();
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        Cliente cliente = clientes.get(i);

        View linha = LayoutInflater.from(ctx).inflate( R.layout.item_cliente, null);

        TextView txtNome = (TextView) linha.findViewById(R.id.Nome_P);
        TextView txtPessoa = (TextView) linha.findViewById(R.id.txtPessoa);
        TextView txtCpf = (TextView) linha.findViewById(R.id.txtCpf);
        TextView txtRenda = (TextView) linha.findViewById(R.id.txtRenda);
        TextView txtObs = (TextView) linha.findViewById(R.id.txtObs);

        txtObs.setText(cliente.getObservacao());
        txtNome.setText(cliente.getNome ());
        txtPessoa.setText(cliente.getTipo ());
        txtRenda.setText(cliente.getRenda());
        txtCpf.setText(cliente.getCpf());

        return linha;
    }

    @Override
    public CharSequence[] getAutofillOptions() {
        return new CharSequence[0];
    }
}
