package com.demo.cliente.repository;

import com.demo.cliente.model.ProductoCredito;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductoCreditoRepository extends JpaRepository<ProductoCredito, Long> {
    List<ProductoCredito> findByClienteId(Long clienteId);
}