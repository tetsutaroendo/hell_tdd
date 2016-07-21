require 'menu'
require 'supports/stdout_spy'
require 'supports/stdin_stub'
require 'history_repository'

describe Menu do
  let(:spy) { StdoutSpy.new }
  let(:stub) { StdinStub.new(input) }
  let(:file_path) { 'test.txt' }
  let(:history_repository){ HistoryRepository.new(file_path) }
  let(:menu) { described_class.new(stub, spy, history_repository) }

  context '1を選択する場合' do
    context '正常系' do
      let(:input) { '3' }

      it do
        menu.select('1')

        fizzbuzz = FizzBuzz.new(input.to_i)
        aggregate_failures do
          expect(spy.result).to eq([fizzbuzz.result])
          expect(history_repository.current_history.map{ |f| f.to_s }).to eq([fizzbuzz.to_s])
        end
      end
    end

    context '異常系' do
      let(:input) { '0.2' }

      it 'バリデーションがかかっていること' do
        menu.select('1')
        expect(spy.result).to eq(['整数を入力してください'])
      end
    end
  end

  context '存在しないメニューを選択する場合' do
    let(:input) { nil }

    it do
      menu.select('100')
      expect(spy.result).to be_empty
    end
  end

  # spyを本番で使うSTDOUTにしてテストした例
  #it do
  #  spy = STDOUT
  
  #  obj = Menu.new(stub, spy)
  #  obj.select('1')
  #end

  context '2を選択する場合' do
    let(:input) { nil }

    it do
      fizz = FizzBuzz.new(3)
      buzz = FizzBuzz.new(5)
      history_repository.add(fizz.to_s)
      history_repository.add(buzz.to_s)
      menu.select('2')
      expect(spy.result).to eq([fizz.to_s, buzz.to_s])
    end
  end

  context '4を選択する場合' do
    before { delete_file }

    let(:input) { nil }

    context 'ファイルを保存しなかった場合' do
      it do
        menu.select('4')
        expect(spy.result).to be_empty
      end
    end

    context 'ファイルを保存した場合' do
      after { delete_file }

      it do
        fizzbuzz = FizzBuzz.new(3)
        history_repository.add(fizzbuzz)
        menu.select('3')
        menu.select('4')
        expect(spy.result).to eq(history_repository.current_history.map{ |f| f.to_s })
      end
    end

    private

      def delete_file
        File.unlink file_path if File.exist?(file_path)
      end
  end

end
