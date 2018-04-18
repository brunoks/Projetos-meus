package com.example.brunovieira.exemplocomponentes.adapters;

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.brunovieira.exemplocomponentes.R;
import com.example.brunovieira.exemplocomponentes.models.Carro;

import java.util.List;

/**
 * Created by brunovieira on 19/10/17.
 */

public class CarrosAdapter extends BaseAdapter{
    Context ctx;
    List<Carro> carros;

    public CarrosAdapter(Context ctx, List<Carro> carros) {
        this.ctx = ctx;
        this.carros = carros;
    }

    @Override
    public int getCount() {
        return carros.size();
    }

    @Override
    public Object getItem(int i) {
        return carros.get(i);
    }

    @Override
    public long getItemId(int i) {

        return carros.get(i).getId();
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        Carro carro = carros.get(i);

        View linha = LayoutInflater.from(ctx).inflate(R.layout.item_carro, null);

        ImageView imgLogo = (ImageView) linha.findViewById(R.id.imgLogo);
        TextView txtModelo = (TextView) linha.findViewById(R.id.txtModelo);
        TextView txtCombustivel = (TextView) linha.findViewById(R.id.txtCombustivel);
        TextView txtAno = (TextView) linha.findViewById(R.id.txtAno);
        TextView txtPreco = (TextView) linha.findViewById(R.id.txtPreco);

        Resources res = ctx.getResources();
        TypedArray logos = res.obtainTypedArray(R.array.logos);
        imgLogo.setImageDrawable(logos.getDrawable(carro.getFabricante()));

        txtModelo.setText(carro.getModelo());
        txtAno.setText(String.valueOf(carro.getAno()));
        String combustivel = (carro.isEtanol() ? "G" : "") + (carro.isEtanol() ? "E" : "");
        txtCombustivel.setText(combustivel);
        txtPreco.setText(String.valueOf(carro.getPreco()));

        return linha;
    }

    @Override
    public CharSequence[] getAutofillOptions() {
        return new CharSequence[0];
    }
}
