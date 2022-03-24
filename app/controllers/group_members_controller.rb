class GroupMembersController < ApplicationController
	def index
    @group_members = GroupMember.all
  end

	def new
    @group_member = GroupMember.new
  end

private

 	def group_member_params
    params.require(:group_member).permit(:role)
  end
end
