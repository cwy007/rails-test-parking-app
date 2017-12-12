require 'rails_helper'
# 1. 浏览页面
# 2. 查看文字
# 3. 填表单
# 4. 点击注册按钮
# 5. 检查文字
# 6. 检查资料有没有存进资料库
feature 'register, login and logout', :type => :feature do
  scenario 'register' do
    visit '/users/sign_up'
    expect(page).to have_content('Sign up')
    # The field can be found via its name [attribute], id [attribute,] or label text
    within("#new_user") do
      fill_in 'Email',                 with: 'foobar@example.com'
      fill_in 'user[password]',        with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
    end
    click_button 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')
    user = User.last
    expect(user.email).to eq('foobar@example.com')
  end

  scenario 'login and logout' do
    user = User.create!( :email => "foobar@example.com", :password => '12345678' )
    visit '/users/sign_in'
    within('#new_user') do
      fill_in 'Email',    with: 'foobar@example.com'
      fill_in 'Password', with: '12345678'
    end
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
    click_link '登出'
    expect(page).to have_content('Signed out successfully')
  end
end
