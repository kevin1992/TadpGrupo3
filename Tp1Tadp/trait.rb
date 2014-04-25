
class Trait

  attr_accessor :metodosAgregados , :estrategia

  def initialize()
    self.metodosAgregados = []
  end

  def agregarMethod(nombre, &bloque)
   define_singleton_method (nombre) do |*args| bloque.call(*args) end
   self.metodosAgregados.push(nombre)
  end

  def agregarMetodos (&bloque)

    instance_eval &bloque

  end

  def - (*metodos)

    nuevoTrait = self.clone

    metodos.each {|metodo|
      borrarMetodo(metodo,nuevoTrait)
    }

    nuevoTrait


  end


  def << metodoOriginal,nuevoNombreMetodo

    agregarMethod(nuevoNombreMetodo) {|*args| method(metodoOriginal).call(*args)}

    self

  end

  def hayConflicto trait , nombreMetodo
    trait.metodosAgregados.include? nombreMetodo
  end


  def borrarMetodo nombreMetodo, trait
    trait.singleton_class.send(:remove_method, nombreMetodo)
    trait.metodosAgregados.delete(nombreMetodo)
  end

  def copiarMetodo nombreMetodo , traitAlQueCopio , traitQueTieneElMetodo
    traitAlQueCopio.define_singleton_method(nombreMetodo)  {|*args| traitQueTieneElMetodo.method(nombreMetodo).call(*args)}
    traitAlQueCopio.metodosAgregados.push(nombreMetodo)
  end


  def + (otroTrait)

    nuevoTrait = Trait.new;
    nuevoTrait.estrategia = self.estrategia.clone


   self.metodosAgregados.each {|nombreMetodo|
     self.copiarMetodo nombreMetodo, nuevoTrait, self
   }

    otroTrait.metodosAgregados.each {|nombreMetodo|

      if (hayConflicto nuevoTrait, nombreMetodo)
        nuevoTrait.define_singleton_method(nombreMetodo)  {|*args| nuevoTrait.estrategia.method(:resolver).call(this,otroTrait,nombreMetodo,*args) }
      else
        self.copiarMetodo nombreMetodo, nuevoTrait, otroTrait
      end

    }

    nuevoTrait

  end



end


