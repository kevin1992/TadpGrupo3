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
    define_method nombre ,&bloque

  end

end

