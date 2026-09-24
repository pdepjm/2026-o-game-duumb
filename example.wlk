object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

object personaje{
  var property position = game.origin()
  var property image = "BabosaVerde/BabosaVerdeIzquierda.png"

	method centrar(){
    position = game.center()
	}

  method subir() {
    position = position.up(2)
  }

  method bajar() {
    position = position.down(2)
  }

  method derecha() {
    position = position.right(2)
    image = "BabosaVerde/BabosaVerdeDerecha.png"
  }

  method izquierda() {
    position = position.left(2)
    image = "BabosaVerde/BabosaVerdeIzquierda.png"
  }

}


object manteca {
  method position() = game.center()

  method text() = "Mantecaaa!!!"
}

object segundoPersonaje {
  var property position = game.origin()
  var property image = "BabosaAzul/BabosaAzulDerecha.png"

  method centrar(){
    position = game.center()
	}

  method subir() {
    position = position.up(2)
  }

  method bajar() {
    position = position.down(2)
  }

  method derecha() {
    position = position.right(2)
    image = "BabosaAzul/BabosaAzulDerecha.png"
  }

  method izquierda() {
    position = position.left(2)
    image = "BabosaAzul/BabosaAzulIzquierda.png"
  }

}