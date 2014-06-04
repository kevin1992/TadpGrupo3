class Trait

  attr_accessor :metodos

  def self.define(nombre, &bloque_metodos)
    nuevo_trait = Trait.new
    nuevo_trait.agregar_metodos &bloque_metodos
    Object.const_set(nombre, nuevo_trait)
    nuevo_trait
  end

  def initialize(metodos = Hash.new { [] } )
    # Hash.new { <default value> } hace que cuando le pidan un elemento que no existe evalúe el bloque y retorne su respuesta
    self.metodos = metodos
  end

  def agregar_metodos(&bloque)
    instance_eval(&bloque)
  end

  def method(nombre, &bloque)
    self.metodos[nombre] = self.metodos[nombre] << bloque
  end

  def borrar_metodos(*nombre_metodos)
    nombre_metodos.each { |nombre_metodo|
      self.metodos.delete(nombre_metodo)
    }
  end

  def clone
    Trait.new(self.metodos.clone)
  end

  def +(otroTrait)
    # TODO
  end

  def -(*metodos)
    nuevo_trait = self.clone
    nuevo_trait.borrar_metodos(*metodos)
    nuevo_trait
  end

  def <<(nombre, nuevo_nombre)
    # TODO
  end

end
