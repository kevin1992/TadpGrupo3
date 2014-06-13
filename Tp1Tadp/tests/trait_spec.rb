
require 'rspec'

require_relative '../src/framework'




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
      uses (MiTrait - :metodo2) + (MiOtroTrait - :metodo1)

      def initialize(estrategia)
        definirMetodos estrategia
      end

    end
    o = TodoBienTodoLegal.new  EstrategiaExcepcion.new
    expect {
      o.metodo2(84)
    }.to raise_error NoMethodError
    o.metodo3.should == 'mundo'
    o.metodo1.should == 'hola'

  end



  it 'prueba la suma' do

    class TodoBienTodoLegal
      uses (MiTrait + MiOtroTrait)

      def initialize(estrategia)
        definirMetodos estrategia
      end

    end
    o = TodoBienTodoLegal.new EstrategiaExcepcion.new
    o.metodo2(84).should == 42
    o.metodo3.should == 'mundo'
    expect {
      o.metodo1
    }.to raise_error TraitImplementationError

  end

  it 'renombra selectores' do

    TraitImplem.definirTrait 'TraitAlias' do
      method :metodo1 do
        'hola'
      end
      method :metodo2 do |un_numero|
        un_numero * 0 + 42
      end
    end

    class ConAlias
      uses (TraitAlias.<< :metodo1, :saludo)

      def initialize(estrategia)
        definirMetodos estrategia
      end

    end
    o = ConAlias.new  EstrategiaExcepcion.new

    o.saludo.should == o.metodo1

    o.metodo2(84).should == 42

  end


end



describe 'Estrategia Todos los Mensajes' do

  it 'puedo consultar self' do
    TraitImplem.definirTrait 'MiTraitConSelf' do

      method :algo do
        self
      end
    end

    instancia = Class.new {
      uses MiTraitConSelf
      def initialize(estrategia)
        definirMetodos estrategia
      end
    }.new EstrategiaExcepcion.new

    instancia.algo.should == instancia
  end

  it 'se ejecutan todos los metodos conflictivos y accede al attr de la clase' do

    TraitImplem.definirTrait 'MiTrait2' do

      method :edad_nueva do
        self.edad = self.edad + 20
      end

    end

    TraitImplem.definirTrait 'MiOtroTrait2' do

      method :edad_nueva do
        self.edad = self.edad + 10
      end

    end

    class Persona
      uses (MiTrait2 + MiOtroTrait2)
      attr_accessor :edad

      def initialize(n,estrategia)
        self.edad = n
        definirMetodos estrategia
      end

    end

    prueba_todos = Persona.new(20,EstrategiaTodosLosMensajes.new)
    prueba_todos.edad_nueva.should == 50

  end

end




describe 'Estrategia por Corte' do

  TraitImplem.definirTrait 'Trait1' do
    method :nombre do
      'Kevin'
    end
  end

  TraitImplem.definirTrait 'Trait2' do
    method :nombre do
      'Facundo'
    end
  end

  TraitImplem.definirTrait 'Trait3' do

    method :nombre do
      'Cristian'
    end
  end

  TraitImplem.definirTrait 'Trait4' do
    method :nombre do
      'Maxi'
    end
  end

  TraitImplem.definirTrait 'Trait5' do
    method :nombre do
      'Jony'
    end

  end

  it 'devuelve Kevin por ser el mayor mas proximo a J' do

    class Nombres
      uses (Trait1 + Trait2 + Trait3 + Trait4 + Trait5)
      def initialize(estrategia)
        definirMetodos estrategia
      end
    end

    prueba_corte = Nombres.new EstrategiaPorCorte.new { |elem| elem>'J' }
    prueba_corte.nombre.should == 'Kevin'

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
      uses Trait01+Trait02
      def initialize(estrategia)
        definirMetodos estrategia
      end
    end

    p = Persona2.new EstrategiaPorCorte.new { |result| result>15 }

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
      uses (TFuncion1 + TFuncion2 + TFuncion3)
      def initialize(estrategia)
        definirMetodos estrategia
      end
    end

    prueba_funcion = Numeros.new EstrategiaPorFuncion.new { |x, y| x*y }
    prueba_funcion.numero_x.should == 24

  end


end




describe 'Test de Pablo' do

  it 'estoy probando parametros, acceso al estado interno y retorno' do
    # esto sería un "test de integración" (testeo que todas sus partes se comuniquen y funcionen correctamente)
    # pero ustedes tienen que hacer tests para cada parte así pueden individualizar los problemas
    # (ver test siguiente como ejemplo de test unitario)

    TraitImplem.definirTrait 'TraitA' do

      method :m1 do |parametro|
        @otro1 = 4
        @primero = parametro
        123
      end

    end

    TraitImplem.definirTrait 'TraitB' do

      method :m1 do |parametro|
        @otro2 = 5
        @segundo = parametro
        456
      end

    end

    class Usuario
      attr_accessor :primero, :segundo, :otro1, :otro2
      uses (TraitA + TraitB)
      def initialize(estrategia)
        definirMetodos estrategia
      end
    end

    usuario = Usuario.new EstrategiaTodosLosMensajes.new
    usuario.primero.nil?.should == true
    usuario.segundo.nil?.should == true

    usuario.m1(55).should == 456

    usuario.otro1.should == 4
    usuario.otro2.should == 5

    usuario.primero.should == 55
    usuario.segundo.should == 55
  end

end