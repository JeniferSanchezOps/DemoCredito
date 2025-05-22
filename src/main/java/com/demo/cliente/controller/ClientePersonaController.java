package com.demo.cliente.controller;

import com.demo.cliente.model.ProductoCredito;
import com.demo.cliente.model.SolicitudProducto;
import com.demo.cliente.model.SolicitudCredito;
import com.demo.cliente.repository.ProductoCreditoRepository;
import com.demo.cliente.repository.SolicitudProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api")
public class ClientePersonaController {

    @Autowired
    private ProductoCreditoRepository productoRepo;

    @Autowired
    private SolicitudProductoRepository solicitudProductoRepo;

    @GetMapping("/productos")
    public ResponseEntity<List<ProductoCredito>> getProductosPorCliente(@RequestParam Long clienteId) {
        List<ProductoCredito> productos = productoRepo.findByClienteId(clienteId);
        if (productos.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(productos);
    }

    @PostMapping("/solicitar-producto")
    public ResponseEntity<String> solicitarProducto(
            @RequestParam Long clienteId,
            @RequestParam String tipoProducto,
            @RequestParam Double ingresos,
            @RequestParam Integer personasACargo,
            @RequestParam Double gastosMensuales) {

        List<ProductoCredito> productos = productoRepo.findByClienteId(clienteId);
        if (productos.isEmpty()) {
            return ResponseEntity.status(404).body("No se encontraron productos para el cliente.");
        }

        SolicitudProducto solicitud = new SolicitudProducto();
        solicitud.setClienteId(clienteId);
        solicitud.setTipoProducto(tipoProducto);
        solicitud.setFecha(LocalDateTime.now());

        solicitud = solicitudProductoRepo.save(solicitud);  // persistencia con ID autogenerado

        SolicitudCredito credito = new SolicitudCredito();
        credito.setSolicitudId(solicitud.getId());
        credito.setIngresos(ingresos);
        credito.setPersonasACargo(personasACargo);
        credito.setGastosMensuales(gastosMensuales);

        String validacion = credito.validacionInicial();

        return ResponseEntity.ok("✅ Validación exitosa: " + validacion);
    }
}