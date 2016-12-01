class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.select_random_item
    order("RANDOM()").first(1)
  end

  def best_day
    date = invoices.joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .order("invoice_items.quantity DESC", "created_at DESC")
    .first.created_at
    { best_day: date }
  end
end
