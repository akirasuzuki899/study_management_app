feature 'sample', type: :system, js: true do
  scenario 'sample scenario' do
    # 例えばルートパスにアクセスできることを確認
    visit root_path
    expect(current_path).to eq root_path
  end
end