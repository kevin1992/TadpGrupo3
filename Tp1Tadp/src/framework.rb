require_relative 'trait_implem'
require_relative 'estategias'

class Object

  def uses (trait, estrategia = EstrategiaExcepcion.new)
    # en este momento ustedes ya saben cuales son todos los métodos que hay que agregar y con que estrategia hay que
    #  resolver los conflictos entre ellos

    # hasta el momento del uses NO pueden saber que métodos tienen conflictos y cuales no, porque depende de como se combine el trait

    trait.metodos_agregados.each do
    |nombre, bloques|
      self.nuevo_metodo nombre, bloques, estrategia
    end
  end

  def nuevo_metodo(nombre, bloques, estrategia)
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
