#TODO hacer que se banque metodos con parametros

class Trait

  def self.define(nombre,&bloqueMetodos)

    nuevoTrait = Object.const_set(nombre,TraitOperador.new)


    class << nuevoTrait

      @@metodosAgregados = []

      def agregarMethod(nombre, &bloque)
        self.class.instance_eval do
          define_method(nombre) {bloque.yield}
          @@metodosAgregados.push (nombre)
        end
      end

      def metodosAgregados
        @@metodosAgregados
      end

    end


    nuevoTrait.instance_eval(&bloqueMetodos)



  end

end



class TraitOperador

end



class Object

  def uses trait, lista=trait.metodosAgregados


    lista = lista.select {|elem| trait.metodosAgregados.include? elem }

    lista.each {|nombreMetodo| define_method(nombreMetodo)  {trait.method(nombreMetodo).call}}

  end


end




Trait.define('MiTrait') do

  agregarMethod :saludar do
        puts "Hola!"
  end

  agregarMethod :sumar do
    puts "5"
  end


end


class Persona
  uses MiTrait

end


p = Persona.new

p.saludar()
p.sumar()
