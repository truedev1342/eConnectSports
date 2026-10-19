class ChangePaymentStatusToInteger < ActiveRecord::Migration[8.1]
  # The status columns were strings while PROCESSING/FAILED/SUCCESS are
  # integers, so values round-tripped as "1"/"2"/"3" and comparisons against the
  # constants needed a .to_i on every read.
  def up
    [:payments, :team_payments].each do |table|
      change_column table, :status, :integer,
                    using: "NULLIF(regexp_replace(status, '\\D', '', 'g'), '')::integer"
    end
  end

  def down
    [:payments, :team_payments].each do |table|
      change_column table, :status, :string
    end
  end
end
