require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'
require '../Tp1Tadp/estategias'

class Object

  def uses (trait, estrategia)


      trait.metodosAgregados.each do
      |metodo|
        self.nuevoMetodo metodo , estrategia
      end


  end

  def nuevoMetodo(metodo, estrategia)

    # metodo[1] es el array con todos los bloques de comportamiento del metodo

   if hayConflicto metodo[1]
   metodoResuelto = estrategia.resolver(metodo)
    else
      metodoResuelto = metodo[1][0]
    end

      define_method metodo[0], metodoResuelto

    end


    def hayConflicto arrayMetodos
      arrayMetodos.size>1
    end

end

