module Traits

  class Trait

    attr_accessor :bloque, :definicion

    def initialize(&bloque)

    @definicion = Module.new(&bloque)
    @metodosAgregados = @definicion.instance_methods(false)
    end


  end

end
