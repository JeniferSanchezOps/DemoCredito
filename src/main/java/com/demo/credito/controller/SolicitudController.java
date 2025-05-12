package com.demo.credito.controller;

import com.demo.credito.dto.SolicitudRequestDTO;
import com.demo.credito.model.Cliente;
import com.demo.credito.model.SolicitudCredito;
import com.demo.credito.repository.ClienteRepository;
import com.demo.credito.repository.SolicitudRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/solicitud")
public class SolicitudController {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private SolicitudRepository solicitudRepository;

    @PostMapping
    public ResponseEntity<String> registrarSolicitud(@RequestBody SolicitudRequestDTO solicitudDTO) {
        Cliente cliente = new Cliente();
        cliente.setNombre(solicitudDTO.nombre);
        cliente.setIdentificacion(solicitudDTO.identificacion);
        clienteRepository.save(cliente);

        SolicitudCredito solicitud = new SolicitudCredito();
        solicitud.setCliente(cliente);
        solicitud.setIngresos(solicitudDTO.ingresos);
        solicitud.setPersonasACargo(solicitudDTO.personasACargo);
        solicitud.setGastosMensuales(solicitudDTO.gastosMensuales);
        solicitud.setEstado("EN_VALIDACION");
        solicitudRepository.save(solicitud);

        return ResponseEntity.ok("El sistema está validando sus datos");
    }
}