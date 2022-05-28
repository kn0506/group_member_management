class GroupsController < ApplicationController
  def index
    @groups = Group.all.limit(25)
    @members = Member.all.limit(25)
    @group_members = GroupMember.all.limit(25)
  end

  def show
    @group = Group.find(params[:id])
    @non_group_members = Member.where.not(id: @group.members)
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to action: :index
    else
      render :new
    end
  end

  def destroy
    Group.find(params[:id]).destroy!
    redirect_to action: :index
  end

    def random_role
      group = Group.find(params[:group_id])
      members = GroupMember.where(group: group)
      secretary = GroupMember.where(group: group, role: 'secretary').first
      non_secretaries = GroupMember.where(group: group).where.not(id: secretary)
      next_secretary = GroupMember.where.not(role: 'secretary').shuffle.first
  
      if members.count == 1
        members.first.update!(role: 'secretary')
  
      elsif members.count == 2
        non_secretaries.update(role: 'sub-secretary')
        member_a,member_b = [members[0], members[1]]
        member_a_role,member_b_role = [member_a.role, member_b.role]
        member_a.update!(role: member_b_role)
        member_b.update!(role: member_a_role)
  
      elsif members.count == 3
  
        next_secretary.update!(role: 'secretary')
        member_b, member_c = GroupMember.where.not(id: next_secretary)
        member_b.update!(role: 'sub-secretary')
        member_c.update!(role: 'driver')
  
      elsif members.count > 3
  
        next_secretary.update!(role: 'secretary')
        member_b, member_c = GroupMember.where.not(id: next_secretary)
        member_b.update!(role: 'sub-secretary')
        member_c.update!(role: 'driver')
  
        other_members = GroupMember.where.not(id: [next_secretary, member_b, member_c])
        other_members.update(role: 'regular')
  
      end
  
      redirect_to group_path(group)
    end
  
    private

    def group_params
      params.require(:group).permit(:name)
    end
  end
