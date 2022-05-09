class GroupsController < ApplicationController
  # before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.limit(25)
    @members = Member.all.limit(25)
    @group_members = GroupMember.all.limit(25)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @non_group_members = Member.where.not(id: @group.members)
  end


  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      @group = Group.find(params[:id])
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id]).destroy!
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
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
        member_b, member_c = GroupMember.where.not(id: next_secretary).shuffle
        member_b.update!(role: 'sub-secretary')
        member_c.update!(role: 'driver')
  
      elsif members.count > 3
  
        next_secretary.update!(role: 'secretary')
  
        member_b, member_c = GroupMember.where.not(id: next_secretary).shuffle
        member_b.update!(role: 'sub-secretary')
        member_c.update!(role: 'driver')
  
        other_members = GroupMember.where.not(id: [next_secretary, member_b, member_c])
        other_members.update(role: 'regular')
  
      end
  
      redirect_to group_path(group)
    end
  
  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end

    # def set_group
    #   @group = Group.find(params[:id])
    # end
end