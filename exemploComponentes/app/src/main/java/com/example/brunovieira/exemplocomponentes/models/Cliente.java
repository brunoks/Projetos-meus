package com.example.brunovieira.exemplocomponentes.models;

import java.io.Serializable;

/**
 * Created by brunovieira on 22/10/17.
 */

public class Cliente implements Serializable{

    private Long id;
    private String observacao;
    private String nome;
    private int tipo; // 0 = P_FÍSICA / 1 = P_JURÍDICA
    private int cpf;
    private int renda; // 0 = R$ 0 a R$ 1.000,00 / 1 = R$ 1.000,00 a R$ 2.500,00 / 2 = R$ 2.500,00 a R$ 3.500,00

    public Cliente(Long id, String observacao, String nome, int tipo, int cpf, int renda) {
        this.id = id;
        this.observacao = observacao;
        this.nome = nome;
        this.tipo = tipo;
        this.cpf = cpf;
        this.renda = renda;
    }

    public Cliente(String observacao, String nome, int tipo, int cpf, int renda) {
        this.observacao = observacao;
        this.nome = nome;
        this.tipo = tipo;
        this.cpf = cpf;
        this.renda = renda;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getObservacao() {
        return observacao;
    }

    public void setObservacao(String observacao) {
        this.observacao = observacao;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public int getTipo() {
        return tipo;
    }

    public void setTipo(int tipo) {
        this.tipo = tipo;
    }

    public int getCpf() {
        return cpf;
    }

    public void setCpf(int cpf) {
        this.cpf = cpf;
    }

    public int getRenda() {
        return renda;
    }

    public void setRenda(int renda) {
        this.renda = renda;
    }
}
