class Account < ApplicationRecord
    belongs_to :user

    validates :account_token, presence: true, uniqueness: true
    validates :balance, presence: true, numericality: {greater_than_or_equal_to: 0, message: "can't be negative"}

    has_many :transfers

    before_validation :set_account

    def set_account
        if self.new_record?
            self.account_token = loop do 
                unique_n = Digest::MD5.hexdigest([Time.now, rand].join)
                break unique_n unless Account.exists?(account_token: unique_n)
            end
            self.balance = rand(1000...100000)
        end
    end

    def withdraw(a)
        self.balance -= a
        save!
    end

    def deposit(a)
        self.balance += a
        save!
    end

    def transfer_log(fr, to, am)
        self.transfers.new(from: fr, to: to, amount: am)
        save!
    end

    def self.tx(from, to, amount)
        from.account.withdraw(amount)
        to.account.deposit(amount)
        from.account.transfer_log(from.email, to.email, amount)
    end
end