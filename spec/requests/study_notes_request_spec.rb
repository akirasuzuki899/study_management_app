require 'rails_helper'

RSpec.describe "StudyNotes", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/study_notes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/study_notes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/study_notes/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/study_notes/new"
      expect(response).to have_http_status(:success)
    end
  end

end
