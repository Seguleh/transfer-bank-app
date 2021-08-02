class Transfer < ApplicationRecord
  belongs_to :account

  validates :from, presence: true
  validates :to, presence: true
  validates :amount, presence: true, numericality: {greater_than_or_equal_to: 0, message: "can't be negative"}

  def self.log(u)
    (u.account.transfers.all + Transfer.where(to: u.email)).sort{|a,b| b.created_at <=> a.created_at }
  end

end
