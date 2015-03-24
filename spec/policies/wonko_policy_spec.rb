require 'spec_helper'
require 'rails_helper'

describe WonkoPolicy do
  subject { described_class }

  context 'for a visitor' do
    let(:user) { nil }

    it { should permit(:show)    }

    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end

  context 'for a user' do
    let(:user) { User.new }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end
end
