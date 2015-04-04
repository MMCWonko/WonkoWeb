require 'spec_helper'
require 'rails_helper'

describe HomePolicy do
  subject { described_class.new(user, nil) }

  context 'for a visitor' do
    let(:user) { nil }

    it { should permit(:about)    }
    it { should permit(:irc)  }
  end

  context 'for a user' do
    let(:user) { Fabricate(:user) }

    it { should permit(:about)    }
    it { should permit(:irc)  }
  end

  context 'for a admin' do
    let(:user) { Fabricate(:user_admin) }

    it { should permit(:about)    }
    it { should permit(:irc)  }
  end
end
