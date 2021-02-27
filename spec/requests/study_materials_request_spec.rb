require 'rails_helper'

RSpec.describe "StudyMaterials", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/study_materials/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/study_materials/new"
      expect(response).to have_http_status(:success)
    end
  end

end
