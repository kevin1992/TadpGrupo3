require_relative 'src/trait'
require_relative 'src/trait_implem'
require_relative 'src/estategias'

class Object

  def uses (trait, estrategia=EstrategiaExcepcion.new)

      trait.metodos_agregados.each do
      |nombre, bloques|
        self.nuevo_metodo nombre, bloques, estrategia
      end

  end


  def nuevo_metodo(nombre, bloques, estrategia)
    # metodo[1] es el array con todos los bloques de comportamiento del metodo

   if hay_conflicto bloques
   metodo_resuelto = estrategia.resolver(nombre,bloques)
    else
      metodo_resuelto = bloques.first
    end

      define_method nombre, metodo_resuelto

    end


    def hay_conflicto(array_metodos)
      array_metodos.size>1
    end

end
