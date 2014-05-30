require 'spec_helper'

describe 'Workflow', type: :request, js: true do
  it 'app should be accessible via POST' do
    visit '/learn_lti_engine/test/backdoor'
    click_button('Submit')
    expect(page).to have_content 'My LTI App'
  end
end
