require 'spec_helper'
require 'rails_helper'

describe WonkoPolicy do
  subject { described_class.new(user, wonkofile) }

  context 'for a visitor' do
    let(:user) { nil }
    let(:wonkofile) { Fabricate(:wf_minecraft) }

    it { should permit(:show)    }

    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end

  context 'for a user' do
    let(:wonkofile) { Fabricate(:wf_minecraft) }
    let(:user) { Fabricate(:user) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end

  context 'for the owner' do
    let(:wonkofile) { Fabricate(:wf_minecraft) }
    let(:user) { wonkofile.user }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end

  context 'for a admin' do
    let(:wonkofile) { Fabricate(:wf_minecraft) }
    let(:user) { Fabricate(:user_admin) }

    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end
end
