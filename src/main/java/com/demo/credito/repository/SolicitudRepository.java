package com.demo.credito.repository;

import com.demo.credito.model.SolicitudCredito;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SolicitudRepository extends JpaRepository<SolicitudCredito, Long> {}