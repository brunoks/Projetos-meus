package com.example.brunovieira.exemplocomponentes.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.example.brunovieira.exemplocomponentes.R;
import com.example.brunovieira.exemplocomponentes.models.Custo;

import java.util.List;

/**
 * Created by brunovieira on 23/10/17.
 */

public class CustosAdapter extends BaseAdapter{

    Context ctx;
    List<Custo> custos;

    public CustosAdapter(Context ctx, List<Custo> custos) {
        this.ctx = ctx;
        this.custos = custos;
    }

    @Override
    public int getCount() {
        return custos.size ();
    }

    @Override
    public Object getItem(int i) {
        return custos.get (i);
    }

    @Override
    public long getItemId(int i) {
        return custos.get (i).getId ();
    }


    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {

        Custo custo = custos.get(i);

        View linhaC = LayoutInflater.from (ctx).inflate ( R.layout.item_custo, null);

        TextView txtValor = (TextView) linhaC.findViewById (R.id.txtValor);
        TextView txtDesc = (TextView) linhaC.findViewById (R.id.edtDescricao );

        TextView txtData = (TextView) linhaC.findViewById(R.id.edtData);

        txtDesc.setText(custo.getDescricao());
        txtValor.setText(String.valueOf(custo.getValor()));
        txtData.setText(custo.getData());

        return linhaC;

    }


    @Override
    public CharSequence[] getAutofillOptions() {
        return new CharSequence[0];
    }
}

