require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has one cart' do
      assoc = described_class.reflect_on_association(:cart)
      expect(assoc).not_to be_nil
      expect(assoc.macro).to eq(:has_one)
    end

    it 'declares dependent: :destroy on cart' do
      assoc = described_class.reflect_on_association(:cart)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'dependent behavior' do
    it 'destroys the associated cart when the user is destroyed' do
      user = create(:user, email: 'spec-user@example.com')
      cart = create(:cart, user: user)

      expect(Cart.exists?(cart.id)).to be true
      expect { user.destroy }.to change { Cart.exists?(cart.id) }.from(true).to(false)
    end
  end
end
