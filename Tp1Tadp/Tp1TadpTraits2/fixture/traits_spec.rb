require 'rspec'
require_relative '../traits'
include Traits
require_relative '../class'

describe 'Creacion de un trait' do

  it 'definir traits' do

    #ejemplo de la consigna

    MiTrait = Trait.new do
      def metodo1
        "hola"
      end
      def metodo2(un_numero)
        un_numero * 0 + 42
      end
      def haceralgo
        letra
      end
    end

    class MiClase
      uses MiTrait
      attr_accessor :letra
      def initialize
        @letra = 'A'
      end
      def metodo1
        "mundo"
      end
    end

    o = MiClase.new
    o.metodo1.should == "mundo"
    o.metodo2(33).should == 42
    o.haceralgo.should == 'A'  #el trait usa el atributo de la clase por ser como un module

  end
end