require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'
require '../Tp1Tadp/estategias'

class Object

  def uses (trait, &block)


      trait.metodosAgregados.each do
      |metodo|
        self.agregarMethod metodo
      end


  end

  def agregarMethod(metodo)

    # metodo[1] es el array con todos los bloques de comportamiento del metodo

    metodo[1].each {
        |bloqueComportamiento|
      define_method metodo[0], bloqueComportamiento
    }


  end

end

