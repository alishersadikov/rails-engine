require 'rails_helper'

describe "invoice relationships" do
  context "GET /api/v1/invoices/:id/transactions" do
    it "returns a list of all transactions associated with one invoice" do
      invoice = create(:invoice_with_customer_and_merchant)
      transaction_1 = create(:transaction, invoice_id: invoice.id)
      transaction_2 = create(:transaction, invoice_id: invoice.id)

      get "/api/v1/invoices/#{invoice.id}/transactions"

      transactions = JSON.parse(response.body)

      expect(response).to be_success
      expect(transactions.count).to eq(2)
      expect(transactions.first["credit_card_number"]).to eq(transaction_1.credit_card_number)
      expect(transactions.last["result"]).to eq(transaction_2.result)
    end
  end

  context "GET /api/v1/invoices/:id/invoice_items" do
    it "returns a list of all invoice_items associated with one invoice" do
      invoice = create(:invoice_with_customer_and_merchant)
      invoice_item_1 = create(:invoice_item_with_item, invoice_id: invoice.id)
      invoice_item_2 = create(:invoice_item_with_item, invoice_id: invoice.id)

      get "/api/v1/invoices/#{invoice.id}/invoice_items"

      invoice_items = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_items.count).to eq(2)
      expect(invoice_items.first["quantity"]).to eq(invoice_item_1.quantity)
      expect(invoice_items.last["unit_price"]).to eq(invoice_item_2.unit_price)
    end
  end
end
