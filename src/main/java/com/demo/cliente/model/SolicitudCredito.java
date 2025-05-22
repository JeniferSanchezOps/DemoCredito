package com.demo.cliente.model;

import lombok.Data;

@Data
public class SolicitudCredito {
    private Long solicitudId;
    private Double ingresos;
    private Integer personasACargo;
    private Double gastosMensuales;

    public String validacionInicial() {
        return "Solicitud ID: " + solicitudId + " validada correctamente.";
    }
}