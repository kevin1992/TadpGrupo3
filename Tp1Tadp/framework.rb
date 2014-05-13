require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'
require '../Tp1Tadp/estategias'

class Object

  def uses (trait, &block)

    if trait.conflictos == []
      trait.metodosAgregados.each do
      |nombre|
        self.agregarMethod nombre
      end

      if !block.nil?  #si no se resuelve manualmente...
        block.call()
      end
    else
      raise TraitException.new('Conflicto con los metodos: ' + trait.conflictos.to_s)
    end

  end

  def resolver_con(estrategia, *metodos)
    metodos.each {|m| estrategia.agrega(m)}
    estrategia.resolver(self)
  end

  def agregarMethod(metodo)

      if !(self.respond_to?(metodo[0]))
      define_method metodo[0], metodo[1]
      #define_method nombre[0].to_s, nombre[1].to_proc
    end   #prioriza la existencia del metodo en la clase

  end

  def ejecutar(*metodos)
    metodos.each {|m| self.send (m)}
  end
end

