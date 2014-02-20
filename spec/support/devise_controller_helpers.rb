module DeviseControllerHelpers
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      admin = create(:user)
      sign_in admin
    end
  end
end
