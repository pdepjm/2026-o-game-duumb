import wollok.game.*
import juego.*

object menu {
    var botonActivo = sinBoton

    method configurarTeclas() {
        keyboard.enter().onPressDo({ botonActivo.accionar() })
    }

    method mostrarMenuInicial() {
        game.clear()
        game.boardGround("menu.png")
        botonActivo = botonEmpezar
        game.addVisual(botonEmpezar)
        self.configurarTeclas()
    }

    method mostrarBotonVolver() {
        botonActivo = botonVolverAlMenu
        game.addVisual(botonVolverAlMenu)
        self.configurarTeclas()
    }

    method desactivarBotones() {
        botonActivo = sinBoton
    }
}

object sinBoton {
    method accionar() {}
}

object botonEmpezar {
    var property position = game.at(3, 4)

    method image() = "boton_empezar.png"

    method accionar() {
        menu.desactivarBotones()
        juego.iniciarPartida()
    }
}

object botonVolverAlMenu {
    var property position = game.at(3, 1)

    method image() = "boton_volver.png"

    method accionar() {
        menu.mostrarMenuInicial()
    }
}