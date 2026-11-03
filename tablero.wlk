import baldosa.*

object tablero {
    const baldosas = []

    method baldosas() = baldosas

    method baldosasDisponibles() = baldosas.filter({ b => b.estaDisponible() })

    method crearBaldosas() {
        (0 .. game.width() - 1).forEach({ x =>
            (0 .. game.height() - 2).forEach({ y =>
                self.agregarBaldosa(new Baldosa(position = game.at(x, y)))
            })
        })
    }

    method agregarBaldosa(unaBaldosa) {
        baldosas.add(unaBaldosa)
        game.addVisual(unaBaldosa)
    }

    method baldosaAleatoria() = baldosas.anyOne()

    method alterarBaldosaAleatoria(nuevoTipo) {
        const disponibles = self.baldosasDisponibles()
        if (not disponibles.isEmpty()) {
            disponibles.anyOne().aplicarEfectoSorpresa(nuevoTipo)
        }
    }

    method validarPosicion(posicion) {
        return posicion.x().between(0, game.width() - 1) and posicion.y().between(0, game.height() - 2)  
    }
}

object cartelFinal {
    var property image = null
    var property position = game.at(3, 3)

    method mostrarEmpate() {
        self.mostrar("cartel_empate.png", "empate.mp3")
    }

    method mostrarGanador(ganador) {
        self.mostrar("cartel_" + ganador.color() + ".png", "win.mp3")
    }

    method mostrar(nombreImagen, archivoSonido) {
        image = nombreImagen
        game.addVisual(self)
        game.sound(archivoSonido).play()
    }
}

object spawnerDeBaldosas {
    const tiposEspeciales = [new TipoTrampa(), new TipoPared()]

    method iniciar() {
        game.onTick(2000, "spawnearBaldosasEspeciales", { self.generarEfectoRandom() })
    }

    method detener() {
        game.removeTickEvent("spawnearBaldosasEspeciales")
    }

    method generarEfectoRandom() {
        tablero.alterarBaldosaAleatoria(tiposEspeciales.anyOne())
    }
}
