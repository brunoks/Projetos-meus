package com.example.brunovieira.exemplocomponentes.models;

import java.io.Serializable;

/**
 * Created by brunovieira on 22/10/17.
 */

public class Custo implements Serializable {

    private Long id;
    private String descricao;
    private Double valor;
    private String data;

    public Custo(Long id, String descricao, Double valor, String data) {
        this.id = id;
        this.descricao = descricao;
        this.valor = valor;
        this.data = data;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public Custo(String descricao, Double valor, String data) {
        this.descricao = descricao;
        this.valor = valor;
        this.data = data;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }



    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }
}
