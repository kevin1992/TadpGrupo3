class Trait

  def self.define(nombre,&bloque_metodos)

    nuevo_trait = Object.const_set(nombre,TraitImplem.new)
    nuevo_trait.nombre = nombre
    nuevo_trait.agregar_metodos &bloque_metodos

  end

end
