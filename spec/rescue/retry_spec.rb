describe Rescue::Handler do

  class Mock
    extend Rescue::Retry

    rescue_retry :mock_method, RuntimeError

    def mock_method
      true
    end
  end

  subject { Mock.new }

  before do
    allow(described_class).to receive(:new).and_call_original
  end

  context 'without any problems' do
    it 'just calls our internal method normally' do
      expect(subject.mock_method).to be
      expect(described_class).to have_received(:new)
    end
  end

  context 'with problems' do
    let(:logger) { double(::Logger) }

    subject { described_class.new(errors: [RuntimeError], logger: logger) }

    before do
      allow(logger).to receive(:warn)
      allow(logger).to receive(:error)
    end

    it 'just calls our internal method normally after rescuing once' do
      expect(subject.call { raise RuntimeError, 'message' if subject.attempt == 1 } ).to be_nil
      expect(logger).to have_received(:warn)
    end

    it 'just calls our internal method normally after rescuing once' do
      expect {
        subject.call { raise RuntimeError, 'message' }
      }.to raise_error(RuntimeError, 'message')
      expect(logger).to have_received(:warn).exactly(3).times
    end

    context 'with a delay in retry' do
      let(:delay) { :none }
      subject { described_class.new(errors: [RuntimeError], logger: logger, delay: delay) }

      before do
        allow(subject).to receive(:sleep)
      end

      context 'exponential delay' do
        let(:delay) { :exponential }

        it 'delays correctly' do
          expect {
            subject.call { raise RuntimeError, 'message' }
          }.to raise_error(RuntimeError, 'message')
          expect(subject).to have_received(:sleep).ordered.with(4)
          expect(subject).to have_received(:sleep).ordered.with(9)
        end
      end

      context 'linear delay' do
        let(:delay) { :linear }

        it 'delays correctly' do
          expect {
            subject.call { raise RuntimeError, 'message' }
          }.to raise_error(RuntimeError, 'message')
          expect(subject).to have_received(:sleep).ordered.with(4)
          expect(subject).to have_received(:sleep).ordered.with(6)
        end
      end

      context 'linear delay' do
        let(:delay) { :random }

        before do
          allow(subject).to receive(:rand).and_return(1)
        end

        it 'delays correctly' do
          expect {
            subject.call { raise RuntimeError, 'message' }
          }.to raise_error(RuntimeError, 'message')
          expect(subject).to have_received(:sleep).ordered.with(2.0)
          expect(subject).to have_received(:sleep).ordered.with(3.0)
        end
      end

      context 'invalid delay' do
        let(:delay) { :invalid }

        it 'delays correctly' do
          expect {
            subject.call { raise RuntimeError, 'message' }
            }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
