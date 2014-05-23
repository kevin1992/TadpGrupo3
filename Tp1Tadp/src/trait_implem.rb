class TraitImplem

  attr_accessor :metodos_agregados, :bloqueMetodos,  :nombre

  def initialize
    self.metodos_agregados = Hash.new
  end


  def agregar_metodos (&bloque)

   self.bloqueMetodos=bloque
    instance_eval(&bloque)
  end

  def set_hash nombre

    if self.metodos_agregados[nombre].nil?
      self.metodos_agregados[nombre] = []
    end

  end

  def method (nombre,&bloque)

    set_hash nombre
    self.metodos_agregados[nombre] << bloque;

  end


  def borrar_metodo nombre_metodo, trait
    trait.metodos_agregados.delete(nombre_metodo)
  end

  def copiar_metodos trait , trait_al_que_copio
    trait.metodos_agregados.each { |nombre,comportamientos|

      comportamientos.each {|comportamiento|
        trait_al_que_copio.method nombre, &comportamiento
      }
    }
  end



  def + (otroTrait)

       nuevoTrait = TraitImplem.new

      copiar_metodos self , nuevoTrait
      copiar_metodos otroTrait , nuevoTrait


    nuevoTrait

  end


  def - (*metodos)

    nuevoTrait = TraitImplem.new
    copiar_metodos self , nuevoTrait

    metodos.each {|metodo| borrar_metodo(metodo,nuevoTrait)}

    nuevoTrait

  end

  def << (nombreMetodoOriginal , nuevoNombreMetodoOriginal)

    nuevoTrait = TraitImplem.new

    copiar_metodos self , nuevoTrait

    nuevoTrait.metodos_agregados[nuevoNombreMetodoOriginal] =  nuevoTrait.metodos_agregados[nombreMetodoOriginal]

    nuevoTrait

  end


end
