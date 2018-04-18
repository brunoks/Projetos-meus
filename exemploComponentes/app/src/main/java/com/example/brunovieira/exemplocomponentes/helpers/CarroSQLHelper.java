package com.example.brunovieira.exemplocomponentes.helpers;

        import android.content.Context;
        import android.database.sqlite.SQLiteDatabase;
        import android.database.sqlite.SQLiteOpenHelper;


public class CarroSQLHelper extends SQLiteOpenHelper {
    private static final String NOME_BANCO = "dbCarro";
    private static final int VERSAO_BANCO = 1;


    /*
        SQLite é Case Insensitive
         */
    public static final String TABELA_CARROS = "CARROS";
    public static final String TABELA_CLIENTES = "CLIENTES";
    public static final String TABELA_CUSTOS = "CUSTOS";

    public CarroSQLHelper(Context context) {
        super(context, NOME_BANCO, null, VERSAO_BANCO);
    }

    /*
    Tipos de Dados do SQLite:
        INTEGER
        REAL
        TEXT
        BLOB
     */
    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL("CREATE TABLE " + TABELA_CARROS + " (" +
                " ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                " MODELO TEXT NOT NULL, " +
                " ANO INTEGER NOT NULL, " +
                " FABRICANTE INTEGER NOT NULL, " +
                " GASOLINA INTEGER, " +
                " ETANOL INTEGER," +
                " PRECO REAL " +
                ") ");

        sqLiteDatabase.execSQL ( "CREATE TABLE " + TABELA_CLIENTES + " (" +
                " ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                " NOME TEXT NOT NULL, " +
                " TIPO INTEGER NOT NULL, " +
                " CPF INTEGER, " +
                " RENDA INTEGER," +
                " OBSERVACAO TEXT " +
                ") ");

        sqLiteDatabase.execSQL ( "CREATE TABLE " + TABELA_CUSTOS + " (" +
                " ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                " DESCRICAO TEXT NOT NULL, " +
                " VALOR REAL, " +
                " DT_EMISSAO TEXT " +
                ") ");
    }


    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {



    }
}
