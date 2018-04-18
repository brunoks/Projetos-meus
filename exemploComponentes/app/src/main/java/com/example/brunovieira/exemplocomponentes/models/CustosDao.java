package com.example.brunovieira.exemplocomponentes.models;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.example.brunovieira.exemplocomponentes.helpers.CarroSQLHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by brunovieira on 23/10/17.
 */

public class CustosDao {

    private CarroSQLHelper helper;


    public static final String TABELA_CUSTOS = "CUSTOS";
    public static final String COLUNA_ID = "ID";
    public static final String COLUNA_DESCRICAO = "DESCRICAO";
    public static final String COLUNA_VALOR = "VALOR";
    public static final String COLUNA_DT_EMISSAO = "DT_EMISSAO";

    public CustosDao(Context ctx) {
        helper = new CarroSQLHelper (ctx);
    }


    public long inserir(Custo custo) {
        SQLiteDatabase db = helper.getWritableDatabase ();

        ContentValues cv = new ContentValues ();

        cv.put ( COLUNA_DESCRICAO, custo.getDescricao () );
        cv.put ( COLUNA_VALOR, custo.getValor () );
        cv.put ( COLUNA_DT_EMISSAO, custo.getData () );

        Long id = db.insert (
                TABELA_CUSTOS,
                null,
                cv
        );

        db.close ();

        return id;
    }

    public long atualizar(Custo custo) {
        SQLiteDatabase db = helper.getWritableDatabase ();

        ContentValues cv = new ContentValues ();
        cv.put ( COLUNA_DESCRICAO, custo.getDescricao () );
        cv.put ( COLUNA_VALOR, custo.getValor () );
        cv.put ( COLUNA_DT_EMISSAO, custo.getData () );

        Long id = db.insert (
                TABELA_CUSTOS,
                null,
                cv
        );

        long linhasAfetadas = db.update (
                TABELA_CUSTOS,
                cv,
                COLUNA_ID + " = ?", // CONDIÇÃO DO WHERE
                new String[]{String.valueOf ( custo.getId () )}
                // |ˆ|ˆ|ˆ| valores dos parâmetros passados no Where (as interrogações)
        );

        db.close ();

        return linhasAfetadas;
    }

    public long salvar(Custo custo) {
        if (custo.getId () != null) {
            return atualizar ( custo );
        }
        return inserir ( custo );
    }

    public int excluir(Custo custo) {
        SQLiteDatabase db = helper.getWritableDatabase ();

        int linhasExcluidas = db.delete (
                TABELA_CUSTOS,
                COLUNA_ID + " = ?", // condição do where
                new String[]{String.valueOf ( custo.getId () )}
                // |-> valores dos parâmetros passados no where (as interrogações)
        );

        db.close ();

        return linhasExcluidas;
    }

    public List<Custo> all() {
        return buscarCusto ( null );
    }

    public List<Custo> buscarCusto(String filtro) {
        SQLiteDatabase db = helper.getReadableDatabase ();
        String sql = "SELECT * FROM " + TABELA_CUSTOS;
        String[] argumentos = null;

        if (filtro != null) {
            sql += "WHERE " + COLUNA_DESCRICAO + "LIKE ?";
            argumentos = new String[]{filtro};

        }

        sql += " ORDER BY " + COLUNA_DESCRICAO;

        Cursor cursor = db.rawQuery ( sql, argumentos );

        List<Custo> custos = new ArrayList<> ();

        while (cursor.moveToNext ()) {
            Long id = cursor.getLong ( cursor.getColumnIndex ( COLUNA_ID ) );
            String descricao = cursor.getString ( cursor.getColumnIndex ( COLUNA_DESCRICAO ) );
            String data = cursor.getString ( cursor.getColumnIndex ( COLUNA_DT_EMISSAO ) );
            double valor = cursor.getDouble ( cursor.getColumnIndex ( COLUNA_VALOR ) );

            Custo custo = new Custo ( id, descricao, valor, data );

            custos.add ( custo );
        }

        cursor.close ();
        db.close ();
        return custos;
    }
}
