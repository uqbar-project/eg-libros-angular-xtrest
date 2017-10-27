app.controller('TodosLosLibrosCtrl', function($resource, $timeout, cfpLoadingBar, Libros) {
    'use strict';
    
    var self = this;

    self.libros = [];

    function errorHandler(error) {
        self.notificarError(error.data);
    }

    this.actualizarLista = function() {
        Libros.query()
        .then(function(data) {
            console.log(data)
            self.libros = data;
        })
        .catch(errorHandler);
    };
    
    this.actualizarLista();

    // AGREGAR
    this.agregarLibro = function() {
        Libros.save(this.nuevoLibro, function(data) {
            self.notificarMensaje('Libro agregado con id:' + data.id);
            self.actualizarLista();
            self.nuevoLibro = null;
        }, errorHandler);
    };

    // ELIMINAR
    this.eliminar = function(libro) {
        var mensaje = "¿Está seguro de eliminar: '" + libro.titulo + "'?";
        bootbox.confirm(mensaje, function(confirma) {
            if (confirma) {
                Libros.remove(libro, function() {
                    self.notificarMensaje('Libro eliminado!');
                    self.actualizarLista();
                }, errorHandler);
            }
        });
    };

    // VER DETALLE
    this.libroSeleccionado = null;

    this.verDetalle = function(libro) {
        self.libroSeleccionado = libro;
        $("#verLibroModal").modal({});
    };

    // EDITAR LIBRO
    this.editarLibro = function(libro) {
    	self.libroSeleccionado = libro;
        $("#editarLibroModal").modal({});
    };

    this.guardarLibro = function() {
    	console.log(this.libroSeleccionado);
        Libros.update(this.libroSeleccionado, function() {
            self.notificarMensaje('Libro actualizado!');
            self.actualizarLista();
        }, errorHandler);

        this.libroSeleccionado = null;
        $("#editarLibroModal").modal('toggle');
    };

    // FEEDBACK & ERRORES
    this.msgs = [];
    this.notificarMensaje = function(mensaje) {
        this.msgs.push(mensaje);
        this.notificar(this.msgs);
    };

    this.errors = [];
    this.notificarError = function(mensaje) {
        this.errors.push(mensaje);
        this.notificar(this.errors);
    };

    this.notificar = function(mensajes) {
        $timeout(function() {
            while (mensajes.length > 0) mensajes.pop();
        }, 3000);
    }

});
