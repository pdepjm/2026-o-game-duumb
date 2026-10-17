import baldosa.*

object tablero{

    method crearBaldosas() {

        (0 .. game.width() - 1).forEach({ x =>
            (0 .. game.height() - 2).forEach({ y =>
                game.addVisual(new Baldosa(position = game.at(x, y)))
            })
        })
    }

    method validarPosicion(posicion) {
        return posicion.x().between(0, game.width() - 1) and posicion.y().between(0, game.height() - 2)  
    }
}

object cartelFinal {
    var property image = null
    var property position = game.at(3,3)
}

object spawnerDeBaldosas {

    method iniciar() {
        game.onTick(4000, "spawnerTrampas", { self.generarTrampaRandom() })
    }

    method detener() {
        game.removeTickEvent("spawnerTrampas")
    }

    method generarTrampaRandom() {
        // 1. Elegimos coordenadas al azar dentro del mapa jugable
        const xRandom = (0 .. game.width() - 1).anyOne()
        const yRandom = (0 .. game.height() - 2).anyOne()
        const posRandom = game.at(xRandom, yRandom)

        // 2. Agarramos todo lo que haya en esa celda
        const cosasAhi = game.getObjectsIn(posRandom)

        // 3. Filtramos para quedarnos SOLO con la baldosa (ignoramos jugadores)
        const baldosasAhi = cosasAhi.filter({ obj => obj.esBaldosa() })

        if (not baldosasAhi.isEmpty()) {
            const baldosa = baldosasAhi.first()

            // Solo la convertimos si no era ya una trampa
            if (not baldosa.esTroll()) {
                baldosa.volverseTroll()
            }
        }
    }
}