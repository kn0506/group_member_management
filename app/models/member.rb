class Member < ApplicationRecord
	has_many :group_members
	has_many :groups, through: :group_members,dependent: :destroy
end
