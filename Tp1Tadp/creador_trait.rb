class CreadorTrait

  def self.definirTrait(nombre,estrategia=EstrategiaNoHacerNada.new,&bloqueMetodos)

    nuevoTrait = Object.const_set(nombre,Trait.new)
    #   nuevoTrait.instance_eval(&bloqueMetodos)
    nuevoTrait.agregarMetodos &bloqueMetodos
    nuevoTrait.estrategia = estrategia


  end

end
