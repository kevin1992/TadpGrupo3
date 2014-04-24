
class Trait

  attr_accessor :metodosAgregados

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

    this = self

   self.metodosAgregados.each {|nombreMetodo|
     self.copiarMetodo nombreMetodo, nuevoTrait, this
   }

    otroTrait.metodosAgregados.each {|nombreMetodo|

      if (nuevoTrait.metodosAgregados.include? nombreMetodo)
        nuevoTrait.define_singleton_method(nombreMetodo)  {throw Exception.new("Conflicto del metodo #{nombreMetodo} ") }
      else
        self.copiarMetodo nombreMetodo, nuevoTrait, otroTrait
      end

    }

    nuevoTrait

  end



end


