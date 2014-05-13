class TraitException < Exception; end

class Trait

  attr_accessor :metodosAgregados, :bloqueMetodos, :conflictos, :nombre

  def initialize
    self.metodosAgregados = Hash.new();
    self.conflictos=[]
  end


  def agregarMetodos (&bloque)

   self.bloqueMetodos=bloque;
    instance_eval(&bloque)
  end

  def agregarMethod (nombre,&bloque)

    #guardo cada metodo en el hash
    self.metodosAgregados[nombre] = bloque;
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
    trait.metodosAgregados.include? nombreMetodo[0].to_sym
  end


  def borrarMetodo nombreMetodo, trait
    trait.singleton_class.send(:remove_method, nombreMetodo)
    trait.metodosAgregados.delete(nombreMetodo)
  end

  def copiarMetodo nombreMetodo , traitAlQueCopio , traitQueTieneElMetodo
#    traitAlQueCopio.define_singleton_method(nombreMetodo)  {|*args| traitQueTieneElMetodo.method(nombreMetodo).call(*args)}
  #  traitAlQueCopio.metodosAgregados.push(nombreMetodo)
    traitAlQueCopio.metodosAgregados[nombreMetodo] = traitQueTieneElMetodo.metodosAgregados[nombreMetodo];
  end

  def copiarMetodo_alias nombreMetodo, nombreMetodoAliased, traitAlQueCopio, traitQueTieneElMetodo
    traitAlQueCopio.metodosAgregados[nombreMetodoAliased] = traitQueTieneElMetodo.metodosAgregados[nombreMetodo]
  end


  def + (otroTrait)

    nuevoTrait = Trait.new
    nuevoTrait.estrategia = self.estrategia.clone


   self.metodosAgregados.each {|metodo|
     self.copiarMetodo metodo[0], nuevoTrait, self
   }

    otroTrait.metodosAgregados.each {|nombreMetodo|
      if hayConflicto nuevoTrait, nombreMetodo

        @nombreMetodoAliased = (self.nombre.downcase+'_'+nombreMetodo[0].to_s).to_sym  # :m => trait1_m   Para que el user pueda resolver el conflito
        self.copiarMetodo_alias nombreMetodo[0], @nombreMetodoAliased, nuevoTrait, otroTrait
        self.conflictos << @nombreMetodoAliased
        self.conflictos << nombreMetodo[0]
        #nuevoBloque=self.estrategia.resolver(nuevoTrait.metodosAgregados[nombreMetodo],otroTrait.metodosAgregados[nombreMetodo])
        #nuevoTrait.metodosAgregados[nombreMetodo]=nuevoBloque
      else
        self.copiarMetodo nombreMetodo[0], nuevoTrait, otroTrait
      end

    }

    nuevoTrait.conflictos = self.conflictos
    nuevoTrait

  end



end


