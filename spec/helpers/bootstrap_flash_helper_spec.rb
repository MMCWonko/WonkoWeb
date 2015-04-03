require 'rails_helper'
require 'pry'

describe BootstrapFlashHelper do
  def flash
    {
      notice: 'This is a notice',
      alert: 'This is an alert',
      error: 'This is an error',
      warning: 'This is a warning',
      asdf: 'This is an asdf'
    }
  end

  it 'renders flashes' do
    data = helper.bootstrap_flash flash: flash
    expect(data).to match(/div.*class.*alert.*alert-success.*This is a notice.*div/)
    expect(data).to match(/div.*class.*alert.*alert-danger.*This is an alert.*div/)
    expect(data).to match(/div.*class.*alert.*alert-danger.*This is an error.*div/)
    expect(data).to match(/div.*class.*alert.*alert-warning.*This is a warning.*div/)
    expect(data).not_to match(/div.*class.*alert.*alert-asdf.*This is an asdf.*div/)
  end
end
