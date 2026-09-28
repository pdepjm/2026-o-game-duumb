object pepita {
    var energy = 100

    method energy() = energy

    method fly(minutes) {
    energy = energy - minutes * 3
    }
}

class Jugador {
    var property position
    const property color
    var property celdasGanadas = 0

    method image() = "slime_" + color + ".png"

    method ganarCelda() {
        celdasGanadas += 1
    }
    method perderCelda() {
        celdasGanadas -= 1
    }

    method esPisable() = false

    method tePiso(otro) {
        otro.position(otro.position())
        self.position(self.position())
    }

    method pintarBaldosaActual() {
        game.getObjectsIn(position).forEach({ elemento => elemento.tePiso(self)})
    }

    method puedoIrA(nuevaPos) {
        if (reloj.tiempo() == 0) {
            return false
        }
        // Retorna true solo si no hay ningún obstáculo (como otro jugador) o otros addons futuros ahi
        return game.getObjectsIn(nuevaPos).all({ objeto => objeto.esPisable() })
    }

    method subir() {
        const nuevaPos = position.up(1)
        // Si no se sale del mapa Y el lugar está libre, avanza
        if (nuevaPos.y() < game.height() - 1 && self.puedoIrA(nuevaPos)){
            position = nuevaPos
            self.pintarBaldosaActual()
        }
    }

    method bajar() {
        const nuevaPos = position.down(1)
        if (position.y() > 0 and self.puedoIrA(nuevaPos)) {
            position = nuevaPos
            self.pintarBaldosaActual()
        }
    }

    method derecha() {
        const nuevaPos = position.right(1)
        if (position.x() < game.width() - 1 and self.puedoIrA(nuevaPos)) {
            position = nuevaPos
            self.pintarBaldosaActual()
        }
    }

    method izquierda() {
        const nuevaPos = position.left(1)
        if (position.x() > 0 and self.puedoIrA(nuevaPos)) {
            position = nuevaPos
            self.pintarBaldosaActual()
        }
    }
}

const jugadorVerde = new Jugador(
    celdasGanadas = 0,
    position = game.at(0,0),
    color = "verde"
)

const jugadorAzul = new Jugador(
    celdasGanadas = 0,
    position = game.at(9, 9),
    color = "azul"
)

object reloj {
    var property tiempo = 30
    var property position = game.at(4, 10)
    var property resultado = null

    method text() {
        if (resultado == null) {
            return "Tiempo: " + tiempo.toString()
        } else {
            return resultado
        }
    }
    method textColor() = "FFFFFF"

    method restarSegundo() {
    if (tiempo > 0) {
        tiempo -= 1
    } else {
        self.tiempoAgotado()
    }
}

    method tiempoAgotado() {
        self.detener()
        resultado = arbitro.darGanador()
        
        if(resultado != "Empate"){
            game.sound("win.mp3").play()
        }
        else{
            game.sound("empate.mp3").play()
        }

        game.schedule(4000, { game.stop() })
    }

    method iniciar() {
        game.onTick(1000, "cronometro", { self.restarSegundo() })
    }

    method detener() {
        game.removeTickEvent("cronometro")
    }
}


object arbitro{
    method darGanador(){
        if (jugadorVerde.celdasGanadas() > jugadorAzul.celdasGanadas()){
            return "Gano el verde"
        }
        else if (jugadorVerde.celdasGanadas() < jugadorAzul.celdasGanadas()){
            return "Gano el azul"
        }
        else{
            return "Empate"
        }
    }
}


class Baldosa {
    var property color = "neutra"
    var property position
    var duenioActual = null

    method esPisable() = true

    method image() = "baldosa_" + color + ".png"

    method tePiso(jugador){
        if(duenioActual != jugador){
            if(duenioActual != null){
                duenioActual.perderCelda()
            }

            duenioActual = jugador
            color = jugador.color()
            jugador.ganarCelda()
        }
    }
}
