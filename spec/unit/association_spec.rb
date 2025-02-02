require 'spec_helper'

class Default
end

describe Neo4j::ActiveNode::HasN::Association do
  let(:options) { {type: nil} }
  let(:name) { :default }
  let(:direction) { :out }

  let(:association) do
    Neo4j::ActiveNode::HasN::Association.new(type, direction, name, options)
  end
  subject do
    association
  end

  context 'type = :invalid' do
    let(:type) { :invalid }

    it { expect { subject }.to raise_error(ArgumentError) }
  end

  context 'has_many' do
    let(:type) { :has_many }

    ### Validations

    context 'direction = :invalid' do
      let(:direction) { :invalid }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'origin and type specified' do
      let(:options) { {type: :bar, origin: :foo} }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'type and rel_class specified' do
      let(:options) { {type: :foo, origin: :bar} }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context 'origin and rel_class specified' do
      let(:options) { {origin: :foo, rel_class: :bar} }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    describe '#arrow_cypher' do
      let(:var) { nil }
      let(:properties) { {} }
      let(:create) { false }
      let(:reverse) { false } # TODO: reverse is not tested!?
      let(:length) { nil }

      subject { association.arrow_cypher(var, properties, create, reverse, length) }
      before do
        class MyRel
          def self._type
            'ar_type'
          end
        end
      end


      it { should == '-[]->' }

      context 'inbound' do
        let(:direction) { :in }

        it { should == '<-[]-' }
      end

      context 'bidirectional' do
        let(:direction) { :both }

        it { should == '-[]-' }
      end

      context 'creation' do
        let(:create) { true }

        it { should == '-[:`DEFAULT`]->' }

        context 'properties given' do
          let(:properties) { {foo: 1, bar: 'test'} }

          it { should == '-[:`DEFAULT` {foo: 1, bar: "test"}]->' }
        end
      end

      context 'variable given' do
        let(:var) { :fooy }

        it { should == '-[fooy]->' }

        context 'properties given' do
          let(:properties) { {foo: 1, bar: 'test'} }

          it { should == '-[fooy {foo: 1, bar: "test"}]->' }
        end

        context 'relationship type given' do
          let(:options) { {type: :new_type} }

          it { should == '-[fooy:`new_type`]->' }
        end

        context 'rel_class given' do
          let(:options) { {rel_class: MyRel} }

          it { should == '-[fooy:`ar_type`]->' }
        end

        context 'creation' do
          let(:create) { true }

          it { should == '-[fooy:`DEFAULT`]->' }

          context 'properties given' do
            let(:properties) { {foo: 1, bar: 'test'} }

            it { should == '-[fooy:`DEFAULT` {foo: 1, bar: "test"}]->' }
          end
        end
      end

      context 'relationship length given' do
        context 'as Symbol' do
          context ':any' do
            let(:length) { :any }

            it { should == '-[*]->' }
          end

          context 'invalid' do
            let(:length) { :none_or_more }

            it 'raises an error' do
              expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length (:none_or_more): expecting one of [:any]'
            end
          end
        end

        context 'as Fixnum' do
          context 'positive' do
            let(:length) { 42 }

            it { should == '-[*42]->' }
          end

          context 'negative' do
            let(:length) { -1337 }

            it 'raises an error' do
              expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length (-1337): cannot be negative'
            end
          end
        end

        context 'as Range' do
          context 'positive & increasing' do
            let(:length) { (2..6) }

            it { should == '-[*2..6]->' }

            context 'with end = Float::INFINITY' do
              let(:length) { (2..Float::INFINITY) }

              it { should == '-[*2..]->' }
            end
          end

          context 'decreasing' do
            let(:length) { (6..1) }

            it 'raises an error' do
              expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length (6..1): cannot be a decreasing Range'
            end
          end

          context 'including negative values' do
            let(:length) { (-10..5) }

            it 'raises an error' do
              expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length (-10..5): cannot include negative values'
            end
          end
        end

        context 'as a Hash' do
          context 'with :min and :max specified' do
            let(:length) { {min: 2, max: 6} }

            it { should == '-[*2..6]->' }
          end

          context 'with only :min specified' do
            let(:length) { {min: 2} }

            it { should == '-[*2..]->' }
          end

          context 'with only :max specified' do
            let(:length) { {max: 2} }

            it { should == '-[*..2]->' }
          end

          context 'with both :min and :max missing' do
            let(:length) { {foo: 2, bar: 3} }

            it 'raises an error' do
              expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length ({:foo=>2, :bar=>3}): Hash keys should be a subset of [:min, :max]'
            end
          end
        end

        context 'as an unsupported type' do
          let(:length) { 'any' }

          it 'raises an error' do
            expect { subject }.to raise_error ArgumentError, 'Invalid value for rel_length ("any"): should be a Symbol, Fixnum, Range or Hash'
          end
        end

        context 'with create = true' do
          let(:length) { 42 }
          let(:create) { true }

          it 'raises an error' do
            expect { subject }.to raise_error ArgumentError, 'rel_length option cannot be specified when creating a relationship'
          end
        end

        context 'with relationship variable given' do
          let(:length) { {min: 0} }
          let(:var) { :r }

          it { should == '-[r*0..]->' }

          context 'with relationship type given' do
            let(:options) { {type: :TYPE} }

            it { should == '-[r:`TYPE`*0..]->' }

            context 'with properties given' do
              let(:properties) {  {foo: 1, bar: 'test'} }

              it { should == '-[r:`TYPE`*0.. {foo: 1, bar: "test"}]->' }
            end
          end
        end
      end
    end

    describe '#target_class_names' do
      subject { association.target_class_names }

      context 'assumed model class' do
        let(:name) { :burzs }

        it { should == ['::Burz'] }
      end


      context 'specified model class' do
        context 'specified as string' do
          let(:options) { {type: :foo, model_class: 'Bizzl'} }

          it { should == ['::Bizzl'] }
        end

        context 'specified as class' do
          before(:each) do
            stub_const 'Fizzl', Class.new { include Neo4j::ActiveNode }
          end

          let(:options) { {type: :foo, model_class: 'Fizzl'} }

          it { should == ['::Fizzl'] }
        end
      end

      context 'with specified rel_class' do
        before(:each) do
          stub_const('TheRel',
                     Class.new do
                       def self.name
                         'TheRel'
                       end
                       include Neo4j::ActiveRel
                       from_class :any
                     end)
        end

        let(:options) { {rel_class: 'TheRel'} }

        context 'targeting any class' do
          before(:each) do
            TheRel.to_class(:any)
          end

          it { should be_nil }
        end

        context 'targeting a specific class' do
          context 'outbound' do
            before(:each) do
              stub_const 'Fizzl', Class.new { include Neo4j::ActiveNode }
              TheRel.to_class(Fizzl)
            end

            it { should == ['::Fizzl'] }
          end

          context 'inbound' do
            let(:direction) { :in }

            before(:each) do
              stub_const 'Buzz', Class.new { include Neo4j::ActiveNode }
              TheRel.from_class(Buzz)
            end

            it { should == ['::Buzz'] }
          end
        end
      end
    end

    describe 'target_class' do
      # subject { association.target_class }

      context 'with invalid target class name' do
        it 'raises an error' do
          expect(association).to receive(:target_class_names).at_least(1).times.and_return(['BadObject'])
          expect { association.target_class }.to raise_error ArgumentError
        end
      end
    end

    describe 'origin_type' do
      let(:start) {  Neo4j::ActiveNode::HasN::Association.new(:has_many, :in, 'name') }
      let(:myclass) { double('another activenode class') }
      let(:myassoc) { double('an association object') }
      let(:assoc_details) { double('the result of calling :associations', relationship_type: 'MyRel') }
      it 'examines the specified association to determine type' do
        expect(start).to receive(:target_class).and_return(myclass)
        expect(myclass).to receive(:associations).and_return(myassoc)
        expect(myassoc).to receive(:[]).and_return(assoc_details)
        expect(start.send(:origin_type)).to eq 'MyRel'
      end
    end

    describe 'relationship_class' do
      it 'returns the value of @relationship_class' do
        association.instance_variable_set(:@relationship_class, :foo)
        expect(association.send(:relationship_class)).to eq :foo
      end
    end

    describe 'unique' do
      context 'true' do
        let(:options) { {type: :foo, unique: true} }

        it do
          expect(subject).to be_unique
        end
      end

      context 'false' do
        let(:type) { :has_many }
        let(:options) { {type: :foo, unique: false} }

        it { expect(subject).not_to be_unique }
      end
    end
  end

  describe 'model refresh methods' do
    let(:type) { :has_many }
    describe '#queue_model_refresh!' do
      it 'changes the response of #pending_model_refresh' do
        expect { association.queue_model_refresh! }.to change { association.pending_model_refresh? }
      end
    end

    describe 'refresh_model_class!' do
      context 'with model class set' do
        before do
          stub_const('MyModel', Class.new)
          association.instance_variable_set(:@model_class, MyModel)
          name = 'MyModel'
          expect(MyModel).to receive(:name).and_return(name)
          expect(name).to receive(:constantize).and_return(Class.new)
        end

        it 'changes the value of #derive_model_class' do
          expect { association.refresh_model_class! }.to change { association.derive_model_class }
        end

        it 'resets #pending_model_refresh?' do
          association.queue_model_refresh!
          expect { association.refresh_model_class! }.to change { association.pending_model_refresh? }
        end
      end

      context 'without model class set' do
        before { association.instance_variable_set(:@model_class, nil) }

        it 'does not raise an error' do
          expect { association.refresh_model_class! }.not_to raise_error
        end

        it 'still resets #pending_model_refresh?' do
          association.queue_model_refresh!
          expect { association.refresh_model_class! }.to change { association.pending_model_refresh? }
        end
      end
    end
  end
end
