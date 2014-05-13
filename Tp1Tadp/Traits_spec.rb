require 'rspec'
require '../Tp1Tadp/framework'


describe 'Algebra' do

  CreadorTrait.definirTrait('MiTrait', EstrategiaExcepcion.new()) do
    agregarMethod :metodo1 do
      "hola"
    end
    agregarMethod :metodo2 do |un_numero|
      un_numero * 0 + 42
    end
  end

  CreadorTrait.definirTrait('MiOtroTrait', EstrategiaExcepcion.new()) do
    agregarMethod :metodo1 do
      'kawuabonga'
    end
    agregarMethod :metodo3 do
      'mundo'
    end
  end


  it 'prueba la resta' do

    class TodoBienTodoLegal
      uses (MiTrait-:metodo2) + (MiOtroTrait-:metodo1)
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
      uses MiTrait + MiOtroTrait
    end
    o = TodoBienTodoLegal.new
    o.metodo2(84).should == 42
    o.metodo3.should == 'mundo'
    expect{
      o.metodo1
    }.to raise_error

  end

  it 'renombra selectores' do

    class ConAlias
      uses MiTrait << :metodo1, :saludo
    end
    o = ConAlias.new
    o.saludo.should == 'hola'
    o.metodo1.should == 'hola'
    o.metodo2(84).should == 42


  end

  it 'componer traits con otros traits' do

    CreadorTrait.definirTrait('TraitComp', EstrategiaExcepcion.new()) do
      uses MiTrait
    end

    class Compuesta
      uses TraitComp
    end

    c = Compuesta.new
    c.metodo1.should == "hola"

  end

end


describe 'Estrategia Todos los Mensajes' do

  it 'se ejecutan todos los metodos conflictivos' do

    CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

      agregarMethod :saludar do |persona|
        'Hola ' + persona.to_s + '!'
      end

    end

    CreadorTrait.definirTrait('MiOtroTrait',EstrategiaTodosLosMensajes.new()) do

      agregarMethod :saludar do |persona|
        'Hola2 ' + persona.to_s + '!'
      end

    end

    class Persona
      uses MiTrait+MiOtroTrait
    end

    prueba_todos = Persona.new
    prueba_todos.saludar("Kevin").should == 'Hola2 Kevin!'
    #Expected: Que ejecute el :saludar de MiOtroTrait .

  end

  it 'el trait debe poder usar un atributo de la clase' do

    CreadorTrait.definirTrait('MiTrait',EstrategiaTodosLosMensajes.new()) do

      agregarMethod :saludar do |persona|
        puts 'Hola2 ' + persona.to_s + '!'
      end

    end

    CreadorTrait.definirTrait('MiOtroTrait',EstrategiaTodosLosMensajes.new()) do

      agregarMethod :saludar do ||
        @saludo = self.saludo + " Que tal"
      end

    end

    class Persona
      uses MiTrait+MiOtroTrait
      attr_accessor :nombre, :saludo
      @saludo = ''
      def initialize(nombre)
        @nombre = nombre
      end

    end

    prueba_todos = Persona.new('Kevin')
    prueba_todos.saludar.should == 'Hola Kevin! Que tal'
    #Expected: Que ejecute todos los mensajes conflictivos.
    # Ejemplo :saludar => Hola Kevin! Que tal
    # IMPORTANTE: Los traits no usan los atributos de la clase

  end


end


describe 'Estrategia por Corte' do

  estrategia_c = EstrategiaPorCorte.new() {|elem| elem>'J' }

  CreadorTrait.definirTrait('Trait1',estrategia_c ) do
    agregarMethod :nombre do
      'Kevin'
    end
  end

  CreadorTrait.definirTrait('Trait2',estrategia_c ) do
    agregarMethod :nombre do
      'Facundo'
    end
  end

  CreadorTrait.definirTrait('Trait3',estrategia_c ) do

    agregarMethod :nombre do
      'Cristian'
    end
  end

  CreadorTrait.definirTrait('Trait4',estrategia_c ) do
    agregarMethod :nombre do
      'Maxi'
    end
  end

  CreadorTrait.definirTrait('Trait5',estrategia_c ) do
    agregarMethod :nombre do
      'Jony'
    end

  end

  it 'devuelve Kevin por ser el mayor mas proximo a J' do

    class Nombres
      uses Trait1 + Trait2 + Trait3 + Trait4 + Trait5
    end

    prueba_corte = Nombres.new
    puts prueba_corte.nombre.should == 'Kevin'

  end

  it 'la clase tiene prioridad para el lookup del metodo conflicitvo' do

    class Nombres
      uses Trait1 + Trait2 + Trait3 + Trait4
      def nombre
        'Carlos'
      end
    end

    prueba_corte = Nombres.new
    puts prueba_corte.nombre.should == 'Carlos'

  end
end


describe 'Estrategia por Funcion' do

  estrategia_f = EstrategiaPorFuncion.new() {|x, y| x*y }

  CreadorTrait.definirTrait('TFuncion1',estrategia_f ) do
    agregarMethod :numero_x do
      2
    end
  end

  CreadorTrait.definirTrait('TFuncion2',estrategia_f ) do
    agregarMethod :numero_x do
      3
    end
  end

  CreadorTrait.definirTrait('TFuncion3',estrategia_f ) do
    agregarMethod :numero_x do
      4
    end
  end

  it 'devuelve la multiplicacion del retorno de cada metodo conflictivo' do

  class Numeros
    uses TFuncion1 + TFuncion2 + TFuncion3
  end

  prueba_funcion = Numeros.new
  prueba_funcion.numero_x.should == 24

  end

end
