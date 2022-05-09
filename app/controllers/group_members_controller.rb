class GroupMembersController < ApplicationController
  def index
    @group_members = GroupMember.all
  end

  def create
    group = Group.find params[:group_id]
    member = Member.find params[:member_id]

     if group.group_members.empty?
      GroupMember.create! group: group, member: member, role: 'secretary'
    elsif 
      GroupMember.create! group: group, member: member, role: 'driver'
    elsif 
      GroupMember.create! group: group, member: member, role: 'sub-secretary'
    else
      GroupMember.create! group: group, member: member, role: 'regular'
    end

    # GroupMember.create!(group_id: params[:group_id], member_id: params[:member_id])
    redirect_to group_path(group)
  end

  def destroy
    group = Group.find params[:group_id]
    member = Member.find params[:member_id]

    group_member = GroupMember.find_by group: group, member: member
    group_member.destroy!

    redirect_to group_path(group)
  end

  private

  def group_member_params
    params.require(:group_member).permit(:role)
  end
end