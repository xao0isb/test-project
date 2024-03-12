# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  context "with invalid attributes" do
    it "does not create" do
      expect(described_class.new).not_to be_valid
    end
  end

  context "with valid attributes" do
    let(:attributes) do
      {
        role: "user",
        login: "Login",
        first_name: "Dmitry",
        last_name: "Kurtsev",
        middle_name: "Olegovich",
        region: Region.new,
        password: "_"
      }
    end

    it "creates" do
      expect(described_class.new(attributes)).to be_valid
    end
  end

  describe ".full_name" do
    let(:user) do
      create(
        :user,
        first_name: "Dmitry",
        middle_name: "Olegovich",
        last_name: "Kurtsev"
      )
    end

    it "returns correct value" do
      expect(user.full_name).to eq("Kurtsev Dmitry Olegovich")
    end
  end

  describe ".admin?" do
    let(:admin) { create(:user, role: :admin) }
    let(:user) { create(:user) }

    it "returns true" do
      expect(admin.admin?).to be(true)
    end

    it "returns false" do
      expect(user.admin?).to be(false)
    end
  end

  describe ".switch_to_admin" do
    let(:user) { create(:user) }

    it "switches" do
      user.switch_to_admin

      expect(user.admin?).to be(true)
    end
  end

  describe "scopes" do
    describe "not_admins" do
      let!(:user) { create(:user) }
      let!(:another_user) { create(:user) }
      let!(:admin) { create(:user, role: :admin) } # rubocop:disable RSpec/LetSetup

      it "returns not admins" do
        expect(described_class.not_admins).to eq([user, another_user])
      end
    end
  end
end
