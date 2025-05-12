package com.demo.credito.model;

import jakarta.persistence.*;

@Entity
public class SolicitudCredito {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Double ingresos;
    private Integer personasACargo;
    private Double gastosMensuales;

    private String estado;

    @ManyToOne
    @JoinColumn(name = "cliente_id")
    private Cliente cliente;

    // Getters y Setters
}