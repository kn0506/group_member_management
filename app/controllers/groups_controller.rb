class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    @members = Member.all.limit(25)
    @group_members = GroupMember.all

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @non_group_members = Member.where.not(id: @group.members)
    # @group_members = GroupMember.where(group_id: 1, role: 'organizer').members.first

  end


  def random_role
    group = Group.find(params[:group_id])
    member = Member.find(params[:member_id])
    group_member = GroupMember.find(params[:group_member_id])
    organizer = GroupMemberships.where(group_id: 1, role: 'organizer').members.first


    # group_members.where(group_id: 1, role: 'organizer')

    # group_member.sample.update(role:) next if group_member == "organizer"

    # GroupMember.any?(role: ..., member: )

    # GroupMember.find_by(...).members
    
    # group = GroupMember.find_by(...)

    # group.members << GroupMember.new(member:,role: )

    redirect_to group_path(group)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
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

  def join
    group = Group.find(params[:group_id])
    member = Member.find(params[:member_id])
    group.members << member
    group.save 
    redirect_to group_path(group)
  end

  def leave
    group = Group.find(params[:group_id])
    member = Member.find(params[:member_id])
    if group.members.include?(member)
      group.members.delete(member)
    else
      flash[:danger] = '所属しておりません'
    end

    redirect_to group_path(group)
  end


  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
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
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, member_id: [])
    end

end
