require 'rails_helper'

# feature spec, integration test
# capybara    rspec
# feature     describe, context
# scenario    it
feature 'parking', :type => :feature do
  scenario 'guest parking' do
    visit '/'
    # save_and_open_page         # NOTE: 这回存下测试时的 html 页面到 tem/capybara/ 目录下
    expect(page).to have_content('一般费率')
    click_button '开始计费'
    click_button '结束计费'
    expect(page).to have_content('¥2.00')
  end
end
