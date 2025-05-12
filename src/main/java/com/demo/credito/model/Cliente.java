package com.demo.credito.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Data
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;

    private String identificacion;

    @OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL)
    private List<SolicitudCredito> solicitudes;
}