package com.demo.cliente.repository;

import com.demo.cliente.model.SolicitudProducto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SolicitudProductoRepository extends JpaRepository<SolicitudProducto, Long> {
}