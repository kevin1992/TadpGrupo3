class TraitException < Exception; end

class Trait

  attr_accessor :metodosAgregados, :bloqueMetodos,  :nombre, :estrategia

  def initialize
    self.metodosAgregados = Hash.new();

  end


  def agregarMetodos (&bloque)

   self.bloqueMetodos=bloque;
    instance_eval(&bloque)
  end

  def setHash nombre

    if self.metodosAgregados[nombre].nil?
      self.metodosAgregados[nombre] = []
    end

  end

  def agregarMethod (nombre,&bloque)


    setHash nombre

    self.metodosAgregados[nombre] << bloque;

  end


  def borrarMetodo nombreMetodo, trait
    trait.metodosAgregados.delete(nombreMetodo)
  end

  def copiarMetodos trait , traitAlQueCopio
    trait.metodosAgregados.each { |nombre,comportamientos|

      comportamientos.each {|comportamiento|
        traitAlQueCopio.agregarMethod nombre, &comportamiento
      }

    }
  end



  def + (otroTrait)

       nuevoTrait = Trait.new

      copiarMetodos self , nuevoTrait
      copiarMetodos otroTrait , nuevoTrait


    nuevoTrait

  end


  def - (*metodos)

    nuevoTrait = self.clone

    metodos.each {|metodo| borrarMetodo(metodo,nuevoTrait)}

    nuevoTrait

  end

  def << (nombreMetodoOriginal , nuevoNombreMetodoOriginal)

    nuevoTrait = Trait.new

    copiarMetodos self , nuevoTrait

    nuevoTrait.metodosAgregados[nuevoNombreMetodoOriginal] =  nuevoTrait.metodosAgregados[nombreMetodoOriginal]

    nuevoTrait

  end


end


