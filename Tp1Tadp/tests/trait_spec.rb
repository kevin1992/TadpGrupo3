require 'rspec'
require_relative '../src/framework'
require_relative '../src/trait'

describe 'Algebra' do

  TraitImplem.definirTrait 'MiTrait' do
    method :metodo1 do
      'hola'
    end
    method :metodo2 do |un_numero|
      un_numero * 0 + 42
    end
  end

  TraitImplem.definirTrait 'MiOtroTrait' do
    method :metodo1 do
      'kawuabonga'
    end
    method :metodo3 do
      'mundo'
    end
  end


  it 'prueba la resta' do

    class TodoBienTodoLegal
      uses (MiTrait - :metodo2) + (MiOtroTrait - :metodo1), EstrategiaExcepcion.new
    end
    o = TodoBienTodoLegal.new
    expect {
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
    expect {
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

    TraitImplem.definirTrait 'TraitComp' do
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
    TraitImplem.definirTrait 'MiTrait' do

      method :algo do
        self
      end
    end

    instancia = Class.new {
      uses MiTrait, EstrategiaExcepcion.new
    }.new

    instancia.algo.should == instancia
  end

  it 'se ejecutan todos los metodos conflictivos y accede al attr de la clase' do

    TraitImplem.definirTrait 'MiTrait' do

      method :edad_nueva do
        self.edad = self.edad + 20
      end

    end

    TraitImplem.definirTrait 'MiOtroTrait' do

      method :edad_nueva do
        self.edad = self.edad + 10
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

  TraitImplem.definirTrait 'Trait1' do
    method :nombresss do
      'Kevin'
    end
  end

  TraitImplem.definirTrait 'Trait2' do
    method :nombresss do
      'Facundo'
    end
  end

  TraitImplem.definirTrait 'Trait3' do

    method :nombresss do
      'Cristian'
    end
  end

  TraitImplem.definirTrait 'Trait4' do
    method :nombresss do
      'Maxi'
    end
  end

  TraitImplem.definirTrait 'Trait5' do
    method :nombresss do
      'Jony'
    end

  end

  it 'devuelve Kevin por ser el mayor mas proximo a J' do

    class Nombres
      uses (Trait1 + Trait2 + Trait3 + Trait4 + Trait5), EstrategiaPorCorte.new { |elem| elem>'J' }
    end

    prueba_corte = Nombres.new
    puts prueba_corte.nombresss.should == 'Kevin'

  end

  it 'recibe parametros el metodo y funciona' do

    TraitImplem.definirTrait 'Trait01' do
      method :numero do |num|
        5 + num
      end
    end


    TraitImplem.definirTrait 'Trait02' do
      method :numero do |num|
        10 + num
      end
    end


    class Persona2
      uses Trait01+Trait02, EstrategiaPorCorte.new { |result| result>15 }
    end

    p = Persona2.new

    p.numero(6).should==16


  end

end


describe 'Estrategia por Funcion' do

  TraitImplem.definirTrait 'TFuncion1' do
    method :numero_x do
      2
    end
  end

  TraitImplem.definirTrait 'TFuncion2' do
    method :numero_x do
      3
    end
  end

  TraitImplem.definirTrait 'TFuncion3' do
    method :numero_x do
      4
    end
  end

  it 'devuelve la multiplicacion del retorno de cada metodo conflictivo' do

    class Numeros
      uses (TFuncion1 + TFuncion2 + TFuncion3), EstrategiaPorFuncion.new { |x, y| x*y }
    end

    prueba_funcion = Numeros.new
    prueba_funcion.numero_x.should == 24

  end

  it 'asdf' do
    a = [1]
    b = a
    a.should == [1]
    b << 2
    b.should == [1, 2]

    a.should == [1, 2]

  end

  it 'puedo definir un metodo' do

    clase = Class.new {
      def nombre
        'hola'
      end

    }
    clase.send(:define_method, :algo) {
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

describe 'Test de Pablo' do

  it 'estoy probando parametros, acceso al estado interno y retorno' do
    # esto sería un "test de integración" (testeo que todas sus partes se comuniquen y funcionen correctamente)
    # pero ustedes tienen que hacer tests para cada parte así pueden individualizar los problemas
    # (ver test siguiente como ejemplo de test unitario)

    Trait.define 'TraitA' do

      method :m1 do |parametro|
        @otro1 = 4
        @primero = parametro
        123
      end

    end

    Trait.define 'TraitB' do

      method :m1 do |parametro|
        @otro2 = 5
        @segundo = parametro
        456
      end

    end

    class Usuario
      attr_accessor :primero, :segundo, :otro1, :otro2
      uses (TraitA + TraitB), EstrategiaTodosLosMensajes.new
    end

    usuario = Usuario.new
    usuario.primero.nil?.should == true
    usuario.segundo.nil?.should == true

    usuario.m1(55).should == 456

    usuario.otro1.should == 4
    usuario.otro2.should == 5

    usuario.primero.should == 55
    usuario.segundo.should == 55
  end

  it 'puedo sumar dos traits' do
    a_m1 = proc {}
    b_m1 = proc {}
    b_m2 = proc {}

    Trait.define 'TraitA' do
      method :m1, &a_m1
    end

    Trait.define 'TraitB' do
      method :m1, &b_m1
      method :m2, &b_m2
    end

    resultado = TraitA + TraitB
    resultado.metodos.size.should == 2

    resultado.metodos[:m1].size.should == 2
    resultado.metodos[:m1][0].should == a_m1
    resultado.metodos[:m1][1].should == b_m1

    resultado.metodos[:m2].size.should == 1
    resultado.metodos[:m2][0].should == b_m2
  end

end