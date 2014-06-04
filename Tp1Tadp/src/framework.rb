require_relative 'estategias'

class Object

  def uses(trait, estrategia = EstrategiaExcepcion.new)
    trait.metodos.each do |nombre, bloques|
      self.nuevo_metodo nombre, bloques, estrategia
    end
  end

  def nuevo_metodo(nombre, bloques, estrategia)
    if hay_conflicto bloques
      metodo_resuelto = estrategia.resolver(nombre, bloques)
    else
      metodo_resuelto = bloques.first
    end

    define_method nombre, metodo_resuelto
  end

  def hay_conflicto(array_metodos)
    array_metodos.size > 1
  end

end
