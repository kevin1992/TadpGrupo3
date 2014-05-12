require '../Tp1Tadp/creador_trait'
require '../Tp1Tadp/trait'
require '../Tp1Tadp/estategias'

class Object



  def uses (trait, lista=trait.metodosAgregados)

    trait.metodosAgregados.each do
    |nombre,bloque| self.agregarMethod nombre, &bloque
    end

  end



  def agregarMethod(nombre,&bloque)
    #unless self.respond_to?(nombre, false) {
    #  define_method nombre, &bloque
    #}
    #end   #prioriza la existencia del metodo en la clase
    
    
    if (!(self.respond_to?(nombre)))
      define_method nombre, &bloque
    end   #prioriza la existencia del metodo en la clase
    
  end
  
end

