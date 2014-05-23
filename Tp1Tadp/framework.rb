require_relative 'src/trait'
require_relative 'src/trait_implem'
require_relative 'src/estategias'

class Object

  def uses (trait, estrategia=EstrategiaExcepcion.new)

      trait.metodos_agregados.each do
      |metodo|
        self.nuevo_metodo metodo , estrategia
      end

  end


  def nuevo_metodo(metodo, estrategia)
    # metodo[1] es el array con todos los bloques de comportamiento del metodo

   if hay_conflicto metodo[1]
   metodo_resuelto = estrategia.resolver(metodo)
    else
      metodo_resuelto = metodo[1][0]
    end

      define_method metodo[0], metodo_resuelto

    end


    def hay_conflicto(array_metodos)
      array_metodos.size>1
    end

end
