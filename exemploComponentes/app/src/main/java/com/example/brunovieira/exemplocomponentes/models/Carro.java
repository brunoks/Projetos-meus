package com.example.brunovieira.exemplocomponentes.models;

import java.io.Serializable;

/**
 * Created by brunovieira on 27/09/17.
 */

public class Carro implements Serializable{
    private Long id;
    private String modelo;
    private int ano;
    private int fabricante; // 0=VW, 1=GM, 2=FIAT, 3=Ford
    private boolean gasolina;
    private boolean etanol;
    private double preco;

    public Carro(String modelo, int ano, int fabricante, boolean gasolina, boolean etanol, double preco) {
        this.modelo = modelo;
        this.ano = ano;
        this.fabricante = fabricante;
        this.gasolina = gasolina;
        this.etanol = etanol;
        this.preco = preco;
    }

    public Carro(Long id, String modelo, int ano, int fabricante, boolean gasolina, boolean etanol, double preco) {
        this.id = id;
        this.modelo = modelo;
        this.ano = ano;
        this.fabricante = fabricante;
        this.gasolina = gasolina;
        this.etanol = etanol;
        this.preco = preco;
    }

    public Long getId() {

        return id;
    }

    public void setId(Long id) {

        this.id = id;
    }

    public String getModelo() {

        return modelo;
    }

    public void setModelo(String modelo) {

        this.modelo = modelo;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public int getFabricante() {
        return fabricante;
    }

    public void setFabricante(int fabricante) {
        this.fabricante = fabricante;
    }

    public boolean isGasolina() {
        return gasolina;
    }

    public void setGasolina(boolean gasolina) {
        this.gasolina = gasolina;
    }

    public boolean isEtanol() {
        return etanol;
    }

    public int getGasolinaInt() {
        return gasolina == true ? 1 : 0;
    }

    public int getEtanolInt() { return etanol == true ? 1 : 0; }

    public void setEtanol(boolean etanol) {
        this.etanol = etanol;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }
}
