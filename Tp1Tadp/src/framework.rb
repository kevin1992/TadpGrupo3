require_relative 'trait_implem'
require_relative 'estategias'

class Object

  @@trait = nil;

  def uses (trait)


    @@trait = trait;

  end


  def definirMetodos (estrategia)

    @@trait.metodos_agregados.each do
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

    define_singleton_method nombre, metodo_resuelto

  end


  def hay_conflicto(array_metodos)
    array_metodos.size>1
  end

end
