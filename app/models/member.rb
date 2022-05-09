class Member < ApplicationRecord
	has_many :group_members
	has_many :groups, -> { distinct }, through: :group_member
	has_many :groups, through: :group_members
end
