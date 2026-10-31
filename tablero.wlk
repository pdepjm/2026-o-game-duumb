import baldosa.*

object tablero {
    const baldosas = []

    method baldosas() = baldosas

    method baldosasPisables() = baldosas.filter({ b => b.esPisable() })

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

    method reemplazarBaldosa(anterior, nueva) {
        baldosas.remove(anterior)
        game.removeVisual(anterior)
        self.agregarBaldosa(nueva)
    }

    method baldosaAleatoria() = baldosas.anyOne()

    method trampearBaldosaAleatoria() {
        const pisables = self.baldosasPisables()
        if (not pisables.isEmpty()) {
            pisables.anyOne().volverseTrampa()
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
    method iniciar() {
        game.onTick(4000, "spawnerTrampas", { self.generarTrampaRandom() })
    }

    method detener() {
        game.removeTickEvent("spawnerTrampas")
    }

    method generarTrampaRandom() {
        tablero.trampearBaldosaAleatoria()
    }
}
