package com.demo.cliente.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class ProductoCredito {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long clienteId;
    private String nombreProducto;
}