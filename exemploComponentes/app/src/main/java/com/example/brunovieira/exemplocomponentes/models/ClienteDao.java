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

public class ClienteDao {

    private CarroSQLHelper helper;

    public static final String TABELA_CLIENTES = "CLIENTES";
    public static final String COLUNA_ID = "ID";
    public static final String COLUNA_OBSERVACAO = "OBSERVACAO";
    public static final String COLUNA_NOME = "NOME";
    public static final String COLUNA_TIPO = "TIPO";
    public static final String COLUNA_CPF = "CPF";
    public static final String COLUNA_RENDA = "RENDA";



    public ClienteDao(Context ctx) { helper = new CarroSQLHelper(ctx); }

    public long inserir(Cliente cliente) {
        SQLiteDatabase db = helper.getWritableDatabase();

        ContentValues cv = new ContentValues();

        cv.put(COLUNA_OBSERVACAO, cliente.getObservacao());
        cv.put(COLUNA_NOME, cliente.getNome());
        cv.put(COLUNA_TIPO, cliente.getTipo());
        cv.put(COLUNA_CPF, cliente.getCpf());
        cv.put(COLUNA_RENDA, cliente.getRenda());


        Long id = db.insert(
                TABELA_CLIENTES,
                null,
                cv
        );

        db.close();

        return id;
    }

    public long atualizar(Cliente cliente) {
        SQLiteDatabase db = helper.getWritableDatabase ();

        ContentValues cv = new ContentValues();
        cv.put(COLUNA_OBSERVACAO, cliente.getObservacao ());
        cv.put(COLUNA_NOME, cliente.getNome ());
        cv.put(COLUNA_TIPO, cliente.getTipo ());
        cv.put(COLUNA_CPF, cliente.getCpf ());
        cv.put(COLUNA_RENDA, cliente.getRenda ());


        long linhasAfetadas = db.update(
                TABELA_CLIENTES,
                cv,
                COLUNA_ID + " = ? ",
                new String[]{ String.valueOf(cliente.getId ()) }
        );
        db.close ();

        return linhasAfetadas;
    }

    public long salvar(Cliente cliente) {
        if(cliente.getId() != null) {
            return atualizar(cliente);
        }
        return inserir(cliente);
    }

    public int excluir(Cliente cliente) {
        SQLiteDatabase db = helper.getWritableDatabase();

        int linhasExcluidas = db.delete(
                TABELA_CLIENTES,
                COLUNA_ID + " = ?",
                new String[]{ String.valueOf(cliente.getId()) }
        );

        db.close();

        return linhasExcluidas;
    }

    public List<Cliente> all() {
        return buscarCliente(null);
    }

    public List<Cliente> buscarCliente(String filtro) {
        SQLiteDatabase db = helper.getReadableDatabase();
        String sql = "SELECT * FROM " + TABELA_CLIENTES;
        String[] argumentos = null;

        if(filtro != null) {
            sql += "WHERE " + COLUNA_ID + "LIKE ?";
            argumentos = new String[]{ filtro };

        }

        sql += " ORDER BY " + COLUNA_ID;

        Cursor cursor = db.rawQuery(sql, argumentos);

        List<Cliente> clientes = new ArrayList<>();

        while (cursor.moveToNext()) {
            Long id = cursor.getLong(cursor.getColumnIndex(COLUNA_ID));
            String observacao = cursor.getString(cursor.getColumnIndex(COLUNA_OBSERVACAO));
            String nome = cursor.getString(cursor.getColumnIndex(COLUNA_NOME));
            int tipo = cursor.getInt(cursor.getColumnIndex(COLUNA_TIPO));
            int cpf = cursor.getInt(cursor.getColumnIndex(COLUNA_CPF));
            int renda = cursor.getInt(cursor.getColumnIndex(COLUNA_RENDA));

            Cliente cliente = new Cliente( id, observacao, nome, tipo, cpf, renda);

            clientes.add(cliente);
        }

        cursor.close();
        db.close();
        return clientes;
    }
}
