class CreadorTrait

  def self.definirTrait(nombre,&bloqueMetodos)

    nuevoTrait = Object.const_set(nombre,Trait.new)
    nuevoTrait.nombre = nombre
    nuevoTrait.agregarMetodos &bloqueMetodos
    #nuevoTrait.estrategia = estrategia

  end

end
