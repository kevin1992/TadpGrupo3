require 'rspec'
require_relative 'framework'


describe 'Algebra' do

  CreadorTrait.definirTrait('MiTrait') do
    agregarMethod :metodo1 do
      'hola'
    end
    agregarMethod :metodo2 do |un_numero|
      un_numero * 0 + 42
    end
  end

  CreadorTrait.definirTrait 'MiOtroTrait' do
    agregarMethod :metodo1 do
      'kawuabonga'
    end
    agregarMethod :metodo3 do
      'mundo'
    end
  end


  it 'prueba la resta' do

    class TodoBienTodoLegal
      uses (MiTrait - :metodo2) + (MiOtroTrait - :metodo1), EstrategiaExcepcion.new()
    end
    o = TodoBienTodoLegal.new
    expect{
      o.metodo2(84)
    }.to raise_error NoMethodError
    o.metodo3.should == 'mundo'
    o.metodo1.should == 'hola'

  end

  it 'prueba la suma' do

    class TodoBienTodoLegal
      uses (MiTrait + MiOtroTrait), EstrategiaExcepcion.new
    end
    o = TodoBienTodoLegal.new
    o.metodo2(84).should == 42
    o.metodo3.should == 'mundo'
    expect{
      o.metodo1
    }.to raise_error TraitImplementationError

  end

  it 'renombra selectores' do

    class ConAlias
      uses (MiTrait.<< :metodo1, :saludo), EstrategiaExcepcion.new
    end
    o = ConAlias.new
    o.saludo.should == 'hola'
    o.metodo1.should == 'hola'
    o.metodo2(84).should == 42

  end

  it 'componer traits con otros traits' do

    CreadorTrait.definirTrait 'TraitComp' do
      uses MiTrait, EstrategiaExcepcion.new
    end

    class Compuesta
      uses TraitComp, EstrategiaExcepcion.new
    end

    c = Compuesta.new
    c.metodo1.should == "hola"

  end

end


describe 'Estrategia Todos los Mensajes' do

  it 'puedo consultar self' do
    CreadorTrait.definirTrait 'MiTrait' do

      agregarMethod :algo do
        self
      end
    end

    instancia = Class.new {
      uses MiTrait, EstrategiaExcepcion.new
    }.new

    instancia.algo.should == instancia
  end

  it 'se ejecutan todos los metodos conflictivos y accede al attr de la clase' do

    CreadorTrait.definirTrait 'MiTrait' do

      agregarMethod :edad_nueva do
        self.edad = self.edad + 20
      end

    end

    CreadorTrait.definirTrait 'MiOtroTrait' do

      agregarMethod :edad_nueva do
        self.edad  = self.edad + 10
      end

    end

    class Persona
      uses (MiTrait + MiOtroTrait), EstrategiaTodosLosMensajes.new
      attr_accessor :edad
      def initialize(n)
        self.edad = n
      end
    end

    prueba_todos = Persona.new(20)
    prueba_todos.edad_nueva.should == 50

  end

end

describe 'Estrategia por Corte' do

  CreadorTrait.definirTrait 'Trait1' do
    agregarMethod :nombresss do
      'Kevin'
    end
  end

  CreadorTrait.definirTrait 'Trait2' do
    agregarMethod :nombresss do
      'Facundo'
    end
  end

  CreadorTrait.definirTrait 'Trait3' do

    agregarMethod :nombresss do
      'Cristian'
    end
  end

  CreadorTrait.definirTrait 'Trait4' do
    agregarMethod :nombresss do
      'Maxi'
    end
  end

  CreadorTrait.definirTrait 'Trait5' do
    agregarMethod :nombresss do
      'Jony'
    end

  end

  it 'devuelve Kevin por ser el mayor mas proximo a J' do

    class Nombres
      uses (Trait1 + Trait2 + Trait3 + Trait4 + Trait5), EstrategiaPorCorte.new {|elem| elem>'J' }
    end

    prueba_corte = Nombres.new
    puts prueba_corte.nombresss.should == 'Kevin'

  end

  it 'recibe parametros el metodo y funciona' do

    CreadorTrait.definirTrait 'Trait01' do
      agregarMethod :numero do |num|
        5 + num
      end
      end


      CreadorTrait.definirTrait 'Trait02' do
        agregarMethod :numero do |num|
          10 + num
        end
        end


        class Persona2
          uses Trait01+Trait02 , EstrategiaPorCorte.new() {|result| result>15}
        end

        p = Persona2.new()

        p.numero(6).should==16


end

end


describe 'Estrategia por Funcion' do

  CreadorTrait.definirTrait 'TFuncion1' do
    agregarMethod :numero_x do
      2
    end
  end

  CreadorTrait.definirTrait 'TFuncion2' do
    agregarMethod :numero_x do
      3
    end
  end

  CreadorTrait.definirTrait 'TFuncion3' do
    agregarMethod :numero_x do
      4
    end
  end

  it 'devuelve la multiplicacion del retorno de cada metodo conflictivo' do

  class Numeros
    uses (TFuncion1 + TFuncion2 + TFuncion3), EstrategiaPorFuncion.new() {|x, y| x*y }
  end

  prueba_funcion = Numeros.new
  prueba_funcion.numero_x.should == 24

  end

  it 'asdf' do
    a = [1]
    b = a
    a.should == [1]
    b << 2
    b.should == [1,2]

    a.should == [1,2]

  end

  it  'puedo definir un metodo'  do

    clase = Class.new {
      def nombre
        'hola'
      end

    }
    clase.send(:define_method, :algo){
        self.nombre
    }

    instancia = clase.new
    instancia.algo.should == 'hola'
  end

  it 'call a un bloque y self' do

    class A
      def nombresss
        'jose'
      end

      def dame_bloque
        proc {
          self.nombresss
        }
      end
    end

    class B
      def nombre
        'pepe'
      end

      def ejecutar(un_a)
        un_a.dame_bloque.call
      end
    end

    una_instancia_de_a = A.new
    B.new.ejecutar(una_instancia_de_a).should == una_instancia_de_a

  end

end
